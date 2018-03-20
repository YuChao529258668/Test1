//
//  CGMyMainViewController.h
//  CGSays
//
//  Created by mochenyang on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGMyMainViewController : CTBaseViewController

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

//获取token回调 state:YES-成功 NO-失败
-(void)tokenCheckComplete:(BOOL)state;

@property (nonatomic,copy) void (^onNeedLoginBlock)();

@end
