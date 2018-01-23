//
//  YCMeetingRoom.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingRoom.h"

@implementation YCMeetingCompanyRoom
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roomData": [YCMeetingRoom class]};
}

- (void)setRoomData:(NSArray<YCMeetingRoom *> *)roomData {
    _roomData = roomData;
    if (self.type ==1) {
        for (YCMeetingRoom *room in roomData) {
            room.type = self.type;
        }
    }
}

- (void)setType:(int)type {
    _type = type;
    if (self.roomData && type == 1) {
        for (YCMeetingRoom *room in self.roomData) {
            room.type = self.type;
        }

    }
}
@end


@implementation YCMeetingRoom

//
////收费会议室：按会议类型+参会人数+时长进行计算费用
//// 免费/包月会议室时：直接显示为免费
//- (float)videoRoomPrice {
//    if (self.roomcharge == 0 || self.roomcharge == 2) {
//        return 0;
//    }
//    return self.costvideo * self.roomnum;
//}
//
//// 免费/包月会议室时：直接显示为免费
//- (float)voiceRoomPrice {
//    if (self.roomcharge == 0 || self.roomcharge == 2) {
//        return 0;
//    }
//    return self.costvoice * self.roomnum;
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


