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

@interface ViewController () <CBPeripheralManagerDelegate>

@end

@implementation ViewController
{
    UIButton *broadcastButton;
    UIButton *detectButton;
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

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{

}
#pragma mark -

- (void)startBroadcasting:(UIButton *)button
{
    
}

- (void)startDetecting:(UIButton *)button
{
    
}

- (void)startBluetooth
{
    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:@"com.weareinstrument.dawnsipadmini"];
    
    
    // Create a dictionary of advertisement data.
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Create the peripheral manager.
    CBPeripheralManager *peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    // Start advertising your beacon's data.
    [peripheralManager startAdvertising:beaconPeripheralData];
}
@end
