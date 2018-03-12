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

// 最大选择数
@property (nonatomic,assign) NSUInteger maxSelectCount;

// 用于第一次显示时，判断哪些联系人要打钩，不作为最后的选择结果
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contacts;

@property (nonatomic,copy) void (^completeBtnClickBlock)(NSMutableArray<CGUserCompanyContactsEntity *> *contacts);

@end


@interface CGSelectContactsViewControllerCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end
