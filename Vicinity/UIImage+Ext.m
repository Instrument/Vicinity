//
//  UIImage+Ext.m
//  
//
//  Created by Ben Ford on 1/16/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage(Ext)

- (UIImage *)extStretchableImageByWidth
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, floorf(self.size.width/2.0f)-1.0f, 0.0f, floorf(self.size.width/2.0f)+1.0f)];
}

- (UIImage *)extStretchableImageByHeight
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(self.size.height/2.0f)-1.0f, 0.0f, floorf(self.size.height/2.0f)+1.0f, 0.0f)];
}

- (UIImage *)extStretchableImage
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(self.size.height/2.0f)-1.0f,
                                                              floorf(self.size.width/2.0f)-1.0f,
                                                              floorf(self.size.height/2.0f)+1.0f,
                                                              floorf(self.size.width/2.0f)+1.0f)];
}

- (UIImage *)extRotateImageToOrientation:(UIImageOrientation)orientation
{
    return [[UIImage alloc] initWithCGImage:self.CGImage scale:self.scale orientation:orientation];
}
@end
