//
//  NSSet+Ext.h
//  
//
//  Created by Ben Ford on 5/7/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet(Ext)
- (NSSet *)extMapObjectsUsingBlock:(id (^)(id object))block;
- (NSSet *)extMapObjectsUsingSelector:(SEL)selector;
- (NSSet *)extMapObjectsUsingKeyPath:(NSString *)keyPath;

// this only exists to maintain compatibility with NSArray+Ext extFilteredArrayUsingBlock
// it merely wraps NSFoundation's objectsPassingTest: method
- (NSSet *)extFilteredSetUsingBlock:(BOOL (^)(id obj, BOOL *stop))predicate;

- (NSMutableSet *)extMutableSet;
@end
