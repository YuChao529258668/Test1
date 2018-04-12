//
//  YCMeetingRoom.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingRoom.h"



@implementation YCMeetingOccupyTime

- (void)setStartTime:(long)startTime {
    _startTime = startTime/1000.0;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_startTime];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"HH";
    self.startHour = [f stringFromDate:date].integerValue;
    f.dateFormat = @"mm";
    self.startM = [f stringFromDate:date].integerValue;
}

- (void)setEndTime:(long)endTime {
//    _endTime = endTime/1000.0;
    _endTime = endTime/1000.0 - 1;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_endTime];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"HH";
    self.endHour = [f stringFromDate:date].integerValue;
    f.dateFormat = @"mm";
    self.endM = [f stringFromDate:date].integerValue;
}

@end


#pragma mark -

@implementation YCMeetingCompanyRoom
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roomData": [YCMeetingRoom class]};
}

- (void)setRoomData:(NSArray<YCMeetingRoom *> *)roomData {
    _roomData = roomData;
    if (self.type ==1) {
        for (YCMeetingRoom *room in roomData) {
            room.type = self.type;
            room.isAddress = self.isAddress;
            room.companyRoom = self;
        }
    }
}

- (void)setType:(int)type {
    _type = type;
    if (self.roomData && type == 1) {
        for (YCMeetingRoom *room in self.roomData) {
            room.type = self.type;
            room.isAddress = self.isAddress;
            room.companyRoom = self;

        }

    }
}
@end


#pragma mark -

@implementation YCMeetingRoom

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"meetingTimeList": [YCMeetingOccupyTime class]};
}

//
//- (void)setMeetingTimeList:(NSArray<YCMeetingOccupyTime *> *)meetingTimeList {
//    _meetingTimeList = meetingTimeList;
//
//    BOOL full = YES;
//
//    long total = 0;
//
//    for (YCMeetingOccupyTime *time in meetingTimeList) {
//        total += time.endTime - time.startTime;
//    }
//
//    long secondsOneDay = 24 * 60 *60;
//
//    if (total >= secondsOneDay - 1) {
//        full = YES;
//    }
//    
//    self.isFullTime = full;
//
//}


@end


#pragma mark -

@implementation YCAvailableMeetingTime

//+ (NSArray *)timesWithKeyValues:(NSArray<NSDictionary *> *)array {
//    NSMutableArray *times = [NSMutableArray arrayWithCapacity:array.count];
//
//    for (NSDictionary *dic in array) {
//        YCAvailableMeetingTime *time = [YCAvailableMeetingTime new];
//        time.dateStr = dic[@"date"];
//
//        NSArray *result = dic[@"result"];
//        for (NSDictionary *d in result) {
//            time.info = d[@"info"];
//            time.timeB = d[@"timeB"];
//            time.timeE = d[@"timeE"];
//        }
//        [times addObject:time];
//    }
//    return times;
//}


@end


#pragma mark -

@implementation YCAvailableMeetingTimeList

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"result": [YCAvailableMeetingTime class]};
}

// json 数据
//date = 23;
//result =     (
//              {
//                  info = "08:38-23:59";
//                  timeB = "08:38";
//                  timeE = "23:59";
//              }
//              );

@end





