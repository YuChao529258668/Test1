//
//  YCWorkViewController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"

@interface YCWorkViewController : CTBaseViewController

#pragma mark - 适配旧代码

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;
//获取token回调 state:YES-成功 NO-失败
- (void)tokenCheckComplete:(BOOL)state;


@end
