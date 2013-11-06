//
//  BeaconCircleView.h
//  Vicinity
//
//  Created by Ben Ford on 11/5/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    BeaconDirectionUp = 0,
    BeaconDirectionDown = 1,
} BeaconDirection;

@interface BeaconCircleView : UIView

- (void)startAnimationWithDirection:(BeaconDirection)direction;
- (void)stopAnimation;
@end
