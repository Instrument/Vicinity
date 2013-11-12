//
//  CBUUID+Ext.m
//  Vicinity
//
//  Created by Ben Ford on 11/12/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "CBUUID+Ext.h"

@implementation CBUUID(Ext)
- (NSString *)representativeString;
{
    NSData *data = self.data;
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity:16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
    {
        switch (currentByteIndex)
        {
            case 3:
            case 5:
            case 7:
            case 9:[outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]]; break;
            default:[outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
        }
        
    }
    
    return outputString;
}
@end
