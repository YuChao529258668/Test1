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

- (NSString *)caculateMeetingCostStr {
    float cost = self.attendance * self.meetingCost;
    return [NSString stringWithFormat:@"%f", cost];
}

@end
