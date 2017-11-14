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
#define kCreateMeetingBtnHeight 50
#define kCreateMeetingBtnRightSpace 10
#define kCreateMeetingBtnBottomSpace 10

//#define kMeetingListBottomBarHeight 70

@interface CGMeetingListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *createMeetingBtn;

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

// 布局在viewWillLayoutSubviews
- (void)setupCreateMeetingBtn {
    // 创建按钮容器
//    float y = self.view.frame.size.height - kMeetingListBottomBarHeight;
//    float width = self.view.frame.size.width;
//    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, y, width, kMeetingListBottomBarHeight)];
//    bar.backgroundColor = [UIColor whiteColor];
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.layer.cornerRadius = kCreateMeetingBtnHeight / 2;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor redColor];
    
    [btn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createMeetingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.createMeetingBtn = btn;
    [self.view addSubview:btn];
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
