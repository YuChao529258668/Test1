//
//  YCSpaceBiz.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCSeeBoard.h"
#import "YCMeetingProfit.h"

@interface YCSpaceBiz : CGBaseBiz

// 看板数据
+ (void)getBoardWithSuccess:(void (^)(YCSeeBoard *board))success fail:(void (^)(NSError *error))fail;

// 获取收益
+ (void)getProfitWithType:(int)type companyID:(NSString *)cid Success:(void (^)(YCMeetingProfit *profit))success fail:(void (^)(NSError *error))fail;

//type 0:公司 1：用户
//doShare 0取消共享 1开启共享
+ (void)joinShareWithType:(int)type companyID:(NSString *)cid doShare:(int)share Success:(void (^)())success fail:(void (^)(NSError *error))fail;

@end
