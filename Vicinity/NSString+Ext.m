//
//  NSString+Ext.m
//
//  Created by Ben Ford on 10/27/11.
//  Copyright (c) 2011 Ben Ford All rights reserved.
//

#import "NSString+Ext.h"
#import "NSArray+Ext.h"
#import <QuartzCore/QuartzCore.h>
#import "NSRangeExt.h"

@implementation NSString(Ext)

+ (NSString *)extEmptyStringIfNilOrBlank:(NSString *)inputString {
    BOOL isBlank = [[inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
    if( inputString == nil || isBlank == YES )
        return @"";
    else
        return inputString;
}

+ (BOOL)extContainsText:(NSString *)inputString {
    return inputString != nil && [[inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

- (CGRect)extToCGRect {
	NSArray * arr = [self componentsSeparatedByString:@","];
	
	return CGRectMake([[arr extNumberAtIndexOrZero:0] floatValue], [[arr extNumberAtIndexOrZero:1] floatValue], [[arr extNumberAtIndexOrZero:2] floatValue],[[arr extNumberAtIndexOrZero:3] floatValue]);
}

- (BOOL)extBeginsWithString:(NSString *)beginsWith {
    return [self rangeOfString:beginsWith].location == 0;
}

- (BOOL)extEndsWithString:(NSString *)endsWith
{
    NSRange range = [self rangeOfString:endsWith];
    return Ext_NSRangeGetArrayIndex(range) == (self.length-1);
}

- (NSString *)extExtensionWithDot {
    return [NSString stringWithFormat:@".%@",[self pathExtension]];    
}

- (NSString *)extLastPathComponentWithoutExtension {    
    return [[self lastPathComponent] stringByReplacingOccurrencesOfString:[self extExtensionWithDot] withString:@""];
}

- (NSString *)extPathWithoutExtension {
    return [self stringByReplacingOccurrencesOfString:[self extExtensionWithDot] withString:@""];
}

- (NSString *)extStringThatFitsWidth:(CGFloat)maxWidth font:(UIFont *)font withElipses:(NSStringExtElipseType)elipseType {
    NSMutableString *stringToShrink = [[NSMutableString alloc] initWithString:self];
    CGSize size = [stringToShrink sizeWithAttributes:@{NSFontAttributeName:font}];
    if( size.width <= maxWidth )
        return stringToShrink;
    
    CGSize ellipseSize = [@"..." sizeWithAttributes:@{NSFontAttributeName:font}];
    
    NSUInteger charIndex;
    for( charIndex = [stringToShrink length]-1; charIndex > 0; charIndex-- ) {
        [stringToShrink deleteCharactersInRange:NSMakeRange(charIndex, 1)];

        CGSize size = [stringToShrink sizeWithAttributes:@{NSFontAttributeName:font}];
        if( size.width <= maxWidth-ellipseSize.width )
            break;
    }
    
    return [self extStringWithMaxLength:charIndex+1 withElipses:elipseType];
}

- (NSString *)extStringWithMaxLength:(NSUInteger)maxLength withElipses:(NSStringExtElipseType)elipseType {
    if( [self length] <= maxLength )
        return self;
    
    
    if( elipseType == NSStringExtElipseTypeNone )
        return [self substringToIndex:maxLength];

    if( elipseType == NSStringExtElipseTypeFront ) {
        NSUInteger lastHalf = [self length]-maxLength;
        return [NSString stringWithFormat:@"%@%@", @"...", [self substringFromIndex:lastHalf]];
    }
    
    if( elipseType == NSStringExtElipseTypeMiddle ) {
        NSUInteger firstHalf = maxLength / 2;
        NSUInteger lastHalf = [self length]-firstHalf;
        return [NSString stringWithFormat:@"%@%@%@", [self substringToIndex:firstHalf], @"...", [self substringFromIndex:lastHalf]];
    }
    
    if( elipseType == NSStringExtElipseTypeEnd )
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:maxLength], @"..."];

    return [self substringToIndex:maxLength];
}

- (NSString *)extTrimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
