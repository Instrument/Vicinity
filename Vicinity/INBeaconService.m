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
#import "GCDSingleton.h"
#import "ConsoleView.h"
#import "INWeightedAverage.h"
#import "EasedValue.h"

#define ENABLE_REGION_BOUNDRY NO

@interface INBeaconService() <CBPeripheralManagerDelegate, CBCentralManagerDelegate>
@end

@implementation INBeaconService
{
    NSString *identifier;
    
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    
    NSMutableSet *delegates;
    
    INDetectorRange previousRange;
    INWeightedAverage *averageProximity;
    EasedValue *easedProximity;
}

#pragma mark Singleton
+ (INBeaconService *)singleton
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initWithIdentifier:SINGLETON_IDENTIFIER];
    });
}
#pragma mark -


- (id)initWithIdentifier:(NSString *)theIdentifier
{
    if ((self = [super init])) {
        identifier = theIdentifier;
        delegates = [[NSMutableSet alloc] init];
        
        averageProximity = [[INWeightedAverage alloc] init];
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
    NSArray *services = @[[CBUUID UUIDWithString:identifier]];
    
    [centralManager scanForPeripheralsWithServices:services options:scanOptions];
    _isDetecting = YES;
}

- (void)stopDetecting
{
    _isDetecting = NO;
    
    [centralManager stopScan];
    centralManager = nil;
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
                                      CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:identifier]]};

    // Start advertising over BLE
    [peripheralManager startAdvertising:advertisingData];
    
    _isBroadcasting = YES;
}

- (CLBeaconRegion *)beacon
{
    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:identifier];
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:@"com.weareinstrument.vicinity"];
    
    return beaconRegion;
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
//    NSLog(@"did discover peripheral: %@, data: %@, %1.2f", peripheral, advertisementData, [RSSI floatValue]);
    
    INDetectorRange detectedRange = [self convertRSSItoINProximity:[RSSI floatValue]];

    if (previousRange != detectedRange) {
        previousRange = detectedRange;
        
        [self performBlockOnDelegates:^(id<INBeaconServiceDelegate> delegate) {
            [delegate service:self foundDeviceWithRange:detectedRange];
        }];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"-- central state changed: %@", centralManager.stateString);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScanning];
    }

}
#pragma mark -

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

BOOL inRange(NSInteger start, NSInteger end, NSInteger target)
{
    return target >= start && target <= end;
}

- (INDetectorRange)convertRSSItoINProximity:(NSInteger)proximity
{
    easedProximity.value = fabsf(proximity);
    [easedProximity update];
    
//    [averageProximity addValue:proximity];
//    proximity = [averageProximity weightedAverage];

    proximity = easedProximity.value * -1.0f;
    
    INLog(@"proximity: %d", proximity);
    
    if (inRange(-58, -20, proximity))
        return INDetectorRangeImmediate;
    if (inRange(-70, -59, proximity))
        return INDetectorRangeNear;
    if (inRange(-999, -71, proximity))
        return INDetectorRangeFar;
    
    return INDetectorRangeUnknown;
}
@end
