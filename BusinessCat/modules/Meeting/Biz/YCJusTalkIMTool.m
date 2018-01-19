//
//  YCJusTalkIMTool.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/16.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCJusTalkIMTool.h"

@implementation YCJusTalkIMTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceive:) name:@MtcImTextDidReceiveNotification object:nil];
}

- (void)onReceive:(NSNotification *)notification {

    //从userInfo获取message id
//    long msgId = [[notification.userInfo objectForKey:@MtcImMsgIdKey] unsignedIntValue];
    
    //从userInfo获取发送方userUri
    NSString *peerUri = [notification.userInfo objectForKey:@MtcImUserUriKey];//[username:47cd5da6-49db-4390-abfe-f67e15f567a2@102122.cloud.justalk.com]
    
    //从userUri得到发送方用户名
    NSString *username = [NSString stringWithUTF8String:Mtc_UserGetId([peerUri UTF8String])];//47cd5da6-49db-4390-abfe-f67e15f567a2
    if ([username isEqualToString:[ObjectShareTool currentUserID]]) {
        return;
    }
    
    //从userInfo获取文本消息内容
    NSString *msgText = [notification.userInfo objectForKey:@MtcImTextKey];
//    NSLog(@"msgId = %ld, From%@, Text:%@", msgId, username, msgText);
//    NSLog(@"msgId = %ld, From%@, Text:%@", msgId, username, msgText);
    NSLog(@"MTC message = %@", [YCTool stringOfDictionary:notification.userInfo]);

    
    if (self.onReceiveMessageBlock) {
        self.onReceiveMessageBlock(msgText);
    }
    
    
    if (self.onReceiveMeetingInviteBlock) {
        NSDictionary *dic = [msgText objectFromJSONString];

        if ([dic[@"MessageType"] isEqualToString:@"meeting_invite"]) {
            NSString *q = dic[@"Q"];
            NSString *qJson = [YCTool decodeBase64String:q];
            NSDictionary *abs = [qJson objectFromJSONString];
            self.onReceiveMeetingInviteBlock(dic[@"MeetingID"], abs[@"a"], abs[@"s"], abs[@"v"], msgText);
        }
    }
    
    
}

- (ZINT)sendMessage:(NSString *)message to:(NSString *)toID {
    ZCONST ZCHAR *userUri = Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, [toID UTF8String]);
    ZINT success = Mtc_ImSendText(0, userUri, [message UTF8String], @"".UTF8String);

    if (success == ZOK) {
        [CTToast showWithText:@"发送成功"];
        NSLog(@"send message = %@", message);
    } else {
        [CTToast showWithText:@"发送失败"];
    }
    return success;
}

- (void)sendMeetingInviteTo:(NSArray<NSString *> *)users withMeetingID:(NSString *)mid avatarUrl:(NSString *)aUrl userName:(NSString *)userName groupID:(NSString *)gid meetingState:(int)mState roomID:(NSString *)rid q:(NSString *)q {
    // 会议 id，AccessKey, BucketName, SecretKey, 主持人头像，主持人昵称，被邀请人 id, 群聊 id，会议状态, 会议号
    // MessageType, MeetingID, AccessKey, BucketName, SecretKey, FromAvatarUrl, FromUserName,ToUserID, GroupID, MeetingState, ConferenceNumber
    
    NSString *message;
    NSMutableDictionary *dic = @{@"MessageType": @"meeting_invite",
                          @"MeetingID": mid,
                          @"Q": q,
                          @"FromAvatarUrl": aUrl,
                          @"FromUserName": userName,
                          @"ToUserID": @"",
                          @"GroupID": gid,
                          @"MeetingState": [NSString stringWithFormat:@"%d", mState],
                          @"ConferenceNumber": rid
                          }.mutableCopy;
    
    for (NSString *userID in users) {
        dic[@"ToUserID"] = userID;
//        message = [dic JSONString];
        message = [dic mj_JSONString];
        [self sendMessage:message to:userID];
    }
}

@end
