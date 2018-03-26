//
//  YCSelectMeetingFileController.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGInfoHeadEntity.h"

@interface YCSelectMeetingFileController : CTBaseViewController

// fileType: 0 文件，1 素材
@property (nonatomic,copy) void (^didSelectBlock)(CGInfoHeadEntity *entity, int fileType);
@property (nonatomic,strong) NSString *meetingID;

@property (nonatomic, assign) BOOL useForChatControllerSeeFile;

@end
