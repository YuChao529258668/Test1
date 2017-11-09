//
//  MessageViewController.h
//  UltimateEdu
//
//  Created by young on 2017/5/18.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMessageViewController : UIViewController

//消息发送成员昵称的显示颜色
@property (nonatomic, copy) UIColor *nameColor;

//消息内容的显示颜色
@property (nonatomic, copy) UIColor *contentColor;

- (void)sendMessage:(NSString *)message;

@end
