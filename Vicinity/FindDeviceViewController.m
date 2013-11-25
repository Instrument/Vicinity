//
//  FindDeviceViewController.m
//  Vicinity
//
//  Created by Ben Ford on 10/28/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "FindDeviceViewController.h"
#import "INBeaconService.h"
#import "EasyLayout.h"
#import "ButtonMaker.h"
#import "BeaconCircleView.h"

@interface FindDeviceViewController () <INBeaconServiceDelegate>

@end

@implementation FindDeviceViewController
{
    UILabel *statusLabel;
    UILabel *distanceLabel;
    
    BeaconCircleView *baseCircle;
    BeaconCircleView *targetCircle;
    

    
    UIButton *modeButton;
}

- (id)init
{
    if ((self = [super init])) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.88f alpha:1.0f];
    
    UIView *bottomToolbar = [[UIView alloc] init];
    bottomToolbar.backgroundColor = [UIColor colorWithWhite:0.11f alpha:1.0f];
    bottomToolbar.extSize = CGSizeMake(self.view.extSize.width, 82.0f);
    [EasyLayout bottomCenterView:bottomToolbar inParentView:self.view offset:CGSizeZero];
    
    [self.view addSubview:bottomToolbar];
    
    
    statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0f];
    statusLabel.text = @"Searching...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    [EasyLayout centerView:statusLabel inParentView:bottomToolbar offset:CGSizeZero];
    
    [bottomToolbar addSubview:statusLabel];
    
    
    baseCircle = [[BeaconCircleView alloc] init];
    [EasyLayout positionView:baseCircle aboveView:bottomToolbar horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, -50.0f)];
    
    [self.view addSubview:baseCircle];
    
    targetCircle = [[BeaconCircleView alloc] init];
    [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
    
    [self.view addSubview:targetCircle];
    
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.textColor = [UIColor blackColor];
    distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    distanceLabel.text = @"Unknown";
    [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
    [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
    [self.view addSubview:distanceLabel];
    
    
    modeButton = [ButtonMaker plainButtonWithNormalImageName:@"mode_button_detecting.png" selectedImageName:@"mode_button_broadcasting.png"];
    [modeButton addTarget:self action:@selector(didToggleMode:) forControlEvents:UIControlEventTouchUpInside];
    [EasyLayout positionView:modeButton aboveView:bottomToolbar offset:CGSizeMake(10.0f, -10.0f)];
    [self.view addSubview:modeButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[INBeaconService singleton] addDelegate:self];
    [[INBeaconService singleton] startDetecting];
    
    [self changeInterfaceToDetectMode];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - INBeaconServiceDelegate
- (void)service:(INBeaconService *)service foundDeviceUUID:(NSString *)uuid withRange:(INDetectorRange)range
{
    
    [UIView animateWithDuration:0.3f animations:^{
        switch (range) {
            case INDetectorRangeFar:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 60ft";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;

            case INDetectorRangeNear:
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 150.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 5ft";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
                
            case INDetectorRangeImmediate:
                [EasyLayout positionView:targetCircle aboveView:baseCircle
                            horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, 10.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 1 foot";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
                
            case INDetectorRangeUnknown:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 0.5f;
                
                distanceLabel.text = @"Out of range";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
        }
    }];
}
#pragma mark -

- (void)didToggleMode:(UIButton *)button
{
    if ([INBeaconService singleton].isDetecting) {
        modeButton.selected = YES;
        [[INBeaconService singleton] stopDetecting];
        [[INBeaconService singleton] startBroadcasting];
        [self changeInterfaceToBroadcastMode];
    } else if ([INBeaconService singleton].isBroadcasting) {
        modeButton.selected = NO;
        [[INBeaconService singleton] stopBroadcasting];
        [[INBeaconService singleton] startDetecting];
        [self changeInterfaceToDetectMode];
    }
    
}

- (void)changeInterfaceToBroadcastMode
{
    statusLabel.text = @"Broadcasting...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    
    [targetCircle stopAnimation];
    targetCircle.hidden = YES;
    distanceLabel.hidden = YES;
    [baseCircle startAnimationWithDirection:BeaconDirectionUp];
}

- (void)changeInterfaceToDetectMode
{
    statusLabel.text = @"Detecting...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    
    targetCircle.hidden = NO;
    distanceLabel.hidden = NO;
    [targetCircle startAnimationWithDirection:BeaconDirectionDown];
    [baseCircle stopAnimation];
}

@end
