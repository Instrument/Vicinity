//
//  INBlueToothService.m
//  Vicinity
//
//  Created by Ben Ford on 10/28/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "INDetectorService.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CLBeacon+Ext.h"
#import "GCDSingleton.h"

@interface INDetectorService() <CBPeripheralManagerDelegate, CLLocationManagerDelegate>
@end

@implementation INDetectorService
{
    NSString *identifier;
    
    CLLocationManager *locationManager;
    CBPeripheralManager *peripheralManager;
}

#pragma mark Singleton
+ (INDetectorService *)singleton
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
    }
    return self;
}

- (void)startDetecting
{
    if (![self canMonitorBeacons])
        return;
    
    [self startDetectingBeacons];
}

- (void)stopDetecting
{
    
}

- (void)startBroadcasting
{
    if (![self canBroadcast])
        return;
    
    [self startBluetoothBroadcast];

}

- (void)stopBroadcasting
{
    
}

- (void)startDetectingBeacons
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    
    CLBeaconRegion *beaconRegion = [self beacon];
    
    // used for crossing region boundry
    [locationManager startMonitoringForRegion:beaconRegion];
    NSLog(@"starting detection...");
    
    // used for ranging beacons once they are near
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    NSLog(@"starting to range beacon");
}

- (void)startBluetoothBroadcast
{
    // start broadcasting if it's stopped
    if (!peripheralManager)
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    // stop state if it's started
    if (peripheralManager.isAdvertising) {
        NSLog(@"Stopping broadcast");
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
}

- (CLBeaconRegion *)beacon
{
    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:@"com.weareinstrument.dawnsipadmini"];
    
    return beaconRegion;
}

- (BOOL)canBroadcast
{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    BOOL enabled = (status == CBPeripheralManagerAuthorizationStatusAuthorized ||
                    status == CBPeripheralManagerAuthorizationStatusNotDetermined);
    
    if (!enabled)
        NSLog(@"bluetooth not authorized");
    
    return enabled;
}

- (BOOL)canMonitorBeacons
{
    BOOL enabled = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL allowed = (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined);
    
    if (!enabled || !allowed)
        NSLog(@"Cannot monitor beacons: [%d,%d]", enabled, status);
    
    
    return enabled && allowed;
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"-- bluetooth state changed: %d", peripheral.state);
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error)
        NSLog(@"error starting advertising: %@", [error localizedDescription]);
    else
        NSLog(@"did start advertising");
}
#pragma mark -

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    CLBeacon *nearestBeacon = [beacons firstObject];
    if (nearestBeacon)
        NSLog(@"nearestBeacon proximity: %@", nearestBeacon.proximityString);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"Error with beacon region: %@ - %@", region, [error localizedDescription]);
}



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"did enter region: %@", beaconRegion.proximityUUID);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"did exit region: %@", beaconRegion.proximityUUID);
    
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    NSLog(@"stopping range of beacon");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"Error while monitoring region: %@ - error: %@", beaconRegion.proximityUUID, [error localizedDescription]);
}
#pragma mark -
@end
