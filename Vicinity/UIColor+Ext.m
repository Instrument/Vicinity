//
//  UIColor+Ext.m
//  
//
//  Created by Ben Ford on 3/12/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import "UIColor+Ext.h"

NSUInteger intFromHexChar(char c) {
	if ( c >= '0' && c <= '9' ) 
		return [[NSNumber numberWithChar:c] intValue] - '0';
	
	switch ( c ) {
		case 'A': 
        case 'a': 
            return 10;
		case 'B': 
        case 'b': 
            return 11;
		case 'C': 
        case 'c': 
            return 12;
		case 'D': 
        case 'd': 
            return 13;
		case 'E': 
        case 'e': 
            return 14;
		case 'F': 
        case 'f': 
            return 15;
		default: return 0;
	}
}

@implementation UIColor(Ext)

+ (UIColor *)extColorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha {
    if( [hexString length] == 7 )
        hexString = [hexString substringFromIndex:1];
    
	if( [hexString length] != 6 ) 
        return [UIColor blackColor];
    
	CGFloat rgb[3] = {0,0,0};
	int rgbIndex=0;
	for ( NSInteger i = 0; i < [hexString length]; i=i+2 ) {
		NSUInteger firstCharacter = intFromHexChar([hexString characterAtIndex:i]);
		firstCharacter = firstCharacter << 4;
		
        NSUInteger secondCharacter = intFromHexChar([hexString characterAtIndex:i+1]);
		firstCharacter += secondCharacter;
        
		rgb[rgbIndex++] = (CGFloat)(firstCharacter/255.0);
	}
	
	return [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:alpha];    
}

+ (UIColor *)extColorFromHexString:(NSString *)hexString {
	return [UIColor extColorFromHexString:hexString withAlpha:1.0f];
	
}

- (NSString *)extRGBString {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX", (unsigned long)(red*255.0f), (unsigned long)(green*255.0f), (unsigned long)(blue*255.0f)];
}

@end
