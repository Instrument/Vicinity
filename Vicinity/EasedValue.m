//
//  EasedValue.m
//  SpeedometerArc
//
//  Created by Ben Purdy on 1/31/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "EasedValue.h"

#define DEBUG_EASE NO

@implementation EasedValue
{
    CGFloat velocity;
    CGFloat targetValue;
    CGFloat currentValue;
}

- (id)init
{
    self = [super init];
    
    velocity = 0.0f;
    targetValue = 0.0f;
    currentValue = 0.0f;
    
    return self;
}

- (void)setValue:(CGFloat)value {
    targetValue = value;
}

- (CGFloat)value
{
    return currentValue;
}

- (void)update
{
    if (DEBUG_EASE) {
        NSLog(@"-- BEGIN update --");
        
        NSLog(@"velocity: %1.2f, target value: %1.2f, currentValue: %1.2f", velocity, targetValue, currentValue);
    }
    
    velocity += (targetValue - currentValue) * 0.01f;
    velocity *= 0.7f;
    
    if (DEBUG_EASE)
        NSLog(@"velocity: %1.2f, currentValue: %1.2f", velocity, currentValue);
    
    currentValue += velocity;
    
    if(fabsf(targetValue - currentValue) < 0.001f){
        currentValue = targetValue;
        velocity = 0.0f;
    }
    
    if (DEBUG_EASE)
        NSLog(@"velocity: %1.2f, currentValue: %1.2f", velocity, currentValue);
    
    // keep above zero
    currentValue = MAX(0.0f, currentValue);
    
    if (DEBUG_EASE) {
        NSLog(@"currentValue: %1.2f", currentValue);
    
        NSLog(@"-- END update --\n\n");
    }
}

- (void)reset
{
    currentValue = targetValue;
}
@end
