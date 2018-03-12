//
//  CGMeeting.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCMeetingUser : NSObject

@property (nonatomic,assign) NSInteger compere; // 主持人
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *recordId;
@property (nonatomic,assign) int state; // 当前状态:0未进入,1开会中,2已离开,4禁止
@property (nonatomic,strong) NSString *timeB;
@property (nonatomic,strong) NSString *timeE;
@property (nonatomic,strong) NSString *userIcon; // 头像。要加前缀
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *position;// 职位

// http://doc.cgsays.com:50123/index.php?s=/1&page_id=407
#pragma mark - 会议成员接口返回的部分属性
@property (nonatomic,assign) long soundState;
@property (nonatomic,assign) long videoState;
@property (nonatomic,assign) long interactionState;
@property (nonatomic, assign) int remoteMode;

@end


@interface CGMeeting : NSObject

// http://doc.cgsays.com:50123/index.php?s=/1&page_id=387
#pragma mark - 会议列表返回的部分属性

@property (nonatomic,assign) int attendance;//参会人数
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *conferenceNumber; // 会议号(justalk)，justalk的 roomID
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *startTime;
//@property (nonatomic,assign) NSTimeInterval endTime;
//@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,strong) NSString *meetingDuration; // 时长 分钟
@property (nonatomic,strong) NSString *meetingId;
@property (nonatomic,strong) NSString *meetingName;
@property (nonatomic,strong) NSString *meetingPassword;
@property (nonatomic,strong) NSString *meetingRoomId;
@property (nonatomic,assign) int meetingState; // 会议状态 0:未开始 1：进行中 2：已结束 3：已取消
@property (nonatomic,assign) int meetingType; // 会议形式（0：音频，1：视频）
@property (nonatomic,strong) NSMutableArray<YCMeetingUser *> *meetingUserList; // 开会成员列表。主持人在首位
@property (nonatomic,strong) NSMutableArray<YCMeetingUser *> *remoteUserList; // 当前状态:0未进入,1开会中,2已离开,4禁止
@property (nonatomic,strong) NSMutableArray<YCMeetingUser *> *sceneUserList; // 当前状态:0未进入,1开会中,2已离开,4禁止

@property (nonatomic, assign) int isAbsent;// 是否缺席
@property (nonatomic, strong) NSString *companyRoomId;//公司会议室Id/地址Id，本地会议？
@property (nonatomic, strong) NSString *roomName;//公司会议室名称/地点名称

// 用于判断是否远程会议
@property (nonatomic, assign) int canRemote; // 是否进入视频会议 （0：否 1：是）


// http://doc.cgsays.com:50123/index.php?s=/1&page_id=389
#pragma mark - 会议详情接口返回的部分属性

@property (nonatomic,assign) float costVideo;
@property (nonatomic,assign) float costVoice;
@property (nonatomic,strong) NSString *createTime;
//@property (nonatomic,strong) NSString *createUser; // 创建者 id，客户端不能用！这是后台存根的。使用 user 的 compere 属性判断是否主持人。或者 ycCompereID 也可以判断
@property (nonatomic,assign) float meetingCost;//语音/视频每分钟每人价格
@property (nonatomic,strong) NSString *roomId;//会议室Id(justalk)
//@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *roomNum;//会议最大人数
@property (nonatomic,strong) NSString *serverId;//服务器Id(justalk)
@property (nonatomic,strong) NSString *usedTime;//实际开会用时(分钟)
@property (nonatomic,assign) int roomCharge; // 费用(0免费1付费2包月)
@property (nonatomic,strong) NSString *groupId; // 群聊 id，用于腾讯云获取群信息

@property (nonatomic, assign) int totalPeopleNumber;
@property (nonatomic, assign) int onlinePeopleNumber;

@property (nonatomic, assign) int absentOrRemote; // 0:视频开会 1：现场开会，判断会议列表中要显示的模式


// 客户端自定义的属性
@property (nonatomic,strong) YCMeetingUser *ycCompere; // 主持人
@property (nonatomic,strong) NSString *ycCompereID; // 主持人 id
@property (nonatomic,assign) BOOL ycIsCompere; // 当前用户是否主持人



#pragma mark - 函数

+ (NSDictionary *)mj_objectClassInArray;

// 返回 id
//- (NSString *)meetingCreator;
//- (NSString *)meetingCreatorName;

@end


#pragma mark - 会议统计数据

@interface CGMeetingStatistics: NSObject
@property (nonatomic, assign) int toDayMeetCount;
@property (nonatomic, assign) int toDayUnBeginMeetCount;
@property (nonatomic, assign) int tomorrowMeetCount;
@property (nonatomic, assign) int weekMeetCount;
@property (nonatomic, assign) int otherCount;
+ (instancetype)statisticsWithDictionary:(NSDictionary *)dic;

@end


