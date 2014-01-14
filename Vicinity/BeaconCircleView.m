//
//  BeaconCircleView.m
//  Vicinity
//
//  Created by Ben Ford on 11/5/13.
//  
//  The MIT License (MIT)
// 
//  Copyright (c) 2013 Instrument Marketing Inc
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "BeaconCircleView.h"
#import "EasyLayout.h"
#import <QuartzCore/QuartzCore.h>

@implementation BeaconCircleView
{
    UIImageView *circleImage;

    UIImageView *radarRing1;
    UIImageView *radarRing2;
    
    NSTimer *animationTimer;
    
    BOOL isAnimating;
}

- (id)init
{
    
    if ((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 70.0f, 70.0f)])) {
        circleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle.png"]];
        [self addSubview:circleImage];
        
        radarRing1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring.png"]];
        radarRing1.contentMode = UIViewContentModeScaleToFill;
        radarRing1.hidden = YES;
        [circleImage addSubview:radarRing1];
        
        radarRing2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring.png"]];
        radarRing2.contentMode = UIViewContentModeScaleToFill;
        radarRing2.hidden = YES;
        [circleImage addSubview:radarRing2];
        
        isAnimating = NO;
        
    }
    return self;
}

- (void)startAnimationWithDirection:(BeaconDirection)direction
{
    isAnimating = YES;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.0f target:nil selector:nil userInfo:[NSNumber numberWithInt:direction] repeats:NO];
    [self animateRing:timer];
}

- (void)stopAnimation
{
    // stop all animations
    [radarRing1.layer removeAllAnimations];
    [radarRing2.layer removeAllAnimations];
    
    // prevent animation timer from starting
    isAnimating = NO;
}

- (void)animateRing:(NSTimer *)timer
{
    BeaconDirection direction = [timer.userInfo intValue];
    
    radarRing1.hidden = NO;
    radarRing2.hidden = NO;
    
    // pre-compute some frames for animation
    
    // compute start frame
    radarRing1.extSize = circleImage.extHalfSize;
    if (direction == BeaconDirectionUp)
        [EasyLayout bottomCenterView:radarRing1 inParentView:circleImage offset:CGSizeMake(0.0f, -5.0f)];
    if (direction == BeaconDirectionDown)
        [EasyLayout topCenterView:radarRing1 inParentView:circleImage offset:CGSizeMake(0.0f, 5.0f)];
    
    
    CGRect startFrame = radarRing1.frame;
    
    // compute end frame
    radarRing1.extSize = CGSizeMake(300.0f, 300.0f);
    if (direction == BeaconDirectionUp)
        [EasyLayout bottomCenterView:radarRing1 inParentView:circleImage offset:CGSizeZero];
    if (direction == BeaconDirectionDown)
        [EasyLayout topCenterView:radarRing1 inParentView:circleImage offset:CGSizeZero];
    
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
        
        if (!isAnimating) {
            animationTimer = nil;
            return;
        }
        
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(animateRing:)
                                                        userInfo:[NSNumber numberWithInt:direction] repeats:NO];
    }];
}
@end
