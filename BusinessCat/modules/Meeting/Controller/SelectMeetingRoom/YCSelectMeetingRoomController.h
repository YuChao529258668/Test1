//
//  YCSelectMeetingRoomController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"

#import "YCMeetingRoom.h"

@interface YCSelectMeetingRoomController : YCBaseViewController

//@property (nonatomic,strong) NSArray *companyRooms;
//@property (nonatomic,strong) NSArray *otherRooms;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) YCMeetingRoom *selectedRoom;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic,copy) void (^didSelectRoom)(YCMeetingRoom *room);// 废弃
@property (nonatomic,copy) void (^didSelectBlock)(YCMeetingRoom *room, BOOL isVideo, NSInteger count);

@property (nonatomic, assign) BOOL onlyVideoRoom;// 只有视频会议屎

@end
