//
//  YCMeetingProfit.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/31.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCOneMeetingProfit;
@class YCMeetingRecord;

@interface YCMeetingProfit : NSObject
@property (nonatomic, strong) NSArray<YCMeetingRecord *> *meetingRecordList;
@property (nonatomic, strong) NSArray<YCOneMeetingProfit *> *shareProfit;
@property (nonatomic, assign) int isShare;

+ (NSDictionary *)mj_objectClassInArray;
@end


@interface YCMeetingRecord : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) int state;//0已结算 1未结算 2已取消
@property (nonatomic, assign) double videoCost;
@property (nonatomic, assign) int meetingDuration;
// 自定义数据
@property (nonatomic, strong) NSString *stateString;
@property (nonatomic, strong) UIColor *stateColor;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *durationString;
@end

@interface YCOneMeetingProfit : NSObject
@property (nonatomic, assign) double forIncome;
@property (nonatomic, assign) double todayIncome;
@property (nonatomic, assign) double totalIncome;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id;
@end

//        {
//            isShare = 1;
//            meetingRecordList =     (
//                                     {
//                                         "videoCost": 23,
//                                         "createTime": 1517214565000,
//                                         "state": 0,
//                                         "userName": "巫海青",
//                                         "userIcon": "http://pic.jp580.com/user/info/icon/37d13733-67f4-4906-afbd-3bb5972c1e94/1498095336",
//                                         "meetingDuration": "30"
//                                     },
//                                     {
//                                         "videoCost": 23,
//                                         "createTime": 1517214291000,
//                                         "state": 0,
//                                         "userName": "巫海青",
//                                         "userIcon": "http://pic.jp580.com/user/info/icon/37d13733-67f4-4906-afbd-3bb5972c1e94/1498095336",
//                                         "meetingDuration": "30"
//                                     }
//            );
//            shareProfit =     (
//                               {
//                                   forIncome = 0;
//                                   id = "8f82d6d5-e8ed-4c14-b3a9-f808370da47a";
//                                   name = "\U751f\U610f\U732b";
//                                   todayIncome = 0;
//                                   totalIncome = 0;
//                                   type = 0;
//                               }
//                               );
//        }
