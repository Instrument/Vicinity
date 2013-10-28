//
//  UILabel+Ext.m
//  
//
//  Created by Ben Ford on 6/24/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "UILabel+Ext.h"
#import "NSString+Ext.h"

@implementation UILabel(Ext)
- (void)extAddPlaceHolderText:(NSString *)placeHolderText
{
    if ([NSString extContainsText:self.text] == NO)
        self.text = placeHolderText;
}

- (void)extRemovePlaceHolderText:(NSString *)placeHolderText
{
    if ([self.text isEqualToString:placeHolderText])
        self.text = @"";
}
@end
