//
//  YCSeeBoardController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSeeBoardController.h"
#import "YCSeeBoardCell.h"
#import "YCSpaceBiz.h"
#import "YCPersonalProfitController.h"
#import "YCJoinShareController.h"

@interface YCSeeBoardController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<YCOneMeetingProfit *> *shareProfits;
@property (nonatomic, strong) YCSeeBoard *board;

@property (weak, nonatomic) IBOutlet UILabel *todayL;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowL;
@property (weak, nonatomic) IBOutlet UILabel *weekL;
@property (weak, nonatomic) IBOutlet UILabel *otherL;

@property (weak, nonatomic) IBOutlet UILabel *meetingCountL;
@property (weak, nonatomic) IBOutlet UILabel *meetingTimeL;
@property (weak, nonatomic) IBOutlet UILabel *onTimetL;
@property (weak, nonatomic) IBOutlet UILabel *lateL;
@property (weak, nonatomic) IBOutlet UILabel *absentL;
@property (weak, nonatomic) IBOutlet UIView *onTimeV;
@property (weak, nonatomic) IBOutlet UIView *lateV;
@property (weak, nonatomic) IBOutlet UIView *absentV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onTimeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lateH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *absentH;

@end

@implementation YCSeeBoardController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tb = self.tableView;
    [tb registerNib:[UINib nibWithNibName:@"YCSeeBoardCell" bundle:nil] forCellReuseIdentifier:@"YCSeeBoardCell"];
    tb.dataSource = self;
    tb.delegate = self;
    tb.tableHeaderView = self.headerView;
    tb.tableFooterView = [UIView new];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClickCellJoinBtn:) name:[YCSeeBoardCell notificationName] object:nil];
    
    [self getData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shareProfits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCSeeBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCSeeBoardCell" forIndexPath:indexPath];
    YCOneMeetingProfit *profit = self.shareProfits[indexPath.row];
    cell.nameL.text = profit.name;
    cell.todayL.text = [NSString stringWithFormat:@"%.02g", profit.todayIncome];
    cell.waitL.text = [NSString stringWithFormat:@"%.02g", profit.forIncome];
    cell.totalL.text = [NSString stringWithFormat:@"%.02g", profit.totalIncome];

    if (profit.type == 1) {// 个人
        if (self.board.isShare) { // 已加入共享
            cell.joinBtn.hidden = YES;
        } else {
            cell.joinBtn.hidden = NO;
        }
    } else {
        cell.joinBtn.hidden = YES;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCOneMeetingProfit *profit = self.shareProfits[indexPath.row];
    YCPersonalProfitController *vc = [YCPersonalProfitController new];
    vc.type = profit.type;
    vc.companyID = profit.id;
    vc.title = profit.name;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Data

- (void)getData {
    __weak typeof(self) weakself = self;
    [YCSpaceBiz getBoardWithSuccess:^(YCSeeBoard *board) {
        NowMonthMeeting *nowMonthMeeting = board.nowMonthMeeting;
        NowMonthStatistics *nowMonthStatistics = board.nowMonthStatistics;
        weakself.board = board;
        weakself.shareProfits = board.shareProfit;
        [weakself.tableView reloadData];
        
        weakself.todayL.text = [NSString stringWithFormat:@"%d/%d 场", [nowMonthMeeting toDayUnBeginMeetCount], [nowMonthMeeting toDayMeetCount]];
        weakself.tomorrowL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.tomorrowMeetCount];
        weakself.weekL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.weekMeetCount];
        weakself.otherL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.otherCount];
        
        weakself.meetingCountL.text = [NSString stringWithFormat:@"%d 场", nowMonthStatistics.meetingCount];
        [YCTool HMSForSeconds:nowMonthStatistics.useTotal*60 block:^(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string) {
            if (h) {
                [string appendFormat:@"%ld小时", (long)h];
            }
            if (m) {
                [string appendFormat:@"%ld分钟", (long)m];
            }
            if (h + m == 0) {
                [string appendString:@"0 分钟"];
            }
            weakself.meetingTimeL.text = string;
        }];
        weakself.onTimetL.text = [NSString stringWithFormat:@"%d次", nowMonthStatistics.onTimeCount];
        weakself.lateL.text = [NSString stringWithFormat:@"%d次", nowMonthStatistics.lateCount];
        weakself.absentL.text = [NSString stringWithFormat:@"%d次", nowMonthStatistics.absentCount];
        
        float total = nowMonthStatistics.meetingCount;
        if (total) {
            weakself.onTimeH.constant = 90 * (nowMonthStatistics.onTimeCount/total);
            weakself.lateH.constant = 90 * (nowMonthStatistics.lateCount/total);
            weakself.absentH.constant = 90 * (nowMonthStatistics.absentCount/total);
        } else {
            weakself.onTimeH.constant = 0;
            weakself.lateH.constant = 0;
            weakself.absentH.constant = 0;
        }
        
    } fail:^(NSError *error){
        
    }];
}


#pragma mark -

- (void)handleClickCellJoinBtn:(NSNotification *)noti {
    YCJoinShareController *vc = [YCJoinShareController new];
    vc.type = 1;
    vc.companyID = @"";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
