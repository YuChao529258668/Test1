//
//  RoomViewController.m
//  UltimateShow
//
//  Created by 沈世达 on 2017/6/1.
//  Copyright © 2017年 young. All rights reserved.
//

#import "RoomViewController.h"



#import "ConferenceToolBar.h"
#import "JCBaseMeetingReformer.h"
#import "JCPreviewViewController.h"

#import "JCScreenShareViewController.h"
#import "JCSplitScreenViewController.h"
#import "JCWhiteBoardViewController.h"

#import "JCStatisticsViewController.h"
#import "JCMenuViewController.h"
#import "MJPopTool.h"
#import "UIButton+MenuTitleSpacing.h"

#import "YCMeetingDesktopController.h"
#import "YCVideoController.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height


#import "CGMeeting.h"
#import "YCMeetingBiz.h"
#import "YCMeetingRoomMembersController.h"

//#define kVideoViewHeight (kMainScreenWidth/16.0*9) // splitScreenViewController的高度
#define kVideoViewHeight (kMainScreenHeight/2) // splitScreenViewController的高度
#define kTabBarHeight 40
#define kBtnLineHeight 2
#define kWelcomeLabelHeight 26

NSString * const kCoursewareJuphoon = @"COURSEWARE_JUPHOON";
NSString * const kCoursewareMath = @"COURSEWARE_MATH";
NSString * const kCoursewarePhysics = @"COURSEWARE_PHYSICS";

#pragma mark - 命令

// - (int)sendData:(NSString *)key content:(NSString *)content toReceiver:(NSString *)userId;
// - (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId;

// 命令 key
//NSString * const kJCCommandType = @"JC_Command_Type";

// 申请互动
NSString * const kkYCRequestInteractionKey = @"YC_Request_Interacton";
// 允许互动。发送命令后要发送 kkYCUpdateStatesKey 命令
NSString * const kkYCAllowInteractionKey = @"YC_Allow_Interaction";
// 结束互动。发送命令后要发送 kkYCUpdateStatesKey 命令
NSString * const kkYCEndInteractionKey = @"YC_End_Interaction";
// 查询状态。加入成功或者有人加入会议时调用。然后收到命令时要发送 kkYCUpdateStatesKey 命令
NSString * const kkYCQueryStateKey = @"YC_Query_State";
// 更新状态。返回所有人的互动状态
NSString * const kkYCUpdateStatesKey = @"YC_Update_States";

//请求发言
NSString * const kkYCRequestSpeak = @"YC_REQUEST_SPEAK";
NSString * const kkYCAgreeSpeak = @"YC_AGREE_SPEAK";
NSString * const kkYCDisagreeSpeak = @"YC_DISAGREE_SPEAK";

//请求涂鸦
NSString * const kkYCRequestDoodle = @"YC_REQUEST_DOODLE";
NSString * const kkYCAgreeDoodle = @"YC_AGREE_DOODLE";
NSString * const kkYCDisagreeDoodle = @"YC_DISAGREE_DOODLE";


// 显示相关界面
typedef enum {
    ShowNone = 0,
    ShowSplitScreen,            // 分屏界面
    ShowScreenShare,            // 屏幕共享界面
    ShowDoodle                  // 涂鸦界面
} ShowMode;

@interface RoomViewController ()<BaseMeetingDelegate, JCScreenShareDelegate, JCDoodleDelegate, ConferenceToolBarDelegate, MenuDelegate, JCEngineDelegate>
//{
//    JCBaseMeetingReformer *_meetingReformer;
    
//    JCEngineManager *_confManager;
//
//    NSMutableArray *_showModeArray; //用于管理当前大窗口的显示内容，采用栈管理的方式
//
//    NSArray<UIButton *> *_buttons;

//    NSString *_doodleShareUserId; //当前发起涂鸦的成员

//    BOOL _isDoodle;
//    BOOL _isInfo;
//
//    int _count;
//    long _confNumber;
//}

@property (nonatomic,strong) JCBaseMeetingReformer *meetingReformer;
@property (nonatomic,strong) JCEngineManager *confManager;
@property (nonatomic,strong) NSMutableArray *showModeArray; //用于管理当前大窗口的显示内容，采用栈管理的方式
@property (nonatomic,strong) NSArray<UIButton *> *buttons;
@property (nonatomic,strong) NSString *doodleShareUserId; //当前发起涂鸦的成员
@property (nonatomic,assign) BOOL isDoodle;
@property (nonatomic,assign) BOOL isInfo;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) long confNumber;

@property (nonatomic,assign) ZUINT confID; // 加入成功后拿到，底层 API 会用到。和 conferenceNumber 不同





@property (weak, nonatomic) IBOutlet UIView *waitInfoView;                          // 会议等待界面

@property (weak, nonatomic) IBOutlet UIView *mainView;                              // 加入会议后的主View

@property (weak, nonatomic) IBOutlet UIView *preview;                     // 预览窗口

@property (weak, nonatomic) IBOutlet UIView *sidebar;                               // 加入房间后mainView上右边竖排工具栏

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

//@property (weak, nonatomic) IBOutlet ConferenceToolBar *conferenceToolBar;          // 加入会议后mainView上的底部工具栏
@property (strong, nonatomic) ConferenceToolBar *conferenceToolBar;          // 加入会议后mainView上的底部工具栏


@property (nonatomic, strong) JCPreviewViewController *previewViewController;
@property (nonatomic, strong) JCScreenShareViewController *screenShareViewController;
@property (nonatomic, strong) SplitScreenViewController *splitScreenViewController; // 分屏的viewcontroller
@property (nonatomic, strong) JCWhiteBoardViewController *whiteBoardViewController;   // 白板的Viewcontroller

@property (nonatomic, strong) JCMenuViewController *menuViewController;

@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *textLabel;

#pragma mark -

@property (nonatomic,strong) UIView *tabBar; // 中间栏，切换 画板、聊天等
@property (nonatomic,strong) UIButton *whiteBoardTabBtn; // 切换白板
@property (nonatomic,strong) UIButton *chatTabBtn;// 切换 讨论
@property (nonatomic,strong) UIButton *memberTabBtn; // 切换 成员
@property (nonatomic,strong) UIButton *desktopBtn; // 切换 桌面

@property (nonatomic,strong) UIView *btnLine; // 按钮下面的线
@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *myToolBarBtn;// 右上角菜单按钮
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;// 显示会议时长
@property (nonatomic,strong) UIButton *hideKeyboardBtn; // 隐藏键盘的按钮，覆盖全屏

@property (nonatomic,strong) IMAChatViewController *chatVC;
@property (nonatomic,strong) YCMeetingRoomMembersController *membersVC;
@property (nonatomic,strong) YCMeetingDesktopController *desktopVC;

//@property (nonatomic,strong) NSString *charRoomID; // 聊天室 id
@property (nonatomic,strong) CGMeeting *meeting; // 会议详情
//@property (nonatomic,assign) BOOL isAutorotate; // 是否支持自动旋转。白板全屏时支持旋转
@property (nonatomic,assign) BOOL isFullScreen; // 白板是否全屏显示

// 主持人给予的权限
@property (nonatomic,assign) long interactState; // 0 禁止互动，1 允许互动，2 申请互动中
@property (nonatomic,assign) long soundState; // 麦克风
@property (nonatomic,assign) long videoState; // 摄像头

@property (nonatomic,strong) NSTimer *timer; // 会议时间倒计时、welcomeLabel 隐藏倒计时
@property (nonatomic,assign) NSInteger welcomeLabelSeconds;// 默认5秒

@property (weak, nonatomic) IBOutlet UILabel *hintLabel; // 正在加入会议，请稍后。或者提示会议已结束
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn; // 取消按钮
@property (nonatomic,assign) BOOL shouldHiddeStatusBar;

@property (nonatomic,strong) UILabel *welcomeLabel; // 欢迎 xx 加入会议
@property (weak, nonatomic) IBOutlet UILabel *livingLabel;// 直播中、录制中

@property (nonatomic,assign) BOOL isScreening;// 是否正在录屏
@property (nonatomic,assign) BOOL isLiving;// 是否正在直播
@property (nonatomic,strong) NSString *liveUrl;// 直播 url
@property (nonatomic,strong) NSString *fileUrl;// 录屏 url
@property (nonatomic,strong) NSMutableArray<NSString *> *fileUrls; // 录屏文件

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;// 查看回放

@end


@implementation RoomViewController

#pragma mark - Setter and Getter

- (JCPreviewViewController *)previewViewController
{
    if (!_previewViewController) {
        _previewViewController = [[JCPreviewViewController alloc] init];
    }
    return _previewViewController;
}

- (JCScreenShareViewController *)screenShareViewController
{
    if (!_screenShareViewController) {
        _screenShareViewController = [[JCScreenShareViewController alloc] init];
    }
    return _screenShareViewController;
}

- (SplitScreenViewController *)splitScreenViewController
{
    if (!_splitScreenViewController) {
        _splitScreenViewController = [[SplitScreenViewController alloc] init];
    }
    return _splitScreenViewController;
}

- (JCWhiteBoardViewController *)whiteBoardViewController
{
    if (!_whiteBoardViewController) {
        _whiteBoardViewController = [[JCWhiteBoardViewController alloc] init];
        _whiteBoardViewController.meetingID = self.meetingID;
        _whiteBoardViewController.isReview = self.isReview;
        [self setupGesture];
    }
    return _whiteBoardViewController;
}

- (JCMenuViewController *)menuViewController
{
    if (!_menuViewController) {
        _menuViewController = [[JCMenuViewController alloc] init];
    }
    return _menuViewController;
}

// 白板结束共享按钮
- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:221.0/255.0 blue:40.0/255.0 alpha:1.0];
        [_stopButton setImage:[UIImage imageNamed:@"screen_share_close"] forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:@"screen_share_close_highlighted"] forState:UIControlStateHighlighted];
        [_stopButton setTitle:@"结束白板共享" forState:UIControlStateNormal];
        _stopButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_stopButton setFrame:CGRectMake((kMainScreenHeight - 150) / 2, 0 , 150, 40)];
        [_stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stopButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
        [_stopButton addTarget:self action:@selector(closeDoodle) forControlEvents:UIControlEventTouchUpInside];
        
        UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:_stopButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(40, 40)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _stopButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _stopButton.layer.mask = maskLayer;
    }
    return _stopButton;
}

#pragma mark - Life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setMaxCapacity:16];
//        [_confManager setJoinMode:JoinModeAudio];

        _meetingReformer = [[JCBaseMeetingReformer alloc] init];
        
        _showModeArray = [NSMutableArray array];
        
        _doodleShareUserId = nil;
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"RoomViewController dealloc");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [self removeKeyboardObserver];
    [self removeObserverForHowlingDetectedNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoBtn.hidden = YES; // 拿到播放地址再显示
    if (self.isReview) {
        [self getVideos];
    }
    
    _conferenceToolBar = [ConferenceToolBar bar];
    [_mainView addSubview:_conferenceToolBar];

    // Do any additional setup after loading the view from its nib.
    
    // 监听加入成功，拿到真正的 confid，调用底层 API 要用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJoinOkNotification:) name:@MtcConfJoinOkNotification object:nil];
    
    // 音频干扰
    [self addObserverForHowlingDetectedNotification];
    
    //防止自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _conferenceToolBar.delegate = self;
//    _conferenceToolBar.buttons[0].selected = YES;
    
    self.menuViewController.delegate = self;
    
    _buttons = self.menuViewController.menuView.buttons;
    _buttons[MenuButtonTypeShare].enabled = NO;
    _buttons[MenuButtonTypeShare].alpha = 0.5;
    
    _preview.backgroundColor = [UIColor blackColor];
    
    [self addChildViewController:self.previewViewController];
    [_preview addSubview:self.previewViewController.view];
    self.previewViewController.view.frame = _preview.bounds;
    
    [self addChildViewController:self.screenShareViewController];
    [_preview addSubview:self.screenShareViewController.view];
    self.screenShareViewController.view.frame = _preview.bounds;
    self.screenShareViewController.delegate = self;
    
    [self addChildViewController:self.splitScreenViewController];
    [_preview addSubview:self.splitScreenViewController.view];
    self.splitScreenViewController.view.frame = _preview.bounds;
    
    [self addChildViewController:self.whiteBoardViewController];
    [_preview addSubview:self.whiteBoardViewController.view];
    self.whiteBoardViewController.view.frame = _preview.bounds;
//    self.whiteBoardViewController.view.layer.borderWidth = 4;
//    self.whiteBoardViewController.view.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:221.0/255.0 blue:40.0/255.0 alpha:1.0].CGColor;
    [self.whiteBoardViewController.view addSubview:self.stopButton];
    
    //    Zmf_VideoCaptureListenRotation(0, 90);
    //    Zmf_VideoRenderListenRotation(0, 90);
    //    Zmf_VideoScreenOrientation(270);
    
    // 设置涂鸦的代理
    [JCDoodleManager setDelegate:self];
    
    [_confManager setDelegate:self];
    
    _meetingReformer.delegate = self;
    
    [_confManager setMaxCapacity:16];
    [_confManager setDefaultAudio:YES]; // 默认打开音频
    [_confManager setLiveEnable:YES]; // 直播
    [_confManager setCdnUrl:@"rtmp://17390.livepush.myqcloud.com/live/17390_b01d76b4f1fc11e792905cb9018cf0d4?bizid=17390"];
    
    
    
    
    [self configForCustom]; // 自定义
    
    
    
    
    
    self.hintLabel.textColor = [UIColor whiteColor];

    
//    [self joinRoom];
    
//    [self configForCustom];
    
}

- (void)joinRoom {
    // 0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
    if (self.meetingState == 3) {
        self.cancelBtn.hidden = YES;
        self.hintLabel.text = @"会议已结束";
        return;
    }
    
    [self.whiteBoardTabBtn sendActionsForControlEvents:UIControlEventTouchUpInside];

    if (self.meetingState == 0) {
        self.cancelBtn.hidden = YES;
        self.hintLabel.text = @"会议未开始";
        [self.memberTabBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        return;
    }


    BOOL ret = [_meetingReformer joinWithRommId:self.meeting.conferenceNumber displayName:_displayName];
    
    if (!ret) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"join failed", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[MJPopTool sharedInstance] closeAnimated:YES];
                _doodleShareUserId = nil;
                [JCDoodleManager stopDoodle];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutViewControllers];
    [self layoutTabBar];
    self.hideKeyboardBtn.frame = self.view.bounds;
    
    float y = kVideoViewHeight - kWelcomeLabelHeight;
    self.welcomeLabel.frame = CGRectMake(0, y, kMainScreenWidth, kWelcomeLabelHeight);
    self.welcomeLabel.hidden = YES;
    self.welcomeLabel = nil;

    self.conferenceToolBar.frame = self.view.bounds;
}


#pragma  mark - JCEngineDelegate
- (void)onParticipantJoin:(NSString *)userId {
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 文档翻页
//        [JCDoodleManager selectPage:self.whiteBoardViewController.currentPage];
//    });
    [self updateMemberBtn];
    
    
//    if ([self isMeetingCreator:nil]) {
//        [self.membersVC sendQueryInteractionStateCommand];
//    }
    [self.membersVC getMeetingUser];
    
    // 欢迎 xx
    NSInteger index = [self.meeting.meetingUserList indexOfObjectPassingTest:^BOOL(YCMeetingUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userid isEqualToString:userId]) {
            *stop = YES;
            return YES;
        } else {
            return NO;
        }
    }];
    NSString *name;
    if (index != NSNotFound) {
        name = self.meeting.meetingUserList[index].userName;
    } else {
        name = userId;
    }
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"   欢迎 %@ 加入会议", name];
    self.welcomeLabel.hidden = NO;
    self.welcomeLabelSeconds = 5;
}

- (void)onParticipantLeft:(ErrorReason)errorReason userId:(NSString *)userId {
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
    [self updateMemberBtn];
    
//     更新服务器并且群发命令
//    [self.membersVC onUserLeft:userId];
    [self.membersVC getMeetingUser];
}

#pragma mark - BaseMeetingDelegate

- (void)joinSuccess
{
    _waitInfoView.hidden = YES; //隐藏会议等待view
    _mainView.hidden = NO; //显示加入会议后的主view
    
    _confNumber = [_confManager getConfNumber];
    
//    if (_doodleShareUserId) {
//        return;
//    }
    
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
    
    //更新界面
    [self showCurrentShowMode:ShowSplitScreen];
    [self updateTitleBtn];
    [self updateMemberBtn];
    
    // 麦克风
//    UIButton *soundBtn = self.conferenceToolBar.buttons[ConferenceToolBarButtonMicrophone];
    UIButton *soundBtn = self.conferenceToolBar.microphoneBtn;
    __weak typeof(self) weakself = self;
    int success = [_meetingReformer setAudioEnabled:YES completion:^(BOOL isAudioEnabled) {
        [weakself.membersVC reloadTableView];
    }];
    if (success == JCOK) {
        soundBtn.selected = YES;
        [weakself.conferenceToolBar updateLabels];
    }

    [self.whiteBoardViewController checkCurrentMeetingFile];
//    [self.membersVC reloadTableView];
    
//    [self test2];
}

- (void)joinFailedWithReason:(ErrorReason)reason
{
    NSString *message = [YCJCSDKHelper errorStringOfErrorCode:reason];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"join failed", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leaveWithReason:(ErrorReason)reason
{
    
    [self.timer invalidate];
    self.timer = nil;
    
    // 更新服务器的状态
    // 内存泄露，要 weak
    __weak typeof(self) weakself = self;

    [[YCMeetingBiz new]meetingUserWithMeetingID:weakself.meetingID userId:[ObjectShareTool currentUserID] soundState:nil videoState:nil interactionState:nil compereState:nil userState:@"0" userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        
    } fail:^(NSError *error) {
        
    }];

    if (reason == ErrorEndOffline) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"offline" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self stopAllRender];
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self stopAllRender];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)onParticipantStateUpdated {
    [self.membersVC reloadTableView];
}

#pragma mark - ScreenShareDelegate

- (void)screenShareStart
{
    //有成员发起屏幕共享，涂鸦发起按钮不可按
    UIButton *doodleButton = _menuViewController.menuView.buttons[MenuButtonTypeDoodle];
    doodleButton.enabled = NO;
    doodleButton.alpha = 0.5;
    
    _buttons[MenuButtonTypeShare].enabled = YES;
    _buttons[MenuButtonTypeShare].alpha = 1.0;
    
    [self showCurrentShowMode:ShowScreenShare];
}

- (void)screenShareStop
{
    //有成员发起屏幕共享，涂鸦发起按钮不可按
    UIButton *doodleButton = _menuViewController.menuView.buttons[MenuButtonTypeDoodle];
    doodleButton.enabled = YES;
    doodleButton.alpha = 1.0;
    
    _buttons[MenuButtonTypeShare].enabled = NO;
    _buttons[MenuButtonTypeShare].alpha = 0.5;
    
    _buttons[MenuButtonTypeShare].layer.borderWidth = 0;
    _buttons[MenuButtonTypeShare].layer.cornerRadius = 0;
    
    _buttons[MenuButtonTypeVideo].layer.borderWidth = 3;
    _buttons[MenuButtonTypeVideo].layer.cornerRadius = 2;
    _buttons[MenuButtonTypeVideo].layer.borderColor = [_menuViewController colorWithHexString:@"#03a9f4"].CGColor;
    
    //如果当前大窗口显示屏幕共享
    if ([self getCurrentShowMode] == ShowScreenShare) {
        [self cancelCurrentShowMode];
    }
}

#pragma mark - JCDoodleDelegate

- (void)receiveActionType:(JCDoodleActionType)type doodle:(JCDoodleAction *)doodle fromSender:(NSString *)userId
{
    if (type == JCDoodleActionStart) { //收到开始涂鸦
        
        //更新当前发起涂鸦的成员
        _doodleShareUserId = userId;
        
        NSString *ownUserId = [[JCEngineManager sharedManager] getOwnUserId];
        if (!ownUserId) {
            ownUserId = [ObjectShareTool currentUserID];
        }
        //如果是自己发起
        if ([userId isEqualToString:ownUserId]) {
            
        } else {
            self.stopButton.enabled = NO;
            self.stopButton.alpha = 0.5;
        }
        
        [self showCurrentShowMode:ShowDoodle];
        
    } else if (type == JCDoodleActionStop) { //收到结束涂鸦
        //如果当前大窗口显示涂鸦
        if ([self getCurrentShowMode] == ShowDoodle) {
            [self cancelCurrentShowMode];
        }
        
        [_whiteBoardViewController cleanAllPath]; //清除轨迹
        self.stopButton.enabled = YES;
        self.stopButton.alpha = 1.0;
        _isDoodle = NO;
        
        _buttons[MenuButtonTypeDoodle].layer.borderWidth = 0;
        _buttons[MenuButtonTypeDoodle].layer.cornerRadius = 0;
        
        _buttons[MenuButtonTypeVideo].layer.borderWidth = 3;
        _buttons[MenuButtonTypeVideo].layer.cornerRadius = 2;
        _buttons[MenuButtonTypeVideo].layer.borderColor = [_menuViewController colorWithHexString:@"#03a9f4"].CGColor;
        
        //更新当前发起涂鸦的成员
        _doodleShareUserId = nil;
    } else if (type == JCDoodleActionCourseware) { // 修改课件
        [self handleCoursewareChange];

    }
}

#pragma mark - ConferenceToolBarDelegate 工具栏
- (void)conferenceToolBar:(ConferenceToolBar *)toolBar
              clickButton:(UIButton *)button
               buttonType:(ConferenceToolBarButtonType)type
{
    switch (type) {
            // 视频
        case ConferenceToolBarButtonVideo:
        {
            BOOL selected = !button.isSelected;
            if (selected == YES && self.videoState == 0) {
                [CTToast showWithText:@"全员禁频中"];
                return;
            }
            int success = [_meetingReformer setVideoEnabled:selected completion:^(BOOL isVideoEnabled) {
                button.selected = isVideoEnabled;
            }];
            if (success == JCOK) {
                button.selected = selected;
            } else {
                [CTToast showWithText:@"更改视频状态失败"];
            }
            break;
        }
            
            // 切换摄像头
        case ConferenceToolBarButtonCamera:
        {
            [_meetingReformer switchCamera];
            break;
        }
            
            // 外放
        case ConferenceToolBarButtonVolume:
        {
            BOOL selected = !button.isSelected;
            [_meetingReformer setMuteEnabled:selected];
            button.selected = selected;
            break;
        }
            
            // 麦克风，语音
        case ConferenceToolBarButtonMicrophone:
        {
            BOOL selected = !button.isSelected;
            if (selected == YES && self.soundState == 0) {
                [CTToast showWithText:@"全员禁音中"];
                return;
            }
            __weak typeof(self) weakself = self;
            // completion 可能不执行
            int success = [_meetingReformer setAudioEnabled:selected completion:^(BOOL isAudioEnabled) {
                [YCMeetingRoomMembersController sendUpdateStatesCommandWithMeetingID:weakself.meetingID];
                [weakself.membersVC reloadTableView];
            }];
            if (success == JCOK) {
                button.selected = selected;
            } else {
                [CTToast showWithText:@"更改麦克风状态失败"];
            }
            break;
        }
            
        case ConferenceToolBarButtonREC:
        {
            [self clickVedioControlBtn:button];
            break;
        }
            
        case ConferenceToolBarButtonLive:
        {
            [self clickLivingBtn:button];
            break;
        }
            
        case ConferenceToolBarButtonChange:
        {
            break;
        }
            
        case ConferenceToolBarButtonEnd:
        {
            [self finishMeeting];
            break;
        }

        default:
            break;
    }
}

#pragma mark - menu delegate
- (void)showVideo:(JCMenuView *)menuView {
    if ([self getCurrentShowMode] == ShowSplitScreen) {
        return;
    }
    
    if ([self getCurrentShowMode] == ShowDoodle) {
        _isDoodle = YES;
    }
    
    [self cancelCurrentShowMode];
}

- (void)showDoodle:(JCMenuView *)menuView {
    
    if ([self getCurrentShowMode] == ShowDoodle) {
        return;
    }
    
    if ([self getCurrentShowMode] == ShowSplitScreen && _isDoodle) {
        [self showCurrentShowMode:ShowDoodle];
        return;
    }
    
    [JCDoodleManager startDoodle];
}

- (void)closeDoodle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sure to quit doodle", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JCDoodleManager stopDoodle];
    }];
    [alert addAction:action];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showShareScreen {
    if ([self getCurrentShowMode] == ShowScreenShare) {
        return;
    }
    [self showCurrentShowMode:ShowScreenShare];
}

#pragma mark - Button action

// 取消加入会议事件
- (IBAction)cancel:(id)sender {
    
    [self.timer invalidate];
    self.timer = nil;
    
    // 点击按钮输出： 0 -[JCEngineManager leave] no confEngine ，界面不消失
    int success = [_meetingReformer leave];
    if (success != JCOK) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    [self removeKeyboardObserver];
//    [self removeObserverForHowlingDetectedNotification];
}

// 会议信息
- (IBAction)showInfo:(id)sender
{
    if (_isInfo) {
        [[MJPopTool sharedInstance] closeAnimated:YES];
    } else {
        
        UIFont *font = [UIFont boldSystemFontOfSize:12];
        
        NSDictionary *dic = @{NSFontAttributeName : font};
        NSString *info = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
        
        CGRect textRect = [info boundingRectWithSize:CGSizeMake(MAXFLOAT, 24) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, textRect.size.width + 24, 24)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = font;
        _textLabel.text = info;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth - (_textLabel.frame.size.width + 65), kMainScreenHeight - (kMainScreenHeight - 25), _textLabel.frame.size.width, _textLabel.frame.size.height)];
        
        contentView.backgroundColor = [UIColor colorWithRed:0.0
                                                      green:0.0f
                                                       blue:0.0f
                                                      alpha:0.7f];
        [contentView addSubview:_textLabel];
        
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [[MJPopTool sharedInstance] popView:contentView animated:YES];
    }
    _isInfo = !_isInfo;
}

// 功能菜单
- (IBAction)showMenu:(id)sender
{
    if ([self getCurrentShowMode] == ShowDoodle) {
        
        _buttons[MenuButtonTypeVideo].layer.borderWidth = 0;
        _buttons[MenuButtonTypeVideo].layer.cornerRadius = 0;
        
        _buttons[MenuButtonTypeDoodle].layer.borderWidth = 3;
        _buttons[MenuButtonTypeDoodle].layer.cornerRadius = 2;
        _buttons[MenuButtonTypeDoodle].layer.borderColor = [_menuViewController colorWithHexString:@"#03a9f4"].CGColor;
    } else if ([self getCurrentShowMode] == ShowScreenShare) {
        
        _buttons[MenuButtonTypeVideo].layer.borderWidth = 0;
        _buttons[MenuButtonTypeVideo].layer.cornerRadius = 0;
        
        _buttons[MenuButtonTypeShare].layer.borderWidth = 3;
        _buttons[MenuButtonTypeShare].layer.cornerRadius = 2;
        _buttons[MenuButtonTypeShare].layer.borderColor = [_menuViewController colorWithHexString:@"#03a9f4"].CGColor;
    } else {
        _buttons[MenuButtonTypeVideo].layer.borderWidth = 3;
        _buttons[MenuButtonTypeVideo].layer.cornerRadius = 2;
        _buttons[MenuButtonTypeVideo].layer.borderColor = [_menuViewController colorWithHexString:@"#03a9f4"].CGColor;
    }
    
    [self presentViewController:_menuViewController animated:YES completion:nil];
}

// 离开房间
- (IBAction)leave:(id)sender {
    if (!self.meeting.ycIsCompere) {
        // 成员退出
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sure to quit", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[MJPopTool sharedInstance] closeAnimated:YES];
            _doodleShareUserId = nil;
            [JCDoodleManager stopDoodle];
            //        [_meetingReformer leave];
            
//            if (self.isScreening) {
//                [self endScreen:nil];
//            }

            [self cancel:nil];
            
            // 更新服务器的状态
            [[YCMeetingBiz new]meetingUserWithMeetingID:self.meetingID userId:[ObjectShareTool currentUserID] soundState:nil videoState:nil interactionState:nil compereState:nil userState:@"0" userAdd:nil userDel:nil success:^(YCMeetingState *state) {
                
            } fail:^(NSError *error) {
                
            }];
        }];
        [alert addAction:action];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        // 主持人退出
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"退出还是结束会议？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *finish = [UIAlertAction actionWithTitle:@"结束" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self finishMeeting];
        }];
        
        UIAlertAction *quit = [UIAlertAction actionWithTitle:@"退出" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.timer invalidate];
            self.timer = nil;
            
            [[MJPopTool sharedInstance] closeAnimated:YES];
            _doodleShareUserId = nil;
            [JCDoodleManager stopDoodle];
            //        [_meetingReformer leave];
            
            if (self.isScreening) {
                [self endScreen:nil];
            }
            if (self.isLiving) {
                [self endLiving:nil];
            }


            [self cancel:nil];
            
            // 更新服务器的状态
            // 内存泄露，要 weak
            __weak typeof(self) weakself = self;
            [[YCMeetingBiz new]meetingUserWithMeetingID:weakself.meetingID userId:[ObjectShareTool currentUserID] soundState:nil videoState:nil interactionState:nil compereState:nil userState:@"0" userAdd:nil userDel:nil success:^(YCMeetingState *state) {
                
            } fail:^(NSError *error) {
                
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler: nil];
        [ac addAction:cancel];
        [ac addAction:finish];
        [ac addAction:quit];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

//显示统计
- (IBAction)showStats:(id)sender
{
    [[MJPopTool sharedInstance] closeAnimated:YES];
    JCStatisticsViewController *statsVc = [[JCStatisticsViewController alloc] init];
    [self presentViewController:statsVc animated:YES completion:nil];
}


#pragma mark - private function

//获取当前大窗口显示的内容
- (ShowMode)getCurrentShowMode
{
    return [[_showModeArray lastObject] intValue];
}

- (void)showCurrentShowMode:(ShowMode)mode
{
    [_showModeArray addObject:[NSNumber numberWithInt:mode]];
    [self showMode:mode];
}

//取消当前大窗口显示的内容
- (void)cancelCurrentShowMode
{
    [_showModeArray removeLastObject];
    
    int mode = [[_showModeArray lastObject] intValue];
    
    [self showMode:mode];
}

//设置当前大窗口显示的内容
- (void)showMode:(ShowMode)mode
{
//        [_previewViewController stopShowPreview];
    //    _previewViewController.view.hidden = YES;
    //    [_splitScreenViewController stopShowSplitSreenView];
    //    _splitScreenViewController.view.hidden = YES;
    //    [_screenShareViewController stopScreenShare];
    //    _screenShareViewController.view.hidden = YES;
    //    _whiteBoardViewController.view.hidden = YES;
    
    switch (mode) {
        case ShowSplitScreen:               // 分屏界面
            [self showSplitScreenUI];
            break;
        case ShowScreenShare:               // 屏幕共享界面
            [self showScreenShareUI];
            break;
        case ShowDoodle:                    // 涂鸦界面
            [self showDoodleUI];
            break;
        default:
            [self showSplitScreenUI];
            break;
    }
}

//显示分屏的视频
- (void)showSplitScreenUI
{
    //显示分屏的视频
    _splitScreenViewController.view.hidden = NO;
    [_splitScreenViewController reloadSplitSreenView];
    
//    _conferenceToolBar.hidden = NO;
}

//显示屏幕共享
- (void)showScreenShareUI
{
    _screenShareViewController.view.hidden = NO;
    [_screenShareViewController reloadScreenShare];
    
//    _conferenceToolBar.hidden = NO;
}

//显示涂鸦
- (void)showDoodleUI
{
    _whiteBoardViewController.view.hidden = NO;
    
//    _conferenceToolBar.hidden = YES;
}

- (void)stopAllRender
{
    //必须在会议结束（会议界面释放时）要释放各个模块的资源
    [_previewViewController stopShowPreview];
    [_screenShareViewController stopScreenShare];
    [_splitScreenViewController stopShowSplitSreenView];
}

#pragma mark - yc_Layout

- (void)layoutViewControllers {
    float height = self.view.frame.size.height - kTabBarHeight;
    
//    float kVideoViewHeight = kMainScreenWidth/2.0/16*9;
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth, height);
    self.splitScreenViewController.view.frame = frame;
    
//    float y = kVideoViewHeight + kTabBarHeight;
    self.chatVC.view.frame = frame;
    self.desktopVC.view.frame = frame;
    self.membersVC.view.frame = frame;
    
    // 白板全屏的时候，允许自动旋转
    if (self.isFullScreen) {
        self.whiteBoardViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    } else {
        self.whiteBoardViewController.view.frame = frame;
    }
    
//    [UIView animateWithDuration:0.26 animations:^{
//        // 白板全屏的时候，允许自动旋转
//        if (self.isFullScreen) {
//            self.whiteBoardViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
//        } else {
//            self.whiteBoardViewController.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
//        }
//    }];

}

- (void)layoutTabBar {
    float y = self.view.frame.size.height - kTabBarHeight;

    self.tabBar.frame = CGRectMake(0, y, kMainScreenWidth, kTabBarHeight);
    
//    float btnWidth = kMainScreenWidth / 4;
    float btnWidth = kMainScreenWidth / 3;
    self.whiteBoardTabBtn.frame = CGRectMake(0, 0, btnWidth, kTabBarHeight);
//    self.desktopBtn.frame = CGRectMake(btnWidth * 1, 0, btnWidth, kTabBarHeight);
    self.chatTabBtn.frame = CGRectMake(btnWidth * 1, 0, btnWidth, kTabBarHeight);
    self.memberTabBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, kTabBarHeight);
    
    CGRect frame = self.btnLine.frame;
    frame.origin.y = kTabBarHeight - kBtnLineHeight;
    frame.size = CGSizeMake(btnWidth, kBtnLineHeight);
    self.btnLine.frame = frame;
    
    UIImageView *iv = [self.tabBar viewWithTag:999];
    iv.frame = CGRectMake(0, self.tabBar.size.height-1, self.tabBar.size.width, 1);
}

- (void)layoutBtnLine:(UIButton *)btn {
    CGRect frame = self.btnLine.frame;
    frame.origin.x = btn.frame.origin.x;
    frame.origin.y = btn.frame.size.height - kBtnLineHeight;
    self.btnLine.frame = frame;
}

#pragma mark - yc_Setup

- (void)setupTarBar {
    self.btnLine = [UIView new];
    self.btnLine.backgroundColor = TEXT_MAIN_CLR;
    
    self.whiteBoardTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.desktopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.memberTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.whiteBoardTabBtn.selected = YES;
    
    [self.whiteBoardTabBtn addTarget:self action:@selector(whiteBoardTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.desktopBtn addTarget:self action:@selector(desktopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.chatTabBtn addTarget:self action:@selector(chatTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.memberTabBtn addTarget:self action:@selector(memberTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whiteBoardTabBtn setTitle:@"白板" forState:UIControlStateNormal];
    [self.desktopBtn setTitle:@"桌面" forState:UIControlStateNormal];
    [self.chatTabBtn setTitle:@"讨论" forState:UIControlStateNormal];
    [self.memberTabBtn setTitle:@"成员" forState:UIControlStateNormal];
    
    UIFont *font= [UIFont systemFontOfSize:15];
    self.whiteBoardTabBtn.titleLabel.font = font;
    self.desktopBtn.titleLabel.font = font;
    self.chatTabBtn.titleLabel.font = font;
    self.memberTabBtn.titleLabel.font = font;

    UIColor *colorS = TEXT_MAIN_CLR;
    [self.whiteBoardTabBtn setTitleColor:colorS forState:UIControlStateSelected];
    [self.desktopBtn setTitleColor:colorS forState:UIControlStateSelected];
    [self.chatTabBtn setTitleColor:colorS forState:UIControlStateSelected];
    [self.memberTabBtn setTitleColor:colorS forState:UIControlStateSelected];
    
    UIColor *colorN = TEXT_GRAY_CLR;
    [self.whiteBoardTabBtn setTitleColor:colorN forState:UIControlStateNormal];
    [self.desktopBtn setTitleColor:colorN forState:UIControlStateNormal];
    [self.chatTabBtn setTitleColor:colorN forState:UIControlStateNormal];
    [self.memberTabBtn setTitleColor:colorN forState:UIControlStateNormal];
    
    // 线
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"work_line_1"]];
    iv.contentMode = UIViewContentModeScaleToFill;
    iv.clipsToBounds = YES;
    iv.tag = 999;

    self.tabBar = [UIView new];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:self.whiteBoardTabBtn];
//    [self.tabBar addSubview:self.desktopBtn];
    [self.tabBar addSubview:self.chatTabBtn];
    [self.tabBar addSubview:self.memberTabBtn];
    [self.tabBar addSubview:self.btnLine];
    [self.tabBar addSubview:iv];
    
    [self.preview addSubview:self.tabBar];
}

- (void)setupHideKeyboardBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:self.view.bounds];
        btn.backgroundColor = [UIColor clearColor];
//    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    self.hideKeyboardBtn = btn;
}

- (void)setupTitleBtn {
    [self.titleBtn.superview bringSubviewToFront:self.titleBtn];
    [self.titleBtn setTitle:@" 0分钟 " forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIImage *image = [UIImage imageNamed:@"video_block"];
//    float inset = image.size.height;
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, inset, 0, inset)];
//    [self.titleBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.titleBtn.backgroundColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:63.0/255 alpha:0.22];
    self.titleBtn.layer.cornerRadius = self.titleBtn.frame.size.height/2;
    self.titleBtn.clipsToBounds = YES;

}

- (void)setupTimer {
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        self.timer = timer;
        [timer fire];
    }
}

- (void)setupWelcomeLabel {
    UILabel *label = [UILabel new];
    self.welcomeLabel = label;
    [self.preview addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    label.text = @"   欢迎进入会议室";
    label.backgroundColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:63.0/255 alpha:0.22];

}

- (void)handleTimer {
    NSString *title = [YCTool countDonwStringWithTargetDate:self.meeting.endTime.longLongValue / 1000];
    title = [NSString stringWithFormat:@"  %@  ", title];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    
    // 欢迎 xx
    if (self.welcomeLabel.hidden == NO) {
        self.welcomeLabel.hidden = self.welcomeLabelSeconds <= 0? YES: NO;
        self.welcomeLabelSeconds --;
    }
}

#pragma mark - yc_Action

- (void)whiteBoardTabBtnClick {
    self.whiteBoardViewController.view.hidden = !self.whiteBoardViewController.view.isHidden;
    self.desktopVC.view.hidden = YES;
    self.chatVC.view.hidden = YES;
    self.membersVC.view.hidden = YES;

    self.whiteBoardTabBtn.selected = !self.whiteBoardTabBtn.isSelected;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = NO;
    self.memberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.whiteBoardTabBtn];
    
    [self.view endEditing:YES];
    
//    [self.tabBar sendSubviewToBack:self.whiteBoardTabBtn];
}

- (void)desktopBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    self.desktopVC.view.hidden = NO;
    self.chatVC.view.hidden = YES;
    self.membersVC.view.hidden = YES;
    
    self.whiteBoardTabBtn.selected = NO;
    self.desktopBtn.selected = YES;
    self.chatTabBtn.selected = NO;
    self.memberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.desktopBtn];
    [self.view endEditing:YES];

}

- (void)chatTabBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    self.desktopVC.view.hidden = YES;
    self.chatVC.view.hidden = !self.chatVC.view.isHidden;
    self.membersVC.view.hidden = YES;

    self.whiteBoardTabBtn.selected = NO;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = !self.chatTabBtn.isSelected;
    self.memberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.chatTabBtn];
    [self.view endEditing:YES];
    
    [self showRedPoint:NO];
//    [self.tabBar sendSubviewToBack:self.chatTabBtn];
}

- (void)memberTabBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    self.desktopVC.view.hidden = YES;
    self.chatVC.view.hidden = YES;
    self.membersVC.view.hidden = !self.membersVC.view.isHidden;

    self.whiteBoardTabBtn.selected = NO;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = NO;
    self.memberTabBtn.selected = !self.memberTabBtn.isSelected;
    
    [self layoutBtnLine:self.memberTabBtn];
    [self.view endEditing:YES];
    
//    [self.tabBar sendSubviewToBack:self.menuButton];
    [self.membersVC reloadTableView];
}

- (IBAction)myToolBarBtnClick:(UIButton *)sender {
//    self.myBackBtn.hidden = !self.myBackBtn.hidden;
    self.conferenceToolBar.hidden = !self.conferenceToolBar.hidden;
}

- (void)handleJoinOkNotification:(NSNotification *)noti {
    ZUINT confId = [noti.userInfo[@MtcConfIdKey] unsignedIntValue];
    self.confID = confId;
    self.desktopVC.confID = confId;
}

#pragma mark - yc_Data

// 获取群信息
- (void)getGroupWithGroupID:(NSString *)groupId {
    if (!groupId) {
        [CTToast showWithText:@"获取群信息失败: 群id为空"];
        return;
    }
    
    NSMutableArray * groupList = [[NSMutableArray alloc] init];
    //    [groupList addObject:@"TGID1JYSZEAEQ"];
    [groupList addObject:groupId];
    
    __weak typeof(self) weakself = self;
    int fail = [[TIMGroupManager sharedInstance] getGroupInfo:groupList succ:^(NSArray * groups) {
        TIMGroupInfo * info = groups.firstObject;
        [weakself addChatViewControllerWith:info];
    } fail:^(int code, NSString* err) {
        [CTToast showWithText: [NSString stringWithFormat:@"获取群信息失败 %d %@ groupId:%@", code, err, groupId]];
    }];
    
    if (fail) {
        [CTToast showWithText:@"获取群信息失败， 可能聊天功能未登录"];
    }
}

// 会议详情
- (void)getMeetingDetail {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingDetailWithMeetingID:weakself.meetingID success:^(CGMeeting *meeting) {
        weakself.meeting = meeting;
        
        [weakself joinRoom];
        
        // 获取群聊
        [weakself getGroupWithGroupID:weakself.meeting.groupId];
        // 成员
        [weakself addMembersControllerWithUsers:meeting.meetingUserList];
        [weakself updateTitleBtn];
        [weakself updateMemberBtn];
        [weakself setupTimer];
        weakself.desktopVC.meeting = meeting;
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"获取会议详情失败 : %@", error]];
    }];
}


#pragma mark - 成员

- (void)addMembersControllerWithUsers:(NSArray *)users {
//    return;
    
    self.membersVC = [YCMeetingRoomMembersController new];
//    self.membersVC.users = users;
    self.membersVC.meetingCreatorID = self.meeting.ycCompereID;
    self.membersVC.meetingID = self.meetingID;
    self.membersVC.isMeetingCreator = self.meeting.ycIsCompere;
    self.membersVC.isReview = self.isReview;
    
    __weak typeof(self) weakself = self;

    self.membersVC.q = self.q;
//    self.membersVC.AccessKey = self.AccessKey;
//    self.membersVC.BucketName = self.BucketName;
//    self.membersVC.SecretKey = self.SecretKey;

    // 检查是否主持人
    self.membersVC.onGetMeetingDateSuccessBlock = ^(BOOL isMeetingCreator) {
        if (isMeetingCreator) {
            weakself.conferenceToolBar.contentViewHeightConstraint.constant = 194;
        } else {
            weakself.conferenceToolBar.contentViewHeightConstraint.constant = 97;
        }
    };
    
    // 成员发生改变
    self.membersVC.onMembersChangeBlock = ^(NSArray *users) {
        weakself.meeting.meetingUserList = users.mutableCopy;
        [weakself updateMemberBtn];
    };

    // 会议结束或取消
    self.membersVC.onMeetingStateChangeBlock = ^(int meetingState) {
        if (weakself.isReview) {
            return ;
        }

        weakself.meeting.meetingState = meetingState;
        if (meetingState == 0 || meetingState == 1) {
            return ;
        }

        NSString *title = nil;
        // 会议状态 0:未开始    1：进行中   2：已结束    3：已取消
        if (meetingState == 2) {
            title = @"会议已结束";
        } else if (meetingState == 3) {
            title = @"会议已取消";
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[MJPopTool sharedInstance] closeAnimated:YES];
            weakself.doodleShareUserId = nil;
            [JCDoodleManager stopDoodle];
            [weakself cancel:nil];
        }];
        [ac addAction:sure];
        [weakself presentViewController:ac animated:YES completion:nil];
    };

    // 被移出会议
    self.membersVC.onBeRemoveFromMeetingBlock = ^{
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"您已被主持人移出会议" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[MJPopTool sharedInstance] closeAnimated:YES];
            weakself.doodleShareUserId = nil;
            [JCDoodleManager stopDoodle];
            [weakself cancel:nil];

            // 更新服务器的状态
            [[YCMeetingBiz new]meetingUserWithMeetingID:weakself.meetingID userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:[ObjectShareTool currentUserID] success:^(YCMeetingState *state) {

            } fail:^(NSError *error) {

            }];

        }];
        [ac addAction:sure];
//        [weakself presentViewController:ac animated:YES completion:nil];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    };

    // 自身的权限发生改变
    self.membersVC.onStateChangeBlock = ^(long interactState, long soundState, long videoState) {
        weakself.interactState = interactState;
        weakself.soundState = soundState;
        weakself.videoState = videoState;

        if (interactState > 1) { // 申请互动中
            return ;
        }
        BOOL enable = interactState?YES:NO;
        [weakself.whiteBoardViewController enableDraw:enable];
        [weakself.whiteBoardViewController enableSwitchPage:enable];

        enable = soundState?YES:NO;
//        UIButton *soundBtn = weakself.conferenceToolBar.buttons[ConferenceToolBarButtonMicrophone];
        UIButton *soundBtn = weakself.conferenceToolBar.microphoneBtn;
//        if (enable == NO && soundBtn.isSelected == YES) {
//        if (enable != soundBtn.isSelected) {
//            [soundBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
        if (enable == NO && soundBtn.isSelected == YES) {
            [weakself.meetingReformer setAudioEnabled:enable completion:^(BOOL isAudioEnabled) {
                soundBtn.selected = isAudioEnabled;
                [weakself.conferenceToolBar updateLabels];
            }];
        }

        
        enable = videoState?YES:NO;
//        UIButton *videoBtn = weakself.conferenceToolBar.buttons[ConferenceToolBarButtonVideo];
        UIButton *videoBtn = weakself.conferenceToolBar.videoBtn;
////        if (enable == NO && videoBtn.isSelected == YES) {
//        if (enable != videoBtn.isSelected) {
//            [videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
        if (enable == NO && videoBtn.isSelected == YES) {
            [weakself.meetingReformer setVideoEnabled:enable completion:^(BOOL isVideoEnabled) {
                videoBtn.selected = isVideoEnabled;
                [weakself.conferenceToolBar updateLabels];
            }];
        }

    };
    
    self.membersVC.view.hidden = !self.memberTabBtn.isSelected;
//    [self.preview addSubview:self.membersVC.view];
    [self.preview insertSubview:self.membersVC.view aboveSubview:self.tabBar];
    // 布局
    [self layoutViewControllers];
}

#pragma mark - 桌面

- (void)setupDesktopController {
    YCMeetingDesktopController *vc = [YCMeetingDesktopController new];
    self.desktopVC = vc;
    vc.AccessKey = self.AccessKey;
    vc.SecretKey = self.SecretKey;
    vc.BucketName = self.BucketName;
//    vc.q = self.q;
    vc.view.hidden = YES;
    vc.myNavigationController = self.navigationController;
    [self.preview addSubview:vc.view];
}


#pragma mark - 腾讯云

- (UILabel *)getRedPoint {
    UILabel *label = [self.chatTabBtn viewWithTag:111];
    if (!label) {
//        CGSize size = self.chatTabBtn.bounds.size;
        CGRect btnLabelFrame = self.chatTabBtn.titleLabel.frame;
        float width = 10;
        float x = btnLabelFrame.size.width + btnLabelFrame.origin.x;
        float y = btnLabelFrame.origin.y - width/2.0;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, width)];
        label.layer.cornerRadius = width/2;
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor redColor];
//        label.hidden = YES;
        label.tag = 111;
        [self.chatTabBtn addSubview:label];
    }
    return label;
}

- (void)showRedPoint:(BOOL)show {
    [self getRedPoint].hidden = !show;
//    [self getRedPoint].hidden = NO;
//    NSLog(@"showRedPoint");
}

- (void)onReceiveNewMessage:(NSArray *)messages {
    if (self.chatTabBtn.isSelected) {
        return;
    }
    // 添加小红点
    [self showRedPoint:YES];
}

- (void)addChatViewControllerWith:(TIMGroupInfo *)info {
__weak typeof(self) weakself = self;
    self.chatVC = [self createChatViewControllerWith:info];
    self.chatVC.view.hidden = !self.chatTabBtn.isSelected;
    self.chatVC.onReceiveNewMessage = ^(NSArray *messages) {
        [weakself onReceiveNewMessage:messages];
    };
    [self.preview addSubview:self.chatVC.view];
    // 布局
    [self layoutViewControllers];
}

// 聊天界面
- (IMAChatViewController *)createChatViewControllerWith:(TIMGroupInfo *)info {
    IMAGroup *user = [[IMAGroup alloc] initWithInfo:info];
    
    
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
    vc.view.backgroundColor = [UIColor clearColor];
    vc.tableView.backgroundColor = [UIColor clearColor];
    return vc;
}


#pragma mark - yc_Custom

- (BOOL)isSupportPanReturnBack {
    return NO;
}

- (void)updateTitleBtn {
    NSString *title = [NSString stringWithFormat:@" %@分钟 ", self.meeting.meetingDuration];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateMemberBtn {
    NSString *title = [NSString stringWithFormat:@"成员(%d/%d人) ", self.meeting.onlinePeopleNumber, self.meeting.totalPeopleNumber];
    [self.memberTabBtn setTitle:title forState:UIControlStateNormal];
}

// viewDidLoad 的时候调用
- (void)configForCustom {
    self.videoBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.videoBtn setBackgroundColor:CTThemeMainColor];
    self.videoBtn.layer.cornerRadius = 4;
    self.videoBtn.clipsToBounds = YES;
    
    self.whiteBoardViewController.view.hidden = NO;
    _waitInfoView.hidden = NO; //隐藏会议等待view
    _mainView.hidden = NO; //显示加入会议后的主view

    [self setupTarBar];
//    [self setupDesktopController];

    [self.stopButton removeFromSuperview]; // 结束白板共享按钮
    [self.sidebar removeFromSuperview]; // 右边栏
    
    self.conferenceToolBar.hidden = YES;
//    self.myBackBtn.hidden = YES;
    self.myToolBarBtn.hidden = NO;
    
    [self.preview bringSubviewToFront:self.myBackBtn];
    [self.preview bringSubviewToFront:self.myToolBarBtn];
    
    // 获取会议详情
    [self getMeetingDetail];

    [self addKeyboardObserver];
    [self setupHideKeyboardBtn];
    
    [self setupTitleBtn];
    [self updateTitleBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.preview.backgroundColor = [UIColor whiteColor];
    
//    // 麦克风
//    UIButton *soundBtn = self.conferenceToolBar.buttons[ConferenceToolBarButtonMicrophone];
//    __weak typeof(self) weakself = self;
//    int success = [_meetingReformer setAudioEnabled:YES completion:^(BOOL isAudioEnabled) {
////        [YCMeetingRoomMembersController sendUpdateStatesCommandWithMeetingID:weakself.meetingID];
//        [weakself.membersVC reloadTableView];
//    }];
//    if (success == JCOK) {
//        soundBtn.selected = YES;
//    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.waitInfoView addGestureRecognizer:tap];
    
    [self setupWelcomeLabel];
    self.welcomeLabelSeconds = 5;
    
    self.livingLabel.hidden = YES;
    self.livingLabel.layer.cornerRadius = self.livingLabel.frame.size.height/2;
    self.livingLabel.clipsToBounds = YES;
    self.livingLabel.backgroundColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:63.0/255 alpha:0.22];
    self.livingLabel.textColor = [UIColor whiteColor];
    [self.livingLabel.superview bringSubviewToFront:self.livingLabel];
}


//#pragma mark - 隐藏菜单

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    BOOL isEditing = [self.view endEditing:YES];
////    if (isEditing) {
////        self.myBackBtn.hidden = YES;
////        self.conferenceToolBar.hidden = YES;
////    } else {
////        self.myBackBtn.hidden = !self.myBackBtn.hidden;
////        self.conferenceToolBar.hidden = !self.conferenceToolBar.hidden;
////    }
//    self.myBackBtn.hidden = !self.myBackBtn.hidden;
//    self.conferenceToolBar.hidden = !self.conferenceToolBar.hidden;
//
//
//    [super touchesBegan:touches withEvent:event];
//}

#pragma mark - 键盘

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    [self.preview insertSubview:self.hideKeyboardBtn belowSubview:self.tabBar];
//    [self.chatVC.view.superview insertSubview:self.hideKeyboardBtn belowSubview:self.chatVC.view];
//    [self.view addSubview:self.hideKeyboardBtn];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
    [self.hideKeyboardBtn removeFromSuperview];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - 课件


- (void)handleCoursewareChange {
    NSString *url = [JCDoodleManager getCoursewareUrl];
    
    //        _blackboardView.hidden = YES;
    
    NSArray *array = nil;
    if ([url isEqualToString:kCoursewareJuphoon]) {
        array = @[[UIImage imageNamed:@"ppt1.jpg"],
                  [UIImage imageNamed:@"ppt2.jpg"],
                  [UIImage imageNamed:@"ppt3.jpg"],
                  [UIImage imageNamed:@"ppt4.jpg"],
                  [UIImage imageNamed:@"ppt5.jpg"]];
        
        
    } else if ([url isEqualToString:kCoursewareMath]) {
        array = @[[UIImage imageNamed:@"math1.jpg"],
                  [UIImage imageNamed:@"math2.jpg"],
                  [UIImage imageNamed:@"math3.jpg"],
                  [UIImage imageNamed:@"math4.jpg"],
                  [UIImage imageNamed:@"math5.jpg"],
                  [UIImage imageNamed:@"math6.jpg"],
                  [UIImage imageNamed:@"math7.jpg"]];
        
    } else if ([url isEqualToString:kCoursewarePhysics]) {
        array = @[[UIImage imageNamed:@"physics1.jpg"],
                  [UIImage imageNamed:@"physics2.jpg"],
                  [UIImage imageNamed:@"physics3.jpg"],
                  [UIImage imageNamed:@"physics4.jpg"],
                  [UIImage imageNamed:@"physics5.jpg"],
                  [UIImage imageNamed:@"physics6.jpg"]];
        
    } else {
        array = nil;
    }
    
    [_whiteBoardViewController cleanAllPath];
    _whiteBoardViewController.pageCount = array.count;
    [_whiteBoardViewController setBackgroundImages:array];
    
    //        if (self.isTeacher) {
//    _whiteBoardViewController.currentPage = 0;
    //        }
    
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //            self.pageLabel.text =[NSString stringWithFormat:@"%ld / %ld", (long)_whiteBoardViewController.currentPage + 1, (long)_whiteBoardViewController.pageCount];
//    [self.whiteBoardViewController updatePageLabel];
    //        }

}


#pragma mark - 全屏

- (void)setupGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapForWhiteBoardVC)];
    tap.numberOfTapsRequired = 2;
    [self.whiteBoardViewController.view addGestureRecognizer:tap];
}

- (void)handleDoubleTapForWhiteBoardVC {
    self.isFullScreen = !self.isFullScreen;
    [self.whiteBoardViewController.view.superview bringSubviewToFront:self.whiteBoardViewController.view];
    
    // 旋转
    double rotation = self.isFullScreen? M_PI_2: 0;
    [UIView animateWithDuration:0.26 animations:^{
//        [self layoutViewControllers];
        self.whiteBoardViewController.view.transform = CGAffineTransformMakeRotation(rotation);
        
        // 白板全屏的时候，允许自动旋转
        if (self.isFullScreen) {
            self.whiteBoardViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        } else {
            float y = kVideoViewHeight + kTabBarHeight;
            self.whiteBoardViewController.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
        }
    }];
    
    // 隐藏状态栏
    self.shouldHiddeStatusBar = self.isFullScreen;
    [self setNeedsStatusBarAppearanceUpdate];
    
    // 关闭右上角的工具栏
    if (self.isFullScreen) {
        self.conferenceToolBar.hidden = YES;
    }
}

#pragma mark - 状态栏

- (BOOL)prefersStatusBarHidden {
    return self.shouldHiddeStatusBar;
}

#pragma mark - 收到命令

- (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId {
//    NSLog(@"%@, %@, %@", key, content, userId);// 命令类型, 命令内容, 57e93bad-a2c4-4e00-892f-adf2c090a55b
    // 允许互动：可以画画、翻页 ppt
//    if ([key isEqualToString:kkYCAllowInteractionKey]) {
//        [self.whiteBoardViewController enableDraw:YES];
//    } else if ([key isEqualToString:kkYCEndInteractionKey]) {
//        [self.whiteBoardViewController enableDraw:NO];
//    } else if ([key isEqualToString:kkYCRequestInteractionKey]) {
//        [self showRequsetForInteractionWithUserID:userId];
//    } else if ([key isEqualToString:kkYCQueryStateKey]) {
//        [self.membersVC sendUpdateStatesCommand];
//    } else if ([key isEqualToString:kkYCUpdateStatesKey]) {
//        // 更新所有人状态
//        [self.membersVC updateStates:content];
//    }

//    if ([key isEqualToString:kkYCRequestInteractionKey]) {
//        [self showRequsetForInteractionWithUserID:userId];
//    } else if ([key isEqualToString:kkYCUpdateStatesKey]) {
//        [self.membersVC getMeetingUser];
//    }
    
    if ([key isEqualToString:kkYCUpdateStatesKey]) {
        [self.membersVC getMeetingUser];
    } else if ([key isEqualToString: kYCChangeCoursewareCommand]) {
        [self.whiteBoardViewController checkCurrentMeetingFile];
    }
}

//- (void)showRequsetForInteractionWithUserID:(NSString *)userID {
//    NSString *name = [self getNameWithUserID:userID];
//    NSString *message = [NSString stringWithFormat:@"是否允许 %@ 互动？", name];
//
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"允许" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.membersVC updateUserInteractingState:1 withUserID:userID];
//    }];
//    UIAlertAction *refuse = [UIAlertAction actionWithTitle:@"拒绝" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.membersVC updateUserInteractingState:0 withUserID:userID];
//    }];
//
//    [ac addAction:sure];
//    [ac addAction:refuse];
//    [self presentViewController:ac animated:YES completion:nil];
//}

- (NSString *)getNameWithUserID:(NSString *)userID {
    NSString *name;
    for (YCMeetingUser *user in self.meeting.meetingUserList) {
        if ([user.userid isEqualToString:userID]) {
            return user.userName;
        }
    }
    return name;
}

//// 判断是否会议主持人。userID 为 nil 表示当前用户
//- (BOOL)isMeetingCreator:(NSString *)userID {
//    if (!userID) {
//        userID = [ObjectShareTool currentUserID];
//    }
//    return [self.meeting.createUser isEqualToString:userID];
//}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 音频干扰

- (void)handleHowlingDetectedNotification:(NSNotification *)noti {
//    [CTToast showWithText:@"检测到音频干扰。已关闭麦克风。请确保只有一个用户开启麦克风"];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"检测到音频干扰，已关闭扬声器。请确保附近只有一个用户开启扬声器" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:sure];
    [self presentViewController:ac animated:YES completion:nil];
    
    __weak typeof(self) weakself = self;
//    UIButton *vBtn = weakself.conferenceToolBar.buttons[ConferenceToolBarButtonVolume];
    UIButton *vBtn = weakself.conferenceToolBar.volumeBtn;
    [_meetingReformer setMuteEnabled:NO];
    vBtn.selected = NO;
    [weakself.conferenceToolBar updateLabels];

//    int success = [_meetingReformer setAudioEnabled:NO completion:^(BOOL isAudioEnabled) {
//        [YCMeetingRoomMembersController sendUpdateStatesCommandWithMeetingID:weakself.meetingID];
//        [weakself.membersVC reloadTableView];
//    }];
//    if (success == JCOK) {
//        soundBtn.selected = NO;
//    } else {
//        [CTToast showWithText:@"更改麦克风状态失败"];
//    }

}

- (void)addObserverForHowlingDetectedNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHowlingDetectedNotification:) name:@MtcMediaHowlingDetectedNotification object:nil];
}

- (void)removeObserverForHowlingDetectedNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@MtcMediaHowlingDetectedNotification object:nil];
}

#pragma mark - 结束会议

- (void)finishMeeting {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"结束会议？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        [[MJPopTool sharedInstance] closeAnimated:YES];
        _doodleShareUserId = nil;
        [JCDoodleManager stopDoodle];
        //        [_meetingReformer leave];
        [self cancel:nil];
        
        // 结束会议
        [[YCMeetingBiz new] cancelMeetingWithMeetingID:self.meetingID cancelType:1 success:^(id data) {
            
        } fail:^(NSError *error) {
            [CTToast showWithText:[NSString stringWithFormat:@"结束会议失败 : %@", error]];
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 录屏

- (void)clickVedioControlBtn:(UIButton *)btn {
    if (!self.meeting) {
        [CTToast showWithText:@"正在获取会议详情，请稍后再试"];
        return;
    }
    if (!self.confID) {
        [CTToast showWithText:@"正在加入会议，请稍后再试"];
        return;
    }
    
    NSString *message = btn.isSelected? @"结束录屏？": @"开始录屏？";
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btn.isSelected) {
            [self endScreen:btn];
        } else {
            [self startScreen:btn];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)startScreen:(UIButton *)btn {
    
    //    判断是否为直播会议
    ZUINT iConfId = self.confID;
    ZCONST ZCHAR *pcName = MtcConfPropDeliveryUri;
    ZCONST ZCHAR *DeliveryURI = Mtc_ConfGetProp(iConfId, pcName); // [username:delivery_10935553@delivery.cloud.justalk.com]
    if (DeliveryURI == ZNULL) {
        [CTToast showWithText:@"不是直播会议，无法录屏"];
        return;
    }
    
    // 发起录屏
    NSString *time = [NSString stringWithFormat:@"%ld", (long)([NSDate date].timeIntervalSince1970*1000)];
    NSString *fileName = [NSString stringWithFormat:@"meeting_%@_%@.mp4", self.meeting.meetingId, time];
    NSDictionary *storageDic = @{@"Protocol" : @"qiniu",
                                 @"AccessKey" : self.AccessKey,
                                 @"SecretKey" : self.SecretKey,
                                 @"BucketName" : self.BucketName,
                                 @"FileKey" : fileName};
    NSDictionary *para = @{@"MtcConfIsVideoKey" : @YES, @"Storage" : storageDic};
    
    ZINT ret = Mtc_ConfCommand(iConfId, MtcConfCmdReplayStartRecord, [para JSONString].UTF8String);
    if (ret == ZOK) {
        btn.selected = YES;
        [self.conferenceToolBar updateLabels];
        self.isScreening = YES;
        [self updateLivingLabel];
        [CTToast showWithText:@"开始录屏"];
        [self meetingTranscribeWithFileName:fileName type:1];
    } else {
        [CTToast showWithText:@"无法发起录制，请重试多几次！"];
    }
}

- (void)endScreen:(UIButton *)btn {
    ZUINT iConfId = self.confID;
    ZCHAR *pcCmd = MtcConfCmdReplayStopRecord;
    
    ZINT success = Mtc_ConfCommand(iConfId, pcCmd, nil);
    if (success == ZOK) {
        btn.selected = NO;
        [self.conferenceToolBar updateLabels];
        self.isScreening = NO;
        [self updateLivingLabel];
        [CTToast showWithText:@"结束录屏"];
        [self meetingTranscribeWithFileName:nil type:0];
    } else {
        [CTToast showWithText:@"结束录屏 失败"];
    }
    
}

//type: 0取消/1开始/2获取录制网址
- (void)meetingTranscribeWithFileName:(NSString *)fileName type:(int)type {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingTranscribeWithMeetingID:self.meetingID fileName:fileName type:type success:^(NSDictionary *dic, int transcribeState, NSString *fileUrl, NSArray *files) {
        if (type == 2) {
            weakself.fileUrl = fileUrl;
        }
        if (transcribeState == 1) {
            [weakself startScreen:weakself.conferenceToolBar.RECBtn];
            [weakself.conferenceToolBar updateLabels];
        }
    } failue:^(NSError *error) {
        
    }];
}

// 获取录屏文件
- (void)getVideos {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingTranscribeWithMeetingID:weakself.meetingID fileName:nil type:2 success:^(NSDictionary *dic, int transcribeState, NSString *fileUrl, NSArray *files) {
        // files 里面是字典, timeLen 时长，单位是毫秒。fileUrl 视频地址
        if (files && files.count > 0) {
            NSMutableArray *fileUrls = [NSMutableArray arrayWithCapacity:files.count];
            for (NSDictionary *dic in files) {
                [fileUrls addObject:dic[@"fileUrl"]];
            }
            weakself.fileUrls = fileUrls;
        }
        weakself.fileUrl = fileUrl;
        if (weakself.fileUrls) {
            weakself.videoBtn.hidden = NO;
        }
    } failue:^(NSError *error) {
        
    }];

}

#pragma mark - 直播

- (void)clickLivingBtn:(UIButton *)btn {
    if (!self.meeting) {
        [CTToast showWithText:@"正在获取会议详情，请稍后再试"];
        return;
    }
    if (!self.confID) {
        [CTToast showWithText:@"正在加入会议，请稍后再试"];
        return;
    }
    
    NSString *message = btn.isSelected? @"结束直播？": @"开始直播？";
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btn.isSelected) {
            [self endLiving:btn];
        } else {
            [self startLiving:btn];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)startLiving:(UIButton *)btn {
    //    判断是否为直播会议
    ZUINT iConfId = self.confID;
    ZCONST ZCHAR *pcName = MtcConfPropDeliveryUri;
    ZCONST ZCHAR *DeliveryURI = Mtc_ConfGetProp(iConfId, pcName); // [username:delivery_10935553@delivery.cloud.justalk.com]
    if (DeliveryURI == ZNULL) {
        [CTToast showWithText:@"不是直播会议，无法直播"];
        return;
    }
    
    // 发起直播
    ZINT s = Mtc_ConfStartCdn(iConfId);
    if (s != ZOK) {
        [CTToast showWithText:@"发起直播 失败"];
    } else {
        btn.selected = YES;
        [self.conferenceToolBar updateLabels];
        self.isLiving = YES;
        [self updateLivingLabel];
        [CTToast showWithText:@"开始直播"];
        [self meetingLiveWithType:1];
        
    }
}

- (void)endLiving:(UIButton *)btn {
    ZUINT iConfId = self.confID;
    ZINT s = Mtc_ConfStopCdn(iConfId);
    if (s != ZOK) {
        [CTToast showWithText:@"结束直播 失败"];
    } else {
        btn.selected = NO;
        [self.conferenceToolBar updateLabels];
        self.isLiving = NO;
        [self updateLivingLabel];
        [CTToast showWithText:@"结束直播"];
        [self meetingLiveWithType:0];
    }
}

// 要在获取会议详情成功后调用，主持人才能打开直播
//type: 0取消/1开始/2获取直播网址
- (void)meetingLiveWithType:(int)type {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingLiveWithMeetingID:self.meetingID type:type success:^(NSDictionary *dic, int liveState, NSString *liveUrl) {
        if (type == 2) {
            weakself.liveUrl = liveUrl;
        }
        if (liveState == 1) {
            [weakself startLiving:weakself.conferenceToolBar.liveBtn];
            [weakself.conferenceToolBar updateLabels];
        }
    } failue:^(NSError *error) {
        
    }];
}

- (void)updateLivingLabel {
    self.livingLabel.hidden = NO;
    if (self.isLiving && self.isScreening) {
        self.livingLabel.text = @"  直播、录制中  ";
        return;
    }
    if (!self.isLiving && !self.isScreening) {
        self.livingLabel.hidden = YES;
        return;
    }
    if (self.isLiving && !self.isScreening) {
        self.livingLabel.text = @"直播中";
        return;
    }
    if (!self.isLiving && self.isScreening) {
        self.livingLabel.text = @"录制中";
        return;
    }
}

#pragma mark - 回放

- (IBAction)clickVideoBtn:(UIButton *)sender {
    YCVideoController *vc = [YCVideoController new];
    vc.videoPath = @"http://2449.vod.myqcloud.com/2449_22ca37a6ea9011e5acaaf51d105342e3.f20.mp4";
    vc.videoUrls = self.fileUrls;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -




@end


