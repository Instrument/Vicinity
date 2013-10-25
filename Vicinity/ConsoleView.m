//
//  ConsoleView.m
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "ConsoleView.h"

@implementation ConsoleView
{
    UITextView *outputTextField;
}

- (id)init
{
    NSLog(@"-- pre-init --: %p", outputTextField);
    if ((self = [super init])) {
        NSLog(@"-- post-init-- %p", outputTextField);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"-- pre-initWithFrame-- %p", outputTextField);
    if ((self = [super initWithFrame:frame])) {
        NSLog(@"-- post-initWithFrame-- %p", outputTextField);
        outputTextField = [[UITextView alloc] initWithFrame:frame];
        outputTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        outputTextField.font = [UIFont fontWithName:@"Courier" size:12.0f];
        [self addSubview:outputTextField];
        
        
    }
    return self;
}

- (void)logStringWithFormat:(NSString *)formatString, ...
{
    va_list args;
    va_start(args, formatString);
    NSString *output = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    
    outputTextField.text = [NSString stringWithFormat:@"%@%@\n", outputTextField.text, output];
}

@end
