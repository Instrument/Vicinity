//
//  NSDictionary+Ext.m
//  
//
//  Created by Ben Ford on 2/23/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import "NSDictionary+Ext.h"

@implementation NSDictionary(Ext)
- (NSNumber *)extNumberForKeyOrZero:(NSString *)theKey {
	id number = [self objectForKey:theKey];
    
	if ( [number isKindOfClass:[NSNumber class]] )
		return number;
	
	if ( [number isKindOfClass:[NSString class]] ) 
		return [NSNumber numberWithFloat:[number floatValue]];
	
	return [NSNumber numberWithInt:0];
}

@end
