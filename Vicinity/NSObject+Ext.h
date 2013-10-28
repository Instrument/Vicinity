//
//  NSObject+Ext.h
//  
//
//  Created by Ben Ford on 5/8/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Ext)
+ (id)extNSNullIfNil:(id)object;
+ (BOOL)extIsNilOrNSNull:(id)object;
@end
