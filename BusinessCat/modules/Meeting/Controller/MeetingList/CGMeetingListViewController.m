//
//  CGMeetingListViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeetingListViewController.h"
#import "YCBookMeetingController.h"
#import "CGMainLoginViewController.h"

#import "CGMeetingListCell.h"
#import "CGMeetingListTopBar.h"
#import "CGMeeting.h"
#import "YCMeetingBiz.h"

#import "YCMultiCallHelper.h"
#import "RoomViewController.h"

#import "YCCreateMeetingController.h"

#import "YCMeetingListCreateBar.h"

#define kHeaderViewHeight 46
#define kHeaderViewBtnHeight 36
#define kCreateMeetingBtnHeight 56
#define kCreateMeetingBtnRightSpace 10
#define kCreateMeetingBtnBottomSpace 30

//#define kMeetingListBottomBarHeight 70

@interface CGMeetingListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *createMeetingBtn;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *backImageView;


@property (nonatomic, strong) CGMeetingListTopBar *topBar;

@property (nonatomic,strong) NSArray<CGMeeting *> *meetings;
@property (nonatomic,assign) int currentPage; // 页数，用于获取后台分页数据
@property (nonatomic, assign) int dateType; //0：所有 1：今天 2：明天 3：本周 4：其他

@property (nonatomic, strong) YCMeetingListCreateBar *createBar;

@end


@implementation CGMeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    
    [self setupCreateBar];
    [self setupTopBar];
    [self setupTableView];
    [self setupHeaderView];
    [self setupCreateMeetingBtn];
//    [self getMeetingModels];
//    self.title = @"会议";
    
//    [self createCustomNavi];
    [self addObserverForLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        [self getMeetingModels];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    {
        CGRect rect = self.topBar.frame;
        rect.size.width = self.view.frame.size.width;
        rect.size.height = [CGMeetingListTopBar barHeight];
        self.topBar.frame = rect;
    }
    
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        self.tableView.frame = frame;
        
        // 适配旧代码
        float naviH = self.navi.frame.size.height;
        float topBarHeight = [CGMeetingListTopBar barHeight];
        frame.origin = CGPointMake(0, naviH + topBarHeight);
        frame.size = CGSizeMake(frame.size.width, frame.size.height - naviH);
        self.tableView.frame = frame;
    }
    
    {
        float x = self.view.frame.size.width - kCreateMeetingBtnHeight - kCreateMeetingBtnRightSpace;
        float y = self.view.frame.size.height - kCreateMeetingBtnHeight - kCreateMeetingBtnBottomSpace;
        CGRect frame = CGRectMake(x, y, kCreateMeetingBtnHeight, kCreateMeetingBtnHeight);
        self.createMeetingBtn.frame = frame;
    }
    
    self.backImageView.frame = self.view.bounds;
    
//    [self.createBar barAlignToView:self.createMeetingBtn];
//    self.createBar.frame = self.view.bounds;
    self.createBar.frame = [UIScreen mainScreen].bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 适配旧代码

-(void)createCustomNavi{
    self.titleStr = @"会议";
    
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


#pragma mark - Setup

// 布局在viewWillLayoutSubviews
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.tableFooterView = [UIView new];
    
    [tableView registerNib:[UINib nibWithNibName:@"CGMeetingListCell" bundle:nil] forCellReuseIdentifier:@"CGMeetingListCell"];
    
    tableView.rowHeight = [CGMeetingListCell cellHeight];
    tableView.separatorInset = UIEdgeInsetsMake(0, 800, 0, 0);
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellAtionBtnClick:) name:kCGMeetingListCellBtnClickNotification object:nil];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMeetingModels)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreMeetingModels)];
}

- (void)setupHeaderView {
    return;
    
    CGRect frame = self.view.bounds;
    frame.size.height = kHeaderViewHeight;
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
//    self.tableView.tableHeaderView = view;
    self.headerView = view;
    
    CGRect rect = frame;
    rect.size.height = kHeaderViewBtnHeight;
    rect.origin.y = kHeaderViewHeight - kHeaderViewBtnHeight;
    btn.frame = rect;
    
    btn.backgroundColor = CTThemeMainColor;
    btn.tag = 1;
//    [btn setTitle:@"您有会议正在召开" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
}

// 布局在viewWillLayoutSubviews
- (void)setupCreateMeetingBtn {    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.layer.cornerRadius = kCreateMeetingBtnHeight / 2;
    btn.clipsToBounds = YES;
//    btn.backgroundColor = CTThemeMainColor;
    
    UIImage *image = [UIImage imageNamed:@"work_add"];
//    image = [image imageWithTintColor:[UIColor blackColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createMeetingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.createMeetingBtn = btn;
    [self.view addSubview:btn];
}

- (void)setupTopBar {
    self.topBar = [CGMeetingListTopBar bar];
    [self.view addSubview:self.topBar];
    
    __weak typeof(self) weakself = self;
    self.topBar.didClickIndex = ^(int index) {
        weakself.dateType = index;
        [weakself.tableView.mj_header beginRefreshing];
    };
    self.topBar.didUnSelectBlock = ^{
        weakself.dateType = 0; // 所有
        [weakself.tableView.mj_header beginRefreshing];
        [CTToast showWithText:@"显示所有数据"];
    };
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backImageView.contentMode = UIViewContentModeCenter;
        _backImageView.hidden = YES;
        _backImageView.image = [UIImage imageNamed:@"word_picture"];
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}

- (void)setupCreateBar {
    _createBar = [YCMeetingListCreateBar bar];
    //        _createBar.hidden = YES;
    //        [self.view addSubview:_createBar];
    //        [self.view insertSubview:_createBar belowSubview:self.createMeetingBtn];
    
    __weak typeof(self) weakself = self;
    _createBar.clickButtonIndexBlock = ^(int index) {
        if (index == 0) {
            YCCreateMeetingController *vc = [YCCreateMeetingController new];
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    };
}

#pragma mark - Action

- (void)headerViewClick {
    
}

//显示规则：
//1）会议详情：未开始或进行中的会议，同时非创建者为会议详情。
//2）再次召开：已结束或已取消的会议，显示再次召开。执行再次再次召开后，将详情值加载到预约会议界面上。
//3）修改预约：创建者，并未开始显示为修改预约。

- (void)cellAtionBtnClick:(NSNotification *)noti {
    CGMeetingListCell *cell = (CGMeetingListCell *)noti.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CGMeeting *meeting = self.meetings[indexPath.row];
    int state = meeting.meetingState;
    
    switch (state) {
        case 0:// 未开始
            if ([self isMeetingCreater:meeting]) {
                // 修改预约
                [self goToModifyMeeting:meeting];
            } else {
                // 预约详情
                [self goToMeetingDetail:meeting];
            }
            break;
        case 1: // 进行中
            if ([self isMeetingCreater:meeting]) {
                // 修改预约
                [self goToModifyMeeting:meeting];
            } else {
                // 预约详情
                [self goToMeetingDetail:meeting];
            }
            break;
        case 2: // 已结束
                // 再次召开
            [self goToReopenMeeting:meeting];
            break;
        case 3: // 已取消
                // 再次召开
            [self goToReopenMeeting:meeting];
            break;
    }
}

- (void)createMeetingBtnClick {
//    self.createBar.hidden = !self.createBar.isHidden;
    [self.createBar showOrHide];
    return;
    
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
//        YCBookMeetingController *vc = [YCBookMeetingController new];
        YCCreateMeetingController *vc = [YCCreateMeetingController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - Data

- (void)getMeetingModels {
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
        return;
    }
    
    self.backImageView.hidden = YES;
    self.tableView.hidden = NO;
    
    self.currentPage = 1;
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingListWithPage:self.currentPage type:self.dateType Success:^(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics) {
        weakself.meetings = meetings;
        [weakself updateHeaderView];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        if (meetings.count) {
            weakself.backImageView.hidden = YES;
            weakself.tableView.hidden = NO;
        } else {
            weakself.backImageView.hidden = NO;
            weakself.tableView.hidden = YES;
        }
        [weakself.topBar updateWithToday0:statistics.toDayUnBeginMeetCount today1:statistics.toDayMeetCount tomorrow:statistics.tomorrowMeetCount week:statistics.weekMeetCount other:statistics.otherCount];
    } fail:^(NSError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取会议列表失败 : %@", error]];
    }];
}

- (void)getMoreMeetingModels {
    if (![ObjectShareTool sharedInstance].currentUser.token) {
        return;
    }
    
    self.currentPage ++;
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingListWithPage:self.currentPage type:self.dateType Success:^(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics) {
        weakself.meetings = [weakself.meetings arrayByAddingObjectsFromArray:meetings];
//        [self updateHeaderView];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [weakself.tableView.mj_footer endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取更多会议列表失败 : %@", error]];
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGMeeting *meeting = self.meetings[indexPath.row];
    if (!meeting.meetingRoomId) {
        // conferenceNumber?
        [CTToast showWithText:@"本地会议"];
        return;
    }
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingEntranceWithMeetingID:meeting.meetingId Success:^(int state, NSString *password, NSString *message, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *q) {
        // 状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
        if (state == 1 || state == 3) {
            [weakself goToVideoMeetingWithRoomID:meeting.conferenceNumber meetingID:meeting.meetingId state:state AccessKey:AccessKey SecretKey:SecretKey BucketName:BucketName q:q];
        } else {
            [CTToast showWithText:message];
        }
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGMeeting *meeting = self.meetings[indexPath.row];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:meeting.meetingUserList.count];
    for (YCMeetingUser *user in meeting.meetingUserList) {
        [titles addObject:user.userName];
    }
    
    CGMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CGMeetingListCell" forIndexPath:indexPath];
    cell.meetingTypeLabel.text = meeting.meetingName;
    [cell setCountLabelTextWithNumber:meeting.meetingUserList.count];
    [cell setTimeLabelTextWithTimeInterval:meeting.startTime];
    [cell setTitles:titles];
    cell.absendImageView.hidden = !meeting.isAbsent;
    [self configCell:cell withMeeting:meeting];
    return cell;
}


#pragma mark - 界面逻辑

// 会议状态 0:未开始    1:进行中    2：已结束     3：已取消
//图标状态：1）进行中：黄色底 2）已结束：灰色底 3）已取消：灰色底 4）未开始：蓝色底
// 会议详情，再次召开，修改预约
//显示规则：
//1）会议详情：未开始或进行中的会议，同时非创建者为会议详情。
//2）再次召开：已结束或已取消的会议，显示再次召开。执行再次再次召开后，将详情值加载到预约会议界面上。
//3）修改预约：创建者，并未开始显示为修改预约。
- (void)configCell:(CGMeetingListCell *)cell withMeeting:(CGMeeting *)meeting {
    NSString *title;
    NSString *imageName; // 蓝色 work_icon_3, 黄色 work_icon_1, 灰色 work_temporary
    int state = meeting.meetingState;
    
    switch (state) {
        case 0:// 未开始
            title = @"会议详情";
            if ([self isMeetingCreater:meeting]) {
                title = @"修改预约";
            }
            imageName = @"work_icon_3";
            break;
        case 1: // 进行中
            title = @"会议详情";
            if ([self isMeetingCreater:meeting]) {
                title = @"修改预约";
            }
            imageName = @"work_icon_1";
            break;
        case 2: // 已结束
            title = @"再次开会";
            imageName = @"work_icon_2";
            break;
        case 3: // 已取消
            title = @"再次开会";
            imageName = @"work_icon_2";
            break;
    }
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell setImageName:imageName];
    
    
    BOOL isGray = meeting.meetingState == 2;
    NSString *typeImageName; // 本地会议：meeting_bighome_normal，远程视频：meeting_videobtn_normal，远程语音：meeting_speech_normal
    // 0远程，1现场
    if (meeting.absentOrRemote == 1) {// 现场开会
        typeImageName = @"meeting_bighome_normal";
        if (isGray) {
            typeImageName = @"meeting_bighome_visited";
        }
        cell.locationLabel.text = meeting.roomName;
    } else {
        // 会议形式（0：音频，1：视频）
        if (meeting.meetingType) {
            typeImageName = @"meeting_videobtn_normal";
            if (isGray) {
                typeImageName = @"meeting_videobtn_visited";
            }
            cell.locationLabel.text = @"视频会议";
        } else {
            typeImageName = @"meeting_speech_normal";
            if (isGray) {
                typeImageName = @"meeting_bigspeech_visited";
            }
            cell.locationLabel.text = @"音频会议";
        }
    }
    [cell setTypeImageName:typeImageName];
}

- (BOOL)isMeetingCreater:(CGMeeting *)meeting {
    return [[ObjectShareTool currentUserID] isEqualToString:meeting.ycCompereID];
}

- (void)goToMeetingDetail:(CGMeeting *)meeting {
    YCBookMeetingController *vc = [YCBookMeetingController new];
    vc.meeting = meeting;
    vc.style = YCBookMeetingControllerStylePreview;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToModifyMeeting:(CGMeeting *)meeting {
    YCBookMeetingController *vc = [YCBookMeetingController new];
    vc.meeting = meeting;
    vc.style = YCBookMeetingControllerStyleModify;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToReopenMeeting:(CGMeeting *)meeting {
    YCBookMeetingController *vc = [YCBookMeetingController new];
    vc.meeting = meeting;
    vc.style = YCBookMeetingControllerStyleReopen;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateHeaderView {
    // 只在今天显示
    if (self.dateType != 1) {
        self.tableView.tableHeaderView = nil;
        return;
    }
    
    // 会议状态 0:未开始 1：进行中
    int ready = 0;
    for (CGMeeting *meeting in self.meetings) {
        if (meeting.meetingState == 1) {
            UIButton *btn = [self.headerView viewWithTag:1];
            [btn setTitle:@"您有会议正在召开" forState:UIControlStateNormal];
            self.tableView.tableHeaderView = self.headerView;
            return;
        }
        if (meeting.meetingState == 0) {
            ready ++;
        }
    }
    
    if (ready > 0) {
        UIButton *btn = [self.headerView viewWithTag:1];
        NSString *title = [NSString stringWithFormat:@"您有 %d 个会议需要参加", ready];
        [btn setTitle:title forState:UIControlStateNormal];
        self.tableView.tableHeaderView = self.headerView;
        return;
    }
    
    self.tableView.tableHeaderView = nil;
}


#pragma mark - 视频会议

//        状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
- (void)goToVideoMeetingWithRoomID:(NSString *)rid meetingID:(NSString *)mid state:(long)state AccessKey:(NSString *)AccessKey SecretKey:(NSString *)SecretKey BucketName:(NSString *)BucketName q:(NSString *)q {
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        roomVc.roomId = rid;
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        roomVc.meetingID = mid;
        roomVc.meetingState = state;
        roomVc.isReview = state == 3? YES: NO;
        roomVc.AccessKey = AccessKey;
        roomVc.SecretKey = SecretKey;
        roomVc.BucketName = BucketName;
        roomVc.q = q;
        [self.navigationController pushViewController:roomVc animated:YES];
    } else {
        [CTToast showWithText:@"会议功能尚未登录，请稍后再试"];
        [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    }
}

- (void)test {
    RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    roomVc.roomId = @"111";
    roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
    [self.navigationController pushViewController:roomVc animated:YES];
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{
    [self getMeetingModels];
}


#pragma mark - 定时刷新

- (void)checkForUpdate {
    //
    
    self.currentPage = 1;
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingListWithPage:self.currentPage type:self.dateType Success:^(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics) {
        weakself.meetings = meetings;
        [weakself updateHeaderView];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        if (meetings.count) {
            weakself.backImageView.hidden = YES;
            weakself.tableView.hidden = NO;
        } else {
            weakself.backImageView.hidden = NO;
            weakself.tableView.hidden = YES;
        }
        [weakself.topBar updateWithToday0:statistics.toDayUnBeginMeetCount today1:statistics.toDayMeetCount tomorrow:statistics.tomorrowMeetCount week:statistics.weekMeetCount other:statistics.otherCount];
    } fail:^(NSError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取会议列表失败 : %@", error]];
    }];
}

#pragma mark -

- (void)addObserverForLogin {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccessNotification) name:NOTIFICATION_LOGINSUCCESS object:nil];
}

- (void)handleLoginSuccessNotification {
    [self getMeetingModels];
}


@end
