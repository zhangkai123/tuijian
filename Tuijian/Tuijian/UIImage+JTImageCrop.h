//
//  UIImage+JTImageCrop.h
//  Tuijian
//
//  Created by zhang kai on 3/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JTImageCrop)

+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect;

// define rect in proportional to the target image.
//
//  +--+--+
//  |A | B|
//  +--+--+
//  |C | D|
//  +--+--+
//
//  rect {0, 0, 1, 1} produce full image without cropping.
//  rect {0.5, 0.5, 0.5, 0.5} produce part D, etc.

+ (UIImage *)imageWithImage:(UIImage *)image cropInRelativeRect:(CGRect)rect;
@end

// Used by +[UIImage imageWithImage:cropInRelativeRect]
CGRect CGRectTransformToRect(CGRect fromRect, CGRect toRect);
