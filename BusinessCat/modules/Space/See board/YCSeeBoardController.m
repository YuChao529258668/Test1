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
#import "YCSeeBoard.h"

@interface YCSeeBoardController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<BoardProfit *> *shareProfits;

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

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tb = self.tableView;
    [tb registerNib:[UINib nibWithNibName:@"YCSeeBoardCell" bundle:nil] forCellReuseIdentifier:@"YCSeeBoardCell"];
    tb.dataSource = self;
    tb.tableHeaderView = self.headerView;
    tb.tableFooterView = [UIView new];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shareProfits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCSeeBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCSeeBoardCell" forIndexPath:indexPath];
    BoardProfit *profit = self.shareProfits[indexPath.row];
    cell.nameL.text = profit.name;
    cell.todayL.text = [NSString stringWithFormat:@"%.02lf", profit.todayIncome];
    cell.waitL.text = [NSString stringWithFormat:@"%.02lf", profit.forIncome];
    cell.totalL.text = [NSString stringWithFormat:@"%.02lf", profit.totalIncome];

    return cell;
}


#pragma mark - Data

- (void)getData {
    __weak typeof(self) weakself = self;
    [YCSpaceBiz getBoardWithSuccess:^(YCSeeBoard *board) {
        NowMonthMeeting *nowMonthMeeting = board.nowMonthMeeting;
        NowMonthStatistics *nowMonthStatistics = board.nowMonthStatistics;
        weakself.shareProfits = board.shareProfit;
        [weakself.tableView reloadData];
        
        weakself.todayL.text = [NSString stringWithFormat:@"%d/%d 场", [nowMonthMeeting toDayUnBeginMeetCount], [nowMonthMeeting toDayMeetCount]];
        weakself.tomorrowL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.tomorrowMeetCount];
        weakself.weekL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.weekMeetCount];
        weakself.otherL.text = [NSString stringWithFormat:@"%d 场", nowMonthMeeting.otherCount];
        
        weakself.meetingCountL.text = [NSString stringWithFormat:@"%d 场", nowMonthStatistics.meetingCount];
        [YCTool HMSForSeconds:nowMonthStatistics.useTotal*60 block:^(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string) {
            if (h) {
                [string appendFormat:@"%ld小时", h];
            }
            if (m) {
                [string appendFormat:@"%ld分钟", m];
            }
            if (h + m == 0) {
                [string appendString:@"0 分钟"];
            }
            weakself.meetingTimeL.text = string;
        }];
        weakself.onTimetL.text = [NSString stringWithFormat:@"%d", nowMonthStatistics.onTimeCount];
        weakself.lateL.text = [NSString stringWithFormat:@"%d", nowMonthStatistics.lateCount];
        weakself.absentL.text = [NSString stringWithFormat:@"%d", nowMonthStatistics.absentCount];
        
        float total = nowMonthStatistics.meetingCount;
        weakself.onTimeH.constant = 90 * (nowMonthStatistics.onTimeCount/total);
        weakself.lateH.constant = 90 * (nowMonthStatistics.lateCount/total);
        weakself.absentH.constant = 90 * (nowMonthStatistics.absentCount/total);
        
    } fail:^(NSError *error){
        
    }];
}


@end
