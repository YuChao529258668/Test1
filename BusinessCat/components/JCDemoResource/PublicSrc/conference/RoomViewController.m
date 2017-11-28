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

#define kVideoViewHeight (kMainScreenHeight * 0.4) // splitScreenViewController的高度
#define kTabBarHeight 40
#define kBtnLineHeight 1

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
@property (nonatomic,strong) UIButton *menberTabBtn; // 切换 成员
@property (nonatomic,strong) UIView *btnLine; // 按钮下面的线
@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *myToolBarBtn;


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
        _meetingReformer = [[JCBaseMeetingReformer alloc] init];
        
        _showModeArray = [NSMutableArray array];
        
        _doodleShareUserId = nil;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ConferenceViewController dealloc");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
    self.whiteBoardViewController.view.layer.borderWidth = 4;
    self.whiteBoardViewController.view.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:221.0/255.0 blue:40.0/255.0 alpha:1.0].CGColor;
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
}


#pragma  mark - JCEngineDelegate
- (void)onParticipantJoin:(NSString *)userId {
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
}

- (void)onParticipantLeft:(ErrorReason)errorReason userId:(NSString *)userId {
    _count = (int)[_confManager getRoomInfo].participants.count;
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
}

#pragma mark - BaseMeetingDelegate

- (void)joinSuccess
{
    _waitInfoView.hidden = YES; //隐藏会议等待view
    _mainView.hidden = NO; //显示加入会议后的主view
    
    _confNumber = [_confManager getConfNumber];
    
    if (_doodleShareUserId) {
        return;
    }
    
    _count = (int)[_confManager getRoomInfo].participants.count;
    
    _textLabel.text = [NSString stringWithFormat:@"RoomID:%@ 参与人数:%d 会议号码:%ld", _roomId, _count, _confNumber];
    
    //更新界面
    [self showCurrentShowMode:ShowSplitScreen];
}

- (void)joinFailedWithReason:(ErrorReason)reason
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"join failed", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
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
        
        //如果是自己发起
        if ([userId isEqualToString:[_confManager getOwnUserId]]) {
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
                [CTToast showWithText:@"开启麦克风失败"];
            } else {
                [CTToast showWithText:@"开启麦克风成功"];
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
    [_meetingReformer leave];
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
        [_meetingReformer leave];
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

- (IBAction)myToolBarBtnClick:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
    BOOL hidden = !self.myBackBtn.hidden;
    self.myBackBtn.hidden = hidden;
    self.conferenceToolBar.hidden = hidden;
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
    //    [_previewViewController stopShowPreview];
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


#pragma mark - 屏幕方向

//旋转时，支持的方向（如果用户会议界面竖屏的时候，可以修改下面两个方法的返回值）
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    //    return UIInterfaceOrientationMaskLandscapeRight;
}

//被present时，首选的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
    //    return UIInterfaceOrientationLandscapeRight;
}


#pragma mark - yc_Layout

- (void)layoutViewControllers {
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth, kVideoViewHeight);
    self.splitScreenViewController.view.frame = frame;
    
    float y = kVideoViewHeight + kTabBarHeight;
    self.whiteBoardViewController.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y);
}

- (void)layoutTabBar {
    self.tabBar.frame = CGRectMake(0, kVideoViewHeight, kMainScreenWidth, kTabBarHeight);
    
    float btnWidth = kMainScreenWidth / 3;
    self.whiteBoardTabBtn.frame = CGRectMake(0, 0, btnWidth, kTabBarHeight);
    self.chatTabBtn.frame = CGRectMake(btnWidth, 0, btnWidth, kTabBarHeight);
    self.menberTabBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, kTabBarHeight);
    
    CGRect frame = self.btnLine.frame;
    frame.origin.y = kTabBarHeight - kBtnLineHeight;
    frame.size = CGSizeMake(btnWidth, kBtnLineHeight);
    self.btnLine.frame = frame;
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
    self.btnLine.backgroundColor = [UIColor blueColor];
    
    self.whiteBoardTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menberTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.whiteBoardTabBtn.selected = YES;
    
    [self.whiteBoardTabBtn addTarget:self action:@selector(whiteBoardTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.chatTabBtn addTarget:self action:@selector(chatTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menberTabBtn addTarget:self action:@selector(menberTabBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whiteBoardTabBtn setTitle:@"白板" forState:UIControlStateNormal];
    [self.chatTabBtn setTitle:@"讨论" forState:UIControlStateNormal];
    [self.menberTabBtn setTitle:@"成员" forState:UIControlStateNormal];
    
    [self.whiteBoardTabBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.chatTabBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.menberTabBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self.whiteBoardTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.menberTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.tabBar = [UIView new];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:self.whiteBoardTabBtn];
    [self.tabBar addSubview:self.chatTabBtn];
    [self.tabBar addSubview:self.menberTabBtn];
    [self.tabBar addSubview:self.btnLine];
    [self.preview addSubview:self.tabBar];
}

#pragma mark - yc_Action

- (void)whiteBoardTabBtnClick {
    self.whiteBoardViewController.view.hidden = NO;
    
    self.whiteBoardTabBtn.selected = YES;
    self.chatTabBtn.selected = NO;
    self.menberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.whiteBoardTabBtn];
}

- (void)chatTabBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    
    self.whiteBoardTabBtn.selected = NO;
    self.chatTabBtn.selected = YES;
    self.menberTabBtn.selected = NO;
    
    [self layoutBtnLine:self.chatTabBtn];
}

- (void)menberTabBtnClick {
    self.whiteBoardViewController.view.hidden = YES;
    
    self.whiteBoardTabBtn.selected = NO;
    self.chatTabBtn.selected = NO;
    self.menberTabBtn.selected = YES;
    
    [self layoutBtnLine:self.menberTabBtn];
}


#pragma mark - yc_Custom

- (BOOL)isSupportPanReturnBack {
    return NO;
}

// viewDidLoad 的时候调用
- (void)configForCustom {
    self.whiteBoardViewController.view.hidden = NO;
    
    [self setupTarBar];
    
    [self.stopButton removeFromSuperview]; // 结束白板共享按钮
    [self.sidebar removeFromSuperview]; // 右边栏
    
    self.conferenceToolBar.hidden = YES;
    self.myBackBtn.hidden = YES;
    self.myToolBarBtn.hidden = NO;
    
    [self.preview bringSubviewToFront:self.myBackBtn];
    [self.preview bringSubviewToFront:self.myToolBarBtn];
}

@end


