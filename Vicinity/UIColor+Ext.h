//
//  UIColor+Ext.h
//  
//
//  Created by Ben Ford on 3/12/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(Ext)
+ (UIColor *)extColorFromHexString:(NSString *)hexString;
+ (UIColor *)extColorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha;

- (NSString *)extRGBString;
@end
