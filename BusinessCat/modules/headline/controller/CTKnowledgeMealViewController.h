//
//  CTKnowledgeMealViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CTKnowledgeMealViewController : CTBaseViewController

-(void)tokenCheckComplete:(BOOL)state;

- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

//加载完成分类回调
-(void)loadNavTypeFinish;

//收到推送处理
-(void)getPushDealWithRecordId:(NSString *)recordId parameterId:(NSString *)parameterId;
@end
