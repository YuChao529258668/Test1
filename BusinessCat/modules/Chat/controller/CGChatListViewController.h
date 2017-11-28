//
//  CGChatListViewController.h
//  CGKnowledge
//
//  Created by 余超 on 2017/10/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

#import "ConversationListViewController.h"

//@interface CGChatListViewController : CTBaseViewController
@interface CGChatListViewController : ConversationListViewController
@property(nonatomic, strong)NSString *titleStr;

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

//获取token回调 state:YES-成功 NO-失败
- (void)tokenCheckComplete:(BOOL)state;

@end

