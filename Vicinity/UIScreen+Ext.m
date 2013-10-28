//
//  UIScreen+Ext.m
//  
//
//  Created by Ben Ford on 3/26/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import "UIScreen+Ext.h"

@implementation UIScreen(Ext)
- (CGRect)extOrientedBounds {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )
        return CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    else
        return CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
}
@end
