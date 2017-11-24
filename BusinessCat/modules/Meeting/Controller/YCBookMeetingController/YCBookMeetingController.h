//
//  YCBookMeetingController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"
#import "CGMeeting.h"

typedef NS_ENUM(NSUInteger, YCBookMeetingControllerStyle) {
    YCBookMeetingControllerStyleCreate,
    YCBookMeetingControllerStyleModify,
    YCBookMeetingControllerStylePreview,
    YCBookMeetingControllerStyleReopen,
};

@interface YCBookMeetingController : YCBaseViewController

@property (nonatomic,strong) CGMeeting *meeting;

// 创建、预览、修改、再次召开
@property (nonatomic,assign) YCBookMeetingControllerStyle style;

@end
