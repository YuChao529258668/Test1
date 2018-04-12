//
//  YCRoomMeetingListController.m
//  BusinessCat
//
//  Created by 余超 on 2018/4/8.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCRoomMeetingListController.h"
#import "YCMeetingBiz.h"
#import "YCPickerViewForDateController.h"
#import "YCCreateMeetingController.h"
#import "CGMeetingListCell.h"
#import "YCBookMeetingController.h"
#import "RoomViewController.h"

#import "YCEditMeetingRoomController.h"


#define kCreateMeetingBtnHeight 56
#define kCreateMeetingBtnRightSpace 10
#define kCreateMeetingBtnBottomSpace 30

@interface YCRoomMeetingListController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) UIImageView *backImageView;// 会议室无会议
@property (nonatomic,strong) UIButton *createMeetingBtn;

@property (nonatomic,strong) NSMutableArray<CGMeeting *> *meetings;
@property (nonatomic,assign) int currentPage; // 页数，用于获取后台分页数据

@property (weak, nonatomic) IBOutlet UIView *bgView;// 未加入组织
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation YCRoomMeetingListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupRightBtn];
    [self setupCreateMeetingBtn];
    [self setupTableView];
    [self updateDateLabel];
    self.titleView.text = self.room.roomName;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    {
        float x = self.view.frame.size.width - kCreateMeetingBtnHeight - kCreateMeetingBtnRightSpace;
        float y = self.view.frame.size.height - kCreateMeetingBtnHeight - kCreateMeetingBtnBottomSpace;
        CGRect frame = CGRectMake(x, y, kCreateMeetingBtnHeight, kCreateMeetingBtnHeight);
        self.createMeetingBtn.frame = frame;
    }
    
//    self.backImageView.frame = self.view.bounds;
    
}


#pragma mark -

- (void)updateDateLabel {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"YYYY年MM月dd日 EEEE";
    self.dateL.text = [f stringFromDate:self.date];
}

// 布局在viewWillLayoutSubviews
- (void)setupTableView {
    UITableView *tableView = self.tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.tableFooterView = [UIView new];
    
    [tableView registerNib:[UINib nibWithNibName:@"CGMeetingListCell" bundle:nil] forCellReuseIdentifier:@"CGMeetingListCell"];
    
    tableView.rowHeight = [CGMeetingListCell cellHeight];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellAtionBtnClick:) name:kCGMeetingListCellBtnClickNotification object:nil];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMeetingModels)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreMeetingModels)];
    footer.automaticallyRefresh = NO;
    tableView.mj_footer = footer;
    [tableView.mj_header beginRefreshing];
}

- (void)setupCreateMeetingBtn {
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.layer.cornerRadius = kCreateMeetingBtnHeight / 2;
    btn.clipsToBounds = YES;
    //    btn.backgroundColor = CTThemeMainColor;
    
    UIImage *image = [UIImage imageNamed:@"work_add"];
    //    image = [image imageWithTintColor:[UIColor blackColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBookBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.createMeetingBtn = btn;
    [self.view addSubview:btn];
}

- (void)setupRightBtn {
    // 判断？
//    添加会议室权限的规则如下：
//    1）未认领组织，已加入的成员谁都可以添加会议室及显示+号
//    2）已认领组织，只有管理员及超级管理的人才可以添加会议室及显示+号

    self.editBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 22, 40, 40)];
    [self.editBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn setImage:[UIImage imageNamed:@"icon_panbook"] forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navi addSubview:self.editBtn];
}

//- (UIImageView *)backImageView {
//    if (!_backImageView) {
//        _backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        _backImageView.contentMode = UIViewContentModeCenter;
//        _backImageView.hidden = YES;
//        _backImageView.image = [UIImage imageNamed:@"word_picture"];
//        [self.view addSubview:_backImageView];
//    }
//    return _backImageView;
//}

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


#pragma mark - Actions

- (IBAction)clickDateBtn:(id)sender {
    YCPickerViewForDateController *vc = [YCPickerViewForDateController new];
    vc.mode = UIDatePickerModeDate;
    vc.hint = @"选择日期";
    vc.minimumDate = [NSDate date];
    vc.onSelectItemBlock = ^(NSDate *date) {
        self.date = date;
        [self updateDateLabel];
        [self getMeetingModels];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)clickBookBtn:(UIButton *)sender {
    YCCreateMeetingController *vc = [YCCreateMeetingController new];
    vc.useCollectionView = YES;
    vc.room = self.room;
    vc.pointDate = self.date;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickRightBtn {
    YCEditMeetingRoomController *vc = [YCEditMeetingRoomController new];
    vc.isAddMode = NO;
    vc.isAddressMode = self.room.isAddress == 1;
    vc.room = self.room;
    vc.companyRoom = self.room.companyRoom;
    vc.saveSuccessBlock = ^{
        self.titleView.text = self.room.roomName;
        if (self.roomDidUpdateBlock) {
            self.roomDidUpdateBlock(self.room);
        }
    };
    vc.deleteSuccessBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.roomDidUpdateBlock) {
            self.roomDidUpdateBlock(nil);
        }
    };
    [self presentViewController:vc animated:YES completion:nil];

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


#pragma mark - Data

- (void)getMeetingModels {
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
        return;
    }
    
    self.bgView.hidden = YES;
    self.tableView.hidden = NO;
    
    self.currentPage = 0;
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getRoomMeetingListWithPage:self.currentPage companyRoomId:self.room.roomId date:self.date Success:^(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics) {
        weakself.meetings = meetings.mutableCopy;
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        if (meetings.count) {
            weakself.bgView.hidden = YES;
            weakself.tableView.hidden = NO;
        } else {
            weakself.bgView.hidden = NO;
            weakself.tableView.hidden = YES;
        }
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
    [[YCMeetingBiz new] getRoomMeetingListWithPage:self.currentPage companyRoomId:self.room.roomId date:self.date Success:^(NSArray<CGMeeting *> *meetings, CGMeetingStatistics *statistics) {
        [weakself handleMoreData:meetings];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        weakself.currentPage --;
        [weakself.tableView.mj_footer endRefreshing];
        [CTToast showWithText:[NSString stringWithFormat:@"获取更多会议列表失败 : %@", error]];
    }];
}

- (void)handleMoreData:(NSArray<CGMeeting *> *)meetings {
    if (meetings.count == 0) {
        self.currentPage --;
        return;
    }
    if ([self.meetings.lastObject.meetingId isEqualToString:meetings.lastObject.meetingId]) {
        self.currentPage --;
        return;
    }
    
    for (CGMeeting *new in meetings) {
        BOOL has = NO;
        for (CGMeeting *old in self.meetings) {
            if ([new.meetingId isEqualToString:old.meetingId]) {
                has = YES;
                break;
            }
        }
        if (!has) {
            [self.meetings addObject:new];
        }
    }
}


#pragma mark -

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

@end
