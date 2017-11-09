//
//  JCParticipantModel.h
//  JCConference
//
//  Created by young on 16/11/28.
//  Copyright © 2016年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 说话音量大小的状态值
 */
typedef NS_ENUM(NSUInteger, JCVolumeStatus) {
    JCVolumeStatusNone = 0,  //音频输入设备关闭或关闭音频数据发送
    JCVolumeStatusZero,      //无
    JCVolumeStatusLow,       //低
    JCVolumeStatusMid,       //中
    JCVolumeStatusHigh       //高
};


@interface JCParticipantModel : NSObject

@property (nonatomic, readonly, copy) NSString *userId;         //会议参与者id
@property (nonatomic, readonly, copy) NSString *displayName;    //会议参与者昵称

@property (nonatomic, readonly, getter=isMyself) BOOL myself;   //是否自己

@property (nonatomic, readonly, getter=isHost) BOOL host;       //是否为主持人

@property (nonatomic, readonly, getter=isOwner) BOOL owner;

@property (nonatomic, readonly) JCVolumeStatus volumeStatus;    //音量状态

/*
 * 当 isAudioUpload == YES && isAudioForward == YES 时，比如会议中成员A发送自己的语音到会议服务器，并且会议服务器转发了成员A的语音到其他会议成员，这样其它成员才能听到成员A的语音。可用于UI界面成员的语音状态提示。
 */
@property (nonatomic, readonly, getter=isAudioUpload) BOOL audioUpload;  //成员是否发送自己的音频数据到会议服务器

@property (nonatomic, readonly, getter=isAudioForward) BOOL audioForward;  //会议服务器是否转发自己的音频数据到其他成员

/*
 * 当 isVideoUpload == YES && isVideoForward == YES 时，比如会议中成员A发送自己的视频到会议服务器，并且会议服务器转发了成员A的视频到其他会议成员，这样其它成员才能收到成员A的视频。可用于UI界面成员的视频状态提示。
 */
@property (nonatomic, readonly, getter=isVideoUpload) BOOL videoUpload;  //成员是否发送自己的视频数据到会议服务器

@property (nonatomic, readonly, getter=isVideoForward) BOOL videoForward;  //会议服务器是否转发自己的视频数据到其他成员

@end
