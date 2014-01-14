//
//  ConsoleView.m
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  
//  The MIT License (MIT)
// 
//  Copyright (c) 2013 Instrument Marketing Inc
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "ConsoleView.h"
#import "EasyLayout.h"
#import "GCDSingleton.h"

void INLog(NSString *message, ...)
{
    va_list args;
    va_start(args, message);
    NSString *output = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    
    [[ConsoleView singleton] logStringWithFormat:output];
    NSLog(@"%@", output);
}

@implementation ConsoleView
{
    UIScrollView *outputScrollView;
    UILabel *outputLabel;
    NSUInteger lineCounter;
}

#pragma mark Singleton
+ (ConsoleView *)singleton
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}
#pragma mark -

- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
 
    if ((self = [super initWithFrame:frame])) {
 
        outputScrollView = [[UIScrollView alloc] initWithFrame:frame];
        outputScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:outputScrollView];
        
        outputLabel = [[UILabel alloc] init];
        outputLabel.autoresizingMask = UIViewAutoresizingNone;
        outputLabel.font = [UIFont fontWithName:@"Courier" size:12.0f];
        outputLabel.text = @"-- initialize logging --";
        [outputScrollView addSubview:outputLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [EasyLayout sizeLabel:outputLabel mode:ELLineModeMulti maxWidth:outputScrollView.extSize.width];
    outputScrollView.contentSize = CGSizeMake(outputScrollView.extSize.width, outputLabel.extSize.height);
}

- (void)logStringWithFormat:(NSString *)formatString, ...
{
    va_list args;
    va_start(args, formatString);
    NSString *output = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    
    
    outputLabel.text = [NSString stringWithFormat:@"%lu: %@\n%@", (unsigned long)lineCounter, output, outputLabel.text];
    [self setNeedsLayout];
    
    lineCounter++;
}

@end
