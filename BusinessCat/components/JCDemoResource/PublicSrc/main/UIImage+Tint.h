//
//  UIImage.h
//  UltimateShow
//
//  Created by young on 16/12/16.
//  Copyright © 2016年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

+ (UIImage *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (UIImage *)imageWithColor:(UIColor *)tintColor;

@end
