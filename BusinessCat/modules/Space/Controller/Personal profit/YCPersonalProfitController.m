//
//  YCPersonalProfitController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/31.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCPersonalProfitController.h"
#import "YCPersonalProfitCell.h"
#import "YCJoinShareController.h"

@interface YCPersonalProfitController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bar;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noIncomeView;
@property (weak, nonatomic) IBOutlet UILabel *todayL;
@property (weak, nonatomic) IBOutlet UILabel *waitL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraint;
@property (nonatomic, strong) YCMeetingProfit *profit;
@end


@implementation YCPersonalProfitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.shouldHideNavigationBar) {
        self.navHeightConstraint.constant = 0;
    }
    
    self.titleL.text = self.title;
    self.noIncomeView.hidden = YES;
//    self.noIncomeView.hidden = NO;

    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tb.tableFooterView = [UIView new];
    [tb registerNib:[UINib nibWithNibName:@"YCPersonalProfitCell" bundle:nil] forCellReuseIdentifier:@"YCPersonalProfitCell"];
    tb.dataSource = self;
    tb.delegate = self;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView = tb;
    [self.scrollView addSubview:tb];
    [self.scrollView addSubview:self.bar];
    [self.view addSubview:self.topView];

    CGSize size = CGSizeZero;
    size.width = [YCPersonalProfitCell cellWidth];
    self.scrollView.contentSize = size;
    
    [self getProfit];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect topFrame = [UIScreen mainScreen].bounds;
    topFrame.origin.y = 64;
    if (self.shouldHideNavigationBar) {
        topFrame.origin.y = 0;
    }
    topFrame.size.height = 99;
    self.topView.frame = topFrame;

    CGRect barF = self.bar.frame;
    barF.origin.x = 0;
    barF.origin.y = 0;
    barF.size.width = [YCPersonalProfitCell cellWidth];
    barF.size.height = 30;
    self.bar.frame = barF;

    CGRect frame = self.scrollView.bounds;
    frame.origin.y = CGRectGetMaxY(self.bar.frame);
    frame.size.width = [YCPersonalProfitCell cellWidth];
    self.tableView.frame = frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profit.meetingRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCPersonalProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCPersonalProfitCell" forIndexPath:indexPath];
    YCMeetingRecord *record = self.profit.meetingRecordList[indexPath.row];
    cell.dateL.text = record.dateString;
    cell.nameL.text = record.userName;
    cell.incomeL.text = [YCTool numberStringOf:record.videoCost];
    cell.durationL.text = record.durationString;
    cell.stateL.text = record.stateString;
    cell.stateL.textColor = record.stateColor;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSLog(@"viewForHeaderInSection");
// 不执行？？？
//    return self.bar;
//}


#pragma mark -

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickJoinBtn:(UIButton *)sender {
    YCJoinShareController *vc = [YCJoinShareController new];
    vc.type = self.type;
    vc.companyID = self.companyID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getProfit {
    __weak typeof(self) weakself = self;
    [YCSpaceBiz getProfitWithType:self.type companyID:self.companyID Success:^(YCMeetingProfit *profit){
        [weakself updateWithProfit:profit];
    } fail:^(NSError *error) {
        
    }];
}

//- (void)reloadDataWithCompanyID:(NSString *)cid {
//    self.companyID = cid;
//    [self getProfit];
//}

- (void)updateWithProfit:(YCMeetingProfit *)profit {
    self.profit = profit;
    [self.tableView reloadData];
    
    if (self.type == 1) {
        self.noIncomeView.hidden = profit.isShare;
    }
    YCOneMeetingProfit *op = profit.shareProfit.firstObject;
    self.todayL.text = [YCTool numberStringOf:op.todayIncome];
    self.waitL.text = [YCTool numberStringOf:op.forIncome];
    self.totalL.text = [YCTool numberStringOf:op.totalIncome];
}

@end
