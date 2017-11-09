//
//  DoodleDrawView.h
//  UltimateShow
//
//  Created by young on 17/1/4.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCDoodleDrawView : UIView

- (void)drawInCacheWithPath:(CGPathRef)path width:(CGFloat)width color:(UIColor *)color;
- (void)drawInTempWithPath:(CGPathRef)path width:(CGFloat)width color:(UIColor *)color;
- (void)eraseInCacheWithPath:(CGPathRef)path width:(CGFloat)width;
- (void)cleanAllPath;

@end
