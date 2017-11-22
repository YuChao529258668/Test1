//
//  YCBookMeetingController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"
#import "CGMeeting.h"

@interface YCBookMeetingController : YCBaseViewController

@property (nonatomic,strong) CGMeeting *meeting;

// 创建、预览、修改
@property (nonatomic,assign) BOOL isUseAsCreate;
@property (nonatomic,assign) BOOL isUseAsPreview;
@property (nonatomic,assign) BOOL isUseAsModify;

@end
