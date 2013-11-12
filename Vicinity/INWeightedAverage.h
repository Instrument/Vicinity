//
//  INWeightedAverage.h
//  Vicinity
//
//  Created by Ben Ford on 11/12/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INWeightedAverage : NSObject

- (void)addValue:(NSInteger)value;

@property (nonatomic, readonly) NSInteger weightedAverage;

@end
