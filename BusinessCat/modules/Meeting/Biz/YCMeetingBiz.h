//
//  YCMeetingBiz.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
@class CGMeeting;
@class YCMeetingState;
@class YCMeetingCompanyRoom;
@class YCMeetingRebate;

@interface YCMeetingBiz : CGBaseBiz

// 获取会议列表
- (void)getMeetingListWithPage:(int)page Success:(void(^)(NSArray<CGMeeting *> *meetings))success fail:(void(^)(NSError *error))fail;

// 能否进入会议 状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
- (void)meetingEntranceWithMeetingID:(NSString *)mid Success:(void(^)(int state, NSString *password, NSString *message, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *q))success fail:(void(^)(NSError *error))fail;

// 获取会议室列表
- (void)getMeetingRoomListWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed Success:(void(^)(NSArray<YCMeetingCompanyRoom *> *companyRooms))success fail:(void(^)(NSError *error))fail;

// 会议日期是否有效
- (void)checkMeetingDateValidWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed roomID:(NSString *)rid OnSuccess:(void(^)(NSString *message, int state, NSString *recommendTime))success fail:(void(^)(NSError *error))fail;

// 预约会议。users是所有开会的人的 uuid 用英文逗号连起来的字符串,除了发起人
//"meetingId":"", 为空代表新预约，有值代表修改
//"meetingMans":"37d13733-67f4-4906-afbd-3bb5972c1e94,a2af44fb-",开会的人,所有人除了发起人（uuid多个用英文逗号隔开）
// oldMeetingID 再次召开的时候传值，否则@""
- (void)bookMeetingWithMeetingID:(NSString *)mid oldMeetingID:(NSString *)oldMid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate Success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;
// live: 是否直播
//roomType 视频的会议室类型 0:公司 1:用户
//companyRoomId 公司会议房间Id（空为非公司会议）
- (void)bookMeeting2WithMeetingID:(NSString *)mid oldMeetingID:(NSString *)oldMid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate live:(int)live accessNumber:(NSInteger)an roomType:(int)roomType companyRoomId:(NSString *)crID shareType:(int)shareType toType:(int)toType toId:(NSString *)toID Success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;

// 会议详情
- (void)getMeetingDetailWithMeetingID:(NSString *)mid  success:(void(^)(CGMeeting *meeting))success fail:(void(^)(NSError *error))fail;

// 会议室可用时间
- (void)getMeetingRoomTimeWithRoomID:(NSString *)rid  success:(void(^)(NSArray *times))success fail:(void(^)(NSError *error))fail;

// 取消会议. type 0取消/1结束
- (void)cancelMeetingWithMeetingID:(NSString *)mid cancelType:(int)type success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;


#pragma mark - 文件
// 会议当前文件
- (void)getCurrentFileWithMeetingID:(NSString *)mid success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;

// 会议使用文件。关闭课件，toId = @"0"
// picUrl 素材图片 url，没有就传 nil。
// fileType，0 文件，1 素材
- (void)updateMeetingFileWithMeetingID:(NSString *)mid fileType:(int)type toId:(NSString *)toID picUrl:(NSString *)picUrl success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;

// 会议文件页码
- (void)updateMeetingPageWithMeetingID:(NSString *)mid currentPage:(int)page success:(void(^)(id data))success fail:(void(^)(NSError *error))fail;

//查询会议文件列表
- (void)getUserCollectionDataWithLabel:(int)label page:(NSInteger)page meetingID:(NSString *)mid success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;


#pragma mark - 成员

// 会议成员接口 - ShowDoc http://doc.cgsays.com:50123/index.php?s=/1&page_id=407
// userId: 传all时代表所有人，除了主持人外
// compereState: 更换主持人
// userState: 参会状态
- (void)meetingUserWithMeetingID:(NSString *)mid userId:(NSString *)userId soundState:(NSString *)soundState videoState:(NSString *)videoState interactionState:(NSString *)interactionState compereState:(NSString *)compereState userState:(NSString *)userState userAdd:(NSString *)userAdd userDel:(NSString *)userDel success:(void(^)(YCMeetingState *state))success fail:(void(^)(NSError *error))fail ;


#pragma mark - 录制、直播

//type: 0取消/1开始/2获取直播网址
- (void)meetingLiveWithMeetingID:(NSString *)mid type:(int)type success:(void(^)(NSDictionary *dic, int liveState, NSString *liveUrl))success failue:(void(^)(NSError *error))fail;

//录制
//fileName: 文件名称（type为1时传）
//type: 0取消/1开始/2获取录制网址
- (void)meetingTranscribeWithMeetingID:(NSString *)mid fileName:(NSString *)fileName type:(int)type success:(void(^)(NSDictionary *dic, int transcribeState, NSString *fileUrl, NSArray *files))success failue:(void(^)(NSError *error))fail;

#pragma mark - 支付

- (void)getMeetingMinuteListWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed accessNumber:(NSInteger)count Success:(void(^)(NSArray<NSArray<YCMeetingRebate *> *> *twoLists))success fail:(void(^)(NSError *error))fail;

@end
