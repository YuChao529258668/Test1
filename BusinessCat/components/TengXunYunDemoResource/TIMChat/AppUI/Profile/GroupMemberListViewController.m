//
//  GroupMemberListViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupMemberListViewController.h"

@implementation GroupMemberListViewController

- (BOOL)canAddRightBarItem
{
    BOOL noCanAdd = [_group isChatRoom] | [_group isPublicGroup];//聊天室和公开群不能邀请好友
    if (noCanAdd)
    {
        return NO;
    }
    return [_group isCreatedByMe] || [_group isManagedByMe];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCustomNavi];
    [self createBackBtn];
}

#pragma mark - 适配旧代码

-(void)createCustomNavi{
    self.titleStr = @"群成员";
    
    if(!self.navi){
        self.navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPBARHEIGHT)];
        self.navi.backgroundColor = CTThemeMainColor;
        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(TOPBARCONTENTHEIGHT+5, CTMarginTop, SCREEN_WIDTH-2*(TOPBARCONTENTHEIGHT+5), TOPBARCONTENTHEIGHT)];
        self.titleView.backgroundColor = [UIColor clearColor];
        self.titleView.textColor = [UIColor blackColor];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        self.titleView.font = [UIFont systemFontOfSize:18];
        [self.navi addSubview:self.titleView];
    }
    self.titleView.text = self.titleStr;
    [self.view addSubview:self.navi];
    
}

- (void)createBackBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    headline_delete_confirm_center_back
    //    headline_detail_back
    UIImage *image = [UIImage imageNamed:@"headline_detail_back"];
    image = [image imageWithTintColor:[UIColor whiteColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [self.navi addSubview:btn];
    btn.frame = CGRectMake(5, 20, 44, 44);
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.tintColor = [UIColor whiteColor];
}
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutTableView {
    float y = TOPBARHEIGHT; // 自定义导航栏高度
    float height = [UIScreen mainScreen].bounds.size.height - y;
    CGRect rect = self.tableView.frame;
    rect.size.height = height;
    rect.origin.y = y;
    self.tableView.frame = rect;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTableView];
}

#pragma mark -

@end
