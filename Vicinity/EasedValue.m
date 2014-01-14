//
//  EasedValue.m
//  
//
//  Created by Ben Purdy on 1/31/13.
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


#import "EasedValue.h"

@implementation EasedValue
{
    CGFloat velocity;
    CGFloat targetValue;
    CGFloat currentValue;
}

- (id)init
{
    self = [super init];
    
    velocity = 0.0f;
    targetValue = 0.0f;
    currentValue = 0.0f;
    
    return self;
}

- (void)setValue:(CGFloat)value
{
    targetValue = value;
}

- (CGFloat)value
{
    return currentValue;
}

- (void)update
{
    // determine speed at which the ease will happen
    // this is based on difference between target and current value
    velocity += (targetValue - currentValue) * 0.01f;
    velocity *= 0.7f;
    
    // ease the current value
    currentValue += velocity;
    
    // limit how small the ease can get
    if(fabsf(targetValue - currentValue) < 0.001f){
        currentValue = targetValue;
        velocity = 0.0f;
    }
    
    // keep above zero
    currentValue = MAX(0.0f, currentValue);
}

- (void)reset
{
    currentValue = targetValue;
}
@end
