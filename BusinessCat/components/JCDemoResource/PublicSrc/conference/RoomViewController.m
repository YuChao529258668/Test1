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

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height


#import "CGMeeting.h"
#import "YCMeetingBiz.h"
#import "YCMeetingRoomMembersController.h"

#define kVideoViewHeight (kMainScreenHeight * 0.4) // splitScreenViewController的高度
#define kTabBarHeight 40
#define kBtnLineHeight 2

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
{
    JCBaseMeetingReformer *_meetingReformer;
    
    JCEngineManager *_confManager;
    
    NSMutableArray *_showModeArray; //用于管理当前大窗口的显示内容，采用栈管理的方式
    
    NSArray<UIButton *> *_buttons;
    
    NSString *_doodleShareUserId; //当前发起涂鸦的成员
    
    BOOL _isDoodle;
    BOOL _isInfo;
    
    int _count;
    long _confNumber;
}






@property (weak, nonatomic) IBOutlet UIView *waitInfoView;                          // 会议等待界面

@property (weak, nonatomic) IBOutlet UIView *mainView;                              // 加入会议后的主View

@property (weak, nonatomic) IBOutlet UIView *preview;                     // 预览窗口

@property (weak, nonatomic) IBOutlet UIView *sidebar;                               // 加入房间后mainView上右边竖排工具栏

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet ConferenceToolBar *conferenceToolBar;          // 加入会议后mainView上的底部工具栏

@property (nonatomic, strong) JCPreviewViewController *previewViewController;
@property (nonatomic, strong) JCScreenShareViewController *screenShareViewController;
@property (nonatomic, strong) SplitScreenViewController *splitScreenViewController; // 分屏的viewcontroller
@property (nonatomic, strong) JCWhiteBoardViewController *whiteBoardViewController;   // 白板的Viewcontroller

@property (nonatomic, strong) JCMenuViewController *menuViewController;

@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *textLabel;


@property (nonatomic,strong) UIView *tabBar; // 中间栏，切换 画板、聊天等
@property (nonatomic,strong) UIButton *whiteBoardTabBtn; // 切换白板
@property (nonatomic,strong) UIButton *chatTabBtn;// 切换 讨论
@property (nonatomic,strong) UIButton *memberTabBtn; // 切换 成员
@property (nonatomic,strong) UIButton *desktopBtn; // 切换 桌面

@property (nonatomic,strong) UIView *btnLine; // 按钮下面的线
@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *myToolBarBtn;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic,strong) UIButton *hideKeyboardBtn; // 隐藏键盘的按钮，覆盖全屏

@property (nonatomic,strong) IMAChatViewController *chatVC;
@property (nonatomic,strong) YCMeetingRoomMembersController *membersVC;

//@property (nonatomic,strong) NSString *charRoomID; // 聊天室 id
@property (nonatomic,strong) CGMeeting *meeting; // 会议详情
//@property (nonatomic,assign) BOOL isAutorotate; // 是否支持自动旋转。白板全屏时支持旋转
@property (nonatomic,assign) BOOL isFullScreen; // 白板是否全屏显示



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
//        [self setupGesture];
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
        [_confManager setMaxCapacity:32];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //防止自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _conferenceToolBar.delegate = self;
    _conferenceToolBar.buttons[0].selected = YES;
    
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
    
    [_confManager setMaxCapacity:4];
    
    BOOL ret = [_meetingReformer joinWithRommId:_roomId displayName:_displayName];
    
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
    
    [self configForCustom];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutViewControllers];
    [self layoutTabBar];
    self.hideKeyboardBtn.frame = self.view.bounds;
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
}

- (void)onParticipantLeft:(ErrorReason)errorReason userId:(NSString *)userId {
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
    [self updateMemberBtn];
    
    // 更新服务器并且群发命令
    [self.membersVC onUserLeft:userId];
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
//    [CTToast showWithText:@"加入会议成功"];
//    [self setDoc]; // 设置课件
    [self updateTitleBtn];
    [self updateMemberBtn];
    
    // 如果不是主持人，就向主持人查询互动状态
//    if (![self isMeetingCreator:nil]) {
//        [self.membersVC sendQueryInteractionStateCommand];
//    }
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
    if (reason == ErrorEndOffline) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"offline" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self stopAllRender];
            [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - ConferenceToolBarDelegate
- (void)conferenceToolBar:(ConferenceToolBar *)toolBar
              clickButton:(UIButton *)button
               buttonType:(ConferenceToolBarButtonType)type
{
    switch (type) {
        case ConferenceToolBarButtonVideo: {
            BOOL selected = !button.isSelected;
            [_meetingReformer setVideoEnabled:selected completion:^(BOOL isVideoEnabled) {
                button.selected = isVideoEnabled;
            }];
            break;
        }
        case ConferenceToolBarButtonCamera:
            [_meetingReformer switchCamera];
            break;
        case ConferenceToolBarButtonVolume: {
            BOOL selected = !button.isSelected;
            [_meetingReformer setMuteEnabled:selected];
            button.selected = selected;
            break;
        }
        case ConferenceToolBarButtonMicrophone: {
            BOOL selected = !button.isSelected;
            int success = [_meetingReformer setAudioEnabled:selected completion:^(BOOL isAudioEnabled) {
                button.selected = isAudioEnabled;
            }];
            if (success != JCOK) {
//                [CTToast showWithText:@"开启麦克风失败"];
            } else {
//                [CTToast showWithText:@"开启麦克风成功"];
            }
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
    // 点击按钮输出： 0 -[JCEngineManager leave] no confEngine ，界面不消失
    int success = [_meetingReformer leave];
    if (success != JCOK) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sure to quit", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MJPopTool sharedInstance] closeAnimated:YES];
        _doodleShareUserId = nil;
        [JCDoodleManager stopDoodle];
//        [_meetingReformer leave];
        [self cancel:nil];
    }];
    [alert addAction:action];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth, kVideoViewHeight);
    self.splitScreenViewController.view.frame = frame;
    
    float y = kVideoViewHeight + kTabBarHeight;
    self.chatVC.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
    self.membersVC.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
    
    // 白板全屏的时候，允许自动旋转
    if (self.isFullScreen) {
        self.whiteBoardViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    } else {
        self.whiteBoardViewController.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
    }
}

- (void)layoutTabBar {
    self.tabBar.frame = CGRectMake(0, kVideoViewHeight, kMainScreenWidth, kTabBarHeight);
    
    float btnWidth = kMainScreenWidth / 4;
    self.whiteBoardTabBtn.frame = CGRectMake(0, 0, btnWidth, kTabBarHeight);
    self.desktopBtn.frame = CGRectMake(btnWidth * 1, 0, btnWidth, kTabBarHeight);
    self.chatTabBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, kTabBarHeight);
    self.memberTabBtn.frame = CGRectMake(btnWidth * 3, 0, btnWidth, kTabBarHeight);
    
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
    [self.tabBar addSubview:self.desktopBtn];
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
    [btn addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    self.hideKeyboardBtn = btn;
}

- (void)setupTitleBtn {
    [self.titleBtn.superview bringSubviewToFront:self.titleBtn];
    [self.titleBtn setTitle:@" 0分钟 " forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"video_block"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
    [self.titleBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - yc_Action

- (void)whiteBoardTabBtnClick {
    self.whiteBoardViewController.view.hidden = NO;
    self.chatVC.view.hidden = YES;
    self.membersVC.view.hidden = YES;

    self.whiteBoardTabBtn.selected = YES;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = NO;
    self.memberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.whiteBoardTabBtn];
    
    [self.view endEditing:YES];
    
//    [self.tabBar sendSubviewToBack:self.whiteBoardTabBtn];
}

- (void)desktopBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
//    self.desktopBtn.
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
    self.chatVC.view.hidden = NO;
    self.membersVC.view.hidden = YES;

    self.whiteBoardTabBtn.selected = NO;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = YES;
    self.memberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.chatTabBtn];
    [self.view endEditing:YES];
    
//    [self.tabBar sendSubviewToBack:self.chatTabBtn];
}

- (void)memberTabBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    self.chatVC.view.hidden = YES;
    self.membersVC.view.hidden = NO;

    self.whiteBoardTabBtn.selected = NO;
    self.desktopBtn.selected = NO;
    self.chatTabBtn.selected = NO;
    self.memberTabBtn.selected = YES;
    
    [self layoutBtnLine:self.memberTabBtn];
    [self.view endEditing:YES];
    
//    [self.tabBar sendSubviewToBack:self.menuButton];
}

- (IBAction)myToolBarBtnClick:(UIButton *)sender {
//    self.myBackBtn.hidden = !self.myBackBtn.hidden;
    self.conferenceToolBar.hidden = !self.conferenceToolBar.hidden;
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
    
    int fail = [[TIMGroupManager sharedInstance] getGroupInfo:groupList succ:^(NSArray * groups) {
        TIMGroupInfo * info = groups.firstObject;
        [self addChatViewControllerWith:info];
    } fail:^(int code, NSString* err) {
        [CTToast showWithText: [NSString stringWithFormat:@"获取群信息失败 %d %@ groupId:%@", code, err, groupId]];
    }];
    
    if (fail) {
        [CTToast showWithText:@"获取群信息失败， 可能聊天功能未登录"];
    }
}

// 会议详情
- (void)getMeetingDetail {
    [[YCMeetingBiz new] getMeetingDetailWithMeetingID:self.meetingID success:^(CGMeeting *meeting) {
        self.meeting = meeting;
        // 获取群聊
        [self getGroupWithGroupID:self.meeting.groupId];
        // 成员
        [self addMembersControllerWithUsers:meeting.meetingUserList];
        [self updateTitleBtn];
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"获取会议详情失败 : %@", error]];
    }];
}


#pragma mark - 成员

- (void)addMembersControllerWithUsers:(NSArray *)users {
    self.membersVC = [YCMeetingRoomMembersController new];
//    self.membersVC.users = users;
    self.membersVC.meetingCreatorID = self.meeting.createUser;
    self.membersVC.meetingID = self.meetingID;
    self.membersVC.isMeetingCreator = [self isMeetingCreator:nil];
    
    __weak typeof(self) weakself = self;
    self.membersVC.onStateChangeBlock = ^(long interactState) {
        if (interactState > 1) {
            return ;
        }
        BOOL enable = interactState?YES:NO;
        [weakself.whiteBoardViewController enableDraw:enable];
    };
    
    self.membersVC.view.hidden = !self.memberTabBtn.isSelected;
    [self.preview addSubview:self.membersVC.view];
    // 布局
    [self layoutViewControllers];
}


#pragma mark - 腾讯云

- (void)addChatViewControllerWith:(TIMGroupInfo *)info {
    self.chatVC = [self createChatViewControllerWith:info];
    self.chatVC.view.hidden = !self.chatTabBtn.isSelected;
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
    NSString *title = [NSString stringWithFormat:@"成员(%d/%d人) ", (int)[[JCEngineManager sharedManager] getRoomInfo].participants.count, self.meeting.attendance];
    [self.memberTabBtn setTitle:title forState:UIControlStateNormal];
}

// viewDidLoad 的时候调用
- (void)configForCustom {
    self.whiteBoardViewController.view.hidden = NO;
    
    [self setupTarBar];
    
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
}

- (void)hideKeyboard:(UIButton *)btn {
    [self.view endEditing:YES];
    [btn removeFromSuperview];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - 课件

// 设置课件
- (void)setDoc {
//    NSString *url = _urls[indexPath.row];
    NSString *url = @"COURSEWARE_MATH";
    [JCDoodleManager sendCoursewareUrl:url];
}

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
//    [self.whiteBoardViewController handleDoubleTap];
    [self layoutViewControllers];
}


#pragma mark - 互动

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

    if ([key isEqualToString:kkYCRequestInteractionKey]) {
        [self showRequsetForInteractionWithUserID:userId];
    } else if ([key isEqualToString:kkYCUpdateStatesKey]) {
        [self.membersVC getMeetingUser];
    }
}

- (void)showRequsetForInteractionWithUserID:(NSString *)userID {
    NSString *name = [self getNameWithUserID:userID];
    NSString *message = [NSString stringWithFormat:@"是否允许 %@ 互动？", name];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"允许" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.membersVC updateUserInteractingState:1 withUserID:userID];
    }];
    UIAlertAction *refuse = [UIAlertAction actionWithTitle:@"拒绝" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.membersVC updateUserInteractingState:0 withUserID:userID];
    }];

    [ac addAction:sure];
    [ac addAction:refuse];
    [self presentViewController:ac animated:YES completion:nil];
}

- (NSString *)getNameWithUserID:(NSString *)userID {
    NSString *name;
    for (YCMeetingUser *user in self.meeting.meetingUserList) {
        if ([user.userid isEqualToString:userID]) {
            return user.userName;
        }
    }
    return name;
}

// 判断是否会议主持人。userID 为 nil 表示当前用户
- (BOOL)isMeetingCreator:(NSString *)userID {
    if (!userID) {
        userID = [ObjectShareTool currentUserID];
    }
    return [self.meeting.createUser isEqualToString:userID];
}

@end


