//
//  CGMeetingListViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeetingListViewController.h"

#import "CGMeetingListCell.h"

#import "CGMeeting.h"

#define kHeaderViewHeight 46


@interface CGMeetingListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *meetings;

@end

@implementation CGMeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    [self setupHeaderView];
    [self setupCreateMeetingBtn];
    [self getMeetingModels];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Setup

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
}

- (void)setupHeaderView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView.tableHeaderView = btn;
    
    CGRect frame = self.view.bounds;
    frame.size.height = kHeaderViewHeight;
    btn.frame = frame;
    
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"您有会议正在召开，点此进入..." forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCreateMeetingBtn {
    
}

#pragma mark -

- (void)headerViewClick {
    
}

- (void)cellAtionBtnClick:(NSNotification *)noti {
    CGMeetingListCell *cell = (CGMeetingListCell *)noti.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
}

- (void)createMeetingBtnClick {
    
}

#pragma mark - Data

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
//    CGMeetingListCellButtonModell *m = [CGMeetingListCellButtonModell new];
//    m.title = @"阿斯兰";
//    NSArray *array = @[m,m,m,m];
    
    NSString *title = @"阿斯兰";
    NSArray *array = @[title, title, title, title, title, title, title, title, title];
    
    CGMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CGMeetingListCell" forIndexPath:indexPath];
    [cell setCountLabelTextWithNumber:@"3"];
//    [cell setBtnModels:array];
    [cell setTitles:array];
    return cell;
}

#pragma mark - UITableViewDelegate



@end
