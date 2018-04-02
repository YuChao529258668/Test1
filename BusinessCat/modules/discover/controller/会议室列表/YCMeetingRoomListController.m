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

@interface YCMeetingRoomListController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<YCMeetingCompanyRoom *> *companyRooms;
@property (nonatomic, strong) NSDate *date;

@end

@implementation YCMeetingRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleView.text = @"会议室";
    
    self.date = [NSDate date];
    [self updateDateLabel];
    
    [self setupTableView];
    [self getData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMeetingRoomListCell" bundle:nil] forCellReuseIdentifier:@"YCMeetingRoomListCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.rowHeight = [YCMeetingRoomListCell hight];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBookBtn:) name:[YCMeetingRoomListCell notificationName] object:nil];
}

- (void)updateDateLabel {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"YYYY年MM月dd日 EEEE";
    self.dateL.text = [f stringFromDate:self.date];
}

#pragma mark - Data

- (void)getData {
    __weak typeof(self) weakself = self;

    [[YCMeetingBiz new] getMeetingRoomTimeListWithSelectDate:self.date success:^(NSArray<YCMeetingCompanyRoom *> *companyRooms) {
        weakself.companyRooms = companyRooms;
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
        [self updateDateLabel];
        [self getData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickBookBtn:(NSNotification *)noti {
    YCCreateMeetingController *vc = [YCCreateMeetingController new];
    vc.useCollectionView = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.companyRooms.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCMeetingCompanyRoom *company = self.companyRooms[section];
    return company.roomData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingCompanyRoom *company = self.companyRooms[indexPath.section];
    YCMeetingRoom *room = company.roomData[indexPath.row];
    
    YCMeetingRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingRoomListCell" forIndexPath:indexPath];
    cell.room = room;
    return cell;
}



@end
