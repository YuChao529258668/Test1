//
//  YCMeetingState.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGMeeting.h"

@interface YCMeetingState : NSObject

@property (nonatomic,strong) NSString *conferenceNumber;
@property (nonatomic,strong) NSString *meetingId;
@property (nonatomic,assign) long meetingType;
//@property (nonatomic,strong) NSString *jRoomId;
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *meetingDuration;
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *meetingName;
@property (nonatomic,assign) long roomNum;
@property (nonatomic,strong) NSString *createUser;
@property (nonatomic,strong) NSString *meetingState; // 会议状态 0:未开始 1：进行中 2：已结束 3：已取消
@property (nonatomic,assign) long attendance;
@property (nonatomic,strong) NSArray<YCMeetingUser *> *meetingUserList; // 当前状态:0未进入,1开会中,2已离开,4禁止

+ (NSDictionary *)mj_objectClassInArray;

@end

//    "conferenceNumber": "10823781",
//    "meetingId": "02f45f3320c741cb8de6340d5b48fa4d",
//    "costVideo": "",
//    "serverId": null,
//    "meetingType": 0,
//    "costVoice": 0.05,
//    "jRoomId": null,
//    "roomName": "收费会议室",
//    "meetingDuration": "840000",
//    "usedTime": "840000",
//    "companyId": "e7140cb4-f562-4fd7-83d3-715ba765b0b1",
//    "meetingName": "test",
//    "roomNum": 50,
//    "createTime": 1510393292000,
//    "startTime": 1510954817000,
//    "createUser": "37d13733-67f4-4906-afbd-3bb5972c1e94",
//    "meetingState": "0",
//    "endTime": 1510695617000,
//    "attendance": 4,
//    "meetingUserList":

