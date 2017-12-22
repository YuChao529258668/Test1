//
//  ColourToolbarView.h
//  UltimateShow
//
//  Created by Justin on 2017/1/18.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCColourToolbar;

@protocol ColourToolbarDelegate <NSObject>
/**
 按钮的代理事件
 
 @param colourToolbar       ColourToolbar对象
 @param button              UIButton对象
 @param color               选中的颜色
 */
- (void)colourToolbar:(JCColourToolbar *)colourToolbar color:(UIColor *)color colorImage:(UIImage *)image;

@end

@interface JCColourToolbar : UIView
// 设置代理
@property (nonatomic, weak) id<ColourToolbarDelegate> delegate;
// UIButton的对象数组
@property (nonatomic, readonly, strong) NSArray *buttons;
// 当前颜色值
@property (nonatomic, readonly, strong) UIColor *currentColor;

- (CGSize)mySize;

// 初始颜色图片
- (UIImage *)initialColorImage;

@end
