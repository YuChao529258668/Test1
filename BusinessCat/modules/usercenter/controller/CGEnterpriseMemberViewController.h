//
//  CGEnterpriseMemberViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGEnterpriseMemberViewController : CTBaseViewController
@property (nonatomic, assign) int type;//0会员 1企业
@property (nonatomic, copy) NSString *companyID;
@end
