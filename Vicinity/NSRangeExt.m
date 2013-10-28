//
//  NSRangeExt.m
//  
//
//  Created by Ben Ford on 10/3/12.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//

#import "NSRangeExt.h"

NSRange Ext_NSRangeFromArrayIndexes(NSUInteger startIndex, NSUInteger endIndex) {
    return NSMakeRange(startIndex, endIndex-startIndex+1);
}

NSUInteger Ext_NSRangeGetArrayIndex(NSRange range) {
    return range.location+range.length-1;
}

NSRange Ext_NSRangeUnion(NSRange firstRange, NSRange secondRange) {
    
    NSUInteger fromIndex = MIN(firstRange.location, secondRange.location);
    NSUInteger toIndex = MAX(Ext_NSRangeGetArrayIndex(firstRange),Ext_NSRangeGetArrayIndex(secondRange));

    return Ext_NSRangeFromArrayIndexes(fromIndex, toIndex);
}

BOOL Ext_NSRangeValidForArray(NSRange range, NSArray *array) {
    NSUInteger endIndex = Ext_NSRangeGetArrayIndex(range);
    return endIndex <= [array count]-1;
}

BOOL EXT_NSRangeIsZero(NSRange range) {
    return range.location == 0 && range.length == 0;
        
}

NSRange Ext_NSRangeIntersectionFromArrays(NSArray *firstArray, NSArray *secondArray) {
    // handle empty arrays
    if( [firstArray count] == 0 || [secondArray count] == 0 )
        return NSMakeRange(0, 0);
    
    // force smallest array to be first
    NSArray *temp;
    if( [firstArray count] > [secondArray count] ) {
        temp = secondArray;
        secondArray = firstArray;
        firstArray = temp;
    }
    
    id firstObject = [firstArray objectAtIndex:0];
    id lastObject = [firstArray lastObject];
    
    NSUInteger indexOfFirstObject = [secondArray indexOfObject:firstObject];
    NSUInteger indexOfLastObject = [secondArray indexOfObject:lastObject];
    
    return Ext_NSRangeFromArrayIndexes(indexOfFirstObject, indexOfLastObject);
}