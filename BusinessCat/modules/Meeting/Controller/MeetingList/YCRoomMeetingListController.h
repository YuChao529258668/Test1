//
//  YCRoomMeetingListController.h
//  BusinessCat
//
//  Created by 余超 on 2018/4/8.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseViewController.h"
#import "YCMeetingRoom.h"

@interface YCRoomMeetingListController : CTBaseViewController
@property (nonatomic, strong) YCMeetingRoom *room;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic,copy) void (^roomDidUpdateBlock)(YCMeetingRoom *room);

@end
