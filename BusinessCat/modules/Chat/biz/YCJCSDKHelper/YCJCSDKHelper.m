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
#define kJCKey @"5f523868f54c24aa8fdc5096" // 生意猫
//#define kJCKey @"97346350260773bfd2544096" // 安卓的
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

// 文档共享
//#import <JusDoc/JusDoc.h>

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
        [helper addObserver];
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
+ (void)loginVideoCallWithUserID:(NSString *)userID {
    int success = [[JCEngineManager sharedManager] loginWithUserId:userID password:@"111"];
    if (success == JCOK) {
        NSLog(@"%@, 发起视频会议登录成功  = %@", NSStringFromSelector(_cmd),  nil);
    }
//    [[JCEngineManager sharedManager] loginWithUserId:@"test" password:@"123"];
}

+ (BOOL)isLoginForVideoCall {
    return [[JCEngineManager sharedManager] isOnline];
}


#pragma mark  JCEngineDelegate

/**
 * @brief  错误回调
 *   SDK 运行中发生错误时就会触发此互调。如调用 - (int)joinWithRoomId:(NSString *)roomId
 *   displayName:(NSString *)displayName 时操作失败等
 *
 * @param  errorReason 具体原因值 @ref ErrorReason
 */
- (void)onError:(ErrorReason)errorReason {
    
//    /** 发起连接服务端失败，原因为无效的网络 */
//    ErrorCodeErrLoginNetUnavailable,
//    /** 发起连接服务端失败，原因为密码错误 */
//    ErrorCodeErrLoginAuthFailed,
//    /** 发起连接服务端失败，原因为超时 */
//    ErrorCodeErrLoginTimeout,

//    NSString *error;
//    switch (errorReason) {
//        case ErrorCodeErrLoginNetUnavailable:
//            error = @"发起连接服务端失败，原因为无效的网络";
//            break;
//        case ErrorCodeErrLoginAuthFailed:
//            error = @"发起连接服务端失败，原因为密码错误";
//            break;
//        case ErrorCodeErrLoginTimeout:
//            error = @"发起连接服务端失败，原因为超时";
//            break;
//        default:
//            error = @"未知原因";
//            break;
//    }
//
//    NSLog(@"失败 JCEngine error %@", error);
    
    [CTToast showWithText:[YCJCSDKHelper errorStringOfErrorCode:errorReason]];
}


#pragma mark - 语音

// 语音用的 demo 是 justalk-cloud

// http://www.justalkcloud.com/cn/docs/gitbook/call/MultiCallServiceIntegrationUsingUIControls/iOS/readme.html
+ (void)initializeMultiCall {
    Zmf_AudioInitialize(NULL);
    Zmf_VideoInitialize(NULL);
    
    if (Mtc_Init() == ZOK) {
        NSLog(@"JCSDK 语音初始化成功");
    }
    
    [MtcLoginManager Init:kJCKey];
    //    [MtcLoginManager Set:self]; // MtcLoginDelegate

    //    [MtcPushManager SetPayloadForCall:@MY_PUSH_CALL_PAYLOAD                     Expiration:MY_PUSH_EXPIRATION];
    [MtcCallManager Init];
    
    //    [MtcDoodleManager Init:(id<MtcDoodleDelegate>)self];
    //    [MtcDoodleManager Init:nil];
    
}

+ (BOOL)isLoginedForMultiCall {
    EN_MTC_CLI_STATE_TYPE state = Mtc_CliGetState();
    return state == EN_MTC_CLI_STATE_LOGINED;
}

+ (void)loginMultiCallWithUserID:(NSString *)userID {
    NSString *server = @"http:router.justalkcloud.com:8080";
    if ([MtcLoginManager Login:userID password:@"jp580" network:server] == ZOK) {
        NSLog(@"调用语音登录成功");
    } else {
        [CTToast showWithText:@"会议功能无法登录"];
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


#pragma mark - Notification

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcLoginOkNotification:) name:@MtcLoginOkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcLoginDidFailNotification:) name:@MtcLoginDidFailNotification object:nil];
}

//// MtcLoginOkNotification
//+ (void)onLoginMultiCallSuccess {
//
//}
//
//// MtcLoginDidFailNotification
//+ (void)onLoginMultiCallFaild {
//
//}

- (void)handleMtcLoginOkNotification:(NSNotification *)noti {
    NSLog(@"%@, 视频会议登录成功 ", NSStringFromSelector(_cmd));
}

- (void)handleMtcLoginDidFailNotification:(NSNotification *)noti {
    NSLog(@"%@, 视频会议登录失败 error  = %@", NSStringFromSelector(_cmd), noti);
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

#pragma mark - 错误码

// 返回错误字符串。错误码定义在 JCEngineManager.h。ErrorNone = 0
+ (NSString *)errorStringOfErrorCode:(NSInteger)code {
    NSArray *errors = @[
        /** 默认值, 0 */
        @"ErrorNone",
        /** 其他错误 */
        @"ErrorOther",
        /** 其他错误 */
        @"ErrorRoomOther",
        /** 与服务器断开连接，主动断开 */
        @"DisconnectReasonActive",
        /** 与服务器断开连接，相同 userId 在别的设备登录 */
        @"DisconnectReasonDeacted",
        /** 与服务器断开连接，其他原因 */
        @"DisconnectReasonOther",
        /** 发起连接服务器失败，鉴权错误。只有当开发者将鉴权模式设置为 RSA 鉴权时才会通知此错误 */
        @"ErrorConnectFailAuth",
        /** 发起连接服务端失败，原因为无效的网络 */
        @"ErrorCodeErrLoginNetUnavailable",
        /** 发起连接服务端失败，原因为密码错误 */
        @"ErrorCodeErrLoginAuthFailed",
        /** 发起连接服务端失败，原因为超时 */
        @"ErrorCodeErrLoginTimeout",
        /** 加入房间失败，原因会议不存在 */
        @"ErrorJoinFailNotExist",
        /** 加入房间失败，原因房间已满 */
        @"ErrorJoinFailFull",
        /** 加入房间失败，原因密码错误 */
        @"ErrorJoinFailInvalidPassword",
        /** 加入房间失败，连接到服务器时失败 */
        @"ErrorJoinFailConnect",
        /** 加入房间失败，原因会议加入超时 */
        @"ErrorJoinFailTimeout",
        /** 加入房间失败，roomid不可用 */
        @"ErrorJoinFailRInvalidRoomID",
        /** 加入房间失败，当前网络异常 */
        @"ErrorJoinFailNetUnavailabile",
        /** 加入房间失败，当前已经在一个房间中 */
        @"ErrorJoinFailBusy",
        /** 媒体操作失败 */
        @"ErrorMediaChangeFail",
        /** 离开房间的原因，主动退出（调用离开房间的接口）*/
        @"ErrorEndQuit",
        /** 离开房间的原因，掉线 */
        @"ErrorEndOffline",
        /** 离开房间的原因，房间已关闭 */
        @"ErrorEndOver",
        /** 离开房间原因，被移出 */
        @"ErrorEndKicked",
        /** 离开房间的原因，其他原因 */
        @"ErrorEndOther",
        /** 日志打印级别，打印调试信息 */
        @"LogLevelDebug",
        /** 日志打印级别，仅打印必要信息 */
        @"LogLevelInfo",
        /** 日志打印级别，关闭 */
        @"LogLeaveOff",
        /** 日志类型，调试信息 */
        @"LogTypeDebug",
        /** 日志类型，错误信息 */
        @"LogTypeError",
        /** 日志类型，必要信息 */
        @"LogTypeInfo",
        /** 房间模式，直播模式 */
        @"RoomModeBroadcast",
        /** 房间模式，通信模式 */
        @"RoomModeCommunication",
        /** 房间状态，闲置 */
        @"RoomStateIdle",
        /** 房间状态，正在进入房间 */
        @"RoomStateJoining",
        /** 房间状态，正在离开房间 */
        @"RoomStateLeaving",
        /** 房间状态，已进入房间 */
        @"RoomStateOnAir",
        /** 房间状态，已就绪，正在等待连接至服务器的通知 */
        @"RoomStateReady",
        /** 自己发起屏幕共享失败（iOS 暂不支持发起屏幕共享）*/
        @"ScreenShareFailed",
        /** 有成员发起屏幕共享 */
        @"ScreenShareStart",
        /** 发起的成员取消了屏幕共享 */
        @"ScreenShareStop",
        /** 自己修改房间主题失败 */
        @"TitleFailed",
        /** 房间主题被修改（自己或其他成员修改）*/
        @"TitleChanged"
    ];
    
    code = code < 0? 1: code;
    code = code > errors.count? 1: code;
    
    return errors[code];
}


#pragma mark - 文档共享

+ (void)initializeDocShare {
//    [JusDocManager init];
}

//+ (void)init;
//+ (void)setDelegate:(id<JusDocDelegate>)delegate;
////用于全屏显示
//+ (void)start:(NSString *)docUri;
////用于添加到其他 view 的时候来显示，需要传入对应 view 的 size
//+ (UIViewController *)start:(NSString *)docUri displayViewSize:(CGSize)size;
//+ (void)stop;

//@protocol JusDocDelegate
//- (void)didCreate;
//- (void)requestToStart:(NSString *)docUri;
//- (void)requestToStop;
//@end



@end
