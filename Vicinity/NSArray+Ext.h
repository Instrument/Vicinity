//
//  NSArray+Ext.h
//
//  Created by Ben Ford on 10/27/11.
//  Copyright (c) 2011 Ben Ford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Ext)
- (id)extObjectAtIndexOrNil:(NSUInteger)theIndex;
- (id)extFirstObject;

- (NSUInteger)extLastIndex;

- (NSNumber *)extNumberAtIndexOrZero:(NSUInteger)theIndex;

- (id)extObjectPrecedingObject:(id)object;

- (NSArray *)extMapObjectsUsingBlock:(id (^)(id object))block;
- (NSArray *)extMapObjectsUsingSelector:(SEL)selector;
- (NSArray *)extMapObjectsUsingKeyPath:(NSString *)keyPath;

- (NSArray *)extFilteredArrayUsingBlock:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (NSRange)extRangeOfObjectsWithKeyPath:(NSString *)keyPath matchingTwoValues:(NSArray *)values;

- (NSSet *)extSet;
- (NSMutableSet *)extMutableSet;
- (NSMutableArray *)extMutableArray;

- (NSArray *)extSortArrayByKey:(NSString *)key ascending:(BOOL)ascending;
- (NSArray *)extSortArrayByKeys:(NSArray *)keys ascending:(BOOL)ascending;

+ (NSArray *)extEmptyArrayIfNil:(NSArray *)array;
@end
