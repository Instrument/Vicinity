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
#import "INBeaconService.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIButton *broadcastButton;
    UIButton *detectButton;
    
    ConsoleView *consoleView;
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
    
    consoleView = [ConsoleView singleton];
    consoleView.extSize = CGSizeMake(self.view.extSize.width, floorf(self.view.extSize.height/2.0f));
    [EasyLayout bottomCenterView:consoleView inParentView:self.view offset:CGSizeZero];
    [self.view addSubview:consoleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)startBroadcasting:(UIButton *)button
{
    [[INBeaconService singleton] startBroadcasting];
}

- (void)startDetecting:(UIButton *)button
{
    [[INBeaconService singleton] startDetecting];
}


@end
