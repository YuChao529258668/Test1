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

@property (nonatomic,strong) NSArray *companyRooms;
@property (nonatomic,strong) NSArray *otherRooms;

@property (nonatomic,copy) void (^didSelectRoom)(YCMeetingRoom *room);

@end
