//
//  CLBeacon+Ext.m
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "CLBeacon+Ext.h"

@implementation CLBeacon(Ext)
- (NSString *)proximityString
{
    switch (self.proximity) {
        case CLProximityFar:
            return @"Far";
            break;
            
        case CLProximityImmediate:
            return @"Immediate";
            break;
            
        case CLProximityNear:
            return @"Near";
            break;
            
        case CLProximityUnknown:
            return @"Unknown";
            break;
    }
}
@end
