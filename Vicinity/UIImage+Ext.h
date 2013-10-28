//
//  UIImage+Ext.h
//  
//
//  Created by Ben Ford on 1/16/13.
//  Copyright (c) 2013 Ben Ford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Ext)
- (UIImage *)extStretchableImageByWidth;
- (UIImage *)extStretchableImageByHeight;
- (UIImage *)extStretchableImage;

- (UIImage *)extRotateImageToOrientation:(UIImageOrientation)orientation;
@end
