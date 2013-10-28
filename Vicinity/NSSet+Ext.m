//
//  NSSet+Ext.m
//  
//
//  Created by Ben Ford on 5/7/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "NSSet+Ext.h"

@implementation NSSet(Ext)
- (NSSet *)extMapObjectsUsingBlock:(id (^)(id object))block
{
    NSMutableSet *results = [NSMutableSet setWithCapacity:self.count];
    for (id object in self.allObjects) {
        id fetchedObject = block(object);
        if (fetchedObject != nil)
            [results addObject:fetchedObject];
    }
    
    return [NSSet setWithSet:results];
}

- (NSSet *)extMapObjectsUsingSelector:(SEL)selector
{
    NSMutableSet *results = [NSMutableSet setWithCapacity:self.count];
    for (id object in self.allObjects) {

        // used to suppress use of performSelector:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id fetchedObject = [object performSelector:selector];
#pragma clang diagnostic pop
        
        if (fetchedObject != nil)
            [results addObject:fetchedObject];

    }
    return [NSSet setWithSet:results];
}

- (NSSet *)extMapObjectsUsingKeyPath:(NSString *)keyPath
{
    NSMutableSet *results = [NSMutableSet setWithCapacity:self.count];
    for (id object in self.allObjects) {
        id fetchedObject = [object valueForKeyPath:keyPath];
        if (fetchedObject != nil)
            [results addObject:fetchedObject];

    }
    return [NSSet setWithSet:results];
}

- (NSSet *)extFilteredSetUsingBlock:(BOOL (^)(id obj, BOOL *stop))predicate
{
    return [self objectsPassingTest:predicate];
}

- (NSMutableSet *)extMutableSet
{
    return [NSMutableSet setWithSet:self];
}
@end
