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

#import "CGMeeting.h"
#import "YCMeetingBiz.h"

#import "YCMultiCallHelper.h"
#import "RoomViewController.h"


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

@property (nonatomic,strong) NSArray<CGMeeting *> *meetings;
@property (nonatomic,assign) int currentPage; // 页数，用于获取后台分页数据

@end


@implementation CGMeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    
    [self setupTableView];
    [self setupHeaderView];
    [self setupCreateMeetingBtn];
//    [self getMeetingModels];
//    self.title = @"会议";
    
    [self createCustomNavi];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMeetingModels];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        self.tableView.frame = frame;
        
        // 适配旧代码
        float naviH = self.navi.frame.size.height;
        frame.origin = CGPointMake(0, naviH);
        frame.size = CGSizeMake(frame.size.width, frame.size.height - naviH);
        self.tableView.frame = frame;
    }
    
    {
        float x = self.view.frame.size.width - kCreateMeetingBtnHeight - kCreateMeetingBtnRightSpace;
        float y = self.view.frame.size.height - kCreateMeetingBtnHeight - kCreateMeetingBtnBottomSpace;
        CGRect frame = CGRectMake(x, y, kCreateMeetingBtnHeight, kCreateMeetingBtnHeight);
        self.createMeetingBtn.frame = frame;
    }
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
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        YCBookMeetingController *vc = [YCBookMeetingController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - Data

- (void)getMeetingModels {
    if (![ObjectShareTool sharedInstance].currentUser.token) {
        return;
    }
    
    self.currentPage = 0;
    
    [[YCMeetingBiz new] getMeetingListWithPage:self.currentPage Success:^(NSArray<CGMeeting *> *meetings) {
        self.meetings = meetings;
        [self updateHeaderView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取会议列表失败 : %@", error]];
    }];
}

- (void)getMoreMeetingModels {
    if (![ObjectShareTool sharedInstance].currentUser.token) {
        return;
    }
    
    self.currentPage ++;
    
    [[YCMeetingBiz new] getMeetingListWithPage:self.currentPage Success:^(NSArray<CGMeeting *> *meetings) {
        self.meetings = [self.meetings arrayByAddingObjectsFromArray:meetings];
//        [self updateHeaderView];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取更多会议列表失败 : %@", error]];
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
            title = @"再次召开";
            imageName = @"work_icon_2";
            break;
        case 3: // 已取消
            title = @"再次召开";
            imageName = @"work_icon_2";
            break;
    }
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell setImageName:imageName];
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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self test];
//    return;
    
    CGMeeting *meeting = self.meetings[indexPath.row];
    [[YCMeetingBiz new] meetingEntranceWithMeetingID:meeting.meetingId Success:^(int state, NSString *password, NSString *message) {
//        状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已取消
        if (state == 1) {
            [self goToVideoMeetingWithRoomID:meeting.conferenceNumber meetingID:meeting.meetingId];
        } else {
            [CTToast showWithText:message];
        }
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - 视频会议

- (void)goToVideoMeetingWithRoomID:(NSString *)rid meetingID:(NSString *)mid{
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        roomVc.roomId = rid;
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        roomVc.meetingID = mid;
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


@end
