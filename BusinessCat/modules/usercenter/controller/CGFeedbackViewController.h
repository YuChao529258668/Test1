//
//  CGFeedbackViewController.h
//  CGSays
//
//  Created by zhu on 2017/4/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGFeedbackViewController : CTBaseViewController
@property (nonatomic, assign) int type;//0个人 1企业
-(void)refresh;
@end
