//
//  CGChatListViewController.m
//  CGKnowledge
//
//  Created by 余超 on 2017/10/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChatListViewController.h"
#import "CGDiscoverPartSeeAddressViewController.h" // 选择部分联系人
#import "CGUserContactsViewController.h" // 通讯录
#import "CGSelectContactsViewController.h" // 选择通讯录
#import "YCMultiCallHelper.h"
#import "CGUserCenterBiz.h"
#import "CGMessageDetailViewController.h"
#import "CGDiscoverBiz.h"

#import "RoomViewController.h"
#import "YCChatListMenu.h"
#import "YCCreateMeetingController.h"
#import "CGMainLoginViewController.h"
#import "CGUserContactsViewController.h"

#import "CGEnterpriseMemberViewController.h"
#import "CGUserFireViewController.h"
#import "YCPersonalProfitController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGUserHelpViewController.h"


// 生意猫
#define kTLSAppid       @"1400047877"
#define kSdkAppId       @"1400047877"
#define kSdkAccountType @"18686"

#import "YCUserTaskView.h"

#import <ImSDK/ImSDK.h>

//@interface CGChatListViewController ()<TLSRefreshTicketListener>
//{
//    //微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
//    //    __weak id<WXApiDelegate>    _tlsuiwx;
//    //    TencentOAuth                *_openQQ;
//    IMALoginParam               *_loginParam;
//}

@interface CGChatListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;
@property (nonatomic,strong) IMALoginParam *loginParam;

@property(nonatomic,retain)UILabel *systemRedHot;//消息红点
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic, strong) YCChatListMenu *menu;
@property (nonatomic, strong) IMAConversation *appMessage;

@property (nonatomic, strong) YCUserTaskView *taskView;
@property (nonatomic, strong) NSMutableArray<YCUserTask *> *tasks;

@end


@implementation CGChatListViewController

- (void)dealloc {
    [self removeObserverForLoginLogout];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationSystemMessageRedHot object:nil];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self addObserverForLoginLogout];
//    [self onViewDidLoad];
    [self loginTengXunYun];
    
    [self createCustomNavi];
//    [self setupCreateGroupChatBtn];
    
//    [self setupMessageBtn];
    
//    [self setupHeaderView];
//    [self setupCallVideoBtn];
//    [self setupCallBtn];
    [self setupMenuBtn];
    [self setupAddressBookBtn];
//    [self addAppMessage];
    
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        [self getUserTask];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pinHeaderView];
//    [self configOwnViews];
    
//    [self editMultiCallViewController];

    
    //    [[TIMGroupManager sharedInstance]getGroupList:^(NSArray *arr) {
    //        for (IMAGroup *group in arr) {
    //                    NSLog(@"%@, group  = %@", NSStringFromSelector(_cmd), group);
    //        }
    //    } fail:^(int code, NSString *msg) {
    //
    //    }];
    //
    
    //    Thread 1: EXC_BAD_ACCESS (code=1, address=0x0)
    //    [[TIMGroupManager sharedInstance] getGroupList:^(NSArray * list) {
    //        for (TIMGroupInfo * info in list) {
    //            NSLog(@"group=%@ type=%@ name=%@", info.group, info.groupType, info.groupName);
    //        }
    //    } fail:^(int code, NSString* err) {
    //        NSLog(@"failed code: %d %@", code, err);
    //    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self layoutTableView]; // 不能删
    
    // 设置为 nil，释放资源
//    [self editMultiCallViewController];
    
//    NSArray *a = _conversationList.safeArray;
//    for (IMAConversation *obj in a) {
//        TIMMessage *message = obj.lastMessage.msg;
//        NSDate *date = message.timestamp;
//        NSLog(@"%@", date.description);
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self editMultiCallViewController];
}


#pragma mark - 创建群聊

- (void)setupCreateGroupChatBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    float x = SCREEN_WIDTH - (44 + 6);
//    float y = CTMarginTop;
    float x = 6;
    float y = CTMarginTop;

    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    [btn setTitle:@"群聊" forState: UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
    // 防止群名字过长，只把姓连起来
    
    NSRange range = NSMakeRange(0, 1);
    NSString *firstName; // 姓
    
    NSString *name = [ObjectShareTool sharedInstance].currentUser.username;
    name = [name substringWithRange:range];
    
    NSInteger count = contacts.count;
    count = count > 3? 3: count;

    
    for (int i = 0; i < count; i++) {
        name = [name stringByAppendingString:@"、"];
        firstName = [contacts[i].userName substringWithRange:range];
        name = [name stringByAppendingString:firstName];
    }
    name = [name stringByAppendingString:[NSString stringWithFormat:@"(%@人)", @(count + 1)]];
//    NSLog(@"群名 = %@, %@", name, NSStringFromSelector(_cmd));

    return name;
}

// 创建公开群
- (void)createGroupChatWithContacts:(NSMutableArray<CGUserCompanyContactsEntity *> *)contacts {
    NSString *groupID = [NSString stringWithFormat:@"@%ld", (long)([NSDate date].timeIntervalSince1970*1000)];
    NSString *groupName = [self createGroupNameWithContacts:contacts];
    NSArray *members = [self createIMAUsersWithContacts:contacts];
    __weak typeof(self) ws = self;
    
    [[IMAPlatform sharedInstance].contactMgr asyncCreatePublicGroupWith:groupName members:members groupId:groupID succ:^(IMAGroup *group){
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
        NSLog(@"头像  = %@, %@",  contact.userIcon, NSStringFromSelector(_cmd));
        user.nickName = contact.userName;
        user.remark = contact.userName;
        [users addObject:user];
    }
    return users;
}


#pragma mark - 适配旧代码

- (void)layoutTableView {
    CGRect taskFrame = self.taskView.frame;
    taskFrame.origin.y = TOPBARHEIGHT;
    taskFrame.size.width = self.view.frame.size.width;
    taskFrame.size.height = [YCUserTaskView height];
    self.taskView.frame = taskFrame;
    
//    float y = TOPBARHEIGHT;
//    y += 56;// 搜索栏高度
    float y = TOPBARHEIGHT + [YCUserTaskView height];
    if (self.tasks.count == 0) {
        y = TOPBARHEIGHT;
    }
//    y = 300;
    
    //    float bottomBarH = [((AppDelegate *)[UIApplication sharedApplication].delegate) bottomBarHeight];
    //    float height = self.tableView.frame.size.height - y;
    //    float height = SCREEN_HEIGHT - y - bottomBarH;
    float height = self.view.frame.size.height - y; // 自己 view 的高度由 tab controller 决定
    CGRect rect = self.tableView.frame;
    rect.size.height = height;
    rect.origin.y = y;
    self.tableView.frame = rect;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutTableView];

}
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self layoutTableView];
//}


-(void)createCustomNavi{
    self.titleStr = @"消息";
    
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

- (void)tokenCheckComplete:(BOOL)state {
    
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict {
    
}

//-(void)createCustomNavi{
////    if(_showCustomNavi){
//        if(!self.navi){
//            self.navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPBARHEIGHT)];
//            self.navi.backgroundColor = CTThemeMainColor;
//            self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(TOPBARCONTENTHEIGHT+5, CTMarginTop, SCREEN_WIDTH-2*(TOPBARCONTENTHEIGHT+5), TOPBARCONTENTHEIGHT)];
//            self.titleView.backgroundColor = [UIColor clearColor];
//            self.titleView.textColor = [UIColor blackColor];
//            self.titleView.textAlignment = NSTextAlignmentCenter;
//            self.titleView.font = [UIFont systemFontOfSize:18];
//            [self.navi addSubview:self.titleView];
//        }
//        self.titleView.text = _titleStr;
//        [self.view addSubview:self.navi];
//}

//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//}



#pragma mark - 登录注销通知

- (void)addObserverForLoginLogout {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccessNotification) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutSuccessNotification) name:NOTIFICATION_LOGOUT object:nil];
}

- (void)handleLoginSuccessNotification {
//    [self onViewDidLoad]; // 腾讯云登录
    [self loginTengXunYun]; // 腾讯云登录
    [self getUserTask];

//    [self addAppMessage];
}

- (void)handleLogoutSuccessNotification {
//    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
//            [[AppDelegate sharedAppDelegate] enterLoginUI];
//            [self configOwnViews];
//        }];
        [[AppDelegate sharedAppDelegate] enterLoginUI];
//        [self configOwnViews];
        _conversationList = nil;
        [self.tableView reloadData];
        
//        [self deleteAppMessage];
        self.appMessage = nil;
        
    } fail:^(int code, NSString *err) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
    }];
    
}

- (void)removeObserverForLoginLogout {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGOUT object:nil];
}


#pragma mark - 腾讯云登录

- (void)loginTengXunYun {
    // 如果用户没有登录，跳过腾讯云登录
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
        return;
    }
    
    _loginParam = [[IMALoginParam alloc] init];
    [IMAPlatform configWith:_loginParam.config];
    
    CGUserEntity *currentUser = [[ObjectShareTool sharedInstance] currentUser];
    
    //    TLSUserInfo *userinfo = [TLSUserInfo new];
    //    userinfo.accountType = 0;
    //    userinfo.identifier = currentUser.txyIdentifier;
    
    _loginParam.identifier = currentUser.txyIdentifier;
    _loginParam.userSig = currentUser.txyUsersig;
    _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
    
    __weak typeof(self) weakself = self;
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [weakself registNotification];
        [weakself onLoginTengXunYunSuccess];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
            [CTToast showWithText:[NSString stringWithFormat:@"聊天功能登录失败 : %@", msg]];
        }];
    }];
}

- (void)onLoginTengXunYunSuccess {
    // 复制 函数 enterMainUI 的代码
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
    
    // 拉取会话列表
    [self pinHeaderView];
    [self configOwnViews];
}


// 进行腾讯云登录
//- (void)onViewDidLoad {
//
//    // 如果用户没有登录，跳过腾讯云登录
//    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
//        return;
//    }
//
//
////    [WXApi registerApp:WX_APP_ID];
//
//    //demo暂不提供微博登录
//    //[WeiboSDK registerApp:WB_APPKEY];
//
//    // 因TLSSDK在IMSDK里面初始化，必须先初始化IMSDK，才能使用TLS登录
//    // 导致登出然后使用相同的帐号登录，config会清掉
//
//    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
//    if (isAutoLogin)
//    {
//        _loginParam = [IMALoginParam loadFromLocal];
//    }
//    else
//    {
//        _loginParam = [[IMALoginParam alloc] init];
//    }
//
//    [IMAPlatform configWith:_loginParam.config];
//
//    if (isAutoLogin && [_loginParam isVailed])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self autoLogin];
//        });
//    }
//    else
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self pullLoginUI];
//        });
//
//    }
//}

/**
 *  自动登录
 */
//- (void)autoLogin
//{
//    if ([_loginParam isExpired])
//    {
////        [[HUDHelper sharedInstance] syncLoading:@"刷新票据。。。"];
//        //刷新票据
//        int success = [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
//        // 0表示调用成功；其它表示调用失败
//        if (success != 0) {
////            [[HUDHelper sharedInstance] syncStopLoading];
////            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"刷新票据失败"];
////            NSLog(@"刷新票据失败");
//            [CTToast showWithText:@"聊天功能：刷新票据失败"];
//        }
//    }
//    else
//    {
//        [self loginIMSDK];
//    }
//}


/**
 *  登录IMSDK
 */
//- (void)loginIMSDK
//{
//    //直接登录
//    __weak CGChatListViewController *weakSelf = self;
////    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
//    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
////        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
//        [weakSelf registNotification];
//        [weakSelf enterMainUI];
//    } fail:^(int code, NSString *msg) {
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
////            [weakSelf pullLoginUI];
//            NSLog(@"腾讯云登录失败 %@, %@", msg, NSStringFromSelector(_cmd));
//            [CTToast showWithText:@"聊天功能登录失败"];
//        }];
//    }];
//}

//必须在登录之后上传token.在登录之后注册通知，保证通知回调也在登录之后，在通知的回调中上传的token。（回调在IMAAppDelegate的didRegisterForRemoteNotificationsWithDeviceToken中）
- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

// 登录成功之后调用
//- (void)enterMainUI
//{
//    //    _tlsuiwx = nil;
//    //    _openQQ = nil;
//    //    [[IMAAppDelegate sharedAppDelegate] enterMainUI];
//
//    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
//
//    //    // 拉取会话列表
//    [self pinHeaderView];
//    [self configOwnViews];
//}


//- (void)pullLoginUI
//{
//    CGUserEntity *currentUser = [[ObjectShareTool sharedInstance] currentUser];
//
//    TLSUserInfo *userinfo = [TLSUserInfo new];
//    userinfo.accountType = 0;
//    userinfo.identifier = currentUser.txyIdentifier;
//
//    [self loginWith:userinfo]; // acctype:0 userid:yc529258668
//}

/**
 *  成功登录TLS之后，再登录IMSDK
 *
 *  @param userinfo 登录TLS成功之后回调回来的用户信息
 */
//- (void)loginWith:(TLSUserInfo *)userinfo
//{
//    //    _openQQ = nil;
//    //    _tlsuiwx = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (userinfo)
//        {
//            CGUserEntity *currentUser = [[ObjectShareTool sharedInstance] currentUser];
//
//            _loginParam.identifier = userinfo.identifier;
//            //            _loginParam.userSig = [[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
//
//            _loginParam.userSig = currentUser.txyUsersig;
//
//            _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
//
//            // 获取本地的登录config
//            [self loginIMSDK];
//        }
//    });
//}


//#pragma mark - TLSRefreshTicketListener
//
//- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
//{
//    [[HUDHelper sharedInstance] syncStopLoading];
//    [self loginWith:userInfo];
//}
//
//- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
//{
//    _loginParam.tokenTime = 0;
//    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
//
//    __weak CGChatListViewController *ws = self;
//    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
//        [ws pullLoginUI];
//    }];
//
//}
//
//- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
//{
//    [self OnRefreshTicketFail:errInfo];
//}


#pragma mark - 创建视频会议

- (void)setupCallVideoBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = SCREEN_WIDTH - (44 + 6) * 2;
    float y = CTMarginTop;
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    [btn setTitle:@"视频" forState: UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(callVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callVideoBtnClick {
//    [CTToast showWithText:@"在会议列表界面使用此功能"];
//    return;
    
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        //    roomVc.roomId = @"9990";
//        roomVc.roomId = @"10726763"; // 服务器
//        roomVc.roomId = @"10877365"; // 服务器
//        roomVc.roomId = @"10563734"; // yj 创建的会议室
        
        roomVc.displayName = @"余超";
        [self.navigationController pushViewController:roomVc animated:YES];
    } else {
        [YCJCSDKHelper loginVideoCallWithUserID:[ObjectShareTool currentUserID]];
    }
}


#pragma mark - 创建电话会议
// http://www.justalkcloud.com/cn/docs/gitbook/call/CallServiceIntegrationUsingUIControls/iOS/readme.html

- (void)setupCallBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = 6;
    float y = CTMarginTop;
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    [btn setTitle:@"语音" forState: UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editMultiCallViewController {
    UIViewController *vc = self.presentedViewController;
    if (vc.class == NSClassFromString(@"CallingViewController")) {
        [YCMultiCallHelper setMultiCallViewController:vc];
    }
    
    // 设置为 nil，释放资源
//    if (!vc) {
//        [YCMultiCallHelper setMultiCallViewController:vc];
//    }
}

- (void)callBtnClick {
    // 判断猫有没有登录
    
//    NSArray *numbers = @[@"1837", @"test"];
//    @"a2af44fb-f67e-4143-9cc1-0a935f044d73"
    NSArray *numbers = @[@"1837"];
//    NSArray *numbers = @[@"a2af44fb-f67e-4143-9cc1-0a935f044d73"];
    NSString *displayName = @"余超";
//    NSString *user1 = @"1837";
//    NSString *user2 = @"test";
//    NSString *user3 = @"a2af44fb-f67e-4143-9cc1-0a935f044d73";

    if ([YCJCSDKHelper isLoginedForMultiCall]) {
//        [self test];
//        [[YCMultiCallHelper shareHelper] setSourceVC:self];
        [YCJCSDKHelper multiCall:numbers displayName:displayName];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [YCJCSDKHelper calll:user3 displayName:nil peerDisplayName:nil isVideo:NO];
//        });
    } else {
        [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    }
}

#pragma mark - 消息按钮

- (void)setupMessageBtn {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_news"] forState:UIControlStateNormal];
    [self.navi addSubview:rightBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSystemMessageRedHot:) name:NotificationSystemMessageRedHot object:nil];

    //检查本地是否有保存系统消息未读标识
    [self setSystemRedHotState:[[[NSUserDefaults standardUserDefaults] objectForKey:NotificationSystemMessageRedHot]intValue]];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scoopLastTimer) userInfo:nil repeats:YES];

}
// 收到系统消息？
-(void)notificationSystemMessageRedHot:(NSNotification *)notification{
    int state = [notification.object intValue];
    [self setSystemRedHotState:state];
    
//    [self moveAppMessage];
}
-(void)setSystemRedHotState:(int)state{
    if(state == 1){
        [self.navi addSubview:self.systemRedHot];
    }else{
        [self.systemRedHot removeFromSuperview];
    }
}
-(UILabel *)systemRedHot{
    if(!_systemRedHot){
        _systemRedHot = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16, 24, 8, 8)];
        _systemRedHot.backgroundColor = [UIColor redColor];
        _systemRedHot.layer.masksToBounds = YES;
        _systemRedHot.layer.cornerRadius = 4;
    }
    return _systemRedHot;
}
-(void)messageAction{
    NSLog(@"消息");
    //    CGMessageViewController *controller = [[CGMessageViewController alloc]init];
    //    [self.navigationController pushViewController:controller animated:YES];
    CGMessageDetailViewController *vc = [[CGMessageDetailViewController alloc]init];
    vc.title = @"系统消息";
    vc.type = 1000;
    vc.ID = @"";
    [self.navigationController pushViewController:vc animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(0) forKey:NotificationSystemMessageRedHot];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSystemMessageRedHot object:@(0)];
}

-(void)scoopLastTimer{
//    __weak typeof(self) weakSelf = self;
    [[CGDiscoverBiz alloc]queryDiscoverRemind:^(TeamCircleLastStateEntity *result) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:result];
//        [weakSelf.tableview reloadData];
    } hasSystemMsg:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(1) forKey:NotificationSystemMessageRedHot];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSystemMessageRedHot object:@(1)];//1代表有未读消息，标红
        
        
    } fail:^(NSError *error) {
    }];
}

#pragma mark -

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (void)setupHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 64.5)];
//    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 10.5, 44, 44);
    [btn setImage:[UIImage imageNamed:@"news_icon_news"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10.25, 239, 28)];
    label.text = @"系统消息";
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 38.25, 239, 16)];
    label2.text = @"没有未读消息";
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor darkGrayColor];
    [view addSubview:label2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, 600, 0.5)];
    line.backgroundColor = [YCTool colorWithRed:180 green:180 blue:180 alpha:1];
    [view addSubview:line];
    
    UIButton *mb = [UIButton buttonWithType:UIButtonTypeCustom];
    mb.frame = view.frame;
    [mb addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:mb];
    
    [[CGUserCenterBiz new] authUserMessageSystemListWithID:@"" page:1 type:1000 success:^(NSMutableArray *reslut) {
        if (reslut.count == 0) {
            label2.text = @"没有未读消息";
        } else {
            CGMessageDetailEntity *message = reslut.firstObject;
            label2.text = message.infoTitle;
        }
    } fail:^(NSError *error) {
    }];
}


#pragma mark - 右上角+

- (void)setupMenuBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = SCREEN_WIDTH - 44 - 6;
    float y = CTMarginTop;
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    UIImage *image = [UIImage imageNamed:@"icon_add"];
    image = [image imageWithColor:[UIColor blackColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(clickMenuBtn) forControlEvents:UIControlEventTouchUpInside];
    
    y = self.navi.frame.size.height;
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    YCChatListMenu *menu = [[YCChatListMenu alloc]initWithFrame:rect];
    menu.menuY = y;
    menu.pointToView = btn;
    menu.hidden = YES;
    [self.view addSubview:menu];
    _menu = menu;
    
    // 发起会议、发起群聊、添加好友
    [menu addButtonTarget:self selector:@selector(createMeeting) buttonIndex:0];
    [menu addButtonTarget:self selector:@selector(createGroupChatBtnClick) buttonIndex:1];
    [menu addButtonTarget:self selector:@selector(addFriend) buttonIndex:2];
}

- (void)createMeeting {
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        YCCreateMeetingController *vc = [YCCreateMeetingController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)clickMenuBtn {
    _menu.hidden = NO;
}

- (void)addFriend {
    
}


#pragma mark - 左上角

- (void)setupAddressBookBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = 6;
    float y = CTMarginTop;
    
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:@"news_icon_pr"] forState: UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(clickAddressBookBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAddressBookBtn {
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
            CGUserContactsViewController *vc = [[CGUserContactsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [CTToast showWithText:@"请先加入所属组织"];
        }
    } else {
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - APP 消息

- (IMAConversation *)appMessage {
    if (!_appMessage) {
        _appMessage = [IMAConversation new];
        _appMessage.isCustom = YES;
        _appMessage.customTimeStr = @"";
        _appMessage.customLastMsg = @"暂无未读消息";
        _appMessage.customBadge = 0;
        _appMessage.customTime = [[NSDate date]timeIntervalSince1970] / 1000.0;
        
        [[CGUserCenterBiz new] authUserMessageSystemListWithID:@"" page:1 type:1000 success:^(NSMutableArray *reslut) {
            if (reslut.count == 0) {
                _appMessage.customLastMsg = @"没有未读消息";
            } else {
                CGMessageDetailEntity *message = reslut.firstObject;
                _appMessage.customLastMsg = message.infoTitle;
                _appMessage.customTime = message.createTime / 1000.0;
            }
            [self.tableView reloadData];
        } fail:^(NSError *error) {
            
        }];

    }
    return _appMessage;
}

// 登录成功后调用
- (void)addAppMessage {
    if (_conversationList) {
//        if ([_conversationList.safeArray containsObject:self.appMessage]) {
//            return;
//        }
        [_conversationList.safeArray removeObject:self.appMessage];

        TIMManager *m = [TIMManager sharedInstance];
        TIMLoginStatus status = [m getLoginStatus];

        if (status == TIM_STATUS_LOGINED) {
            NSArray * conversations = [[TIMManager sharedInstance] getConversationList];

            [conversations enumerateObjectsUsingBlock:^(TIMConversation *con, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *msgs = [con getLastMsgs:1];
                TIMMessage *timmsg = msgs.firstObject;

                NSDate *date = [timmsg timestamp];
                NSTimeInterval t = date.timeIntervalSince1970;

                if (self.appMessage.customTime > t) {
                    [_conversationList insertObject:self.appMessage atIndex:idx];
                    *stop = YES;
                }
            }];

            // 如果没有插入成功，就添加到最后
            if (![_conversationList.safeArray containsObject:self.appMessage]) {
                [_conversationList addObject:self.appMessage];
            }

        }
    }
}


// 注销后调用
- (void)deleteAppMessage {
//    return;
    
    if ([_conversationList containsObject:self.appMessage]) {
        [_conversationList removeObject:self.appMessage];
    }
}

// 重写父类方法
- (void)clickAppMessage {
//    return;
    
    [self messageAction];
}

- (void)callInNumberOfRowsInSection {
    // 检查和插入系统消息
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        [self addAppMessage];
    } else {
        [self deleteAppMessage];
    }
}


#pragma mark - 任务列表

- (void)getUserTask {
    __weak typeof(self) weakself = self;
    [[CGUserCenterBiz new] getTaskListWithSuccess:^(NSArray<YCUserTask *> *tasks) {
        weakself.tasks = tasks.mutableCopy;

        if (tasks.count) {
            weakself.taskView.hidden = NO;
            weakself.taskView.titleL.text = tasks.firstObject.yc_hint;
            [weakself.taskView.collectionView reloadData];
            [weakself.view setNeedsLayout];
            [weakself.view layoutIfNeeded];
        } else {
            weakself.taskView.hidden = YES;
        }
        
    } fail:^(NSError *error) {
        [CTToast showWithText:@"获取任务列表失败"];
    }];
}

// 重写父类方法
- (void)setupTaskView {
    _taskView = [YCUserTaskView view];
    _taskView.hidden = YES;
    _taskView.collectionView.dataSource = self;
    _taskView.collectionView.delegate = self;
    [self.view addSubview:_taskView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCUserTask *task = self.tasks[indexPath.item];
    YCUserTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCUserTaskCell" forIndexPath:indexPath];
//    NSString *urlstr = [task.icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [cell.myIV sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    [cell.myIV sd_setImageWithURL:[NSURL URLWithString:task.icon]];
    cell.myLabel.text = task.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCUserTask *task = self.tasks[indexPath.item];
    __weak typeof(self) weakself = self;
    
    [[CGUserCenterBiz new] updateUserTaskWithType:task.type success:^(id data) {
        [weakself handleCMDWithTask:task];
    } fail:^(NSError *error) {
        [CTToast showWithText:@"任务更新失败，请稍后尝试"];
    }];
}

- (void)handleCMDWithTask:(YCUserTask *)task {
    //    VIPHuiYuanTeQuanGongNeng 特权
    //    DangAnGongNeng 档案
    //     "gongxiangshouyi_benren" 共享收益
    //    SuoShuZuZhi 所属组织
    //    kuaijiebangzhu 快捷帮助
    
    NSString *cmd = task.command;
    if ([cmd containsString:@"VIPHuiYuanTeQuanGongNeng"]) {
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cmd containsString:@"DangAnGongNeng"]) {
        CGUserFireViewController *controller = [[CGUserFireViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([cmd containsString:@"gongxiangshouyi_benren"]) {
        YCPersonalProfitController *vc = [YCPersonalProfitController new];
        vc.type = 1;// 个人
        vc.companyID = @"";
        vc.title = @"收益";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cmd containsString:@"SuoShuZuZhi"]) {
        CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([cmd containsString:@"kuaijiebangzhu"]) {
        CGUserHelpViewController *controller = [[CGUserHelpViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [CTToast showWithText:@"未知命令类型"];
    }
    
    [self.tasks removeObject:task];
    [self.taskView.collectionView reloadData];
    
    if (self.tasks.count == 0) {
        self.taskView.hidden = YES;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

@end

