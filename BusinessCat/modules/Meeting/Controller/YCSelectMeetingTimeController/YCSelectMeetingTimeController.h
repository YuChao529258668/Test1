//
//  YCSelectMeetingTimeController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"
#import "YCMeetingRoom.h"

@interface YCSelectMeetingTimeController : YCBaseViewController

@property (nonatomic,strong) YCMeetingRoom *room;

@property (nonatomic,copy) void (^didSelectTime)(YCAvailableMeetingTime *time);

@end
