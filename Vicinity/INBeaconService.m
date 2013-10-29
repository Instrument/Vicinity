//
//  INBlueToothService.m
//  Vicinity
//
//  Created by Ben Ford on 10/28/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "INBeaconService.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CLBeacon+Ext.h"
#import "GCDSingleton.h"
#import "ConsoleView.h"

#define ENABLE_REGION_BOUNDRY NO

@interface INBeaconService() <CBPeripheralManagerDelegate, CLLocationManagerDelegate>
@end

@implementation INBeaconService
{
    NSString *identifier;
    
    CLLocationManager *locationManager;
    CBPeripheralManager *peripheralManager;
    
    NSMutableSet *delegates;
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

- (void)stopDetecting
{
    _isDetecting = NO;
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
}

- (void)startDetectingBeacons
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    
    CLBeaconRegion *beaconRegion = [self beacon];
    
    // used for crossing region boundry
    if (ENABLE_REGION_BOUNDRY) {
        [locationManager startMonitoringForRegion:beaconRegion];
        INLog(@"starting detection boundry");
    }
    
    // used for ranging beacons once they are near
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    INLog(@"starting to range beacon");
    
    _isDetecting = YES;
}

- (void)startBluetoothBroadcast
{
    // start broadcasting if it's stopped
    if (!peripheralManager)
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    // stop state if it's started
    if (peripheralManager.isAdvertising) {
        INLog(@"Stopping broadcast");
        [peripheralManager stopAdvertising];
        peripheralManager = nil;
    }
}

- (void)startAdvertising
{
    CLBeaconRegion *beaconRegion = [self beacon];
    
    // Create a dictionary of advertisement data.
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start advertising your beacon's data.
    [peripheralManager startAdvertising:beaconPeripheralData];
    
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
    BOOL enabled = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL allowed = (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined);
    
    if (!enabled || !allowed)
        INLog(@"Cannot monitor beacons: [%d,%d]", enabled, status);
    
    
    return enabled && allowed;
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    INLog(@"-- bluetooth state changed: %d", peripheral.state);
    
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    CLBeacon *nearestBeacon = [beacons firstObject];
    if (nearestBeacon) {
        INLog(@"nearestBeacon proximity: %@", nearestBeacon.proximityString);
        
        INDetectorRange convertedRange = [self convertCLProximitytoINProximity:nearestBeacon.proximity];
        
        [self performBlockOnDelegates:^(id<INBeaconServiceDelegate> delegate) {
            [delegate service:self foundDeviceWithRange:convertedRange];
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    INLog(@"Error with beacon region: %@ - %@", region, [error localizedDescription]);
}



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    INLog(@"did enter region: %@", beaconRegion.proximityUUID);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    INLog(@"did exit region: %@", beaconRegion.proximityUUID);
    
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    INLog(@"stopping range of beacon");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    INLog(@"Error while monitoring region: %@ - error: %@", beaconRegion.proximityUUID, [error localizedDescription]);
}
#pragma mark -

- (INDetectorRange)convertCLProximitytoINProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return INDetectorRangeFar;
            break;
            
        case CLProximityImmediate:
            return INDetectorRangeImmediate;
            break;
            
        case CLProximityNear:
            return INDetectorRangeNear;
            break;
            
        case CLProximityUnknown:
            return INDetectorRangeUnknown;
            break;
    }
}
@end
