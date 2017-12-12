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

//// 视频会议
//#import <JCApi/JCApi.h>
//#define kJCKey @"5f523868f54c24aa8fdc5096"
#import "RoomViewController.h"
//
//// 语音会议
//#import "avatar/zos/zos_type.h"
//#import "grape/zmf.h"
//#import "lemon/lemon.h"
//#import <JusCall/JusCall.h>
//#import <JusLogin/JusLogin.h>
//#import <JusDoodle/JusDoodle.h>
//#import <PushKit/PushKit.h>

#import "YCJCSDKHelper.h"

// 生意猫
#define kTLSAppid       @"1400047877"
#define kSdkAppId       @"1400047877"
#define kSdkAccountType @"18686"


#import <ImSDK/ImSDK.h>

//@interface CGChatListViewController ()<TLSRefreshTicketListener>
//{
//    //微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
//    //    __weak id<WXApiDelegate>    _tlsuiwx;
//    //    TencentOAuth                *_openQQ;
//    IMALoginParam               *_loginParam;
//}

@interface CGChatListViewController ()
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;
@property (nonatomic,strong) IMALoginParam *loginParam;

@end


@implementation CGChatListViewController

- (void)dealloc {
    [self removeObserverForLoginLogout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserverForLoginLogout];
//    [self onViewDidLoad];
    [self loginTengXunYun];
    
    [self createCustomNavi];
    [self setupCreateGroupChatBtn];
    
//    [self setupCallVideoBtn];
    [self setupCallBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pinHeaderView];
    [self configOwnViews];
    
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

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    // 设置为 nil，释放资源
//    [self editMultiCallViewController];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self editMultiCallViewController];
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
//    UIImage *image = [[UIImage imageNamed:@"common_add_white"] imageWithTintColor:[UIColor blackColor]];
//    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:@"群聊" forState: UIControlStateNormal];
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
        NSLog(@"头像  = %@, %@",  contact.userIcon, NSStringFromSelector(_cmd));
        user.nickName = contact.userName;
        user.remark = contact.userName;
        [users addObject:user];
    }
    return users;
}


#pragma mark - 适配旧代码

- (void)layoutTableView {
    float y = TOPBARHEIGHT;
    //    float bottomBarH = [((AppDelegate *)[UIApplication sharedApplication].delegate) bottomBarHeight];
    //    float height = self.tableView.frame.size.height - y;
    //    float height = SCREEN_HEIGHT - y - bottomBarH;
    float height = self.view.frame.size.height - y; // 自己 view 的高度由 tab controller 决定
    CGRect rect = self.tableView.frame;
    rect.size.height = height;
    rect.origin.y = y;
    self.tableView.frame = rect;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTableView];
}


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
}

- (void)handleLogoutSuccessNotification {
//    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
//            [[AppDelegate sharedAppDelegate] enterLoginUI];
//            [self configOwnViews];
//        }];
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        [self configOwnViews];
        
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
    NSString *user3 = @"a2af44fb-f67e-4143-9cc1-0a935f044d73";

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

@end

