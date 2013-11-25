//
//  INBlueToothService.m
//  Vicinity
//
//  Created by Ben Ford on 10/28/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "INBeaconService.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CLBeacon+Ext.h"
#import "CBPeripheralManager+Ext.h"
#import "CBCentralManager+Ext.h"
#import "CBUUID+Ext.h"

#import "GCDSingleton.h"
#import "ConsoleView.h"
#import "EasedValue.h"

#define DEBUG_PERIPHERAL NO
#define TIMEOUT_INTERVAL 5.0f
#define UPDATE_INTERVAL 1.0f

@interface INBeaconService() <CBPeripheralManagerDelegate, CBCentralManagerDelegate>
@end

@implementation INBeaconService
{
    NSArray *identifiers;
    NSMutableDictionary *identifierRanges;
    
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    
    NSMutableSet *delegates;

    EasedValue *easedProximity;
    
    NSTimer *detectorTimer;
}

#pragma mark Singleton
+ (INBeaconService *)singleton
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initWithIdentifiers:@[SINGLETON_IDENTIFIER]];
    });
}
#pragma mark -


- (id)initWithIdentifiers:(NSArray *)theIdentifiers
{
    if ((self = [super init])) {
        identifiers = [INBeaconService convertStringIdentifiersToCBUUIDArray:theIdentifiers];
        identifierRanges = [[NSMutableDictionary alloc] init];
        
        delegates = [[NSMutableSet alloc] init];
        
        easedProximity = [[EasedValue alloc] init];
        
    }
    return self;
}

- (void)addDelegate:(id<INBeaconServiceDelegate>)delegate
{
    [delegates addObject:delegate];
}

- (void)removeDelegate:(id<INBeaconServiceDelegate>)delegate
{
    [delegates removeObject:delegate];
}

- (void)performBlockOnDelegates:(void(^)(id<INBeaconServiceDelegate> delegate))block
{
    for (id<INBeaconServiceDelegate>delegate in delegates) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(delegate);
        });
    }
}

- (void)startDetecting
{
    if (![self canMonitorBeacons])
        return;
    
    [self startDetectingBeacons];
}

- (void)startScanning
{
    
    NSDictionary *scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)};
    
    
    [centralManager scanForPeripheralsWithServices:identifiers options:scanOptions];
    _isDetecting = YES;
}

- (void)stopDetecting
{
    _isDetecting = NO;
    
    [centralManager stopScan];
    centralManager = nil;
    
    [detectorTimer invalidate];
    detectorTimer = nil;
}

- (void)startBroadcasting
{
    if (![self canBroadcast])
        return;
    
    [self startBluetoothBroadcast];

}

- (void)stopBroadcasting
{
    _isBroadcasting = NO;
    
    // stop advertising beacon data.
    [peripheralManager stopAdvertising];
    peripheralManager = nil;
}

- (void)startDetectingBeacons
{
    if (!centralManager)
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:Nil options:nil];
    
    detectorTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self
                                                   selector:@selector(reportRanges:) userInfo:nil repeats:YES];
}

- (void)startBluetoothBroadcast
{
    // start broadcasting if it's stopped
    if (!peripheralManager)
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)startAdvertising
{

    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey:@"vicinity-peripheral",
                                      CBAdvertisementDataServiceUUIDsKey:identifiers};
    
    // Start advertising over BLE
    [peripheralManager startAdvertising:advertisingData];
    
    _isBroadcasting = YES;
}

- (BOOL)canBroadcast
{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    BOOL enabled = (status == CBPeripheralManagerAuthorizationStatusAuthorized ||
                    status == CBPeripheralManagerAuthorizationStatusNotDetermined);
    
    if (!enabled)
        INLog(@"bluetooth not authorized");
    
    return enabled;
}

- (BOOL)canMonitorBeacons
{
    return YES;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (DEBUG_PERIPHERAL) {
        NSLog(@"did discover peripheral: %@, data: %@, %1.2f", [peripheral.identifier UUIDString], advertisementData, [RSSI floatValue]);
        
        CBUUID *uuid = [advertisementData[CBAdvertisementDataServiceUUIDsKey] firstObject];
        NSLog(@"service uuid: %@", [uuid representativeString]);
    }
    
    CBUUID *uuid = [advertisementData[CBAdvertisementDataServiceUUIDsKey] firstObject];
    
    // ignore this update if UUID was not specificed
    // this happens when the BLE service wasn't included in the advertisement
    if (!uuid)
        return;
    
    NSString *uuidString = [uuid representativeString];
    
    INDetectorRange detectedRange = [self convertRSSItoINProximity:[RSSI floatValue]];
    
    identifierRanges[uuidString] = @(detectedRange);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"-- central state changed: %@", centralManager.stateString);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScanning];
    }

}
#pragma mark -

- (void)reportRanges:(NSTimer *)timer
{
    for (NSString *uuid in identifierRanges.allKeys) {
        [self performBlockOnDelegates:^(id<INBeaconServiceDelegate>delegate) {
            INDetectorRange range = [identifierRanges[uuid] intValue];
            [delegate service:self foundDeviceUUID:uuid withRange:range];
            
            [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_INTERVAL target:self selector:@selector(didTimeoutBeacon:)
                                           userInfo:uuid repeats:NO];
        }];
    }
}

- (void)didTimeoutBeacon:(NSTimer *)timer
{
    // timeout the beacon to unknown position
    // it it's still active it will be updated by central delegate "didDiscoverPeripheral"
    NSString *timedOutBeacon = timer.userInfo;
    identifierRanges[timedOutBeacon] = @(INDetectorRangeUnknown);
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    INLog(@"-- peripheral state changed: %@", peripheral.stateString);
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error)
        INLog(@"error starting advertising: %@", [error localizedDescription]);
    else
        INLog(@"did start advertising");
}
#pragma mark -

- (INDetectorRange)convertRSSItoINProximity:(NSInteger)proximity
{
    // eased value doesn't support negative values
    easedProximity.value = fabsf(proximity);
    [easedProximity update];
    proximity = easedProximity.value * -1.0f;
    
    INLog(@"proximity: %d", proximity);
    
    
    if (proximity < -70)
        return INDetectorRangeFar;
    if (proximity < -55)
        return INDetectorRangeNear;
    if (proximity < 0)
        return INDetectorRangeImmediate;
    
    return INDetectorRangeUnknown;
}

+ (NSArray *)convertStringIdentifiersToCBUUIDArray:(NSArray *)stringIdentifiers
{
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSString *identifier in stringIdentifiers) {
        CBUUID *uuid = [CBUUID UUIDWithString:identifier];
        [services addObject:uuid];
    }
    
    return [[NSArray alloc] initWithArray:services];
}
@end
