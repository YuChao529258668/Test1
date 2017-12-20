//
//  YCJCSDKHelper.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//






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
