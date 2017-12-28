//
//  CTMessageDialog.h
//  CGSays
//
//  Created by mochenyang on 11-11-15.
//  Copyright 2011年 gdcattsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTMessageDialog : NSObject
{
}

+ (UIAlertView *)show:(NSString *)msg;

+ (UIAlertView *)show:(NSString *)msg title:(NSString *)title;

+ (UIAlertView *)confirm:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

/**
 * 显示提示框，并3秒后关闭
 */
+ (void)toast:(NSString *)msg;

/**
 * 显示提示框
 * duration 自动关闭时间，单位秒
 */
+ (void)toast:(NSString *)msg duration:(float)duration;

/**
 * 同步的确认框
 */
+ (BOOL)yesOrNoWithMsg:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

@end
