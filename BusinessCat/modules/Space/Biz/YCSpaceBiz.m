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
        NSLog(@"%@, error  = %@", NSStringFromSelector(_cmd), error.description);
    }];
}

@end
