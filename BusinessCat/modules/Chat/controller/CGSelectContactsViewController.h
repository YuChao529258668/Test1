//
//  CGSelectContactsViewController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/4.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserContactsViewController.h"

@interface CGSelectContactsViewController : CGUserContactsViewController

// 显示在导航栏
@property (nonatomic,copy) NSString *titleForBar;

@property (nonatomic,copy) void (^completeBtnClickBlock)(NSMutableArray<CGUserCompanyContactsEntity *> *contacts);

@end
