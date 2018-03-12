//
//  CGMeeting.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeeting.h"

@implementation YCMeetingUser

- (void)setUserIcon:(NSString *)userIcon {
    _userIcon = userIcon;
    
    if (userIcon && ![userIcon containsString:@"http"]) {
        _userIcon = [NSString stringWithFormat:@"http://pic.jp580.com/%@", userIcon];
    }
}

@end


@implementation CGMeeting

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"meetingUserList": [YCMeetingUser class], @"remoteUserList": [YCMeetingUser class], @"sceneUserList": [YCMeetingUser class]};
}

- (BOOL)ycIsCompere {
    return [self.ycCompereID isEqualToString:[ObjectShareTool currentUserID]];
}

- (void)setMeetingUserList:(NSMutableArray<YCMeetingUser *> *)meetingUserList {
    _meetingUserList = meetingUserList;
    
    // 把主持人放到第一位，保存主持人
    [_meetingUserList enumerateObjectsUsingBlock:^(YCMeetingUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.compere) {
            [_meetingUserList exchangeObjectAtIndex:0 withObjectAtIndex:idx];
            _ycCompere = obj;
            _ycCompereID = obj.userid;
            *stop = YES;
        }
    }];
}


@end


#pragma mark - 会议统计数据

@implementation CGMeetingStatistics
//meetingStatistics =     {
//    nowMonthMeeting =         {
//        otherCount = 3;
//        toDay =             {
//            toDayMeetCount = 2;
//            toDayUnBeginMeetCount = 0;
//        };
//        tomorrowMeetCount = 1;
//        weekMeetCount = 3;
//    };
//};

+ (instancetype)statisticsWithDictionary:(NSDictionary *)dic {
    NSDictionary *nowMonthMeeting = dic[@"nowMonthMeeting"];
    
    NSNumber *otherCount = nowMonthMeeting[@"otherCount"];
    NSDictionary *toDay = nowMonthMeeting[@"toDay"];
    NSNumber *tomorrowMeetCount = nowMonthMeeting[@"tomorrowMeetCount"];
    NSNumber *weekMeetCount = nowMonthMeeting[@"weekMeetCount"];

    NSNumber *toDayMeetCount = toDay[@"toDayMeetCount"];
    NSNumber *toDayUnBeginMeetCount = toDay[@"toDayUnBeginMeetCount"];

    CGMeetingStatistics *s = [CGMeetingStatistics new];
    s.otherCount = otherCount.intValue;
    s.toDayMeetCount = toDayMeetCount.intValue;
    s.toDayUnBeginMeetCount = toDayUnBeginMeetCount.intValue;
    s.tomorrowMeetCount = tomorrowMeetCount.intValue;
    s.weekMeetCount = weekMeetCount.intValue;
    return s;
}

@end

