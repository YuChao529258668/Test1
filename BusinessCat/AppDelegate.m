//
//  AppDelegate.m
//  CGSays
//
//  Created by mochenyang on 16/8/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AppDelegate.h"
#import "CTBaseDao.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "CGWelcomeVC.h"
#import "CGLaunchScreen.h"
//推送要跳转的
#import "CGUserCenterBiz.h"
#import "CGUserAuditViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGDiscoverSourceCircleViewController.h"

#import "CGUserDao.h"
#import "CGUserContactsViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import <WXApi.h>
#import "CGCommonBiz.h"
//umeng appkey
#define UMeng_AppKey @"591aca19f29d984d01000ba0"
#define UMeng_SECRET @"xp0s70ptnvptcuyaewmdpsputod2gxx3"
#import <iflyMSC/iflyMSC.h>
#import "CGAttestationController.h"
#import "CGUrlView.h"
//#import "CGFristOpenView.h"
#import "CGSortView.h"
#import "CGUserFireViewController.h"

#import "commonViewModel.h"

// 腾讯云
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

//// 视频会议
//#import <JCApi/JCApi.h>
//#define kJCKey @"5f523868f54c24aa8fdc5096"
////#import "RoomViewController.h"
//
//// 语音会议
//#import "avatar/zos/zos_type.h"
//#import "grape/zmf.h"
//#import "lemon/lemon.h"
//#import <JusCall/JusCall.h>
//#import <JusLogin/JusLogin.h>
////#import <JusDoodle/JusDoodle.h>
//#import <PushKit/PushKit.h>

#import "YCJCSDKHelper.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, strong) CGUrlView *urlView;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 腾讯云
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 初始化 JCSDK
//    [YCJCSDKHelper initializeVideoCall]; // 视频
    [YCJCSDKHelper initializeMultiCall]; // 语音
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    [self.window makeKeyAndVisible];
    self.viewModel = [[commonViewModel alloc]init];
    //友盟统计初始化
    UMConfigInstance.appKey = UMeng_AppKey;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setEncryptEnabled:YES];//日志加密传输
    
    //友盟分享
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMeng_AppKey];
    //注册微信支付
    [WXApi registerApp:kWXAPP_ID withDescription:@"荐识"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106151485"  appSecret:@"KySAKNdhytNLBTyE" redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"4266495195" appSecret:@"d4b40e7a050dd575c9f58a4f41754abd" redirectURL:@"http://sns.whalecloud.com"];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAPP_ID appSecret:kWXAPP_SECRET redirectURL:@"http://www.team580.com"];
    
    //注册科大讯飞语音
    [IFlySpeechUtility createUtility:@"appid=58c81249"];
    
    //友盟推送
    [UMessage startWithAppkey:UMeng_AppKey launchOptions:launchOptions httpsEnable:YES];
    //友盟设置渠道
    [UMessage setChannel:@"App Store"];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //    if (![self isShownWelcome]) {
    //        [self showWelcomeView];
    //    } else {
    [self showMainView];
    //    }
    
    //    启动后把启动图重新添加到window上，等H5加载完成再移除
    CGLaunchScreen *zhe = [[CGLaunchScreen alloc]initWithFrame:self.window.bounds];
    [self.window addSubview:zhe];
    [self.window bringSubviewToFront:zhe];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSccess) name:NOTIFICATION_LOGINSUCCESS object:nil];
    
    return YES;
}

-(void)loginSccess{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [defaults boolForKey:DEF_First];
    if (!isFirst) {
        CGSortView *sortView = [[CGSortView alloc]initWithArray:[ObjectShareTool sharedInstance].knowledgeBigTypeData];
    }
}


#pragma mark - 微信回调

//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if ([resp isKindOfClass:[PayResp class]]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        NSLog(@"%@",response.returnKey);
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
                [[CTToast makeText:@"支付成功"]show:window];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [[CTToast makeText:@"支付失败"]show:window];
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                [[CTToast makeText:@"取消支付"]show:window];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                [[CTToast makeText:@"发送失败"]show:window];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                [[CTToast makeText:@"微信不支持"]show:window];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                [[CTToast makeText:@"授权失败"]show:window];
            }
                break;
            default:
                break;
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GETWEIXINCODE object:code];
            //    NSDictionary *dic = @{@"code":code};
        }
    }
}


#pragma mark - WelcomeView

- (void)showWelcomeView {
    CGWelcomeVC *welCome = [[CGWelcomeVC alloc]initWithBlock:^{
        [self setShownWelcome];
        [self showMainView];
    }];
    self.navi = [[CTBaseNaviController alloc]initWithRootViewController:welCome];
    self.window.rootViewController = self.navi;
}

- (void)showMainView{
    self.rootController = [[CTRootViewController alloc]init];
    self.navi = [[CTBaseNaviController alloc]initWithRootViewController:self.rootController];
    self.window.rootViewController = self.navi;
}

- (void)setShownWelcome {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DEF_KEY_SHOWN_WELCOME];
    [defaults synchronize];
}
- (BOOL)isShownWelcome {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DEF_KEY_SHOWN_WELCOME] != nil;
}


#pragma mark - Notification

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [super application:application didReceiveRemoteNotification:userInfo];
    
    //    //NSLog(@"didReceiveRemoteNotification消息推送：%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        CGPushEntity *entity = [CGPushEntity mj_objectWithKeyValues:userInfo];
        if (!entity.aps.alert) {
            alertEntity *alert = [[alertEntity alloc]init];
            NSDictionary *dic = userInfo[@"aps"];
            alert.body = dic[@"alert"];
            entity.aps.alert = alert;
        }
        [self.viewModel messagePushAlertviewWithEnitty:entity];
    }else{
        //应用处于前台时的本地推送接受
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //NSLog(@"iOS10后台消息推送：%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        CGPushEntity *entity = [CGPushEntity mj_objectWithKeyValues:userInfo];
        [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.companyId recordId:entity.recordId messageId:entity.messageId detial:nil typeArray:nil];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSLog(@"deviceToken：%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [super application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - OpenURL

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [super application:application handleOpenURL:url];
    
    return [WXApi handleOpenURL:url delegate:self];;
}


#pragma mark - Life Cycle

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [super applicationDidEnterBackground:application];
    
    //进入后台
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationToApplicationDidEnterBackground object:nil];
    //  [self.urlView dismiss];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [super applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [super applicationDidBecomeActive:application];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationToApplicationDidBecomeActive object:nil];
    //  if ([ObjectShareTool sharedInstance].isLaunchScreen) {
    //    if ([[UIPasteboard generalPasteboard].string hasPrefix:@"http"]) {
    //      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //      NSString *currChangeCount = [user objectForKey:@"changeCount"];
    //      if ([UIPasteboard generalPasteboard].changeCount > currChangeCount.integerValue) {
    //        self.urlView = [[CGUrlView alloc]initWithUrl:[UIPasteboard generalPasteboard].string block:^(NSString *title, NSString *icon) {
    //          CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
    //
    //          }];
    //          if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
    //            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[0];
    //            CGHorrolEntity *entity;
    //            if (companyEntity.companyType == 2) {
    //              entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
    //            }else{
    //              entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
    //            }
    //            entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
    //            vc.currentEntity = entity;
    //            vc.releaseType = DiscoverReleaseTypeCompany;
    //          }else{
    //            vc.releaseType = DiscoverReleaseTypeNoCompany;
    //          }
    //
    //          CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
    //          link.linkIcon = icon;
    //          link.linkId = [UIPasteboard generalPasteboard].string;
    //          link.linkTitle = title;
    //          link.linkType = 1;
    //          vc.link = link;
    //          if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
    //            vc.releaseType = HeadlineReleaseTypeCompany;
    //          }else{
    //            vc.releaseType = HeadlineReleaseTypeNoCompany;
    //          }
    //          [self.navi pushViewController:vc animated:YES];
    //        }];
    //        [self.window addSubview:self.urlView];
    //      }
    //      NSString *changeCount = [NSString stringWithFormat:@"%ld",[UIPasteboard generalPasteboard].changeCount];
    //      [user setObject:changeCount forKey:@"changeCount"];
    //    }
    //  }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 腾讯云

// 代码全部拷贝自 demo 的 AppDelegate

- (void)configAppLaunch
{
    // 作App配置
    [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)enterMainUI
{
    //    self.window.rootViewController = [[TIMTabBarController alloc] init];
}

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    //    TIMTabBarController *tab = (TIMTabBarController *)self.window.rootViewController;
    //    [tab pushToChatViewControllerWith:user];
    
    [self.rootController pushToChatViewControllerWith:user];
}

// 进入登录界面
// 用户可重写
//- (void)enterLoginUI
//{
//    IMALoginViewController *vc = [[IMALoginViewController alloc] init];
//    self.window.rootViewController = vc;
//
//}


@end

