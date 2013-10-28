//
//  ConsoleView.m
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "ConsoleView.h"
#import "EasyLayout.h"

@implementation ConsoleView
{
    UIScrollView *outputScrollView;
    UILabel *outputLabel;
    NSUInteger lineCounter;
}

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
    
    
    outputLabel.text = [NSString stringWithFormat:@"%d: %@\n%@", lineCounter, output, outputLabel.text];
    [self setNeedsLayout];
    
    lineCounter++;
}

@end
