//
//  YCSelectMeetingRoomController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCSelectMeetingRoomController.h"

#import "YCSelectRoomHeaderView.h"


@interface YCSelectMeetingRoomController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) YCSelectRoomHeaderView *firstHeaderView;
@property (nonatomic,strong) YCSelectRoomHeaderView *secondHeaderView;

@property (nonatomic,assign) NSUInteger firstSectionRowNumber;
@property (nonatomic,assign) NSUInteger secondSectionRowNumber;

@end

@implementation YCSelectMeetingRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择会议室";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 74;
    self.tableView.sectionHeaderHeight = [YCSelectRoomHeaderView headerViewHeight];
    
    self.firstSectionRowNumber = self.companyRooms.count;
    self.secondSectionRowNumber = self.otherRooms.count;
    
    [self setupHeaderView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
        self = [sb instantiateViewControllerWithIdentifier:@"YCSelectMeetingRoomController"];
    }
    return self;
}

- (void)setupHeaderView {
    self.firstHeaderView = [YCSelectRoomHeaderView headerView];
    [self.firstHeaderView.button addTarget:self action:@selector(firstSectionHeaderViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.firstHeaderView.countLabel.text = [NSString stringWithFormat:@"%ld", self.companyRooms.count];
    self.firstHeaderView.nameLabel.text = @"公司会议室";
    [self.firstHeaderView.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    self.secondHeaderView = [YCSelectRoomHeaderView headerView];
    [self.secondHeaderView.button addTarget:self action:@selector(secondSectionHeaderViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.secondHeaderView.countLabel.text = [NSString stringWithFormat:@"%ld", self.otherRooms.count];
    self.secondHeaderView.nameLabel.text = @"生意猫会议室";
    [self.secondHeaderView.button sendActionsForControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Action

- (void)firstSectionHeaderViewClick {
    if (self.firstHeaderView.triangleBtn.isSelected) {
        self.firstSectionRowNumber = self.companyRooms.count;
    } else {
        self.firstSectionRowNumber = 0;
    }
    [self.tableView reloadData];
}

- (void)secondSectionHeaderViewClick {
    if (self.secondHeaderView.triangleBtn.isSelected) {
        self.secondSectionRowNumber = self.otherRooms.count;
    } else {
        self.secondSectionRowNumber = 0;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectRoom) {
        YCMeetingRoom *room;
        if (indexPath.section == 0) {
            room = self.companyRooms[indexPath.row];
        } else {
            room = self.otherRooms[indexPath.row];
        }

        self.didSelectRoom(room);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstSectionRowNumber;
    }
    return self.secondSectionRowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingRoom *room;
    if (indexPath.section == 0) {
        room = self.companyRooms[indexPath.row];
    } else {
        room = self.otherRooms[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *nameL = [cell viewWithTag:1];
    UILabel *contentL = [cell viewWithTag:2];
    UILabel *yellowL = [cell viewWithTag:3];
    
    nameL.text = room.roomname;
    contentL.text = room.roomHint;
    yellowL.backgroundColor = CTThemeMainColor;
    yellowL.layer.cornerRadius = 4;
    yellowL.clipsToBounds = YES;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstHeaderView;
    }
    return self.secondHeaderView;
}

@end
