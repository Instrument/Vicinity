//
//  CBPeripheralManager+Ext.h
//  Vicinity
//
//  Created by Ben Ford on 11/6/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheralManager(Ext)
- (NSString *)stateString;
@end
