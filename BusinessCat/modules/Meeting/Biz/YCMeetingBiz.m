//
//  YCMeetingBiz.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingBiz.h"
#import "YCMeetingRoom.h"
#import "CGMeeting.h"

@implementation YCMeetingBiz

- (void)getMeetingListWithPage:(int)page Success:(void(^)(NSArray<CGMeeting *> *meetings))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
//    NSDictionary *dic = @{@"token":token, @"page":@(page)};
    NSDictionary *dic = @{@"page":@(page)};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingList param:dic success:^(id data) {
        NSArray *meetingModels = [CGMeeting mj_objectArrayWithKeyValuesArray:data];
        success(meetingModels);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已取消
- (void)meetingEntranceWithMeetingID:(NSString *)mid Success:(void(^)(int state))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
//    NSDictionary *dic = @{@"token":token, @"meetingId":mid};
    NSDictionary *dic = @{@"meetingId":mid};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingEntrance param:dic success:^(id data) {
        NSLog(@"%@", data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getMeetingRoomListWithSuccess:(void(^)(NSArray *companyRooms, NSArray *otherRooms))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
    NSString *companyId = [[ObjectShareTool sharedInstance].currentUser getCompanyID];
//    NSDictionary *dic = @{@"token":token, @"companyId":companyId};
    NSDictionary *dic = @{@"companyId":companyId};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingRoomList param:dic success:^(id data) {
        NSArray *companyData = [data objectForKey:@"companyData"];
        NSArray *otherData = [data objectForKey:@"otherData"];
        NSArray *companyDataModelArray = [YCMeetingRoom mj_objectArrayWithKeyValuesArray:companyData];
        NSArray *otherDataModelArray = [YCMeetingRoom mj_objectArrayWithKeyValuesArray:otherData];
        success(companyDataModelArray, otherDataModelArray);
    } fail:^(NSError *error) {
        NSLog(@"%@, error  = %@", NSStringFromSelector(_cmd), error.description);
    }];
}

// 验证时间是否有效
- (void)checkMeetingDateValidWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed meetingID:(NSString *)mid OnSuccess:(void(^)(NSString *message, int state, NSString *recommendTime))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;

//    NSNumber *timestamp = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]*1000];

//    NSUInteger timeb = bd.timeIntervalSince1970*1000;
//    NSUInteger timee = ed.timeIntervalSince1970*1000;
    
//    NSNumber *bn = [NSNumber numberWithLong:timeb];
//    NSNumber *en = [NSNumber numberWithLong:timee];
    
    NSNumber *bn = [NSNumber numberWithLong:bd.timeIntervalSince1970*1000];
    NSNumber *en = [NSNumber numberWithLong:ed.timeIntervalSince1970*1000];
    
//    NSString *tb = [NSString stringWithFormat:@"%ld", timeb];
//    NSString *te = [NSString stringWithFormat:@"%ld", timee];
    
//    NSDictionary *dic = @{@"token":token, @"roomId":mid, @"timeB":bn, @"timeE":en};
    NSDictionary *dic = @{@"roomId":mid, @"timeB":bn, @"timeE":en};
//    NSDictionary *dic = @{@"token":token, @"roomId":mid, @"timeB":@(timeb), @"timeE":@(timee)};
//    NSDictionary *dic = @{@"token":token, @"roomId":mid, @"timeB":tb, @"timeE":te};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingTime param:dic success:^(id data) {
        NSString *messageTip = [data valueForKey:@"messageTip"];
        int state = ((NSNumber *)[data valueForKey:@"state"]).intValue;
        NSString *recommendTime = [data valueForKey:@"recommendTime"];
        success(messageTip, state, recommendTime);
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//"meetingId":"", 为空代表新预约，有值代表修改
//"meetingMans":"37d13733-67f4-4906-afbd-3bb5972c1e94,a2af44fb-",开会的人,所有人除了发起人（uuid多个用英文逗号隔开）
//http://doc.cgsays.com:50123/index.php?s=/1&page_id=391
- (void)bookMeetingWithMeetingID:(NSString *)mid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate Success:(void(^)())success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
    NSString *companyId = [ObjectShareTool sharedInstance].currentUser.getCompanyID;
    NSNumber *bn = [NSNumber numberWithLong:bDate.timeIntervalSince1970*1000];
    NSNumber *en = [NSNumber numberWithLong:eDate.timeIntervalSince1970*1000];
    NSDictionary *dic = @{@"meetingId": mid,
                          @"companyId": companyId,
                          @"meetingType": [NSString stringWithFormat:@"%@", @(type)],
                          @"meetingName": name,
                          @"meetingMans": users,
                          @"meetingRoomId": rid,
                          @"startTime": bn,
                          @"endTime": en,
                          @"meetingMode": @0,
                          @"meetingPic": @"",
                          @"meegingPay": @0,
                          @"meegingCost": @0,
                          @"userMode": @0,
                          @"meegingDeadline": @"",
                          @"companyPlace": @0,
                          @"attendance": @0
                          };

    [self.component sendPostRequestWithURL:URL_Meeting_BespeakMeeting param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getMeetingDetailWithMeetingID:(NSString *)mid  success:(void(^)(CGMeeting *meeting))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
//    NSDictionary *dic = @{@"token": token, @"meetingId": mid};
    NSDictionary *dic = @{@"meetingId": mid};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingDetail param:dic success:^(id data) {
        CGMeeting *meeting = [CGMeeting mj_objectWithKeyValues:data];
        success(meeting);
    } fail:^(NSError *error) {
        fail(error);
    }];

}

// 获取会议有效日期
- (void)getMeetingRoomTimeWithRoomID:(NSString *)rid  success:(void(^)(NSArray *times))success fail:(void(^)(NSError *error))fail {
//    NSString *token = [ObjectShareTool sharedInstance].currentUser.token;
//    NSDictionary *dic = @{@"token": token, @"roomId": rid};
    NSDictionary *dic = @{@"roomId": rid};
//    NSLog(@"开始获取会议有效日期");

    [self.component sendPostRequestWithURL:URL_Meeting_RoomTime param:dic success:^(id data) {
//        NSLog(@"获取会议有效日期成功");

        NSArray *times = [YCAvailableMeetingTimeList mj_objectArrayWithKeyValuesArray:data];
        success(times);
    } fail:^(NSError *error) {
//        NSLog(@"获取会议有效日期失败");
        fail(error);
    }];
//    NSLog(@"结束 获取会议有效日期");

}


@end
