//
//  YCSeeBoard.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSeeBoard.h"

@implementation YCSeeBoard
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"shareProfit": [BoardProfit class]};
}

@end


@implementation NowMonthMeeting
- (int)toDayMeetCount {
    return ((NSNumber *)self.toDay[@"toDayMeetCount"]).intValue;
}
- (int)toDayUnBeginMeetCount {
    return ((NSNumber *)self.toDay[@"toDayUnBeginMeetCount"]).intValue;
}
@end

@implementation NowMonthStatistics
@end

@implementation BoardProfit
@end

