//
//  CGDiscoverMainController.h
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGDiscoverMainController : CTBaseViewController

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

-(void)tokenCheckComplete:(BOOL)state;
@end
