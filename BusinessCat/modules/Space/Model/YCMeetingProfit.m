//
//  YCMeetingProfit.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/31.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingProfit.h"

@implementation YCMeetingProfit
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"shareProfit": [YCOneMeetingProfit class], @"meetingRecordList": [YCMeetingRecord class]};
}
@end


@implementation YCMeetingRecord
- (void)setState:(int)state {
    _state = state;
    //0已结算 1未结算 2已取消
    if (state == 2) {
        _stateString = @"已取消";
        _stateColor = [YCTool colorOfHex:0x777777];
    } else {
        _stateString = (state == 0)? @"已结算": @"未结算";
        _stateColor = (state == 0)? [YCTool colorOfHex:0x128bed]: [YCTool colorOfHex:0xffcc00];
    }
}
- (void)setCreateTime:(NSTimeInterval)createTime {
    _createTime = createTime;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime / 1000];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd HH:mm";
    _dateString = [f stringFromDate:date];
}
- (void)setMeetingDuration:(int)meetingDuration {
    _meetingDuration = meetingDuration;
    
    _durationString = [YCTool HMStringForSeconds:meetingDuration * 60];
}
@end


@implementation YCOneMeetingProfit
@end
