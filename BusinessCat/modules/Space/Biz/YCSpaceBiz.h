//
//  YCSpaceBiz.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCSeeBoard.h"

@interface YCSpaceBiz : CGBaseBiz

+ (void)getBoardWithSuccess:(void (^)(YCSeeBoard *board))success fail:(void (^)(NSError *error))fail;

@end
