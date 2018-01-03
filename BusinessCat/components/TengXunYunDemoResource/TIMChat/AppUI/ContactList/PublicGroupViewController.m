//
//  PublicGroupViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "PublicGroupViewController.h"
#import "CGSelectContactsViewController.h"
#import "CGUserCompanyContactsEntity.h"

@interface PublicGroupViewController()
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;
@property(nonatomic, strong)NSString *titleStr;

@end

@implementation PublicGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCustomNavi];
    [self createBackBtn];
    [self setupCreateGroupChatBtn];
}

#pragma mark - 适配旧代码

-(void)createCustomNavi{
    self.titleStr = @"群聊";
    
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
    image = [image imageWithTintColor:[UIColor blackColor]];
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


- (void)addRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
    self.title = @"公开群";
}


- (void)onClickRightItem
{
    NewPublicGroupViewController *vc = [[NewPublicGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)configOwnViews
{
    //调试手动设置管理员
//    [[IMAPlatform sharedInstance].groupAssistant ModifyGroupMemberInfoSetRole:@"@TGS#2ZHYURAEJ" user:@"wilderdev0" role:TIM_GROUP_MEMBER_ROLE_ADMIN succ:^{
//        NSLog(@"succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"fail");
//    }];
    
     _groupDictionary = [[IMAPlatform sharedInstance].contactMgr publicGroups];
}

- (void)addSearchController
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groupDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[section];
    NSArray *groups = _groupDictionary[key];
    return groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"TextTableViewHeaderFooterView";
    TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    
    headerView.tipLabel.text = array[section];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    if (!cell)
    {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    id<IMAGroupShowAble> chat = [groups objectAtIndex:indexPath.row];
    [cell configWith:chat];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    IMAUser *group = [groups objectAtIndex:indexPath.row];
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:group];
    
}

#pragma mark - 创建群聊

- (void)setupCreateGroupChatBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = SCREEN_WIDTH - (44 + 6);
    float y = CTMarginTop;
    //    float x = SCREEN_WIDTH - (44 + 10)/2;
    //    float y = self.titleView.center.y;
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    //    btn.center = CGPointMake(x, y);
    [btn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(createGroupChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createGroupChatBtnClick {
    __weak typeof(self) ws = self;
    
    CGSelectContactsViewController *vc = [[CGSelectContactsViewController alloc]init];
    vc.titleForBar = @"创建群聊";
    vc.completeBtnClickBlock = ^(NSMutableArray<CGUserCompanyContactsEntity *> *contacts) {
        [ws createGroupChatWithContacts:contacts];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 创建群名
- (NSString *)createGroupNameWithContacts:(NSMutableArray<CGUserCompanyContactsEntity *> *)contacts {
    
    NSString *name = [ObjectShareTool sharedInstance].currentUser.username;
    NSInteger count = contacts.count;
    count = count > 3? 3: count;
    
    for (int i = 0; i < count; i++) {
        name = [name stringByAppendingString:@"、"];
        name = [name stringByAppendingString:contacts[i].userName];
    }
    name = [name stringByAppendingString:[NSString stringWithFormat:@"(%@人)", @(count + 1)]];
    
    return name;
}

// 创建公开群
- (void)createGroupChatWithContacts:(NSMutableArray<CGUserCompanyContactsEntity *> *)contacts {
    NSString *groupName = [self createGroupNameWithContacts:contacts];
    NSArray *members = [self createIMAUsersWithContacts:contacts];
    __weak typeof(self) ws = self;
    
    [[IMAPlatform sharedInstance].contactMgr asyncCreatePublicGroupWith:groupName members:members succ:^(IMAGroup *group){
        [[HUDHelper sharedInstance] tipMessage:@"创建公开群成功"];
        [ws onCreateGroupSucc:group];
    } fail:nil];
}

// 创建成功时被调用
- (void)onCreateGroupSucc:(IMAGroup *)group
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate pushToChatViewControllerWith:group];
}

// 模型转换
- (NSMutableArray *)createIMAUsersWithContacts:(NSMutableArray<CGUserCompanyContactsEntity *> *)contacts {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:contacts.count];
    for (CGUserCompanyContactsEntity *contact in contacts) {
        IMAUser *user = [[IMAUser alloc]init];
        user.userId = contact.userId;
        user.icon = contact.userIcon;
        user.nickName = contact.userName;
        user.remark = contact.userName;
        [users addObject:user];
    }
    return users;
}



@end
