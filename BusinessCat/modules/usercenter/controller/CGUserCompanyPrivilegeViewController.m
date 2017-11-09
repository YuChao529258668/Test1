//
//  CGUserCompanyPrivilegeViewController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyPrivilegeViewController.h"
#import "CGUserCompanyPrivilegeHeaderTableViewCell.h"
#import "CGUserMyPrivilegeBottomTableViewCell.h"
#import "CGUserMyPrivilegeDetailTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGUserDao.h"

@interface CGUserCompanyPrivilegeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *unitArray;
@property (nonatomic, strong) NSArray *numberArray;

@end

@implementation CGUserCompanyPrivilegeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.bounces    = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.separatorStyle = NO;
  self.titleArray = @[@"产品线上课",@"线下活动",@"解决方案推荐",@"公司推荐广告",@"主题人工优化",@"竞品报告编写",@"解决方案编写",@"专家导师指导"];
  self.numberArray = @[@"10",@"100",@"100",@"2",@"2",@"2",@"0",@"0"];
  self.unitArray = @[@"次",@"次",@"次",@"次",@"个",@"个",@"套",@"次"];
  
}

- (void)getInfo{
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row==1&&indexPath.section==0) {
    return 100;
  }
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return 2;
      break;
    case 1:
      return 2;
      break;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section ==0) {
    return 0.001;
  }
  return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*identifier = @"CGUserCompanyPrivilegeHeaderTableViewCell";
  static NSString*identifier1 = @"CGUserMyPrivilegeBottomTableViewCell";
  static NSString*identifier2 = @"CGUserMyPrivilegeDetailTableViewCell";
  switch (indexPath.section) {
    case 0:
    {
      if (indexPath.row ==0) {
        CGUserCompanyPrivilegeHeaderTableViewCell *cell = (CGUserCompanyPrivilegeHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanyPrivilegeHeaderTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
      }else{
        CGUserMyPrivilegeDetailTableViewCell *cell = (CGUserMyPrivilegeDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeDetailTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleWithArray:self.titleArray unitWithArray:self.unitArray numberWithArray:self.numberArray];
        return cell;
      }
    }
      break;
    case 1:
    {
      CGUserMyPrivilegeBottomTableViewCell *cell = (CGUserMyPrivilegeBottomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeBottomTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      if (indexPath.row ==0) {
        cell.titleLabel.text = @"我要认证";
        cell.iocn.image = [UIImage imageNamed:@"My_news_privilege_wantcertified"];
      }else{
        cell.titleLabel.text = @"公司特权升级";
        cell.iocn.image = [UIImage imageNamed:@"My_news_privilege_Corporate_privilege"];
        cell.line.hidden = YES;
      }
      return cell;
    }
      break;
  }
  
  return nil;
}

@end
