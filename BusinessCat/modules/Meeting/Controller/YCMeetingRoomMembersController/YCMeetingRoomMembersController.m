//
//  YCMeetingRoomMembersController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//


// 用于会议界面 RoomViewController，显示 成员 tab

#import "YCMeetingRoomMembersController.h"
#import "YCMeetingRoomMembersCell.h"

@interface YCMeetingRoomMembersController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation YCMeetingRoomMembersController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)setupTableView {
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = [YCMeetingRoomMembersCell cellHeight];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMeetingRoomMembersCell" bundle:nil] forCellReuseIdentifier:@"YCMeetingRoomMembersCell"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellReduceBtnClick:) name:[YCCreateMeetingUserCell reducceNotificationName] object:nil];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
    self.tableView.frame = frame;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingUser *user = self.users[indexPath.row];
    YCMeetingRoomMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingRoomMembersCell" forIndexPath:indexPath];

    cell.nameLabel.text = user.userName;
    cell.positionLabel.text = user.position;
    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:[UIImage imageNamed:@"work_head"]];

    return cell;
}

@end
