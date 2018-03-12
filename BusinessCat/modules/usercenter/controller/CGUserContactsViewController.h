//
//  CGUserContactsViewController.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGSearchBar.h"
#import "CGUserCompanyContactsEntity.h"

@interface CGUserContactsViewController : CTBaseViewController
@property(nonatomic,retain)UIButton *rightBtn;
@property (strong, nonatomic) CGSearchBar *searchBar;
-(instancetype)initWithOrganiza:(CGUserOrganizaJoinEntity *)organiza;
-(void)refresh;

// 用于子类修改，比如加个底部栏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint; // 默认是 0

// 用于子类访问
- (CGUserCompanyContactsEntity *)contactAtIndexPath:(NSIndexPath *)indexPath;

@end
