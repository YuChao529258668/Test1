//
//  YCMeetingRoom.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCMeetingRoom;

@interface YCMeetingCompanyRoom : NSObject
// dic: id, name, roomData, type
@property (nonatomic, strong) NSArray<YCMeetingRoom *> *roomData;
+ (NSDictionary *)mj_objectClassInArray;

@property (nonatomic, assign) int type;//类型 1为公司 2为用户
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) NSString *id;

//        {
//            id = "8f82d6d5-e8ed-4c14-b3a9-f808370da47a";
//            name = "\U751f\U610f\U732b";
//            roomData =     (
//                            {
//                                costVideo = 0;
//                                costVoice = 0;
//                                msg = "\U6240\U9009\U65f6\U95f4\U6bb5\U7a7a\U95f2\U53ef\U7528";
//                                roomId = "416802dd-a0a8-45a0-9c2f-7454fdwghe4e";
//                                roomName = "8\U53f7\U4f1a\U8bae\U5ba4";
//                                state = 1;
//                            },
//                            {
//                                costVideo = 0;
//                                costVoice = 0;
//                                msg = "\U6240\U9009\U65f6\U95f4\U6bb5\U7a7a\U95f2\U53ef\U7528";
//                                roomId = "416802dd-a0a8-45a0-9c2f-75ae9f9c63c6";
//                                roomName = "4\U53f7\U4f1a\U8bae\U5ba4";
//                                state = 1;
//                            }
//                            );
//            type = 1;
//        }

@end


@interface YCMeetingRoom : NSObject

@property (nonatomic,assign) float costvideo;
@property (nonatomic,assign) float costvoice;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic,strong) NSString *roomId;
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,assign) int state; // 可用状态 0不可用 1可用

// 非后台直接返回的。
@property (nonatomic, assign) int type;//类型 1为公司 2为用户

//@property (nonatomic,assign) int commonality; // 是否公共 1是0否
//@property (nonatomic,strong) NSString *companyid;
////@property (nonatomic,strong) NSString *createtime;
//@property (nonatomic,strong) NSString *freetime; // 可用时长，分钟
//@property (nonatomic,assign) int roomDefault;
//@property (nonatomic,strong) NSString *roomHint;
@property (nonatomic,assign) int roomcharge; // 费用(0免费1付费2包月)
//@property (nonatomic,assign) int roomnum;//可用人数
//@property (nonatomic,assign) NSTimeInterval timeb;
//@property (nonatomic,assign) NSTimeInterval timee;


//- (float)videoRoomPrice;
//// 免费/包月会议室时：直接显示为免费
//- (float)voiceRoomPrice;

@end


#pragma mark -

@interface YCAvailableMeetingTime : NSObject

@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSString *timeB;
@property (nonatomic,strong) NSString *timeE;

//+ (NSArray *)timesWithKeyValues:(NSArray<NSDictionary *> *)array;

@end


#pragma mark -

@interface YCAvailableMeetingTimeList : NSObject

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSArray<YCAvailableMeetingTime *> *result;

+ (NSDictionary *)mj_objectClassInArray;

@end

