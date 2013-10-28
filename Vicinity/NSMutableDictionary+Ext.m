//
//  NSMutableDictionary.m
//  
//
//  Created by Ben Ford on 7/23/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "NSMutableDictionary+Ext.h"

@implementation NSMutableDictionary(Ext)
- (NSDictionary *)extDictionary
{
    return [NSDictionary dictionaryWithDictionary:self];
}
@end
