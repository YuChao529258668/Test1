//
//  CGUserChoseCompanyViewController.h
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserSearchViewController.h"
#import "CGUserorganizaApplyEntity.h"

@interface CGUserChoseCompanyViewController : CTBaseViewController
@property (nonatomic, assign) UserChoseOrganizeType choseType;
@property (nonatomic, strong) CGUserorganizaApplyEntity *info;
@end
