//
//  CGInviteMembersViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

//#import "CTBaseViewController.h"
#import <UIKit/UIKit.h>

//@interface YCAllShareProfitController : CTBaseViewController
@interface YCAllShareProfitController : UIViewController
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *companyID;
@property (nonatomic,copy) void (^onJoinSuccessBlock)();

@end
