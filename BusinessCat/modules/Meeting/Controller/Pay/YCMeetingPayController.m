//
//  YCMeetingPayController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/24.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingPayController.h"
#import "YCMeetingPayCell.h"
#import "YCMeetingBiz.h"

@interface YCMeetingPayController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *shiChangLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *firstHeader;
@property (nonatomic, strong) UILabel *secondHeader;
@property (nonatomic, strong) UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) NSArray<NSArray<YCMeetingRebate *> *> *pays;
@property (nonatomic, strong) NSArray<YCMeetingRebate *> *myList; // 对应 section 0
@property (nonatomic, strong) NSArray<YCMeetingRebate *> *shareList;

@property (nonatomic, strong) YCMeetingRebate *rebate;

@end

@implementation YCMeetingPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.firstHeader = [self labelWithText:@"我的"];
    self.secondHeader = [self labelWithText:@"会议共享方"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMeetingPayCell" bundle:nil] forCellReuseIdentifier:@"YCMeetingPayCell"];
    self.tableView.backgroundColor = [UIColor clearColor];

    self.timeLabel.text = self.durationString;
    self.timeLabel.textColor = [YCTool colorOfHex:0xff3e3e];
    self.shiChangLabel.textColor = [YCTool colorOfHex:0x7777777];
    
    [self getList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark -

- (UIView *)getFooterView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _footerView.backgroundColor = self.view.backgroundColor;
    }
    return _footerView;
}

- (UILabel *)labelWithText:(NSString *)string {
    UILabel *f = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    f.text = string;
//    f.textColor = [YCTool colorOfHex:0x777777];
    f.font = [UIFont systemFontOfSize:14];
    f.textAlignment = NSTextAlignmentCenter;
//    f.backgroundColor = [UIColor redColor];
    f.backgroundColor = [UIColor whiteColor];// 设置颜色会看不到添加的 CALayer, 延迟0.2秒添加就能看到
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 所以加一个白板
//        UIView *view = [[UIView alloc] initWithFrame:f.bounds];
//        view.backgroundColor = [UIColor greenColor];
//        [f addSubview:view];
        
        CALayer *line = [[CALayer alloc] init];
            line.frame = CGRectMake(15, 39, [UIScreen mainScreen].bounds.size.width - 15 * 2, 0.5);
//        line.frame = CGRectMake(15, 30, [UIScreen mainScreen].bounds.size.width - 15 * 2, 10);
//        line.backgroundColor = [UIColor lightGrayColor].CGColor;
//        line.backgroundColor = [YCTool colorWithRed:233 green:233 blue:233 alpha:1].CGColor;
        line.backgroundColor = [YCTool colorWithRed:187 green:187 blue:187 alpha:1].CGColor;
//        line.backgroundColor = [UIColor redColor].CGColor;
        [f.layer addSublayer:line];
    });

    return f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingPayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.markBtn.selected = YES;
    
    if (indexPath.section == 0) {
        self.rebate = self.myList[indexPath.row];
    } else {
        self.rebate = self.shareList[indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingPayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.markBtn.selected = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myList.count;
    }
    return self.shareList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingRebate *rebate;
    if (indexPath.section == 0) {
        rebate = self.myList[indexPath.row];
    } else {
        rebate = self.shareList[indexPath.row];
    }
    
    YCMeetingPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingPayCell" forIndexPath:indexPath];
    cell.nameLabel.text = rebate.name;
    cell.hintLabel1.text = rebate.msg;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.iv.image = [UIImage imageNamed:@"icon_pay_me"];// 我的
    } else {
        cell.iv.image = [UIImage imageNamed:@"icon_pay_company_1"];
    }
    
    if (!rebate.msg) {
        cell.hintLabel1.text = @"后台没有返回msg";
    }
    
    [YCTool HMSForSeconds:rebate.duration * 60 block:^(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string) {
        [string appendString:@"剩余"];

        if (h) {
            [string appendFormat:@" %ld 小时", h];
        }
        if (m) {
            [string appendFormat:@" %ld 分钟", m];
        }
        if (h + m == 0) {
            [string appendString:@" 0 分钟"];
        }
        cell.hintLabel2.text = string;
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        return self.secondHeader;
    }
    return self.firstHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self getFooterView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickPayBtn:(UIButton *)sender {
    if (!self.rebate) {
        [CTToast showWithText:@"请选择支付选项"];
        return;
    }
    
    if (self.rebate.duration < self.durationMinute) {
        [CTToast showWithText:@"剩余折扣时长不足，请重新选择"];
        return;
    }

    if (self.onClickPayBtnBlock) {
        self.onClickPayBtnBlock(self.rebate);
    }
}

#pragma mark - Data

- (void)getList {
    if (!(self.beginDate && self.endDate)) {
        [CTToast showWithText:@"获取折扣列表失败: 会议时间为空"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingMinuteListWithBeginDate:self.beginDate endDate:self.endDate accessNumber:self.count Success:^(NSArray<NSArray<YCMeetingRebate *> *> *twoLists) {
        weakself.pays = twoLists;
        weakself.myList = twoLists.firstObject;
        weakself.shareList = twoLists.lastObject;
        [weakself.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

@end
