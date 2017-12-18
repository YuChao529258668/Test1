//
//  YCJCSDKHelper.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//


#pragma mark - 命令

// - (int)sendData:(NSString *)key content:(NSString *)content toReceiver:(NSString *)userId;
// - (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId;

// 命令 key
NSString * const kJCCommandType = @"JC_Command_Type";

// 申请互动
NSString * const kYCRequestInteraction = @"YC_Request_Interacton";
// 允许互动
NSString * const kYCAllowInteraction = @"Allow_Interaction";
// 结束互动
NSString * const kYCEndInteraction = @"End_Interaction";

//请求发言
NSString * const kYCRequestSpeak = @"YC_REQUEST_SPEAK";
NSString * const kYCAgreeSpeak = @"YC_AGREE_SPEAK";
NSString * const kYCDisagreeSpeak = @"YC_DISAGREE_SPEAK";

//请求涂鸦
NSString * const kYCRequestDoodle = @"YC_REQUEST_DOODLE";
NSString * const kYCAgreeDoodle = @"YC_AGREE_DOODLE";
NSString * const kYCDisagreeDoodle = @"YC_DISAGREE_DOODLE";




#import <Foundation/Foundation.h>

@interface YCJCSDKHelper : NSObject

// 注意，语音初始化和登录了，视频就不用初始化了，也不用登录。

#pragma mark - 视频会议模块

+ (void)initializeVideoCall;
+ (void)loginVideoCallWithUserID:(NSString *)userID;
+ (BOOL)isLoginForVideoCall;

#pragma mark - 语音会议模块

+ (void)initializeMultiCall;

+ (BOOL)isLoginedForMultiCall;

+ (void)loginMultiCallWithUserID:(NSString *)userID;

+ (void)logoutMultiCall;

+ (void)calll: (NSString *)number displayName:(NSString *)displayName peerDisplayName: (NSString *)peerDisplayName isVideo:(BOOL)isVideo;

+ (void)multiCall:(NSArray *)numbers displayName:(NSString *)dispalyName;


#pragma mark - 白板模块

+ (void)initializeDocShare;


#pragma mark - 错误码

+ (NSString *)errorStringOfErrorCode:(NSInteger)code;

@end
