//
//  YCMeetingRoomMembersController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CGMeeting.h"

@interface YCMeetingRoomMembersController : UIViewController

// 会议主持人要放在第一个
@property (nonatomic,strong) NSArray<YCMeetingUser *> *users;
@property (nonatomic,strong) NSString *meetingCreatorID;// 主持人 id ，申请互动用到
@property (nonatomic,assign) BOOL isMeetingCreator; // 当前用户是否主持人

@end
