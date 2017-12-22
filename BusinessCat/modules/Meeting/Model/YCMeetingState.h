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
//@property (nonatomic,strong) NSString *createUser;
@property (nonatomic,strong) NSString *meetingState; // 会议状态 0:未开始 1：进行中 2：已结束 3：已取消
@property (nonatomic,assign) long attendance;
@property (nonatomic,strong) NSMutableArray<YCMeetingUser *> *meetingUserList; // 当前状态:0未进入,1开会中,2已离开,4禁止



// 客户端自定义的属性
@property (nonatomic,strong) YCMeetingUser *ycCompere; // 主持人
@property (nonatomic,strong) NSString *ycCompereID; // 主持人 id
@property (nonatomic,assign) BOOL ycIsCompere; // 当前用户是否主持人



+ (NSDictionary *)mj_objectClassInArray;

@end


