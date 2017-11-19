//
//  CTRootViewController.m
//  VieProd
//
//  Created by Calon Mo on 16/4/7.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTRootViewController.h"
#import "CGTabbarEntity.h"
#import "CGTabbarView.h"
#import "AppConstants.h"
#import "CGUserCenterBiz.h"
#import "CGUserDao.h"
#import "CGUserCenterBiz.h"
#import "CGCommonBiz.h"
#import <SSZipArchive.h>
#import "CGDiscoverBiz.h"
#import "LightExpBiz.h"
#import "CGCompanyDao.h"
#import "AttentionBiz.h"

#import "YCWorkViewController.h"

#define kTabCount 5
#define kWork 0
#define kChat 1
#define kKnowledgeMeal 2
#define kKnowledgeBase 3
#define kDiscoverMain 5
#define kMyMain 4


@interface CTRootViewController ()<SSZipArchiveDelegate>

@property(nonatomic,assign)int checkTokenState;//0未检查token 1正在检查 2检查成功 3检查失败

//@property(nonatomic,retain)UILabel *redHot;//企业圈红点

//@property(nonatomic,retain)UILabel *systemRedHot;//系统消息红点
@property (nonatomic,strong) CGTabbarView *myMainTabView;
@property (nonatomic,strong) CGTabbarView *conversationListTabView;
@property (nonatomic,strong) UILabel *conversationListRedHot;

@end

@implementation CTRootViewController

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    CGMeetingListViewController *vc = [CGMeetingListViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(UILabel *)redHot{
    if(!_redHot){
        [self createRedHot];
    }
    return _redHot;
}

- (UILabel *)createRedHot {
    UILabel *_redHot = [[UILabel alloc]init];
    _redHot.backgroundColor = [UIColor redColor];
    _redHot.layer.masksToBounds = YES;
    _redHot.textAlignment = NSTextAlignmentCenter;
    _redHot.font = [UIFont systemFontOfSize:10];
    _redHot.textColor = [UIColor whiteColor];
    _redHot.frame = CGRectMake(38, 0, 16, 16);
    _redHot.layer.cornerRadius = 8;
    return _redHot;
}

//-(UILabel *)systemRedHot{
//    if(!_systemRedHot){
//        _systemRedHot = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, 8, 8)];
//        _systemRedHot.backgroundColor = [UIColor redColor];
//        _systemRedHot.layer.masksToBounds = YES;
//        _systemRedHot.layer.cornerRadius = 4;
//    }
//    return _systemRedHot;
//}

//默认显示哪个tab
-(void)showTabIndex:(int)index{
    if(index < 0 || index > kTabCount-1){//目前只有4个tab，超过范围默认选中第一个
        index = 0;
    }
    
    CGTabbarEntity *entity = nil;
    //    if(index == 0){
    //        entity = tabEntity;
    //    }else if(index == 1){
    //        entity = tabEntity;
    //    }else if (index == 2){
    //        entity = tabEntity;
    //    }else if (index == 3){
    //        entity = tabEntity;
    //    }
    entity = self.tabEntitys[index];
    
    [self tabbarSelectedItemAction:entity];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //开启网络状况的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name: kReachabilityChangedNotification object: nil];
        [[ObjectShareTool sharedInstance].reachability startNotifier];//开启网络监听
    }
    return self;
}

- (UIView *)extracted {
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //生成tab和相应的controller
    [self generateTabAndController];
    
    UIView *line = [self extracted];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [self.tabbarView addSubview:line];
    [self hideCustomNavi];
    [self hideCustomBackBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMyTabBarState) name:NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMyTabBarState) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToLoadNavType) name:NOTIFICATION_UPDATESKILLLEVEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDiscoverHasLastData:) name:NotificationDiscoverHasLastData object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSystemMessageRedHot:) name:NotificationSystemMessageRedHot object:nil];
    [self toCheckToken];
    
    TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
    [self setRedHotState:entity];
    //检查本地是否有保存系统消息未读标识
    [self setSystemRedHotState:[[[NSUserDefaults standardUserDefaults] objectForKey:NotificationSystemMessageRedHot]intValue]];
}

// 网络状态监听
- (void) reachabilityChanged{
    NetworkStatus status = [[ObjectShareTool sharedInstance].reachability currentReachabilityStatus];
    if (status != NotReachable) {
        [self toCheckToken];
    }
}

-(void)notificationDiscoverHasLastData:(NSNotification *)notification{
    TeamCircleLastStateEntity *state = notification.object;
    [self setRedHotState:state];
}
-(void)notificationSystemMessageRedHot:(NSNotification *)notification{
    int state = [notification.object intValue];
    [self setSystemRedHotState:state];
}
-(void)setSystemRedHotState:(int)state{
    TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
    if (([CTStringUtil stringNotBlank:entity.badge.portrait]||state == 1)&&entity.count<=0){
        [self.myMainTabView addSubview:self.redHot];
        self.redHot.text = @"";
        self.redHot.frame = CGRectMake(40, 2, 8, 8);
        self.redHot.layer.cornerRadius = 4;
    }else{
        [self.redHot removeFromSuperview];
    }
    //    if(state == 1){
    //        [tabView addSubview:self.systemRedHot];
    //    }else{
    //        [self.systemRedHot removeFromSuperview];
    //    }
}


-(void)setRedHotState:(TeamCircleLastStateEntity *)state{
    int count = [[[NSUserDefaults standardUserDefaults] objectForKey:NotificationSystemMessageRedHot]intValue];
    if(state.count > 0){
        [self.myMainTabView addSubview:self.redHot];
        self.redHot.text = [NSString stringWithFormat:@"%d",state.count > 99 ? 99 : state.count];
        self.redHot.frame = CGRectMake(38, 0, 16, 16);
        self.redHot.layer.cornerRadius = 8;
    }else if([CTStringUtil stringNotBlank:state.badge.portrait]||count == 1){
        [self.myMainTabView addSubview:self.redHot];
        self.redHot.text = @"";
        self.redHot.frame = CGRectMake(40, 2, 8, 8);
        self.redHot.layer.cornerRadius = 4;
    }else{
        [self.redHot removeFromSuperview];
    }
    
}

#pragma mark - 小红点

- (void)setConversationListTabViewRedPoint:(NSInteger)count {
    UILabel *redHot = self.conversationListRedHot;
    if (count > 0) {
        redHot.text = [NSString stringWithFormat:@"%ld",(long)(count < 99?count:99)];
        redHot.hidden = NO;
    } else {
        redHot.hidden = YES;
    }
}

#pragma mark - 创建 tab

//生成tab和对应的controller
-(void)generateTabAndController{
    float length = 44;//tab的长和宽
    float width = 60;
    
    self.tabEntitys = [NSMutableArray arrayWithCapacity:kTabCount];
    self.tabViews = [NSMutableArray arrayWithCapacity:kTabCount];
    
    for(int i=0;i<kTabCount;i++){
        float x = (SCREEN_WIDTH-(kTabCount*width))/(kTabCount+1)*(i+1)+width*i;
        
        CGTabbarView *tabView;
        CGTabbarEntity *tabEntity = [[CGTabbarEntity alloc]init];
        tabEntity.index = i;
        
        if (i == kChat) {
            tabEntity.title = @"消息";
//            tabEntity.normalImage = @"tab_homepage";
//            tabEntity.selectedName = @"tab_homepage_hl";
            tabEntity.normalImage = @"conversation_normal";
            tabEntity.selectedName = @"conversation_hover";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            [self.tabViews addObject:tabView];
            self.conversationListTabView = tabView;
            
            self.conversationListRedHot = [self createRedHot];
            [self.conversationListTabView addSubview:self.conversationListRedHot];

            self.chatListVC = [[CGChatListViewController alloc]init];
            [self addChildViewController:self.chatListVC];
            [self.chatListVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.chatListVC.view];
//            tabView.hidden = NO;
//            [tabView tabbarUpdateItemState:YES];//设置tab为选中状态
        }
        else if(i ==  kWork){
            tabEntity.title = @"工作";
            tabEntity.normalImage = @"tab_homepage";
            tabEntity.selectedName = @"tab_homepage_hl";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            [self.tabViews addObject:tabView];
            
            self.workVC = [[YCWorkViewController alloc]init];
            [self addChildViewController:self.workVC];
            [self.workVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.workVC.view];
            tabView.hidden = NO;
            [tabView tabbarUpdateItemState:YES];//设置tab为选中状态
        }
        else if(i == kKnowledgeMeal){
            tabEntity.title = @"今日知识";
            tabEntity.normalImage = @"tab_homepage";
            tabEntity.selectedName = @"tab_homepage_hl";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            [self.tabViews addObject:tabView];
            
            self.mealVC = [[CTKnowledgeMealViewController alloc]init];
            [self addChildViewController:self.mealVC];
            [self.mealVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.mealVC.view];
            //          tabView.hidden = NO;
            //            [tabView tabbarUpdateItemState:YES];//设置tab为选中状态
        }else if(i == kKnowledgeBase){
            tabEntity.title = @"岗位知识";
            tabEntity.normalImage = @"repository";
            tabEntity.selectedName = @"selectedrepository";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            [self.tabViews addObject:tabView];
            
            self.baseVC = [[CGKnowledgeBaseViewController alloc]init];
            [self addChildViewController:self.baseVC];
            [self.baseVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.baseVC.view];
        }else if(i == kDiscoverMain){
            tabEntity.title = @"发现";
            tabEntity.normalImage = @"discovery";
            tabEntity.selectedName = @"selecteddiscovery";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            [self.tabViews addObject:tabView];
            
            self.discoverVC = [[CGDiscoverMainController alloc]init];
            [self addChildViewController:self.discoverVC];
            [self.discoverVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.discoverVC.view];
        }else if(i == kMyMain){
            int isLogin = [ObjectShareTool sharedInstance].currentUser.isLogin;
            tabEntity.title = isLogin == 1 ? @"我的" : @"未登录";
            tabEntity.normalImage = isLogin == 1 ? @"my" : @"tab_usercenter_nologin";
            tabEntity.selectedName = isLogin == 1 ? @"myy" : @"tab_usercenter_nologin_hl";
            [self.tabEntitys addObject:tabEntity];
            
            tabView = [[CGTabbarView alloc]initWithFrame:CGRectMake(x, 0, width, length) entity:tabEntity target:self];
            [self.tabbarView addSubview:tabView];
            self.myMainTabView = tabView;
            [self.tabViews addObject:tabView];
            
            self.myVC = [[CGMyMainViewController alloc]init];
            [self addChildViewController:self.myVC];
            [self.myVC.view setFrame:self.contentView.bounds];
            [self.contentView addSubview:self.myVC.view];
        }
    }
    
//    [self.contentView addSubview:self.childViewControllers.firstObject.view];//默认显示第一个tab的controller
    [self.contentView bringSubviewToFront:self.childViewControllers.firstObject.view];
}


#pragma mark - Notification

//检查token-APP启动时在网络监听里进行调用
-(void)toCheckToken{
    if(self.checkTokenState == 0 || self.checkTokenState == 3){
        self.checkTokenState = 1;
        __weak typeof(self) weakSelf = self;
        [[[CGUserCenterBiz alloc] init] getToken:^(NSString *uuid, NSString *token) {
            weakSelf.checkTokenState = 2;//成功
            
            //判断是否下载html5
            NSUserDefaults *version = [NSUserDefaults standardUserDefaults];
            NSNumber *latest = [version objectForKey:@"latestVersion"];
            NSInteger latestVersion = 0;
            if (latest) {
                latestVersion = latest.integerValue;
            }
            CGSettingEntity *entity = [CGCompanyDao getSettingStatisticsFromLocal];
            [ObjectShareTool sharedInstance].settingEntity = entity;
            [[[CGUserCenterBiz alloc] init] userSettingSuccess:^(CGSettingEntity *reslut) {
                [CGCompanyDao saveSettingStatistics:reslut];
                [ObjectShareTool sharedInstance].settingEntity = reslut;
            } fail:^(NSError *error) {
                [ObjectShareTool sharedInstance].settingEntity = [CGCompanyDao getSettingStatisticsFromLocal];
            }];
            
            [ObjectShareTool sharedInstance].inviteFriend = [CGCompanyDao getInviteFriendsStatisticsFromLocal];
            [[[CGUserCenterBiz alloc] init] authUserInviteFriendsSuccess:^(CGInviteFriendEntity *reslut) {
                [CGCompanyDao saveInviteFriendsStatistics:reslut];
                [ObjectShareTool sharedInstance].inviteFriend = reslut;
            } fail:^(NSError *error) {
                [ObjectShareTool sharedInstance].inviteFriend = [CGCompanyDao getInviteFriendsStatisticsFromLocal];
            }];
            
            //检查加载今日知识和岗位知识的分类
            if(![ObjectShareTool sharedInstance].knowledgeBigTypeData || [ObjectShareTool sharedInstance].knowledgeBigTypeData.count <= 0){
                [self queryRemoteHeadlineTypeWithDelay:NO];
            }else{
                [self queryRemoteHeadlineTypeWithDelay:YES];
            }
            
            //检查更新离线H5包
            //            CGCommonBiz *commonbiz = [[CGCommonBiz alloc]init];
            //            [commonbiz commonOfflineVersionWithVersion:latestVersion success:^(NSString *version) {
            //                if (version.length>0) {
            //                    [commonbiz downLoadHtml5DataWithUrl:version success:^(NSString *success) {
            //                        NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //                        NSString *filePath = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data.zip"];
            //                        NSString *filePath2 = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data"];
            //                        [weakSelf releaseZipFilesWithUnzipFileAtPath:filePath Destination:filePath2];
            //                    }];
            //                }
            //            } fail:^(NSError *error) {
            //
            //            }];
            
            //如果本地数据是已登录，则启动时加载用户数据，未登录的话不加载
            //            if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
            //            }
            
            //            [weakSelf.firstController tokenCheckComplete:YES];
            //            [weakSelf.secondController tokenCheckComplete:YES];
            //            [weakSelf.thirdController tokenCheckComplete:YES];
            //            [weakSelf.fourthController tokenCheckComplete:YES];
            
            //            for (CTBaseViewController *vc in weakSelf.childViewControllers) {
            //                [vc tokenCheckComplete:YES];
            //            }
            [weakSelf.childViewControllers makeObjectsPerformSelector:@selector(tokenCheckComplete:) withObject:@(YES)];
        } fail:^(NSError *error) {
            weakSelf.checkTokenState = 3;//失败
            //            [weakSelf.firstController tokenCheckComplete:NO];
            //            [weakSelf.secondController tokenCheckComplete:NO];
            //            [weakSelf.thirdController tokenCheckComplete:NO];
            //            [weakSelf.fourthController tokenCheckComplete:NO];
            
            [weakSelf.childViewControllers makeObjectsPerformSelector:@selector(tokenCheckComplete:) withObject:@(NO)];
            
        }];
    }
}

-(void)notificationToLoadNavType{
    [self queryRemoteHeadlineTypeWithDelay:NO];
}

-(void)queryRemoteHeadlineTypeWithDelay:(BOOL)delay{
    NSLog(@"查询远程分类，是否延迟：%d",delay);
    if(delay){//延迟检查
        //检查服务器分类是否有更新
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getNavTypeData];
            });
        });
    }else{//立即
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getNavTypeData];
        });
    }
}

//获取分类数据
-(void)getNavTypeData{
    __weak typeof(self) weakSelf = self;
    [[[AttentionBiz alloc]init] headlinesSkillNavListSuccess:^(NSMutableArray *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mealVC loadNavTypeFinish];
            [weakSelf.baseVC loadNavTypeFinish];
        });
    } fail:^(NSError *error) {
    }];
}

// 解压
//- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
//    NSError *error;
//    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
//        BOOL isHave = NO;
//        for (int i=0; i<self.navigationController.viewControllers.count; i++) {
//            if ([self.navigationController.viewControllers[i] isKindOfClass:[WKWebViewController class]]) {
//                isHave = YES;
//                break;
//            }
//        }
//        if (!isHave) {
//            NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *filePath = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data/index.0694ff.html"];
//            NSURL* url = [NSURL fileURLWithPath:filePath];
//            NSString *filePath1 = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data"];
//            NSURL* url1 = [NSURL fileURLWithPath:filePath1];
//            [[ObjectShareTool sharedInstance].webview loadFileURL:url allowingReadAccessToURL:url1];
//        }
//    }
//}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(CGTabbarEntity *)selectedEntity{
    BOOL clickOnPage = self.currentShowTabIndex == selectedEntity.index;//是否点击当前页面的tab
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(clickOnPage),@"clickOnPage", nil];
    self.currentShowTabIndex = selectedEntity.index;
    
    //    [tabView tabbarUpdateItemState:NO];
    //    [tabView tabbarUpdateItemState:NO];
    //    [tabView tabbarUpdateItemState:NO];
    //    [tabView tabbarUpdateItemState:NO];
    [self.tabViews makeObjectsPerformSelector:@selector(tabbarUpdateItemState:) withObject:@(NO)];
    
    //    if(selectedEntity.index == 0){
    //        [tabView tabbarUpdateItemState:YES];
    //        [self.firstController.view setFrame:self.contentView.bounds];
    //        [self.contentView addSubview:self.firstController.view];
    //        [self.firstController tabbarSelectedItemAction:dict];
    //    }else if(selectedEntity.index == 1){
    //        [tabView tabbarUpdateItemState:YES];
    //        [self.secondController.view setFrame:self.contentView.bounds];
    //        [self.contentView addSubview:self.secondController.view];
    //        [self.secondController tabbarSelectedItemAction:dict];
    //    }else if(selectedEntity.index == 2){
    //        [tabView tabbarUpdateItemState:YES];
    //        [self.thirdController.view setFrame:self.contentView.bounds];
    //        [self.contentView addSubview:self.thirdController.view];
    //        [self.thirdController tabbarSelectedItemAction:dict];
    //    }else if(selectedEntity.index == 3){
    //        [tabView tabbarUpdateItemState:YES];
    //        [self.fourthController.view setFrame:self.contentView.bounds];
    //        [self.contentView addSubview:self.fourthController.view];
    //        [self.fourthController tabbarSelectedItemAction:dict];
    //    }
    
    CGTabbarView *tabView = self.tabViews[selectedEntity.index];
    [tabView tabbarUpdateItemState:YES];
    UIViewController *vc = self.childViewControllers[selectedEntity.index];
    [vc.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:vc.view];
    [vc performSelector:@selector(tabbarSelectedItemAction:) withObject:dict];
}

//登录或者退出登录后调用更新“我的”tabbar的状态
-(void)updateMyTabBarState{
    int isLogin = [ObjectShareTool sharedInstance].currentUser.isLogin;
    CGTabbarEntity *tabEntity = self.tabEntitys[kMyMain];
    tabEntity.title = isLogin == 1 ? @"我的" : @"未登录";
    tabEntity.normalImage = isLogin == 1 ? @"my" : @"tab_usercenter_nologin";
    tabEntity.selectedName = isLogin == 1 ? @"myy" : @"tab_usercenter_nologin_hl";
    [self.myMainTabView tabbarUpdateItemState:tabEntity.selected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}


#pragma mark - 跳转到聊天界面

- (void)pushToChatViewControllerWith:(IMAUser *)user
{
#if kTestChatAttachment
    // 无则重新创建
    IMAChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    IMAChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    
//    IMAChatViewController *vc = [[IMAChatViewController alloc] initWith:user];

    if ([user isC2CType])
    {
        TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
        if ([imconv getUnReadMessageNum] > 0)
        {
            [vc modifySendInputStatus:SendInputStatus_Send];
        }
    }
    
    if ([user.nickName isEqualToString:@""] || !user.nickName) {
        vc.titleStr = user.userId;
    } else {
        vc.titleStr = user.nickName;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [vc.navigationController pushViewController:vc withBackTitle:@"返回" animated:YES]; // 会崩溃
//    [self.navigationController pushViewController:vc withBackTitle:@"返回" animated:YES];
}

@end

