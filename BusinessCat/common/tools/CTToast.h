//  CTToast.h
//  CGSays
//
//  Created by mochenyang on 16-10-16.
//  Copyright (c) 2016年 cgsays.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTToast : NSObject

//显示
- (void)show:(UIView *)parentView;

//显示 指定显示位置
-(void)show:(UIView *)parentView y:(float)y;

// 注：duration单位是毫秒
- (void)setDuration:(NSInteger )duration;

//初始化
+ (CTToast *)makeText:(NSString *)text;

// 创建并显示2秒，在主窗口
+ (void)showWithText:(NSString *)str;

@end
