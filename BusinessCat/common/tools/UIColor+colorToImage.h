//
//  UIColor+colorToImage.h
//  jmtong
//
//  Created by xh on 14-3-7.
//  Copyright (c) 2014年 viviko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorToImage)

+ (UIImage *)createImageWithColor:(UIColor *)color Rect:(CGRect)rect;

@end
