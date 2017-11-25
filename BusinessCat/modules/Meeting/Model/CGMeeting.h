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
@property (nonatomic,assign) int state;
@property (nonatomic,strong) NSString *timeB;
@property (nonatomic,strong) NSString *timeE;
@property (nonatomic,strong) NSString *userIcon;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *position;// 职位

@end


@interface CGMeeting : NSObject

// http://doc.cgsays.com:50123/index.php?s=/1&page_id=387
#pragma mark - 会议列表返回的部分属性

@property (nonatomic,assign) int attendance;//参会人数
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *conferenceNumber; // 会议号(justalk)，justalk的 roomID
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString * meetingDuration; // 时长，可能是一句话，不能用来计算价格！
@property (nonatomic,strong) NSString *meetingId;
@property (nonatomic,strong) NSString *meetingName;
@property (nonatomic,strong) NSString *meetingPassword;
@property (nonatomic,strong) NSString *meetingRoomId;
@property (nonatomic,assign) int meetingState; // 会议状态 0:未开始 1：进行中 2：已结束 3：已取消
@property (nonatomic,assign) int meetingType; // 会议形式（0：音频，1：视频）
@property (nonatomic,strong) NSArray<YCMeetingUser *> *meetingUserList; // 开会成员列表


// http://doc.cgsays.com:50123/index.php?s=/1&page_id=389
#pragma mark - 会议详情接口返回的部分属性

@property (nonatomic,assign) float costVideo;
@property (nonatomic,assign) float costVoice;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *createUser; // 创建者 id
@property (nonatomic,assign) float meetingCost;//语音/视频每分钟每人价格
@property (nonatomic,strong) NSString *roomId;//会议室Id(justalk)
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *roomNum;//会议最大人数
@property (nonatomic,strong) NSString *serverId;//服务器Id(justalk)
@property (nonatomic,strong) NSString *usedTime;//实际开会用时(分钟)
@property (nonatomic,assign) int roomCharge; // 费用(0免费1付费2包月)

#pragma mark - 函数

+ (NSDictionary *)mj_objectClassInArray;
// 返回 id
- (NSString *)meetingCreator;
- (NSString *)meetingCreatorName;

- (float)calculateMeetingCost;
@end
