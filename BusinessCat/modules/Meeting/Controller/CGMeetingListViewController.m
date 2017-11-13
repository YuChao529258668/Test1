//
//  MeetingListViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "MeetingListViewController.h"

#import "CGMeetingListCell.h"

#import "CGMeeting.h"

@interface MeetingListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *meetings;

@end

@implementation MeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    [self getMeetingModels];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.tableFooterView = [UIView new];
    
    [tableView registerClass:[CGMeetingListCell class] forCellReuseIdentifier:@"CGMeetingListCell"];
}

- (void)getMeetingModels {
    self.meetings = [NSMutableArray array];
    CGMeeting *m = [CGMeeting new];
    [self.meetings addObject:m];
    [self.meetings addObject:m];
    [self.meetings addObject:m];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CGMeetingListCell" forIndexPath:indexPath];
    [cell setCountLabelTextWithNumber:@"3"];
    return cell;
}

#pragma mark - UITableViewDelegate



@end
