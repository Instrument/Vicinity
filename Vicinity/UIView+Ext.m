//
//  UIView+Ext.m
//  
//
//  Created by Ben Ford on 10/11/12.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView(Ext)
- (void)extRemoveAllSubviews {
    for( UIView *view in [self subviews] )
        [view removeFromSuperview];
}
@end
