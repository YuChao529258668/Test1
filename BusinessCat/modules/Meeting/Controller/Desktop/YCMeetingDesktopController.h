//
//  YCMeetingDesktopController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/4.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMeeting.h"

@interface YCMeetingDesktopController : UIViewController
@property (nonatomic,strong) CGMeeting *meeting;

@property (nonatomic,assign) ZUINT confID; //底层 API 会用到，和 conferenceNumber 不同

@end
