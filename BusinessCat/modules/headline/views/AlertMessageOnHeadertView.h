//
//  AlertNewDataCountView.h
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-提示更新了多少条的控件

#import <UIKit/UIKit.h>

@interface AlertMessageOnHeadertView : UILabel

+(AlertMessageOnHeadertView *)initWithText:(NSString *)text;

-(void)showInView:(UIView *)view frame:(CGRect)frame;

@end
