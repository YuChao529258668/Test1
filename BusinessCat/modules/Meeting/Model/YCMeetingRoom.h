//
//  YCMeetingRoom.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCMeetingRoom;
@class YCMeetingOccupyTime;


@interface YCMeetingCompanyRoom : NSObject
// dic: id, name, roomData, type
@property (nonatomic, strong) NSArray<YCMeetingRoom *> *roomData;
+ (NSDictionary *)mj_objectClassInArray;

@property (nonatomic, assign) int type;//类型 1为公司 2为用户
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int isAddress; // 是否会议地址

@property (nonatomic, strong) NSString *id; // 公司或个人 id

@end




#pragma mark -

@interface YCMeetingRoom : NSObject

@property (nonatomic,assign) float costvideo;
@property (nonatomic,assign) float costvoice;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic,strong) NSString *roomId;
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,assign) int state; // 可用状态 0不可用 1可用
@property (nonatomic, assign) int roomNum;

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


@property (nonatomic, assign) BOOL isFull;// 预订时间满了
@property (nonatomic, strong) NSArray<YCMeetingOccupyTime *> *meetingTimeList; // 占用时间段
+ (NSDictionary *)mj_objectClassInArray;

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


#pragma mark -

// 会议时占用时间
@interface YCMeetingOccupyTime : NSObject
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;

@property (nonatomic, assign) NSInteger startHour;
@property (nonatomic, assign) NSInteger startM;
@property (nonatomic, assign) NSInteger endHour;
@property (nonatomic, assign) NSInteger endM; // 注意，会 -1秒
@end


