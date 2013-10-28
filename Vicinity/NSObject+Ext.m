//
//  NSObject+Ext.m
//  
//
//  Created by Ben Ford on 5/8/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "NSObject+Ext.h"

@implementation NSObject(Ext)
+ (id)extNSNullIfNil:(id)object
{
    if (object == nil)
        return [NSNull null];
    else
        return object;
}

+ (BOOL)extIsNilOrNSNull:(id)object
{
    return object == nil || [object isKindOfClass:[NSNull class]];
}
@end
