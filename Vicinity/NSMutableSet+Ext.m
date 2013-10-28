//
//  NSMutableSet+Ext.m
//  
//
//  Created by Ben Ford on 8/1/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "NSMutableSet+Ext.h"

@implementation NSMutableSet(Ext)
- (NSSet *)extSet
{
    return [NSSet setWithSet:self];
}
@end
