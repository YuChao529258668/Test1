//
//  CGChatListViewController.m
//  CGKnowledge
//
//  Created by 余超 on 2017/10/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChatListViewController.h"

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

@interface CGChatListViewController ()
//@property(nonatomic,retain)UIView *navi;
//@property(nonatomic,retain)UILabel *titleView;

@end

@implementation CGChatListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
//    [self createCustomNavi];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = CTCommonViewControllerBg;

    [self initialTengXunYun];
    [self initialJCSDK];
    [self initialJCSDKCall];
    [self setupCallVideoBtn];
    [self setupCallBtn];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@MtcLoginOkNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@MtcCliServerLoginDidFailNotification object:nil];

}


#pragma mark - 适配旧代码

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
