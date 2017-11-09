//
//  CGCommonBiz.h
//  CGSays
//
//  Created by zhu on 2016/11/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import "CGRewardEntity.h"
#import "MXWechatSignAdaptor.h"
#import <WXApi.h>
#import "CGPayMethodEntity.h"

@interface CGCommonBiz : CGBaseBiz
- (void)commonOfflineVersionWithVersion:(NSInteger)version success:(void(^)(NSString * version))success fail:(void (^)(NSError *error))fail;

- (void)downLoadHtml5DataWithUrl:(NSString *)url success:(void(^)(NSString * success))success;

//提交日志
-(void)uploadAppLog:(NSString *)content;

//调起微信支付
- (NSString *)jumpToBizPayWithEntity:(CGRewardEntity *)entity;

//用户下订单接口
-(void)authUserPlaceOrderWithToId:(NSString *)toId toType:(NSInteger)toType subType:(NSInteger)subType payType:(NSInteger)payType payMethod:(NSString *)payMethod toUserId:(NSString *)toUserId body:(NSString *)body detail:(NSString *)detail attach:(id)attach trade_type:(NSString *)trade_type device_info:(NSString *)device_info total_fee:(NSInteger )total_fee notify_url:(NSString *)notify_url order_type:(NSInteger)order_type iOSProductId:(NSString *)iOSProductId success:(void(^)(CGRewardEntity * entity))success fail:(void (^)(NSError *error))fail;

//企业圈打赏知识分
-(void)authDiscoverScoopRewardIntegralWithUserId:(NSString *)userId scoopId:(NSString *)scoopId integral:(NSInteger)integral success:(void(^)())success fail:(void (^)(NSError *error))fail;

//用户订单苹果校验接口
-(void)authUserOrderAppleVerifyWithOrderId:(NSString *)orderId receipt:(NSString *)receipt sign:(NSString *)sign success:(void(^)())success fail:(void (^)(NSError *error))fail;

//支付方式获取接口
-(void)authUserWalletPayMethodSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
@end
