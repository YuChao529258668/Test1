//
//  MyProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/24.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MyProfileViewController.h"

@implementation MyProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的资料";
    
    //注：设置头像的功能，demo暂不支持，后期也还没有计划支持。SDK中设置头像功能接口 SetFaceURL 是可以用的
    
    [self createCustomNavi];
    [self createBackBtn];

}

- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    __weak MyProfileViewController *ws = self;
    RichCellMenuItem *uid = [[RichCellMenuItem alloc] initWith:@"帐号ID" value:[_user userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *remark = [[RichCellMenuItem alloc] initWith:@"昵称" value:[_user showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    }];

    [_dataDictionary setObject:@[uid, remark] forKey:@(0)];
}

- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAUser *wu = _user;
    __weak MyProfileViewController *ws = self;
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:@"修改昵称" text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            NSInteger length = [editText utf8Length];
            NSLog(@"%ld",length);
            [[IMAPlatform sharedInstance].host asyncSetNickname:editText succ:^{
                [[HUDHelper sharedInstance] tipMessage:@"修改成功"];
                [wu setRemark:editText];
                menu.value = editText;
                
                UserProfileHeaderView *info = (UserProfileHeaderView *) ws.tableView.tableHeaderView;
                [info configWith:wu];
                
                [(RichMenuTableViewCell *)cell configWith:menu];
            } fail:nil];
            
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 适配旧代码

-(void)createCustomNavi{
    self.titleStr = @"我的信息";
    
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
    self.titleView.text = _titleStr;
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
