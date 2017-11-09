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

// 视频会议
#import <JCApi/JCApi.h>
#define kJCKey @"5f523868f54c24aa8fdc5096"
#import "RoomViewController.h"

// 语音会议
#import "avatar/zos/zos_type.h"
#import "grape/zmf.h"
#import "lemon/lemon.h"
#import <JusCall/JusCall.h>
#import <JusLogin/JusLogin.h>
#import <JusDoodle/JusDoodle.h>
#import <PushKit/PushKit.h>


// 生意猫
#define kTLSAppid       @"1400047877"
#define kSdkAppId       @"1400047877"
#define kSdkAccountType @"18686"


#import <ImSDK/ImSDK.h>

@interface CGChatListViewController ()<TLSRefreshTicketListener>
{
    //微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
    //    __weak id<WXApiDelegate>    _tlsuiwx;
    //    TencentOAuth                *_openQQ;
    IMALoginParam               *_loginParam;
}
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;
@end


@implementation CGChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserverForLoginLogout];
    [self onViewDidLoad];
    [self createCustomNavi];
    [self setupCreateGroupChatBtn];

//    [self initialTengXunYun];
    [self initialJCSDK];
    [self initialJCSDKCall];
    [self setupCallVideoBtn];
    [self setupCallBtn];
    
}

- (void)dealloc {
    [self removeObserverForLoginLogout];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@MtcLoginOkNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@MtcCliServerLoginDidFailNotification object:nil];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pinHeaderView];
    [self configOwnViews];
    
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
    NSLog(@"群名 = %@, %@", name, NSStringFromSelector(_cmd));
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
        self.titleView.textColor = [UIColor whiteColor];
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
//            self.titleView.textColor = [UIColor whiteColor];
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
    [self onViewDidLoad];
}
- (void)handleLogoutSuccessNotification {
    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
            [self configOwnViews];
        }];
        
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

// 进行腾讯云登录
- (void)onViewDidLoad {
    
    // 如果用户没有登录，跳过腾讯云登录
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
        return;
    }
    
    [WXApi registerApp:WX_APP_ID];
    //demo暂不提供微博登录
    //[WeiboSDK registerApp:WB_APPKEY];
    
    // 因TLSSDK在IMSDK里面初始化，必须先初始化IMSDK，才能使用TLS登录
    // 导致登出然后使用相同的帐号登录，config会清掉
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (isAutoLogin)
    {
        _loginParam = [IMALoginParam loadFromLocal];
    }
    else
    {
        _loginParam = [[IMALoginParam alloc] init];
    }
    
    [IMAPlatform configWith:_loginParam.config];
    
    if (isAutoLogin && [_loginParam isVailed])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoLogin];
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pullLoginUI];
        });
        
    }
}

/**
 *  自动登录
 */
- (void)autoLogin
{
    if ([_loginParam isExpired])
    {
        [[HUDHelper sharedInstance] syncLoading:@"刷新票据。。。"];
        //刷新票据
        [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
    }
    else
    {
        [self loginIMSDK];
    }
}


/**
 *  登录IMSDK
 */
- (void)loginIMSDK
{
    //直接登录
    __weak CGChatListViewController *weakSelf = self;
    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
        [weakSelf registNotification];
        [weakSelf enterMainUI];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
            [weakSelf pullLoginUI];
        }];
    }];
}

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
- (void)enterMainUI
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    //    [[IMAAppDelegate sharedAppDelegate] enterMainUI];
    
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
    
    //    // 拉取会话列表
    //    [super viewDidLoad];
    [self pinHeaderView];
    //    [self onRefresh];
    [self configOwnViews];
}


- (void)pullLoginUI
{
    CGUserEntity *currentUser = [[ObjectShareTool sharedInstance] currentUser];
    
    TLSUserInfo *userinfo = [TLSUserInfo new];
    userinfo.accountType = 0;
    if (SCREEN_WIDTH == 375) {
        // iPhone 8是375，8plus 是540
        userinfo.identifier = kTestUserID;
    } else {
        userinfo.identifier = currentUser.txyIdentifier;
    }
    [self loginWith:userinfo]; // acctype:0 userid:yc529258668
}

/**
 *  成功登录TLS之后，再登录IMSDK
 *
 *  @param userinfo 登录TLS成功之后回调回来的用户信息
 */
- (void)loginWith:(TLSUserInfo *)userinfo
{
    //    _openQQ = nil;
    //    _tlsuiwx = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (userinfo)
        {
            CGUserEntity *currentUser = [[ObjectShareTool sharedInstance] currentUser];
            
            _loginParam.identifier = userinfo.identifier;
            //            _loginParam.userSig = [[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
            
            if (SCREEN_WIDTH == 375) {
                // iPhone 8 是375，8 plus 是540
                _loginParam.userSig = kUserSig;
            } else {
                _loginParam.userSig = currentUser.txyUsersig;
            }
            _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
            
            // 获取本地的登录config
            [self loginIMSDK];
        }
    });
}


#pragma mark - TLSRefreshTicketListener

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [[HUDHelper sharedInstance] syncStopLoading];
    [self loginWith:userInfo];
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    _loginParam.tokenTime = 0;
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
    
    __weak CGChatListViewController *ws = self;
    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
        [ws pullLoginUI];
    }];
    
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}



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
    RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    roomVc.roomId = @"9990";
    roomVc.displayName = @"我的昵称";
    [self.navigationController pushViewController:roomVc animated:YES];
}

#pragma mark - 初始化 JCSDk

- (void)initialTengXunYun {
    TIMManager *manager = [TIMManager sharedInstance];
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [kSdkAppId intValue] ;
    config.accountType = kSdkAccountType;
    //    config.disableCrashReport = NO;
    //    config.connListener = self;
    int r = [manager initSdk:config];
    if (r == 0) {
        NSLog(@"腾讯云初始化成功");
    }
}

- (void)initialJCSDK {
    int ret = [[JCEngineManager sharedManager] initializeWithAppkey:kJCKey];
    if (ret == JCOK) {
        NSLog(@"JCSDK 视频初始化成功");
    }
}

- (void)initialJCSDKCall {
    Zmf_AudioInitialize(NULL);
    Zmf_VideoInitialize(NULL);
    
    if (Mtc_Init() == ZOK) {
        NSLog(@"JCSDK 语音初始化成功");
    }
    
    [MtcLoginManager Init:kJCKey];
    //    [MtcPushManager SetPayloadForCall:@MY_PUSH_CALL_PAYLOAD                     Expiration:MY_PUSH_EXPIRATION];
    [MtcCallManager Init];
    
//    [MtcDoodleManager Init:(id<MtcDoodleDelegate>)self];
//    [MtcDoodleManager Init:nil];

//    [MtcLoginManager Set:self]; // MtcLoginDelegate
}

- (void)loginJCSDKCall {
//    http://www.justalkcloud.com/cn/docs/gitbook/account/LoginUsingJusLogin/iOS/readme.html
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJCSDKLoginOK) name:@MtcLoginOkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcCliServerLoginDidFailNotification:) name:@MtcCliServerLoginDidFailNotification object:nil];

    NSString *server = @"http:router.justalkcloud.com:8080";
    if ([MtcLoginManager Login:@"1837" password:@"111" network:server] == ZOK) {
        NSLog(@"调用语音登录成功");
    }
    
}

- (void)handleJCSDKLoginOK {
    NSLog(@"语音登录成功");
    [MtcCallManager Call:@"1836" displayName:nil peerDisplayName:nil isVideo:NO userInfo:nil];
//    [MtcCallManager Call:@"test" displayName:nil peerDisplayName:nil isVideo:NO userInfo:nil];
}

- (void)handleMtcCliServerLoginDidFailNotification:(NSNotification *)noti {
//    http://www.justalkcloud.com/cn/docs/gitbook/account/LoginErrorCode/readme.html
    // MtcCliStatusCodeKey
    NSLog(@"%@", noti.userInfo);
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

- (void)callBtnClick {
//    CallViewController *callViewController = [[CallViewController alloc] init];
//    [self.navigationController pushViewController:callViewController animated:YES];
    
    [self loginJCSDKCall];
}

@end
