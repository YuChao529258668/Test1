//
//  CGMeeting.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeeting.h"

@implementation YCMeetingUser

@end


@implementation CGMeeting

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"meetingUserList": [YCMeetingUser class]};
}

- (NSString *)meetingCreator {
    for (YCMeetingUser *user in self.meetingUserList) {
        if (user.compere) {
            return user.userid;
        }
    }
    return nil;
}

- (NSString *)meetingCreatorName {
    for (YCMeetingUser *user in self.meetingUserList) {
        if (user.compere) {
            return user.userName;
        }
    }
    return nil;
}

- (float)calculateMeetingCost {
//    int minute = (self.endTime.doubleValue/1000 - self.startTime.doubleValue/1000)/60;
//    return self.meetingCost * minute * self.meetingUserList.count;
    
    return self.meetingCost * self.meetingDuration.intValue * self.attendance;

}

- (void)setMeetingUserList:(NSMutableArray<YCMeetingUser *> *)meetingUserList {
    _meetingUserList = meetingUserList;
    
    [_meetingUserList enumerateObjectsUsingBlock:^(YCMeetingUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.compere) {
            [_meetingUserList exchangeObjectAtIndex:0 withObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}


@end
