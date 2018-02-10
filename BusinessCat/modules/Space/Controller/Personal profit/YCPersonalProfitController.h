//
//  YCPersonalProfitController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/31.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCPersonalProfitController : UIViewController
@property (nonatomic, assign) int type;// 0 公司，1 个人
@property (nonatomic, strong) NSString *companyID;
@property (nonatomic, assign) BOOL shouldHideNavigationBar;

- (void)reloadDataWithCompanyID:(NSString *)cid;
@end
