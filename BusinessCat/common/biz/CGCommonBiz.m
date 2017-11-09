//
//  CGCommonBiz.m
//  CGSays
//
//  Created by zhu on 2016/11/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGCommonBiz.h"

@implementation CGCommonBiz
- (void)commonOfflineVersionWithVersion:(NSInteger)version success:(void(^)(NSString * version))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:version],@"version", nil];
  [self.component sendPostRequestWithURL:URL_COMMON_OFFLINE_VERSION param:param success:^(id data) {
    NSDictionary *dic = data;
    NSNumber *latest = [dic objectForKey:@"latest"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:latest forKey:@"temporaryVerSion"];
      [user synchronize];
    NSString *version = dic[@"version"];
    if ([dic[@"version"] isKindOfClass:[NSNull class]]) {
      version = @"";
    }
    success(version);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

- (void)downLoadHtml5DataWithUrl:(NSString *)url success:(void(^)(NSString *success))success{
    if([CTStringUtil stringNotBlank:url]){
        [self.component sendDownLoadRequestWithURL:url filename:@"html5Data.zip" success:^(id data) {
          NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
          NSNumber *latest = [user objectForKey:@"temporaryVerSion"];
          [user setObject:latest forKey:@"latestVersion"];
          [user synchronize];
            success(@"success");
        }];
    }
}

//用户下订单接口
-(void)authUserPlaceOrderWithToId:(NSString *)toId toType:(NSInteger)toType subType:(NSInteger)subType payType:(NSInteger)payType payMethod:(NSString *)payMethod toUserId:(NSString *)toUserId body:(NSString *)body detail:(NSString *)detail attach:(id)attach trade_type:(NSString *)trade_type device_info:(NSString *)device_info total_fee:(NSInteger )total_fee notify_url:(NSString *)notify_url order_type:(NSInteger)order_type iOSProductId:(NSString *)iOSProductId success:(void(^)(CGRewardEntity * entity))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:toId,@"toId",[NSNumber numberWithInteger:toType],@"toType",[NSNumber numberWithInteger:payType],@"payType",payMethod,@"payMethod",toUserId,@"toUserId",body,@"body",trade_type,@"trade_type",[NSNumber numberWithInteger:total_fee],@"total_fee",[NSNumber numberWithInteger:order_type],@"order_type", nil];
  if ([CTStringUtil stringNotBlank:detail]) {
    [param setObject:detail forKey:@"detail"];
  }
  if (attach) {
    if ([attach isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dic = attach;
      NSString *json = [dic mj_JSONString];
     [param setObject:json forKey:@"attach"];
    }
  }
  if ([CTStringUtil stringNotBlank:device_info]) {
    [param setObject:device_info forKey:@"device_info"];
  }
  
  if ([CTStringUtil stringNotBlank:notify_url]) {
    [param setObject:notify_url forKey:@"notify_url"];
  }
  
  if ([CTStringUtil stringNotBlank:iOSProductId]) {
    [param setObject:iOSProductId forKey:@"iOSProductId"];
  }
  
  if (toType == 3) {
    [param setObject:[NSNumber numberWithInteger:subType] forKey:@"subType"];
  }
  
  [self.component sendPostRequestWithURL:URL_COMMON_PLACE_ORDER param:param success:^(id data) {
    NSDictionary *dict = data;
    CGRewardEntity *comment = [CGRewardEntity mj_objectWithKeyValues:dict];
    success(comment);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//提交日志
-(void)uploadAppLog:(NSString *)content{
    if([CTStringUtil stringNotBlank:content]){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //手机系统版本
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        // app版本
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        // app build版本
        NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        //手机别名： 用户定义的名称
        NSString* userPhoneName = [[UIDevice currentDevice] name];
        //设备名称
        NSString* deviceName = [[UIDevice currentDevice] systemName];
        //手机型号
        NSString* phoneModel = [[UIDevice currentDevice] model];
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content",sysVersion,@"sysVersion",appVersion,@"appVersion",appBuild,@"appBuildVersion",userPhoneName,@"userPhoneName",deviceName,@"deviceName",phoneModel,@"phoneModel", nil];
        [self.component sendPostRequestWithURL:URL_COMMON_UPLOAD_LOG param:param success:^(id data) {
            NSLog(@"");
        } fail:^(NSError *error) {
            NSLog(@"");
        }];
    }
}

- (NSString *)jumpToBizPayWithEntity:(CGRewardEntity *)entity {
  if(entity != nil){
    if ([entity.result_code isEqualToString:@"SUCCESS"]){
      //调起微信支付
      PayReq* req             = [[PayReq alloc] init];
      req.partnerId           = entity.mch_id;
      req.openID              = entity.appid;
      req.prepayId            = entity.prepay_id;
      req.nonceStr            = entity.nonce_str;
      NSDate *datenow = [NSDate date];
      NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
      UInt32 timeStamp =[timeSp intValue];
      req.timeStamp           = timeStamp;
      req.package             = @"Sign=WXPay";
      MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
      req.sign                = [md5 createMD5SingForPay:req.openID
                                               partnerid:req.partnerId
                                                prepayid:req.prepayId
                                                 package:req.package
                                                noncestr:req.nonceStr
                                               timestamp:req.timeStamp];
      NSLog(@"%d",[WXApi sendReq:req]);
      return @"";
    }else{
      return entity.return_msg;
    }
  }else{
    return @"服务器返回错误，未获取到json对象";
  }
}

//企业圈打赏知识分
-(void)authDiscoverScoopRewardIntegralWithUserId:(NSString *)userId scoopId:(NSString *)scoopId integral:(NSInteger)integral success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId,@"userId",scoopId,@"scoopId",[NSNumber numberWithInteger:integral],@"integral", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_REWARD_INTEGRAL param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//用户订单苹果校验接口
-(void)authUserOrderAppleVerifyWithOrderId:(NSString *)orderId receipt:(NSString *)receipt sign:(NSString *)sign success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:orderId,@"orderId",receipt,@"receipt",sign,@"sign", nil];
  [self.component sendPostRequestWithURL:URL_USER_ORDER_APPLE_VERIFY param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//支付方式获取接口
-(void)authUserWalletPayMethodSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_USER_WALLET_PAY_METHOD param:nil success:^(id data) {
    NSArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
     CGPayMethodEntity *info = [CGPayMethodEntity mj_objectWithKeyValues:dict];
      info.list = [NSMutableArray array];
      for (NSDictionary *dic in info.prompt) {
        CGPromptEntity *entity = [CGPromptEntity mj_objectWithKeyValues:dic];
        [info.list addObject:entity];
      }
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

@end
