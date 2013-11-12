//
//  EasedValue.h
//  SpeedometerArc
//
//  Created by Ben Purdy on 1/31/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasedValue : NSObject


@property (nonatomic, assign) CGFloat value;

- (void)update;
- (void)reset;
@end
