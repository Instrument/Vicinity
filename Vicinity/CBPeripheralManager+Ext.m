//
//  CBPeripheralManager+Ext.m
//  Vicinity
//
//  Created by Ben Ford on 11/6/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "CBPeripheralManager+Ext.h"

@implementation CBPeripheralManager(Ext)
- (NSString *)stateString
{
    switch (self.state) {
        case CBPeripheralManagerStatePoweredOn:
            return @"Powered On";
            break;
        case CBPeripheralManagerStatePoweredOff:
            return @"Powered Off";
            break;
        case CBPeripheralManagerStateResetting:
            return @"Resetting";
            break;
        case CBPeripheralManagerStateUnauthorized:
            return @"Unauthorized";
            break;
        case CBPeripheralManagerStateUnknown:
            return @"Unknown";
            break;
        case CBPeripheralManagerStateUnsupported:
            return @"Unsupported";
            break;
        default:
            break;
    }
}
@end
