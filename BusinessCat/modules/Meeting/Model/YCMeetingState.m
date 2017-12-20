//
//  YCMeetingState.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingState.h"

@implementation YCMeetingState

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"meetingUserList": [YCMeetingUser class]};
}

@end
