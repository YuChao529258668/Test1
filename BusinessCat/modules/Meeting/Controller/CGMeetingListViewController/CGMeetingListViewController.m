//
//  CGMeetingListViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeetingListViewController.h"
#import "YCBookMeetingController.h"

#import "CGMeetingListCell.h"

#import "CGMeeting.h"
#import "YCMeetingBiz.h"

#import "YCMultiCallHelper.h"
#import "RoomViewController.h"
#import "YCJCSDKHelper.h"


#define kHeaderViewHeight 46
#define kHeaderViewBtnHeight 36
#define kCreateMeetingBtnHeight 50
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
    
    [self setupTableView];
    [self setupHeaderView];
    [self setupCreateMeetingBtn];
//    [self getMeetingModels];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMeetingModels];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"%@", @(self.navigationController.navigationBar.frame.size.height));

    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
//        frame.size.height -= kMeetingListBottomBarHeight;
        self.tableView.frame = frame;
    }
    
    {
        float x = self.view.frame.size.width - kCreateMeetingBtnHeight - kCreateMeetingBtnRightSpace;
        float y = self.view.frame.size.height - kCreateMeetingBtnHeight - kCreateMeetingBtnBottomSpace;
        CGRect frame = CGRectMake(x, y, kCreateMeetingBtnHeight, kCreateMeetingBtnHeight);
        self.createMeetingBtn.frame = frame;
    }

    
//    底部栏，放创建会议按钮
//    float y = self.view.frame.size.height - kMeetingListBottomBarHeight;
//    float width = self.view.frame.size.width;
//    self.bottomBar.frame = CGRectMake(0, y, width, kMeetingListBottomBarHeight);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    btn.backgroundColor = CTThemeMainColor;
    
    UIImage *image = [UIImage imageNamed:@"common_add_white"];
    image = [image imageWithTintColor:[UIColor blackColor]];
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
    YCBookMeetingController *vc = [YCBookMeetingController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    NSString *imageName; // 蓝色 work_clock, 黄色 work_meeting, 灰色 work_temporary
    int state = meeting.meetingState;
    
    switch (state) {
        case 0:// 未开始
            title = @"会议详情";
            if ([self isMeetingCreater:meeting]) {
                title = @"修改预约";
            }
            imageName = @"work_clock";
            break;
        case 1: // 进行中
            title = @"会议详情";
            if ([self isMeetingCreater:meeting]) {
                title = @"修改预约";
            }
            imageName = @"work_meeting";
            break;
        case 2: // 已结束
            title = @"再次召开";
            imageName = @"work_temporary";
            break;
        case 3: // 已取消
            title = @"再次召开";
            imageName = @"work_temporary";
            break;
    }
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell setImageName:imageName];
}

- (BOOL)isMeetingCreater:(CGMeeting *)meeting {
    return [[ObjectShareTool sharedInstance].currentUser.uuid isEqualToString:[meeting meetingCreator]];
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
    CGMeeting *meeting = self.meetings[indexPath.row];
    [[YCMeetingBiz new] meetingEntranceWithMeetingID:meeting.meetingId Success:^(int state, NSString *password, NSString *message) {
//        状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已取消
        if (state == 1) {
            [CTToast showWithText:message];
            [self goToVideoMeetingWithRoomID:meeting.roomId];
        }
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - 视频会议

- (void)goToVideoMeetingWithRoomID:(NSString *)rid {
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        //    roomVc.roomId = @"9990";
        //        roomVc.roomId = @"10726763"; // 服务器
//        roomVc.roomId = @"10877365"; // 服务器
        //        roomVc.roomId = @"10563734"; // yj 创建的会议室
        roomVc.roomId = rid;
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        [self.navigationController pushViewController:roomVc animated:YES];
    } else {
        [CTToast showWithText:@"会议功能尚未登录，请稍后再试"];
        [YCJCSDKHelper loginVideoCall];
    }

}


@end
