//
//  YCJCSDKHelper.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCJCSDKHelper.h"

// 视频会议
#import <JCApi/JCApi.h>
#define kJCKey @"5f523868f54c24aa8fdc5096"
//#define kJCKey @"6c06d1b0d9015e47ec144097" // 官方 demo
//#import "RoomViewController.h"

// 语音会议
#import "avatar/zos/zos_type.h"
#import "grape/zmf.h"
#import "lemon/lemon.h"
//#import <JusCall/JusCall.h>
#import <JusMultiCall/JusMultiCall.h>
#import <JusLogin/JusLogin.h>
//#import <JusDoodle/JusDoodle.h>
#import <PushKit/PushKit.h>

#define userID1 @"18362970827"
#define userID2 @"1837"

@interface YCJCSDKHelper()<JCEngineDelegate>
@end


@implementation YCJCSDKHelper


#pragma mark - 单例

static YCJCSDKHelper * helper;

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [YCJCSDKHelper new];
    });
    return helper;
}

#pragma mark - 视频

// 视频用的 demo 是 JCEngine

// 视频会议
+ (void)initializeVideoCall {
    int ret = [[JCEngineManager sharedManager] initializeWithAppkey:kJCKey];
    if (ret == JCOK) {
        NSLog(@"JCSDK 视频初始化成功");
    }
    __weak YCJCSDKHelper *wf = [YCJCSDKHelper shareHelper];
    [[JCEngineManager sharedManager] setDelegate:wf];
    
//    [[JCEngineManager sharedManager] setServerAddress:[SettingManager getDefaultServerAddress]];
//    [[JCEngineManager sharedManager] setServerAddress:@"http:router.justalkcloud.com:8080"];
}

// 不用登录?
+ (void)loginVideoCall {
//    NSString *server = @"http:router.justalkcloud.com:8080";
//    if ([MtcLoginManager Login:userID1 password:@"111" network:server] == ZOK) {
//        NSLog(@"调用语音登录成功");
//    }
    [[JCEngineManager sharedManager] loginWithUserId:userID1 password:@"111"];
//    [[JCEngineManager sharedManager] loginWithUserId:@"test" password:@"123"];
}

+ (BOOL)isLoginForVideoCall {
    return [[JCEngineManager sharedManager] isOnline];
}

#pragma mark  JCEngineDelegate

- (void)onError:(ErrorReason)errorReason {
    
//    /** 发起连接服务端失败，原因为无效的网络 */
//    ErrorCodeErrLoginNetUnavailable,
//    /** 发起连接服务端失败，原因为密码错误 */
//    ErrorCodeErrLoginAuthFailed,
//    /** 发起连接服务端失败，原因为超时 */
//    ErrorCodeErrLoginTimeout,

    NSString *error;
    switch (errorReason) {
        case ErrorCodeErrLoginNetUnavailable:
            error = @"发起连接服务端失败，原因为无效的网络";
            break;
        case ErrorCodeErrLoginAuthFailed:
            error = @"发起连接服务端失败，原因为密码错误";
            break;
        case ErrorCodeErrLoginTimeout:
            error = @"发起连接服务端失败，原因为超时";
            break;
        default:
            error = @"未知原因";
            break;
    }
    
    NSLog(@"失败 JCEngine error %@", error);
}


#pragma mark - 语音
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJCSDKLoginOK) name:@MtcLoginOkNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcCliServerLoginDidFailNotification:) name:@MtcCliServerLoginDidFailNotification object:nil];

// 语音用的 demo 是 justalk-cloud

// http://www.justalkcloud.com/cn/docs/gitbook/call/MultiCallServiceIntegrationUsingUIControls/iOS/readme.html
+ (void)initializeMultiCall {
    Zmf_AudioInitialize(NULL);
    Zmf_VideoInitialize(NULL);
    
    if (Mtc_Init() == ZOK) {
        NSLog(@"JCSDK 语音初始化成功");
    }
    
    [MtcLoginManager Init:kJCKey];
    //    [MtcPushManager SetPayloadForCall:@MY_PUSH_CALL_PAYLOAD                     Expiration:MY_PUSH_EXPIRATION];
    [MtcCallManager Init];
    
    //    [MtcDoodleManager Init:(id<MtcDoodleDelegate>)self];
    //    [MtcDoodleManager Init:nil];
    
    //    [MtcLoginManager Set:self]; // MtcLoginDelegate
}

+ (BOOL)isLoginedForMultiCall {
    EN_MTC_CLI_STATE_TYPE state = Mtc_CliGetState();
    return state == EN_MTC_CLI_STATE_LOGINED;
}

+ (void)loginMultiCall {
    NSString *server = @"http:router.justalkcloud.com:8080";
    if ([MtcLoginManager Login:userID1 password:@"111" network:server] == ZOK) {
        NSLog(@"调用语音登录成功");
    }
}

+ (void)logoutMultiCall {
    [MtcLoginManager Logout];
}

+ (void)calll: (NSString *)number displayName:(NSString *)displayName peerDisplayName: (NSString *)peerDisplayName isVideo:(BOOL)isVideo {
    [MtcCallManager Call:number displayName:displayName peerDisplayName:peerDisplayName isVideo:isVideo];
}

+ (void)multiCall:(NSArray *)numbers displayName:(NSString *)dispalyName {
    [MtcCallManager multiCall:numbers displayName:dispalyName];
}





//#pragma mark - 初始化 腾讯云

//- (void)initialTengXunYun {
//    TIMManager *manager = [TIMManager sharedInstance];
//    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
//    config.sdkAppId = [kSdkAppId intValue] ;
//    config.accountType = kSdkAccountType;
//    //    config.disableCrashReport = NO;
//    //    config.connListener = self;
//    int r = [manager initSdk:config];
//    if (r == 0) {
//        NSLog(@"腾讯云初始化成功");
//    }
//}



@end
