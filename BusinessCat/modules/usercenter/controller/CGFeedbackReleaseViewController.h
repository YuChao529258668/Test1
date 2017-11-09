//
//  CGFeedbackReleaseViewController.h
//  CGSays
//
//  Created by zhu on 2017/4/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGDiscoverLink.h"
typedef void (^CGFeedbackReleaseSuccessBlock)(NSString *success);
@interface CGFeedbackReleaseViewController : CTBaseViewController
@property (nonatomic, retain) CGDiscoverLink *link;
-(instancetype)initWithBlock:(CGFeedbackReleaseSuccessBlock)success;
@property (nonatomic, assign) NSInteger level;
@end
