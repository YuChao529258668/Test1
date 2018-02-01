//
//  YCSeeBoard.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCMeetingProfit.h"

@class NowMonthMeeting;
@class NowMonthStatistics;

@interface YCSeeBoard : NSObject
@property (nonatomic, strong) NowMonthMeeting *nowMonthMeeting;
@property (nonatomic, strong) NowMonthStatistics *nowMonthStatistics;
@property (nonatomic, strong) NSArray<YCOneMeetingProfit *> *shareProfit;
@property (nonatomic, assign) int isShare;

+ (NSDictionary *)mj_objectClassInArray;

@end

@interface NowMonthMeeting : NSObject
@property (nonatomic, assign) int otherCount;
@property (nonatomic, strong) NSDictionary *toDay;
@property (nonatomic, assign) int tomorrowMeetCount;
@property (nonatomic, assign) int weekMeetCount;

- (int)toDayMeetCount;
- (int)toDayUnBeginMeetCount;
@end

@interface NowMonthStatistics : NSObject
@property (nonatomic, assign) int absentCount;
@property (nonatomic, assign) int lateCount;
@property (nonatomic, assign) int meetingCount;
@property (nonatomic, assign) int onTimeCount;
@property (nonatomic, assign) int useTotal;

@end

//        {
//            nowMonthMeeting =     {
//                otherCount = 0;
//                toDay =         {
//                    toDayMeetCount = 0;
//                    toDayUnBeginMeetCount = 0;
//                };
//                tomorrowMeetCount = 0;
//                weekMeetCount = 0;
//            };
//            nowMonthStatistics =     {
//                absentCount = 0;
//                lateCount = 0;
//                meetingCount = 157;
//                onTimeCount = 157;
//                useTotal = 1570;
//            };
//            shareProfit =     (
//                               {
//                                   forIncome = 0;
//                                   id = "8f82d6d5-e8ed-4c14-b3a9-f808370da47a";
//                                   name = "\U751f\U610f\U732b";
//                                   todayIncome = 0;
//                                   totalIncome = 0;
//                                   type = 0;
//                               },
//                               {
//                                   forIncome = 0;
//                                   id = "e7140cb4-f562-4fd7-83d3-715ba765b0b1";
//                                   name = "\U521b\U5c06\U79d1\U6280";
//                                   todayIncome = 0;
//                                   totalIncome = 0;
//                                   type = 0;
//                               }
//                               );
//        }
