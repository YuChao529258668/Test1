//
//  YCSpaceBiz.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSpaceBiz.h"

@implementation YCSpaceBiz

+ (CTNetWorkUtil *)component{
    return [self shareBiz].component;
}

+ (YCSpaceBiz *)shareBiz {
    static YCSpaceBiz *biz;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        biz = [YCSpaceBiz new];
    });
    return biz;
}


#pragma mark -

+ (void)getBoardWithSuccess:(void (^)(YCSeeBoard *board))success fail:(void (^)(NSError *error))fail {
    [self.component sendPostRequestWithURL:URL_Meeting_Board param:nil success:^(id data) {
        YCSeeBoard *board = [YCSeeBoard mj_objectWithKeyValues:data];
        if (success) {
            success(board);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)getProfitWithType:(int)type companyID:(NSString *)cid Success:(void (^)(YCMeetingProfit *profit))success fail:(void (^)(NSError *error))fail {
    if (!cid) {
        cid = @"";
    }
    NSDictionary *dic = @{@"type": @(type), @"companyId": cid};
    
    [self.component sendPostRequestWithURL:URL_Meeting_Profit param:dic success:^(id data) {
        YCMeetingProfit *profit = [YCMeetingProfit mj_objectWithKeyValues:data];
        if (success) {
            success(profit);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

//type 0:公司 1：用户
//doShare 0取消共享 1开启共享
+ (void)joinShareWithType:(int)type companyID:(NSString *)cid doShare:(int)share Success:(void (^)())success fail:(void (^)(NSError *error))fail {
    NSDictionary *dic = @{@"type": @(type), @"companyId": cid, @"doShare": @(share)};
    
    [self.component sendPostRequestWithURL:URL_Meeting_Add_Share param:dic success:^(id data) {
        if (success) {
            success();
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

@end
