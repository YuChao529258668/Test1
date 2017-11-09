//
//  CGUserSettingViewController.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseViewController.h"
typedef void (^CGLogoutSuccessBlock)(void);
typedef void (^CGLogoutCancelBlock)(NSError *error);
@interface CGUserSettingViewController : CTBaseViewController
//@property (nonatomic, assign) BOOL isLogin;
-(instancetype)initWithBlock:(CGLogoutSuccessBlock)success fail:(CGLogoutCancelBlock)fail;

@end
