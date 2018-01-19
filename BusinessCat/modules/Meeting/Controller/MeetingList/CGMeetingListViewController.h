//
//  CGMeetingListViewController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"

@interface CGMeetingListViewController : YCBaseViewController

// 适配旧代码
@property(nonatomic, strong)NSString *titleStr;
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

@end
