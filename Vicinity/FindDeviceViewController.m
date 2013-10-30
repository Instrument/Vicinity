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

@interface FindDeviceViewController () <INBeaconServiceDelegate>

@end

@implementation FindDeviceViewController
{
    UILabel *statusLabel;
    
    UIImageView *baseCircle;
    UIImageView *targetCircle;
    
    UIImageView *radarRing1;
    UIImageView *radarRing2;
    
    NSTimer *animationTimer;
    
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
    
    
    baseCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle.png"]];
    baseCircle.clipsToBounds = NO;
    [EasyLayout positionView:baseCircle aboveView:bottomToolbar horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, -50.0f)];
    
    [self.view addSubview:baseCircle];
    
    targetCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle.png"]];
    [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
    
    [self.view addSubview:targetCircle];
    
    radarRing1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring.png"]];
    radarRing1.contentMode = UIViewContentModeScaleToFill;
    [baseCircle addSubview:radarRing1];
    
    radarRing2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring.png"]];
    radarRing2.contentMode = UIViewContentModeScaleToFill;
    [baseCircle addSubview:radarRing2];
    
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
    
    // force initial state
    [self service:nil foundDeviceWithRange:INDetectorRangeUnknown];
    
    [self animateRing:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)animateRing:(NSTimer *)timer
{
    
    // pre-compute some frames for animation
    
    // compute start frame
    radarRing1.extSize = baseCircle.extHalfSize;
    [EasyLayout bottomCenterView:radarRing1 inParentView:baseCircle offset:CGSizeMake(0.0f, -5.0f)];
    

    CGRect startFrame = radarRing1.frame;
    
    // compute end frame
    radarRing1.extSize = CGSizeMake(300.0f, 300.0f);
    [EasyLayout bottomCenterView:radarRing1 inParentView:baseCircle offset:CGSizeZero];
    CGRect endFrame = radarRing1.frame;
    
    
    // apply position
    radarRing1.frame = startFrame;
    radarRing1.alpha = 1.0f;
    
    radarRing2.frame = startFrame;
    radarRing2.alpha = 1.0f;
    
    // animate up and out
    [UIView animateWithDuration:1.3f animations:^{
        radarRing1.frame = endFrame;
        radarRing1.alpha = 0.0f;
    } completion:^(BOOL finished) {
       
    }];
    
    [UIView animateWithDuration:1.3f delay:0.1f options:0 animations:^{

        radarRing2.frame = endFrame;
        radarRing2.alpha = 0.0f;

    } completion:^(BOOL finished) {
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(animateRing:)
                                                        userInfo:nil repeats:NO];
    }];
}

#pragma mark - INBeaconServiceDelegate
- (void)service:(INBeaconService *)service foundDeviceWithRange:(INDetectorRange)range
{
    
    [UIView animateWithDuration:0.3f animations:^{
        switch (range) {
            case INDetectorRangeFar:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 0.7f;
                break;

            case INDetectorRangeNear:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 150.0f)];
                targetCircle.alpha = 1.0f;
                break;
                
            case INDetectorRangeImmediate:
                [EasyLayout positionView:targetCircle aboveView:baseCircle
                            horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, 10.0f)];
                targetCircle.alpha = 1.0f;
                break;
                
            case INDetectorRangeUnknown:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 0.5f;
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
    } else if ([INBeaconService singleton].isBroadcasting) {
        modeButton.selected = NO;
        [[INBeaconService singleton] stopBroadcasting];
        [[INBeaconService singleton] startDetecting];
    }
}
@end
