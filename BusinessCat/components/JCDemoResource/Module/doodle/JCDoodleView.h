//
//  DoodleView.h
//  UltimateShow
//
//  Created by young on 17/1/4.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCDoodleView : UIView

@property (nonatomic, strong) UIImage *backgroundImage;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

//画到缓存的画布上
- (void)drawInCacheWithPath:(CGPathRef)path lineWidth:(CGFloat)width lineColor:(UIColor *)color;

//画到临时的画布上
- (void)drawInTempWithPath:(CGPathRef)path lineWidth:(CGFloat)width lineColor:(UIColor *)color;

- (void)eraseInCacheWithPath:(CGPathRef)path lineWidth:(CGFloat)width;
- (void)cleanAllPath;

@end
