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

// 返回 YES 表示要 dismiss 该控制器
@property (nonatomic,copy) BOOL (^completeBtnClickBlock)(NSMutableArray<CGUserCompanyContactsEntity *> *contacts);

@end
