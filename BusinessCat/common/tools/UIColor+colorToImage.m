//
//  UIColor+colorToImage.m
//  jmtong
//
//  Created by xh on 14-3-7.
//  Copyright (c) 2014年 viviko. All rights reserved.
//

#import "UIColor+colorToImage.h"

@implementation UIColor (colorToImage)

+ (UIImage *)createImageWithColor:(UIColor *)color Rect:(CGRect)rc
{
    CGRect rect = CGRectMake(0.f, 0.f, rc.size.width, rc.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
