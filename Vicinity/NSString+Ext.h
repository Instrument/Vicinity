//
//  NSString+Ext.h
//
//  Created by Ben Ford on 10/27/11.
//  Copyright (c) 2011 Ben Ford All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NSStringExtElipseTypeNone = 0,
    NSStringExtElipseTypeEnd,
    NSStringExtElipseTypeMiddle,
    NSStringExtElipseTypeFront,
} NSStringExtElipseType;

@interface NSString(Ext)

+ (NSString *)extEmptyStringIfNilOrBlank:(NSString *)inputString;

+ (BOOL)extContainsText:(NSString *)inputString;

- (CGRect)extToCGRect;

- (BOOL)extBeginsWithString:(NSString *)beginsWith;
- (BOOL)extEndsWithString:(NSString *)endsWith;

- (NSString *)extExtensionWithDot;
- (NSString *)extLastPathComponentWithoutExtension;
- (NSString *)extPathWithoutExtension;

- (NSString *)extStringWithMaxLength:(NSUInteger)maxLength withElipses:(NSStringExtElipseType)elipseType;
- (NSString *)extStringThatFitsWidth:(CGFloat)maxWidth font:(UIFont *)font withElipses:(NSStringExtElipseType)elipseType;

- (NSString *)extTrimmedString;
@end
