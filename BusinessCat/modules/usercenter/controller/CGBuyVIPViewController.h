//
//  CGBuyVIPViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGBuyVIPViewController : CTBaseViewController
@property (nonatomic, assign) NSInteger type;//0购买会员 1购买企业会员 4知识分套餐 5下载套餐
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *gradeID;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, assign) NSInteger companyType;

@property (nonatomic, assign) BOOL onlyWXPay;

@end
