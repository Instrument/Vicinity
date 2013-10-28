//
//  NSMutableArray+Ext.m
//  
//
//  Created by Ben Ford on 8/22/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "NSMutableArray+Ext.h"

@implementation NSMutableArray(Ext)
- (NSArray *)extArray
{
    return [NSArray arrayWithArray:self];
}
@end
