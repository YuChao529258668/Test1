//
//  CGKnowledgeBaseViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGKnowledgeBaseViewController : CTBaseViewController
//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

//获取token回调 state:YES-成功 NO-失败
-(void)tokenCheckComplete:(BOOL)state;

//加载完成分类回调，为了避免今日知识和岗位知识的分类的公用处理
-(void)loadNavTypeFinish;

//收到推送处理
-(void)getPushDealWithRecordId:(NSString *)recordId;
@end
