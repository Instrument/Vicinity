//
//  NSDictionary+Ext.h
//  
//
//  Created by Ben Ford on 2/23/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Ext)
- (NSNumber *)extNumberForKeyOrZero:(NSString *)theKey;
@end
