//
//  CBCentralManager+Ext.m
//  Vicinity
//
//  Created by Ben Ford on 11/12/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "CBCentralManager+Ext.h"

@implementation CBCentralManager(Ext)
- (NSString *)stateString
{
    switch (self.state) {
        case CBCentralManagerStatePoweredOff:
            return @"Powered Off";
            break;
            
        case CBCentralManagerStateResetting:
            return @"Resetting";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return @"Powered On";
            break;
            
        case CBCentralManagerStateUnauthorized:
            return @"Unauthorized";
            break;
            
        case CBCentralManagerStateUnknown:
            return @"Unknown";
            break;
            
        case CBCentralManagerStateUnsupported:
            return @"Unsupported";
            break;
    }
}
@end
