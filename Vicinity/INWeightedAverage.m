//
//  INWeightedAverage.m
//  Vicinity
//
//  Created by Ben Ford on 11/12/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "INWeightedAverage.h"
#define NUMBER_OF_AVERAGES 70

@implementation INWeightedAverage
{
    NSMutableArray *values;
}

- (id)init
{
    if ((self = [super init])) {
        values = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addValue:(NSInteger)value
{
    if ([values count] > NUMBER_OF_AVERAGES)
        [values removeObjectAtIndex:0];
    
    [values addObject:@(value)];
}

- (NSInteger)weightedAverage
{
    NSInteger sum = 0;
    for (NSNumber *value in values) {
        sum += [value integerValue];
    }
    return sum/(NSInteger)[values count];
}
@end
