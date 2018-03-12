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
