//
//  ConferenceViewController.m
//  UltimateShow
//
//  Created by young on 16/4/5.
//  Copyright © 2016年 juphoon. All rights reserved.
//

#import "ConferenceViewController.h"
#import "ConferenceToolBar.h"
#import "JCBaseMeetingReformer.h"
#import "JCPreviewViewController.h"
#import "JCScreenShareViewController.h"
#import "JCSplitScreenViewController.h"
#import "JCWhiteBoardViewController.h"
#import "JCParticipantViewController.h"
#import "JCStatisticsViewController.h"
#import "JCSingleParticipantViewController.h"
#import "JCMenuViewController.h"
#import "MJPopTool.h"
#import "UIButton+MenuTitleSpacing.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
// 显示相关界面
typedef enum {
    ShowNone = 0,
    ShowParticipant,            // 成员视频界面
    ShowSingleParticipant,      // 大小窗
    ShowSplitScreen,            // 分屏界面
    ShowScreenShare,            // 屏幕共享界面
    ShowDoodle                  // 涂鸦界面
} ShowMode;

@interface ConferenceViewController () <BaseMeetingDelegate, ConferenceToolBarDelegate, JCDoodleDelegate, ParticipantViewDelegate, JCScreenShareDelegate, MenuDelegate, SingleParticipantViewDelegate>
{
    JCBaseMeetingReformer *_meetingReformer;
    
    JCEngineManager *_confManager;
    
    NSMutableArray *_showModeArray; //用于管理当前大窗口的显示内容，采用栈管理的方式
    
    NSArray<UIButton *> *_buttons;
    
    NSString *_selectedUserId; //当前成员列表选中的成员
    NSString *_doodleShareUserId; //当前发起涂鸦的成员
    
    BOOL _isDoodle;
    
    BOOL _isInfo;
}


@property (weak, nonatomic) IBOutlet UIView *waitInfoView;                          // 会议等待界面

@property (weak, nonatomic) IBOutlet UIView *mainView;                              // 加入会议后的主View

@property (weak, nonatomic) IBOutlet UIView *preview;                     // 预览窗口

@property (weak, nonatomic) IBOutlet UITableView *participantTableView;             // 展示会议成员列表的视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *participantViewWidth;

@property (weak, nonatomic) IBOutlet UIView *singleView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;                          // 涂鸦上的返回按钮

@property (weak, nonatomic) IBOutlet UIView *sidebar;                               // 加入房间后mainView上右边竖排工具栏

@property (weak, nonatomic) IBOutlet UIButton *screenShareButton;                   // 屏幕共享的按钮
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *doodleMinimizeButton;                // 涂鸦按钮

@property (weak, nonatomic) IBOutlet UIButton *showButton;                          // 隐藏和显示底部工具栏以及成员列表的按钮


@property (weak, nonatomic) IBOutlet ConferenceToolBar *conferenceToolBar;          // 加入会议后mainView上的底部工具栏

@property (nonatomic, strong) JCPreviewViewController *previewViewController;
@property (nonatomic, strong) JCScreenShareViewController *screenShareViewController;
@property (nonatomic, strong) SplitScreenViewController *splitScreenViewController; // 分屏的viewcontroller
@property (nonatomic, strong) JCWhiteBoardViewController *whiteBoardViewController;   // 白板的Viewcontroller

@property (nonatomic, strong) JCParticipantViewController *participantViewController;

@property (nonatomic, strong) JCSingleParticipantViewController *singleViewController;

@property (nonatomic, strong) JCMenuViewController *menuViewController;

@property (nonatomic, strong) UIView *contentView;

@property (strong, nonatomic) UIButton *stopButton;

@end

@implementation ConferenceViewController

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

- (JCParticipantViewController *)participantViewController
{
    if (!_participantViewController) {
        _participantViewController = [[JCParticipantViewController alloc] init];
    }
    return _participantViewController;
}

- (JCSingleParticipantViewController *)singleViewController
{
    if (!_singleViewController) {
        _singleViewController = [[JCSingleParticipantViewController alloc] init];
    }
    return _singleViewController;
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

        _selectedUserId = nil;
        _doodleShareUserId = nil;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ConferenceViewController dealloc");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

//旋转时，支持的方向（如果用户会议界面竖屏的时候，可以修改下面两个方法的返回值）
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

//被present时，首选的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //防止自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _conferenceToolBar.delegate = self;
    _conferenceToolBar.buttons[0].selected = YES;
    
    [_showButton setImage:[UIImage imageNamed:@"video_window_off_pressed"] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    _showButton.hidden = YES;
    
    self.menuViewController.delegate = self;
    
    _buttons = self.menuViewController.menuView.buttons;

    _buttons[MenuButtonTypeShare].enabled = NO;
    _buttons[MenuButtonTypeShare].alpha = 0.5;
    
    CGFloat H = kMainScreenWidth;
    if (kMainScreenWidth > kMainScreenHeight) {
        H = kMainScreenHeight;
    }
    _participantViewWidth.constant = (H - 68) / 3;
    
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
    
    [self addChildViewController:self.participantViewController];
    [_participantTableView addSubview:self.participantViewController.view];
    self.participantViewController.view.frame = _participantTableView.bounds;
    self.participantViewController.delegate = self;
    
    [self addChildViewController:self.singleViewController];
    [_singleView addSubview:self.singleViewController.view];
    self.singleViewController.view.frame = _singleView.bounds;
    self.singleViewController.delegate = self;
    
    Zmf_VideoCaptureListenRotation(0, 90);
    Zmf_VideoRenderListenRotation(0, 90);
    Zmf_VideoScreenOrientation(270);
    // 设置涂鸦的代理
    [JCDoodleManager setDelegate:self];
    
    _meetingReformer.delegate = self;
    [[JCEngineManager sharedManager] setMaxCapacity:4];
    BOOL ret = [_meetingReformer joinWithRommId:_roomId displayName:_displayName];

    if (!ret) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"join failed", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [JCDoodleManager stopDoodle];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

#pragma mark - BaseMeetingDelegate

- (void)joinSuccess
{
    _waitInfoView.hidden = YES; //隐藏会议等待view
    _mainView.hidden = NO; //显示加入会议后的主view

    _selectedUserId = [_confManager getRoomInfo].participants.firstObject.userId;
    
    //更新界面
    [self showCurrentShowMode:ShowSplitScreen];
//    [self showCurrentShowMode:ShowSingleParticipant];
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
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark － ParticipantViewDelegate

- (void)didSelectRowForUserId:(NSString *)userId
{
    _selectedUserId = userId;
    if ([self getCurrentShowMode] == ShowParticipant) {
        [_previewViewController reloadPreviewWithUserId:_selectedUserId];
    }
}

#pragma mark - SingleParticipantViewDelegate

- (void)didSelectView
{
    for (int i = 0; i < 2; i++) {
        JCParticipantModel *model = [_confManager getRoomInfo].participants[i];
        if (_selectedUserId == model.userId) {
            [_singleViewController reloadSingleParticpantWithUserId:model.userId];
        } else {
            [_previewViewController reloadPreviewWithUserId:_selectedUserId];
        }
    }
}

#pragma mark － JCDoodleDelegate
- (void)receiveActionType:(JCDoodleActionType)type doodle:(JCDoodleAction *)doodle fromSender:(NSString *)userId
{
    if (type == JCDoodleActionStart) { //收到开始涂鸦
        
        //更新当前发起涂鸦的成员
        _doodleShareUserId = userId;
        
        //如果是自己发起
        if ([userId isEqualToString:[_confManager getOwnUserId]]) {
//            [self showCurrentShowMode:ShowDoodle];
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
            [_meetingReformer setAudioEnabled:selected completion:^(BOOL isAudioEnabled) {
                button.selected = isAudioEnabled;
            }];
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
// 涂鸦上的按钮返回事件
- (IBAction)back:(id)sender {
    _backButton.hidden = YES;
    [self cancelCurrentShowMode];
}
// 显示屏幕共享界面
- (IBAction)showScreenShare:(id)sender {
    _screenShareButton.hidden = YES;
    [self showCurrentShowMode:ShowScreenShare];
}
// 全屏显示涂鸦界面
- (IBAction)showDoodleOfFullScreen:(id)sender {
    _doodleMinimizeButton.hidden = YES;
    [self showCurrentShowMode:ShowDoodle];
}
// 会议信息
- (IBAction)showInfo:(id)sender
{
    if (_isInfo) {
        [[MJPopTool sharedInstance] closeAnimated:YES];
    } else {
        NSInteger numbers = [_confManager getRoomInfo].participants.count;
        NSString *info = [NSString stringWithFormat:@"会议号码:%@ 参与人数:%li", _roomId, (long)numbers];
        
        UIFont *font = [UIFont boldSystemFontOfSize:12];
        
        NSDictionary *dic = @{NSFontAttributeName : font};
        
        CGRect textRect = [info boundingRectWithSize:CGSizeMake(MAXFLOAT, 24) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, textRect.size.width + 24, 24)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = font;
        textLabel.text = info;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth - (textLabel.frame.size.width + 65), kMainScreenHeight - (kMainScreenHeight - 25), textLabel.frame.size.width, textLabel.frame.size.height)];
        
        _contentView.backgroundColor = [UIColor colorWithRed:0.0
                                                      green:0.0f
                                                       blue:0.0f
                                                      alpha:0.7f];
        [_contentView addSubview:textLabel];
        
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [[MJPopTool sharedInstance] popView:_contentView animated:YES];
    }
    _isInfo = !_isInfo;
}
// 功能菜单
- (IBAction)showMenu:(id)sender
{
    [self presentViewController:_menuViewController animated:YES completion:nil];
}
// 显示底部工具栏
- (IBAction)showToolBar:(id)sender {
    _showButton.selected = !_showButton.isSelected;
    
    _participantTableView.hidden = _showButton.isSelected;
    _conferenceToolBar.hidden = _showButton.isSelected;
    
    if ([self getCurrentShowMode] == ShowScreenShare) { //如果当前大窗口显示屏幕共享
        //显示成员列表和控制栏时，则隐藏返回按钮
        _backButton.hidden = !_showButton.isSelected;
    } else if ([self getCurrentShowMode] == ShowDoodle) { //如果当前大窗口显示涂鸦
        
        //显示成员列表和控制栏时，则隐藏返回按钮
        _backButton.hidden = !_showButton.isSelected;
        
        //显示成员列表和控制栏时，则隐藏涂鸦的工具栏
        _whiteBoardViewController.doodletoolbar.hidden = !_showButton.isSelected;
        _preview.userInteractionEnabled = _showButton.isSelected;
    }
}
// 离开房间
- (IBAction)leave:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sure to quit", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MJPopTool sharedInstance] closeAnimated:YES];
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
    [_previewViewController stopShowPreview];
    _previewViewController.view.hidden = YES;
    [_splitScreenViewController stopShowSplitSreenView];
    _splitScreenViewController.view.hidden = YES;
    [_screenShareViewController stopScreenShare];
    _screenShareViewController.view.hidden = YES;
    _whiteBoardViewController.view.hidden = YES;
    [_participantViewController stopShow];
    _participantViewController.view.hidden = YES;
    [_singleViewController stopSingleParticpant];
    _singleViewController.view.hidden = YES;
    
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
        case ShowParticipant:               // 成员视频界面
            [self showParticipantUI];
            break;
        case ShowSingleParticipant:
            [self showSingleParticipantUI];
            break;
        default:
            [self showSplitScreenUI];
            break;
    }
}

//显示成员视频
- (void)showParticipantUI
{
    //显示选中成员的视频
    _previewViewController.view.hidden = NO;
    [_previewViewController reloadPreviewWithUserId:_selectedUserId];
    
    //如果成员列表和控制栏不显示的，则设置为显示
    if (_showButton.isSelected) {
        [self showToolBar:nil];
    }

    _backButton.hidden = YES; //隐藏返回按钮
}

// 大小成员视频
- (void)showSingleParticipantUI
{
    _previewViewController.view.hidden = NO;
    [_previewViewController reloadPreviewWithUserId:_selectedUserId];
    
    _singleViewController.view.hidden = NO;
    [_singleViewController reloadSingleParticpantWithUserId:_selectedUserId];
    
    //如果成员列表和控制栏不显示的，则设置为显示
    if (_showButton.isSelected) {
        [self showToolBar:nil];
    }

    _backButton.hidden = YES;
}

//显示分屏的视频
- (void)showSplitScreenUI
{
    //显示分屏的视频
    _splitScreenViewController.view.hidden = NO;
    [_splitScreenViewController reloadSplitSreenView];
    
    //如果控制栏不显示的，则设置为显示
    if (_showButton.isSelected) {
        [self showToolBar:nil];
    }
    
    _backButton.hidden = YES; //隐藏返回按钮
}

//显示屏幕共享
- (void)showScreenShareUI
{
    _screenShareViewController.view.hidden = NO;
    [_screenShareViewController reloadScreenShare];
    
    //如果成员列表和控制栏显示的，则设置为隐藏
    if (!_showButton.isSelected) {
        [self showToolBar:nil];
    }
    
    _backButton.hidden = YES;
}

//显示涂鸦
- (void)showDoodleUI
{
    _whiteBoardViewController.view.hidden = NO;
    
    //如果成员列表和控制栏显示的，则设置为隐藏
    if (!_showButton.isSelected) {
        [self showToolBar:nil];
    }
    
    _backButton.hidden = YES;
}

- (void)stopAllRender
{
    //必须在会议结束（会议界面释放时）要释放各个模块的资源
    [_previewViewController stopShowPreview];
    [_screenShareViewController stopScreenShare];
    [_participantViewController stopShow];
    [_splitScreenViewController stopShowSplitSreenView];
}

@end

