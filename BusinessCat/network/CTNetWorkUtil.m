//
//  NetWorkUtil.m
//  VieProd
//
//  Created by Calon Mo on 16/3/21.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTNetWorkUtil.h"
#import "CTJsonUtil.h"
#import "AppConstants.h"
#import "CTStringUtil.h"
#import "SecurityUtil.h"
#import "CGUserCenterBiz.h"
#import "CGUserDao.h"
#import "GiFHUD.h"

#define UIActivityIndicatorViewLength 70

@interface CTNetWorkUtil(){
    NSTimer *loadingTimer;
//    ASIHTTPRequest *_request;
  AFHTTPSessionManager *_request;
}

@end

@implementation CTNetWorkUtil

static CTNetWorkUtil *_sharedManager;
+(CTNetWorkUtil *)sharedManager{
    return [[CTNetWorkUtil alloc]init];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if(!_sharedManager){
//            _sharedManager = [[CTNetWorkUtil alloc]init];
//        }
//    });
//    return _sharedManager;
}


//-(CGUserCenterBiz *)userBiz{
//    if(!_userBiz){
//        _userBiz = [[CGUserCenterBiz alloc]init];
//    }
//    return _userBiz;
//}
/**
 * 加载loading动画
 */
- (void)startBlockAnimation{
    [GiFHUD setGifWithImageName:@"juhua.gif"];
    [GiFHUD show];
    loadingTimer = [NSTimer scheduledTimerWithTimeInterval:kRequsetTimeOutSeconds target:self selector:@selector(stopBlockAnimation) userInfo:nil repeats:NO];
}

/**
 * 移除loading动画
 */
- (void)stopBlockAnimation{
    [GiFHUD dismiss];
    [loadingTimer invalidate];
    loadingTimer = nil;
}


/**
 *  POST请求
 *  url         接口完整地址
 *  param       请求参数
 *  success     请求成功回调
 *  fail        请求失败回调
 */
- (void)sendPostRequestWithURL:(NSString *)urlString param:(NSDictionary *)param success:(void(^)(id data))success fail:(void (^)(NSError *error))fail{
    successcallback = success;
    failcallback = fail;
    if(!param){
        param = [NSDictionary dictionary];
    }
    //保留url，用于重新请求
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:param];
    self.urlString = urlString;
    //保留参数，用于重新请求
    self.paramDict = parameter;
    //参数签名组装
    NSDictionary *paramString = [self signParam:parameter];
    //请求
    [self sendRequestWithURL:urlString param:paramString];
}


/**
 *  请求总出口
 *
 */
- (void)sendRequestWithURL:(NSString *)urlString param:(NSDictionary *)param{
    if (![urlString containsString:@"interact/data"]) {
        NSLog(@"\n请求总出口 请求地址：%@, 参数：%@\n",urlString, [YCTool stringOfDictionary:param]);
//        NSLog(@"\n请求总出口 请求地址：%@, 参数：%@\n",urlString, param);
        NSLog(@"-------------------------------------");
    }
    
    // 请求的manager
    NSDate *requestStartDate = [NSDate date];
    _request = [AFHTTPSessionManager manager];
    _request.requestSerializer.timeoutInterval = kRequsetTimeOutSeconds;
    [_request.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [_request.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    __weak typeof(self) weakSelf = self;
    
    [_request POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![urlString containsString:@"interact/data"]) {
            NSLog(@"\n请求总出口 %@, 请求接口：%@，返回数据：%@\n", NSStringFromSelector(_cmd),urlString,[YCTool stringOfDictionary:responseObject]);
            NSLog(@"-------------------------------------");
        }
        
        NSDictionary *res = responseObject;
        if(res){
            int errCode = [[res objectForKey:@"errcode"]intValue];
            //记录请求日志
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [weakSelf saveRequestLog:errCode message:[res objectForKey:@"message"] startDate:requestStartDate url:urlString param:jsonString];
            
            if(errCode == 0){
                if(successcallback){
                    successcallback([res objectForKey:@"data"]);
                }
                //                    successcallback = nil;
            }else if(errCode == 100002){//token过期,重新获取
                [weakSelf autoLogin];
            }else if(errCode == 110006){//非法uuid
                NSString *text = [NSString stringWithFormat:@"非法 UUID：%@", param[@"identity"]];
                //                    [CTToast showWithText:text];
                //                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
                //                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                //                    }];
                //                    [ac addAction:sure];
                //                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
                
                
                NSLog(@"%@", text);
                //                    [weakSelf autoLogin];
                
                [ObjectShareTool sharedInstance].isloginState = 1;
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
            }else{
                if(failcallback){
                    failcallback([NSError errorWithDomain:NetworkRequestErrorDomain code:errCode userInfo:res]);
                    //                        failcallback = nil;
                }
                if (errCode == 110113) {//未登陆
                    //                        [CTToast showWithText:@"未登录：110113"];
                    if ([ObjectShareTool sharedInstance].currentUser.isLogin == YES) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
                    }
                }
                if(errCode == 110131 || errCode == 110113 || errCode == 110005){//不弹提示
                    return;
                }
                if (errCode == 10086) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [[CTToast makeText:@"服务正在升级"]show:window];
                    return;
                }
                NSString *message = [res objectForKey:@"message"];
                if(message && message.length > 0){
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [[CTToast makeText:message]show:window];
                }
            }
        }else{
            if(failcallback){
                failcallback([NSError errorWithDomain:NetworkRequestErrorDomain code:-1 userInfo:nil]);
                //                    failcallback = nil;
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"请求失败：%@",request.url.absoluteString);
        NSString *errMsg = nil;
        if(error.code == ASIConnectionFailureErrorType){
            errMsg = @"连接失败，请稍后再试";
        }
        if(failcallback){
            failcallback([NSError errorWithDomain:NetworkRequestErrorDomain code:-1 userInfo:nil]);
            //                failcallback = nil;
        }
        if([CTStringUtil stringNotBlank:errMsg]){
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            [[CTToast makeText:errMsg]show:window];
            //记录请求日志
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [weakSelf saveRequestLog:-1 message:errMsg startDate:requestStartDate url:urlString param:jsonString];
            
        }
        
    }];
}

#pragma mark -

- (void)saveResponseData:(NSData *)data {
    
}

//记录请求日志
-(void)saveRequestLog:(int)code message:(NSString *)message startDate:(NSDate *)startDate url:(NSString *)url param:(NSString *)param{
    if ([url containsString:@"interact/data"]) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"shujudata"];
        NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (data.count<=0) {
            data = [NSMutableArray array];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startDate]];
        NSString *endDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"strtime",endDate,@"endtime",url,@"url",param,@"param",@"IOS",@"type", nil];
        [dic setObject:[NSString stringWithFormat:@"%d",code] forKey:@"errCode"];
      [dic setObject:[CTStringUtil stringNotBlank:message]?message:@"" forKey:@"message"];
        
        [data insertObject:dic atIndex:0];
        if (data.count>100) {
            [data removeObjectsInRange:NSMakeRange(100, (data.count-100))];
        }
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    });
}

////给参数签名
//-(NSString *)signParam:(NSMutableDictionary *)param{
//    if([ObjectShareTool sharedInstance].currentUser){
//        if([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.token]){
//            [param setObject:[ObjectShareTool sharedInstance].currentUser.token forKey:@"token"];
//        }else{//如果token为空，随便赋值
//            [param setObject:@"123456" forKey:@"token"];
//        }
//    }
//    NSString *identifier = [CTDeviceTool getUniqueDeviceIdentifierAsString];
//    NSString *version = @"1.0";//会影响到数据的返回，不可乱改
//    NSString *platform = @"IOS_APP";
//    NSNumber *timestamp = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]*1000];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSString *signString = [NSString stringWithFormat:@"code=jianshi580&data=%@&identity=%@&platform=%@&timestamp=%@&version=%@",jsonString,identifier,platform,timestamp,version];
//    NSString *unicode = [CTStringUtil utf8ToUnicode:signString];
//    NSString *sign = [SecurityUtil md5ByString:unicode];
//    return [NSString stringWithFormat:@"%@&sign=%@",signString,sign];
//}

//给参数签名
-(NSDictionary *)signParam:(NSMutableDictionary *)param{
  if([ObjectShareTool sharedInstance].currentUser){
    if([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.token]){
      [param setObject:[ObjectShareTool sharedInstance].currentUser.token forKey:@"token"];
    }else{//如果token为空，随便赋值
      [param setObject:@"123456" forKey:@"token"];
    }
  }
  NSString *identifier = [CTDeviceTool getUniqueDeviceIdentifierAsString];
    NSLog(@"设备码 = %@", identifier);
//    NSLog(@"啦啦啦identifier =  %@", identifier);
  NSString *version = @"1.0";//会影响到数据的返回，不可乱改
  NSString *platform = @"IOS_APP";
  NSNumber *timestamp = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]*1000];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSString *signString = [NSString stringWithFormat:@"code=jianshi580&data=%@&identity=%@&platform=%@&timestamp=%@&version=%@",jsonString,identifier,platform,timestamp,version];
  NSString *unicode = [CTStringUtil utf8ToUnicode:signString];
  NSString *sign = [SecurityUtil md5ByString:unicode];
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"jianshi580",@"code",jsonString,@"data",identifier,@"identity",platform,@"platform",timestamp,@"timestamp",version,@"version",sign,@"sign", nil];
  return params;
}

-(void)autoLogin{
    NSLog(@"自动获取token---------------------");
    __weak typeof(self) weakSelf = self;
    [[[CGUserCenterBiz alloc]init] getToken:^(NSString *uuid, NSString *token) {
        //获取token成功，如果是其他url则继续请求
        if([CTStringUtil stringNotBlank:weakSelf.urlString] && ![weakSelf.urlString isEqualToString:URL_USER_TOKEN]){
            [weakSelf sendRequestWithURL:weakSelf.urlString param:[weakSelf signParam:weakSelf.paramDict]];
        //获取token成功，如果是token的url则返回成功
        }else if([weakSelf.urlString isEqualToString:URL_USER_TOKEN]){
            if(successcallback){
                successcallback(nil);
            }
//            successcallback = nil;
        }else{
            if(successcallback){
                successcallback(nil);
            }
//            successcallback = nil;
        }
        
    } fail:^(NSError *error){
        if(failcallback){
            failcallback([NSError errorWithDomain:NetworkRequestErrorDomain code:-1 userInfo:nil]);
        }
//        failcallback = nil;
    }];
}

- (void)sendDownLoadRequestWithURL:(NSString *)urlString filename:(NSString *)filename success:(void(^)(id data))success{
  NSString *cachepath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
  NSString *pathFilename=[cachepath stringByAppendingPathComponent:filename];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    return [NSURL fileURLWithPath:pathFilename];
  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    success(@"success");
  }];
  [task resume];
}


#pragma public methods

- (void)abort {
    [self stopBlockAnimation];
}


-(void)dealloc{
    [loadingTimer invalidate];
    loadingTimer = nil;
    
//    NSLog(@"网络工具释放成功 %@", NSStringFromSelector(_cmd));
//    successcallback = nil;
//    failcallback = nil;
}


#pragma mark -

/**
 *   带请求动画的 POST 请求，基于 sendPostRequestWithURL 的封装
 *  url         接口完整地址
 *  param       请求参数    json格式
 *  success     请求成功回调
 *  fail        请求失败回调
 */
- (void)UIPostRequestWithURL:(NSString *)urlString param:(NSDictionary *)param success:(void(^)(id data))success fail:(void (^)(NSError *error))fail {
    [self startBlockAnimation];
    [self sendPostRequestWithURL:urlString param:param success:^(id data) {
        [self stopBlockAnimation];
        success(data);
    } fail:^(NSError *error) {
        [self stopBlockAnimation];
        fail(error);
    }];
}


@end
