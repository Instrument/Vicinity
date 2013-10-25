//
//  ViewController.m
//  Vicinity
//
//  Created by Ben Ford on 10/24/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyLayout.h"
#import "ButtonMaker.h"
#import "CLBeacon+Ext.h"
#import "ConsoleView.h"

@interface ViewController () <CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController
{
    UIButton *broadcastButton;
    UIButton *detectButton;
    
    ConsoleView *consoleView;
    
    CLLocationManager *locationManager;
    CBPeripheralManager *peripheralManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    broadcastButton = [ButtonMaker genericButtonWithTitle:@"Broadcast" target:self action:@selector(startBroadcasting:)];
    [self.view addSubview:broadcastButton];
    
    detectButton = [ButtonMaker genericButtonWithTitle:@"Detect" target:self action:@selector(startDetecting:)];
    [self.view addSubview:detectButton];
    
    [EasyLayout topCenterViews:@[broadcastButton,detectButton]
                  inParentView:self.view offset:CGSizeMake(0.0f, 60.0f) padding:50.0f];
    
    consoleView = [[ConsoleView alloc] init];
    consoleView.extSize = CGSizeMake(self.view.extSize.width, floorf(self.view.extSize.height/2.0f));
    [EasyLayout bottomCenterView:consoleView inParentView:self.view offset:CGSizeZero];
    [self.view addSubview:consoleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    [consoleView logStringWithFormat:@"-- bluetooth state changed: %d", peripheral.state];
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error)
        [consoleView logStringWithFormat:@"error starting advertising: %@", [error localizedDescription]];
    else
        [consoleView logStringWithFormat:@"did start advertising"];
}
#pragma mark -

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    CLBeacon *nearestBeacon = [beacons firstObject];
    [consoleView logStringWithFormat:@"nearestBeacon proximity: %@", nearestBeacon.proximityString];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    [consoleView logStringWithFormat:@"Error with beacon region: %@ - %@", region, [error localizedDescription]];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    [consoleView logStringWithFormat:@"did enter region: %@", beaconRegion.proximityUUID];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    [consoleView logStringWithFormat:@"did exit region: %@", beaconRegion.proximityUUID];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    [consoleView logStringWithFormat:@"Error while monitoring region: %@ - error: %@", beaconRegion.proximityUUID, [error localizedDescription]];
}
#pragma mark -

- (void)startBroadcasting:(UIButton *)button
{
    if (![self canBroadcast])
        return;
    
    [self startBluetoothBroadcast];
}

- (void)startDetecting:(UIButton *)button
{
    if (![self canMonitorBeacons])
        return;
    
    [self startDetectingBeacons];
}

- (void)startDetectingBeacons
{
    CLBeaconRegion *beaconRegion = [self beacon];
    [locationManager startMonitoringForRegion:beaconRegion];

    // used for ranging beacons once they are near
//    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)startBluetoothBroadcast
{
    // Create the peripheral manager.
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
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
        [consoleView logStringWithFormat:@"bluetooth not authorized"];
    
    return enabled;
}

- (BOOL)canMonitorBeacons
{
    BOOL enabled = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL allowed = (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined);
    
    if (!enabled || !allowed)
        [consoleView logStringWithFormat:@"Cannot monitor beacons: [%d,%d]", enabled, status];
    
    
    return enabled && allowed;
}


@end
