//
//  YCJusTalkIMTool.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/16.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCJusTalkIMTool : NSObject

@property (nonatomic,copy) void (^onReceiveMeetingInviteBlock)(NSString *meetingID, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *message); // message：会议 id，AccessKey, BucketName, SecretKey, 主持人头像，主持人昵称，被邀请人 id, 群聊 id，会议状态, 会议号

@property (nonatomic, copy) void (^onReceiveMessageBlock)(NSString *message);


- (ZINT)sendMessage:(NSString *)message to:(NSString *)toID;

- (void)sendMeetingInviteTo:(NSArray<NSString *> *)users withMeetingID:(NSString *)mid avatarUrl:(NSString *)aUrl userName:(NSString *)userName groupID:(NSString *)gid meetingState:(int)mState roomID:(NSString *)rid q:(NSString *)q;

@end
