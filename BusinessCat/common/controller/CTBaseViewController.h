//
//  CTBaseViewController.h
//  VieProd
//
//  Created by Calon Mo on 16/3/23.
//  Copyright © 2016年 VieProd. All rights reserved.
//  默认不使用UINavigationController的导航栏

#import <UIKit/UIKit.h>

@interface CTBaseViewController : UIViewController

@property(nonatomic,retain)UIButton *backBtn;
@property(nonatomic,retain)UIView *navi;
@property(nonatomic,retain)UILabel *titleView;

@property(nonatomic,weak)IBOutlet UITableView *tableview;

//显示带logo的topbar
-(void)showTopbarWithLogo:(NSString *)title desc:(NSString *)desc;

//隐藏自定义导航栏
-(void)hideCustomNavi;
//显示自定义导航栏
-(void)showTheCustomNavi;
//隐藏自定义返回按钮
-(void)hideCustomBackBtn;

-(void)baseBackAction;

@end
