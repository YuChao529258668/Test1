//
//  YCMeetingRoomListController.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingRoomListController.h"
#import "YCMeetingRoomListCell.h"
#import "YCMeetingBiz.h"
#import "YCMeetingRoom.h"
#import "YCPickerViewForDateController.h"
#import "YCCreateMeetingController.h"
#import "YCEditMeetingRoomController.h"

#import "YCRoomMeetingListController.h"
#import "CGUserChangeOrganizationViewController.h"

#import "CGUserOrganizaJoinEntity.h"
#import "CGHorrolView.h"
#import "CGLineLayout.h"

@interface YCMeetingRoomListController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray<CGHorrolEntity *> *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<YCMeetingCompanyRoom *> *companyRooms;
@property (nonatomic, strong) NSMutableArray *companyIDs;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL isToday;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation YCMeetingRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleView.text = @"会议室";
    
    self.date = [NSDate date];
    self.isToday = YES;
    [self updateDateLabel];
    
    [self setupTableView];
    [self getCompanyList];
    [self getData];
    [self setupAddBtn];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMeetingRoomListCell" bundle:nil] forCellReuseIdentifier:@"YCMeetingRoomListCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.rowHeight = [YCMeetingRoomListCell hight];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBookBtn:) name:[YCMeetingRoomListCell notificationName] object:nil];
}

- (void)setupAddBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    float x = SCREEN_WIDTH - 44 - 6;
    float y = CTMarginTop;
    CGRect frame = CGRectMake(x, y, 44, 44);
    btn.frame = frame;
    UIImage *image = [UIImage imageNamed:@"icon_add"];
    image = [image imageWithColor:[UIColor blackColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [self.navi addSubview:btn];
    [btn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = btn;
}

- (void)updateDateLabel {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"YYYY年MM月dd日 EEEE";
    self.dateL.text = [f stringFromDate:self.date];
}

- (void)makeCompanyIDs {
    self.companyIDs = [NSMutableArray arrayWithCapacity:self.companyRooms.count];
    for (YCMeetingCompanyRoom *cr in self.companyRooms) {
        [self.companyIDs addObject:cr.id];
    }
}

- (CGUserOrganizaJoinEntity *)companyOfID:(NSString *)cid {
    CGUserOrganizaJoinEntity *entity;
    for (CGUserOrganizaJoinEntity *je in [ObjectShareTool sharedInstance].currentUser.companyList) {
        if ([je.companyId isEqualToString:cid]) {
            return je;
        }
    }
    return entity;
}

- (void)updateAddBtn {
    //    添加会议室权限的规则如下：
    //    1）未认领组织，已加入的成员谁都可以添加会议室及显示+号
    //    2）已认领组织，只有管理员及超级管理的人才可以添加会议室及显示+号
    CGUserOrganizaJoinEntity *entity = [self companyOfID:self.companyIDs[self.selectIndex]];
    
//    @property(nonatomic,assign)int companyAdmin;//是否为超级管理员
//    @property (nonatomic, assign) int companyManage;//当前用户是否是公司管理
//    @property(nonatomic,assign)int companyState;//0-未认证，1-已认证 2-认证中 3-认证不通过

    if (entity.companyState == 1) {
        if (entity.companyAdmin || entity.companyManage) {
            self.addBtn.hidden = NO;
        } else {
            self.addBtn.hidden = YES;
        }
    } else {
        self.addBtn.hidden = NO;
    }
}

#pragma mark - Data

- (void)getData {
    __weak typeof(self) weakself = self;

    [[YCMeetingBiz new] getMeetingRoomTimeListWithSelectDate:self.date success:^(NSArray<YCMeetingCompanyRoom *> *companyRooms) {
        weakself.companyRooms = companyRooms;
        [weakself makeCompanyIDs];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView reloadData];
    } fail:^(NSError *error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - Actions

- (IBAction)clickDateBtn:(id)sender {
    YCPickerViewForDateController *vc = [YCPickerViewForDateController new];
    vc.mode = UIDatePickerModeDate;
    vc.hint = @"选择日期";
    vc.minimumDate = [NSDate date];
    vc.onSelectItemBlock = ^(NSDate *date) {
        self.date = date;
        self.isToday = [date isToday];
        [self updateDateLabel];
        [self getData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickBookBtn:(NSNotification *)noti {
    YCMeetingRoomListCell *cell = (YCMeetingRoomListCell *)noti.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YCMeetingRoom *room = self.companyRooms[indexPath.section].roomData[indexPath.row];
    
    YCCreateMeetingController *vc = [YCCreateMeetingController new];
    vc.useCollectionView = YES;
    vc.room = room;
    vc.pointDate = self.date;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickJoinBtn:(id)sender {
    CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickAddBtn {
    YCMeetingCompanyRoom *companyRoom = [YCMeetingCompanyRoom new];
    companyRoom.id = self.companyIDs[self.selectIndex];
    
    YCEditMeetingRoomController *vc = [YCEditMeetingRoomController new];
    vc.isAddMode = YES;
    vc.isAddressMode = NO;
    vc.companyRoom = companyRoom;
    vc.saveSuccessBlock = ^{
        self.bgView.hidden = YES;
        [self getData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickTopViewWithIndex:(int)index {
    self.selectIndex = index;
    [self updateAddBtn];
    [self.tableView reloadData];

    if (self.companyRooms[index].roomData.count == 0) {
        self.bgView.hidden = NO;
        self.joinBtn.hidden = YES;
        self.hintLabel.text = @"请先添加会议室";
    } else {
        self.bgView.hidden = YES;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.companyRooms.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.selectIndex) {
        YCMeetingCompanyRoom *company = self.companyRooms[section];
        return company.roomData.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingCompanyRoom *company = self.companyRooms[indexPath.section];
    YCMeetingRoom *room = company.roomData[indexPath.row];
    
    YCMeetingRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingRoomListCell" forIndexPath:indexPath];
    cell.isToday = self.isToday;
    cell.room = room;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingCompanyRoom *company = self.companyRooms[indexPath.section];
    YCMeetingRoom *room = company.roomData[indexPath.row];

    YCRoomMeetingListController *vc = [YCRoomMeetingListController new];
    vc.room = room;
    vc.date = self.date;
    vc.roomDidUpdateBlock = ^(YCMeetingRoom *room) {
        if (room) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableView reloadData];
        } else {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            if ([self.tableView cellForRowAtIndexPath:ip]) {
                [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            [self getData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 顶部滚动栏

- (void)updateTopViewState{
    if (self.dataArray.count<=1) {
        self.topViewHeightConstraint.constant = 0;
    } else {
        self.topViewHeightConstraint.constant = 40;
    }
}

- (CGHorrolView *)bigTypeScrollView{
    if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
        [_bigTypeScrollView removeFromSuperview];
        __weak typeof(self) weakSelf = self;

        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.dataArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            [weakSelf clickTopViewWithIndex:index];
        }];
    }
    return _bigTypeScrollView;
}


- (void)getCompanyList{
    [self updateTopViewState];
    self.bgView.hidden = YES;
    //  __weak typeof(self) weakSelf = self;
    
//    [ObjectShareTool sharedInstance].currentUser.companyList = nil;
    if ([ObjectShareTool sharedInstance].currentUser.auditCompanyList && [ObjectShareTool sharedInstance].currentUser.auditCompanyList.count > 0) {
        
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.auditCompanyList.count; i++) {
            
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.auditCompanyList[i];
            if (companyEntity.auditStete == 1) {
                CGHorrolEntity *entity;
                if (companyEntity.companyType == 2) {
                    entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
                }else{
                    entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
                }
                
                entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
                [self.dataArray addObject:entity];
            }
        }
        
        [self.topView addSubview:self.bigTypeScrollView];
        [self updateTopViewState];
    } else {
        self.bgView.hidden = NO;
        self.joinBtn.hidden = NO;
        self.hintLabel.text = @"请加入组织";
    }
}




@end
