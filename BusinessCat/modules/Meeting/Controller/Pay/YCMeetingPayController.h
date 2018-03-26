//
//  YCMeetingPayController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/24.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMeetingRebate.h"


@interface YCMeetingPayController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSInteger count;// 4 8 16
@property (nonatomic, assign) BOOL isVideo;// 会议类型

@property (nonatomic, copy) NSString *durationString;
@property (nonatomic, assign) long durationMinute;// 会议时长，分钟

@property (nonatomic,copy) void (^onClickPayBtnBlock)(YCMeetingRebate *rebate);

- (void)enablePayButton;

@end
