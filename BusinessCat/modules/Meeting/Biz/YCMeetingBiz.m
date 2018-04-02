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

#import "KnowledgeHeaderEntity.h"
#import "CGInfoHeadEntity.h"
#import "YCMeetingRebate.h"

@implementation YCMeetingBiz

//type 0：所有, 1：今天, 2：明天, 3：本周, 4：其他
- (void)getMeetingListWithPage:(int)page type:(int)type Success:(void(^)(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"page":@(page), @"type": @(type)};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingList param:dic success:^(id data) {
        NSDictionary *meetingList = data[@"meetingList"];
        NSArray *meetingModels = [CGMeeting mj_objectArrayWithKeyValuesArray:meetingList];
        
        NSDictionary *statisticsDic = data[@"meetingStatistics"];
        CGMeetingStatistics *statistics = [CGMeetingStatistics statisticsWithDictionary:statisticsDic];
        success(meetingModels, statistics);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
- (void)meetingEntranceWithMeetingID:(NSString *)mid Success:(void(^)(int state, NSString *password, NSString *message, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *q))success fail:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId":mid};
    [self.component UIPostRequestWithURL:URL_Meeting_MeetingEntrance param:dic success:^(id data) {
        NSString *message = data[@"message"];
        NSString *password = data[@"password"];
        NSNumber *state = data[@"state"];
        NSString *base64String = data[@"q"];//七牛, eyJhIjoiRXVPWHh6YWhqNnZRNlZ4eUlxOUh1NURMQnoyeHowQjNaaW1CTVlqSCIsInYiOiJ2aWRlbyIsInMiOiJBLUNCNU44ai1BeVFSdERiV1VqOWJqTnVzSWVJUXdyR3pKcl9fN0R1In0=, 解密后得到{"a":"EuOXxzahj6vQ6VxyIq9Hu5DLBz2xz0B3ZimBMYjH","v":"video","s":"A-CB5N8j-AyQRtDbWUj9bjNusIeIQwrGzJr__7Du"}
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [decodedString objectFromJSONString];
        NSString *AccessKey = dic[@"a"];
        NSString *SecretKey = dic[@"s"];
        NSString *BucketName = dic[@"v"];
        success(state.intValue, password, message, AccessKey, SecretKey, BucketName, base64String);
    } fail:^(NSError *error) {
        fail(error);
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
// oldMeetingID 再次召开的时候传值，否则@""
// 会议形式（0：音频，1：视频）
//http://doc.cgsays.com:50123/index.php?s=/1&page_id=391
- (void)bookMeetingWithMeetingID:(NSString *)mid oldMeetingID:(NSString *)oldMid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate Success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSString *companyId = [ObjectShareTool sharedInstance].currentUser.getCompanyID;
    NSNumber *bn = [NSNumber numberWithLong:bDate.timeIntervalSince1970*1000];
    NSNumber *en = [NSNumber numberWithLong:eDate.timeIntervalSince1970*1000];
    NSDictionary *dic = @{@"meetingId": mid,
                          @"oldMeetingId": oldMid,
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
                          @"attendance": @0,
                          @"live": @1,
                          @"accessNumber": @16
                          };

    [self.component UIPostRequestWithURL:URL_Meeting_BespeakMeeting param:dic success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//roomType 视频的会议室类型 0:公司 1:用户
//companyRoomId 公司会议房间Id（空为非公司会议）
//http://doc.cgsays.com:50123/index.php?s=/1&page_id=391
- (void)bookMeeting2WithMeetingID:(NSString *)mid oldMeetingID:(NSString *)oldMid MeetingType:(int)type MeetingName:(NSString *)name users:(NSString *)users roomID:(NSString *)rid beginDate:(NSDate *)bDate endDate:(NSDate *)eDate live:(int)live accessNumber:(NSInteger)an roomType:(int)roomType companyRoomId:(NSString *)crID shareType:(int)shareType toType:(int)toType toId:(NSString *)toID juhua:(BOOL)juhua Success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSString *companyId = [ObjectShareTool sharedInstance].currentUser.getCompanyID;
    if (!companyId) {
        companyId = @"";
    }
    NSNumber *bn = [NSNumber numberWithLong:bDate.timeIntervalSince1970*1000];
    NSNumber *en = [NSNumber numberWithLong:eDate.timeIntervalSince1970*1000];
    if (!crID) {
        crID = @"";
    }
    NSDictionary *dic = @{@"meetingId": mid,
                          @"oldMeetingId": oldMid,
                          @"companyId": companyId,
                          @"meetingType": [NSString stringWithFormat:@"%@", @(type)],
                          @"meetingName": name,
                          @"meetingMans": users,
                          @"meetingRoomId": rid,
                          @"startTime": bn,
                          @"endTime": en,
                          @"meetingMode": @0,
                          @"meetingPic": @"",
                          @"meegingPay": @(-1),
                          @"meegingCost": [NSNumber numberWithFloat:-1],
                          @"userMode": @0,
                          @"meegingDeadline": @"",
                          @"companyPlace": @0,
                          @"attendance": @0,
                          @"live": @(live),
                          @"accessNumber": @(an),
                          @"roomType": @(roomType),
                          @"companyRoomId": crID,
                          @"shareType": @(shareType),
                          @"toType": @(toType),
                          @"toId": toID
                          };
    
    if (juhua) {
        [self.component UIPostRequestWithURL:URL_Meeting_BespeakMeeting param:dic success:^(id data) {
            success(data);
        } fail:^(NSError *error) {
            fail(error);
        }];
    } else {
        [self.component sendPostRequestWithURL:URL_Meeting_BespeakMeeting param:dic success:^(id data) {
            success(data);
        } fail:^(NSError *error) {
            fail(error);
        }];
    }
}

- (void)getMeetingDetailWithMeetingID:(NSString *)mid  success:(void(^)(CGMeeting *meeting))success fail:(void(^)(NSError *error))fail {
    if (!mid) {
        [CTToast showWithText:@"获取会议详情失败: 会议id为空"];
        return;
    }

    NSDictionary *dic = @{@"meetingId": mid};
    [self.component sendPostRequestWithURL:URL_Meeting_MeetingDetail param:dic success:^(id data) {
        // 接口有变，修改返回的数据再解析
        NSDictionary *meetingUserList = data[@"meetingUserList"];
        NSArray *remoteUserList = meetingUserList[@"remoteUserList"];
        NSArray *sceneUserList = meetingUserList[@"sceneUserList"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
        dic[@"remoteUserList"] = remoteUserList;
        dic[@"sceneUserList"] = sceneUserList;
        [dic removeObjectForKey:@"meetingUserList"];

        CGMeeting *meeting = [CGMeeting mj_objectWithKeyValues:dic];
        meeting.meetingUserList = [NSMutableArray arrayWithArray:meeting.remoteUserList];
        [meeting.meetingUserList addObjectsFromArray:meeting.sceneUserList];

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

#pragma mark - 会议室

- (void)getMeetingRoomListWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed Success:(void(^)(NSArray<YCMeetingCompanyRoom *> *companyRooms))success fail:(void(^)(NSError *error))fail {
    
    if (!bd) {
        bd = [NSDate dateWithTimeIntervalSince1970:0];
    }
    if (!ed) {
        ed = [NSDate dateWithTimeIntervalSinceNow:30 * 24 *60 * 60];
    }
    
    
    NSNumber *beginDateN = [NSNumber numberWithLong:bd.timeIntervalSince1970 * 1000];
    NSNumber *endDateN = [NSNumber numberWithLong:ed.timeIntervalSince1970 * 1000];
    //    NSDictionary *dic = @{@"companyId":companyId, @"startTime":beginDateN, @"endTime": endDateN};
    NSDictionary *dic = @{@"startTime":beginDateN, @"endTime": endDateN};
    
    
    [self.component UIPostRequestWithURL:URL_Meeting_MeetingRoomList param:dic success:^(id data) {
        
        NSArray<YCMeetingCompanyRoom *> *companyRooms = [YCMeetingCompanyRoom mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(companyRooms);
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@, error  = %@", NSStringFromSelector(_cmd), error.description);
    }];
}

// 添加会议室
// roomId 会议室Id（为空时新增，有值是修改）
// toId 公司Id
// type 1公司会议室 2视频会议室 3会议地点
// roomName 会议室名称/会议地点名称
// toType 0：公司 1：用户
- (void)addMeetingRoomWithRoomID:(NSString *)roomId toId:(NSString *)toId roomName:(NSString *)roomName type:(int)type roomNum:(int)roomNum success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (type == 3) {
        dic[@"toType"] = @1;
    } else {
        dic[@"toType"] = @0;
    }

    dic[@"roomName"] = roomName;
    dic[@"type"] = @(type);
    dic[@"roomNum"] = @(roomNum);

    if (roomId) {
        dic[@"roomId"] = roomId;
    }
    
    if (toId) {
        dic[@"toId"] = toId;
    }
    
    [self.component UIPostRequestWithURL:URL_Meeting_AddMeetingRoom param:dic success:^(NSDictionary *data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 删除会议室
- (void)deleteMeetingRoomWithRoomID:(NSString *)roomId success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:roomId forKey:@"roomId"];
    
    [self.component UIPostRequestWithURL:URL_Meeting_DeleteMeetingRoom param:dic success:^(NSDictionary *data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getMeetingRoomTimeListWithSelectDate:(NSDate *)selectDate success:(void(^)(NSArray<YCMeetingCompanyRoom *> *companyRooms))success fail:(void(^)(NSError *error))fail {
    NSNumber *n = [NSNumber numberWithLong:selectDate.timeIntervalSince1970 * 1000];
    NSDictionary *dic = @{@"selectDate": n};
    
    [self.component UIPostRequestWithURL:URL_Meeting_MeetingRoomTimeList param:dic success:^(NSDictionary *data) {
        NSArray<YCMeetingCompanyRoom *> *companyRooms = [YCMeetingCompanyRoom mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(companyRooms);
        }
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
// picUrl 素材图片 url，没有就传 nil。
// fileType，0 文件，1 素材
- (void)updateMeetingFileWithMeetingID:(NSString *)mid fileType:(int)type toId:(NSString *)toID picUrl:(NSString *)picUrl success:(void(^)(id data))success fail:(void(^)(NSError *error))fail {
    if (!mid || !toID ) {
        [CTToast showWithText:[NSString stringWithFormat:@"更新会议文件失败。会议id:%@, 文件id:%@", mid, toID]];
        return;
    }

    NSMutableDictionary *dic = @{@"meetingId": mid, @"toId": toID}.mutableCopy;
    // 如果是素材
    if (picUrl) {
        dic[@"picUrl"] = picUrl;
        dic[@"fileType"] = @1;
    } else {
        dic[@"fileType"] = @0;
    }
    
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

//查询会议文件列表 代码从 CGUserCenterBiz 复制
- (void)getUserCollectionDataWithLabel:(int)label page:(NSInteger)page meetingID:(NSString *)mid success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:label],@"label",[NSNumber numberWithInteger:page],@"page", nil].mutableCopy;
    param[@"meetingId"] = mid;
    [self.component sendPostRequestWithURL:URL_Meeting_File_List param:param success:^(id data) {
        NSArray *array = data;
        //      if(array && array.count > 0){
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            NSNumber *type = dict[@"type"];
            if (type.integerValue == 26) {
                [result addObject:[KnowledgeHeaderEntity mj_objectWithKeyValues:dict]];
            }else{
                CGInfoHeadEntity *comment = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
                comment.cover = [comment.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [result addObject:comment];
            }
        }
        success(result);
        //      }else{
        //        fail(nil);
        //      }
    } fail:^(NSError *error) {
        fail(error);
    }];
}


#pragma mark - 成员

// 这里的 meetingMode 默认是 1，远程会议
// 03.会议成员接口 - ShowDoc http://doc.cgsays.com:50123/index.php?s=/1&page_id=407
// userId: 传all时代表所有人，除了主持人外
// compereState: 更换主持人
// userState: 参会状态 0未进入,1开会中,2已离开,4禁止
- (void)meetingUserWithMeetingID:(NSString *)mid userId:(NSString *)userId soundState:(NSString *)soundState videoState:(NSString *)videoState interactionState:(NSString *)interactionState compereState:(NSString *)compereState userState:(NSString *)userState userAdd:(NSString *)userAdd userDel:(NSString *)userDel success:(void(^)(YCMeetingState *state))success fail:(void(^)(NSError *error))fail {
    
    [self meetingUser22222WithMeetingID:mid userId:userId soundState:soundState videoState:videoState interactionState:interactionState compereState:compereState userState:userState userAdd:userAdd userDel:userDel meetingMode:@"1" success:success fail:fail];
}

// meetingMode: 0：会议室 1：视频会议
- (void)meetingUser22222WithMeetingID:(NSString *)mid userId:(NSString *)userId soundState:(NSString *)soundState videoState:(NSString *)videoState interactionState:(NSString *)interactionState compereState:(NSString *)compereState userState:(NSString *)userState userAdd:(NSString *)userAdd userDel:(NSString *)userDel meetingMode:(NSString *)meetingMode success:(void(^)(YCMeetingState *state))success fail:(void(^)(NSError *error))fail {
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
    
    if (!meetingMode) {
        meetingMode = @"1";
    }
    dic[@"meetingMode"] = meetingMode; // 0：会议室 1：视频会议
    
    [self.component sendPostRequestWithURL:URL_Meeting_User param:dic success:^(NSDictionary *data) {
        if (success) {
            // 接口有变，修改返回的数据再解析
            NSDictionary *meetingUserList = data[@"meetingUserList"];
            NSArray *remoteUserList = meetingUserList[@"remoteUserList"];
            NSArray *sceneUserList = meetingUserList[@"sceneUserList"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
            dic[@"remoteUserList"] = remoteUserList;
            dic[@"sceneUserList"] = sceneUserList;
            [dic removeObjectForKey:@"meetingUserList"];
            
            YCMeetingState *state = [YCMeetingState mj_objectWithKeyValues:dic];
            state.meetingUserList = [NSMutableArray arrayWithArray:state.remoteUserList];
            [state.meetingUserList addObjectsFromArray:state.sceneUserList];
            success(state);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark - 录制、直播

//直播
//type: 0取消/1开始/2获取直播网址
- (void)meetingLiveWithMeetingID:(NSString *)mid type:(int)type success:(void(^)(NSDictionary *dic, int liveState, NSString *liveUrl))success failue:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId": mid, @"type": @(type)};
    [self.component sendPostRequestWithURL:URL_Meeting_Live param:dic success:^(NSDictionary * data) {
        if (success) {
            NSNumber *liveState = data[@"liveState"];
            NSString *liveUrl = data[@"liveUrl"];
            success(data, liveState.intValue, liveUrl);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];

}

//录制
//fileName: 文件名称（type为1时传）
//type: 0取消/1开始/2获取录制网址
- (void)meetingTranscribeWithMeetingID:(NSString *)mid fileName:(NSString *)fileName type:(int)type success:(void(^)(NSDictionary *dic, int transcribeState, NSString *fileUrl, NSArray *files))success failue:(void(^)(NSError *error))fail {
    NSDictionary *dic = @{@"meetingId": mid, @"type": @(type)};
    if (type == 1) {
        dic = @{@"meetingId": mid, @"type": @(type), @"fileName": fileName};
    }
    
    [self.component sendPostRequestWithURL:URL_Meeting_Transcribe param:dic success:^(NSDictionary * data) {
        if (success) {
//            transcribeState    int            是    当前录制状态
//            transcribeList
//            fileUrl
            NSNumber *transcribeState = data[@"transcribeState"];
            NSString *fileUrl = data[@"fileUrl"];
            NSArray *files = data[@"transcribeList"];
            success(data, transcribeState.intValue, fileUrl, files);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    
}

#pragma mark - 支付

- (void)getMeetingMinuteListWithBeginDate:(NSDate *)bd endDate:(NSDate *)ed accessNumber:(NSInteger)count Success:(void(^)(NSArray<NSArray<YCMeetingRebate *> *> *twoLists))success fail:(void(^)(NSError *error))fail {
//    if (!bd) {
//        bd = [NSDate dateWithTimeIntervalSince1970:0];
//    }
//    if (!ed) {
//        ed = [NSDate dateWithTimeIntervalSinceNow:30 * 24 *60 * 60];
//    }
    
    NSNumber *beginDateN = [NSNumber numberWithLong:bd.timeIntervalSince1970 * 1000];
    NSNumber *endDateN = [NSNumber numberWithLong:ed.timeIntervalSince1970 * 1000];
    NSDictionary *dic = @{@"startTime":beginDateN, @"endTime": endDateN, @"accessNumber": @(count)};

    [self.component UIPostRequestWithURL:URL_Meeting_Minute_List param:dic success:^(id data) {
        NSArray *myList = [YCMeetingRebate mj_objectArrayWithKeyValuesArray:data[@"myList"]];
        NSArray *shareList = [YCMeetingRebate mj_objectArrayWithKeyValuesArray:data[@"shareList"]];
        if (!data[@"myList"] && !data[@"shareList"]) {
            [CTToast showWithText:@"后台没有返回myList和shareList"];
        }
        if (myList.count + shareList.count == 0) {
            [CTToast showWithText:@"后台返回的myList和shareList为空"];
        }
        if (!shareList) {
            shareList = @[];
        }
        NSArray *lists = @[myList, shareList];
        if (success) {
            success(lists);
        }

    } fail:^(NSError *error) {
        NSLog(@"%@, error  = %@", NSStringFromSelector(_cmd), error.description);
    }];

}


// 代码复制的使用 URL_COMMON_PLACE_ORDER 作为参数的接口。
// 使用会议共享金币不足时的微信支付
- (void)authUserPlaceOrderWithToId:(NSString *)toId toType:(NSInteger)toType subType:(NSInteger)subType payType:(NSInteger)payType payMethod:(NSString *)payMethod toUserId:(NSString *)toUserId body:(NSString *)body detail:(NSString *)detail attach:(id)attach trade_type:(NSString *)trade_type device_info:(NSString *)device_info total_fee:(double)total_fee notify_url:(NSString *)notify_url order_type:(NSInteger)order_type iOSProductId:(NSString *)iOSProductId success:(void(^)(CGRewardEntity * entity))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:toId,@"toId",[NSNumber numberWithInteger:toType],@"toType",[NSNumber numberWithInteger:payType],@"payType",payMethod,@"payMethod",toUserId,@"toUserId",body,@"body",trade_type,@"trade_type",[NSNumber numberWithDouble:total_fee],@"total_fee",[NSNumber numberWithInteger:order_type],@"order_type", nil];
    
    if ([CTStringUtil stringNotBlank:detail]) {
        [param setObject:detail forKey:@"detail"];
    }
    if (attach) {
        if ([attach isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = attach;
            NSString *json = [dic mj_JSONString];
            [param setObject:json forKey:@"attach"];
        }
    }
    if ([CTStringUtil stringNotBlank:device_info]) {
        [param setObject:device_info forKey:@"device_info"];
    }
    
    if ([CTStringUtil stringNotBlank:notify_url]) {
        [param setObject:notify_url forKey:@"notify_url"];
    }
    
    if ([CTStringUtil stringNotBlank:iOSProductId]) {
        [param setObject:iOSProductId forKey:@"iOSProductId"];
    }
    
    if (toType == 3) {
        [param setObject:[NSNumber numberWithInteger:subType] forKey:@"subType"];
    }
    
    [self.component UIPostRequestWithURL:URL_Meeting_Order param:param success:^(id data) {
        NSDictionary *dict = data;
        CGRewardEntity *comment = [CGRewardEntity mj_objectWithKeyValues:dict];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

@end
