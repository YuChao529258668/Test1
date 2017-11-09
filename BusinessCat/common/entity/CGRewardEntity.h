//
//  CGRewardEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRewardEntity : NSObject
@property (nonatomic, copy) NSString *trade_type;
@property (nonatomic, copy) NSString *result_code;
@property (nonatomic, copy) NSString *mch_id;
@property (nonatomic, copy) NSString *return_code;
@property (nonatomic, copy) NSString *nonce_str;
@property (nonatomic, copy) NSString *prepay_id;
@property (nonatomic, copy) NSString *return_msg;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *rewardId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *iOSProductId;
@end
