//
//  DoodleDrawView.m
//  UltimateShow
//
//  Created by young on 17/1/4.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCDoodleDrawView.h"

@interface JCDoodleDrawView ()

@property (nonatomic, strong) UIImage *cacheImage;

@end

@implementation JCDoodleDrawView

- (void)drawRect:(CGRect)rect
{
    if (_cacheImage) {
        [_cacheImage drawInRect:self.bounds];
    }
}

- (void)drawInCacheWithPath:(CGPathRef)path width:(CGFloat)width color:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [_cacheImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    _cacheImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)drawInTempWithPath:(CGPathRef)path width:(CGFloat)width color:(UIColor *)color
{
    if (_cacheImage) {
        _cacheImage = nil;
    }
    
    [self drawInCacheWithPath:path width:width color:color];
}

- (void)eraseInCacheWithPath:(CGPathRef)path width:(CGFloat)width
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [_cacheImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    _cacheImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)cleanAllPath
{
    if (_cacheImage) {
        _cacheImage = nil;
    }
    
    [self setNeedsDisplay];
}

@end
