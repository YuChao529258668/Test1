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
#import "YCMeetingState.h"

@implementation YCMeetingBiz

- (void)getMeetingListWithPage:(int)page Success:(void(^)(NSArray<CGMeeting *> *meetings))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"page":@(page)};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingList param:dic success:^(id data) {
        NSArray *meetingModels = [CGMeeting mj_objectArrayWithKeyValuesArray:data];
        success(meetingModels);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已取消
- (void)meetingEntranceWithMeetingID:(NSString *)mid Success:(void(^)(int state, NSString *password, NSString *message))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId":mid};
    [self.component UIPostRequestWithURL:URL_Meeting_MeetingEntrance param:dic success:^(id data) {
        NSString *message = data[@"message"];
        NSString *password = data[@"password"];
        NSNumber *state = data[@"state"];
        success(state.intValue, password, message);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getMeetingRoomListWithSuccess:(void(^)(NSArray *companyRooms, NSArray *otherRooms))success fail:(void(^)(NSError *error))fail {
    NSString *companyId = [[ObjectShareTool sharedInstance].currentUser getCompanyID];
    if (!companyId) {
        [CTToast showWithText:@"获取会议室列表失败，公司 id 为空"];
        return;
    }
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
- (void)checkMeetingDateValidWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed roomID:(NSString *)rid OnSuccess:(void(^)(NSString *message, int state, NSString *recommendTime))success fail:(void(^)(NSError *error))fail {
    NSNumber *bn = [NSNumber numberWithLong:bd.timeIntervalSince1970*1000];
    NSNumber *en = [NSNumber numberWithLong:ed.timeIntervalSince1970*1000];
    NSDictionary *dic = @{@"roomId":rid, @"timeB":bn, @"timeE":en};

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
- (void)bookMeetingWithMeetingID:(NSString *)mid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate Success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
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
                          @"meegingCost": [NSNumber numberWithFloat:0],
                          @"userMode": @0,
                          @"meegingDeadline": @"",
                          @"companyPlace": @0,
                          @"attendance": @0
                          };

    [self.component UIPostRequestWithURL:URL_Meeting_BespeakMeeting param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getMeetingDetailWithMeetingID:(NSString *)mid  success:(void(^)(CGMeeting *meeting))success fail:(void(^)(NSError *error))fail {
    if (!mid) {
        [CTToast showWithText:@"获取会议详情失败: 会议id为空"];
        return;
    }

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
    if (!rid) {
        [CTToast showWithText:@"参数为空，请稍后再试"];
        return;
    }
    
    NSDictionary *dic = @{@"roomId": rid};

    [self.component sendPostRequestWithURL:URL_Meeting_RoomTime param:dic success:^(id data) {
        NSArray *times = [YCAvailableMeetingTimeList mj_objectArrayWithKeyValuesArray:data];
        success(times);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 取消会议. type 0取消/1结束
- (void)cancelMeetingWithMeetingID:(NSString *)mid cancelType:(int)type success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId": mid, @"type": @(type)};
    [self.component UIPostRequestWithURL:URL_Meeting_Cancel param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}


#pragma mark - 文件

// 会议当前文件
- (void)getCurrentFileWithMeetingID:(NSString *)mid success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    if (!mid) {
        [CTToast showWithText:@"获取会议文件失败：会议 id 为空"];
        return;
    }

    NSDictionary *dic = @{@"meetingId": mid};
    [self.component sendPostRequestWithURL:URL_Meeting_Current_File param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 会议使用文件。关闭课件，toId = @"0"
- (void)updateMeetingFileWithMeetingID:(NSString *)mid fileType:(int)type toId:(NSString *)toID success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    if (!mid || !toID ) {
        [CTToast showWithText:[NSString stringWithFormat:@"更新会议文件失败。会议id:%@, 文件id:%@", mid, toID]];
        return;
    }

    NSDictionary *dic = @{@"meetingId": mid, @"fileType": @(type), @"toId": toID};
    [self.component sendPostRequestWithURL:URL_Meeting_Use_File param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 会议文件页码
- (void)updateMeetingPageWithMeetingID:(NSString *)mid currentPage:(int)page success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId": mid, @"pageIn": @(page+1)};
    [self.component sendPostRequestWithURL:URL_Meeting_File_Page param:dic success:^(id data) {
        if (success) {
            success(data);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 03.会议成员接口 - ShowDoc http://doc.cgsays.com:50123/index.php?s=/1&page_id=407
// userId: 传all时代表所有人，除了主持人外
// compereState: 更换主持人
// userState: 参会状态 0未进入,1开会中,2已离开,4禁止
- (void)meetingUserWithMeetingID:(NSString *)mid userId:(NSString *)userId soundState:(NSString *)soundState videoState:(NSString *)videoState interactionState:(NSString *)interactionState compereState:(NSString *)compereState userState:(NSString *)userState userAdd:(NSString *)userAdd userDel:(NSString *)userDel success:(void(^)(YCMeetingState *state))success fail:(void(^)(NSError *error))fail {

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:mid forKey:@"meetingId"];
    
    if (userId) {
        dic[@"userId"] = userId;
    }

    if (soundState) {
        dic[@"soundState"] = soundState;
    }

    if (videoState) {
        dic[@"videoState"] = videoState;
    }

    if (interactionState) {
        dic[@"interactionState"] = interactionState;
    }

    if (compereState) {
        dic[@"compereState"] = compereState;
    }

    if (userState) {
        dic[@"userState"] = userState;
    }

    if (userAdd) {
        dic[@"userAdd"] = userAdd;
    }
    
    if (userDel) {
        dic[@"userDel"] = userDel;
    }
    
    [self.component sendPostRequestWithURL:URL_Meeting_User param:dic success:^(id data) {
        if (success) {
            YCMeetingState *state = [YCMeetingState mj_objectWithKeyValues:data];
            success(state);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


@end
