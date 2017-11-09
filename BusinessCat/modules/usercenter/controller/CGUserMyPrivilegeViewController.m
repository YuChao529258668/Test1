//
//  CGUserMyPrivilegeViewController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserMyPrivilegeViewController.h"
#import "CGUserMyPrivilegeTitleTableViewCell.h"
#import "CGUserMyPrivilegeBottomTableViewCell.h"
#import "CGUserMyPrivilegeDetailTableViewCell.h"
#import "CGUserMyPrivilegeHeaderTableViewCell.h"

@interface CGUserMyPrivilegeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//测试数据
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *numberArray;
@property (nonatomic, strong) NSArray *titleArray2;
@property (nonatomic, strong) NSArray *numberArray2;
@property (nonatomic, strong) NSArray *myPrivilegeUnitArray;
@property (nonatomic, strong) NSArray *companyPrivilegeUnitArray;
@end

@implementation CGUserMyPrivilegeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"会员级别";
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.titleArray = @[@"主题数",@"订阅数",@"应用体验数",@"竞品报告数",@"解决方案数",@"点评报告数",@"产品学习包",@"产品微信群"];
  self.titleArray2 = @[@"产品线上课",@"线下活动",@"解决方案推荐",@"公司推荐广告",@"主题人工优化",@"竞品报告编写",@"解决方案编写",@"专家导师指导"];
  self.numberArray = @[@"10",@"100",@"100",@"2",@"2",@"2",@"1",@"1"];
  self.numberArray2 = @[@"2",@"1",@"0",@"0",@"0",@"0",@"0",@"0"];
  self.myPrivilegeUnitArray = @[@"个",@"个",@"个",@"个",@"个",@"个",@"套",@"个"];
  self.companyPrivilegeUnitArray = @[@"次",@"次",@"次",@"次",@"个",@"个",@"套",@"次"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
      case 0:
      return 144;
      break;
    case 1:
      if (indexPath.row==1||indexPath.row==3) {
        return 100;
      }else{
        return 30;
      }
      break;
    case 2:
      return 44;
      break;
  }
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return 1;
      break;
    case 1:
      return 4;
      break;
    case 2:
      return 2;
      break;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section ==0||section==1) {
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
  static NSString*identifier = @"CGUserMyPrivilegeTitleTableViewCell";
  static NSString*identifier1 = @"CGUserMyPrivilegeBottomTableViewCell";
  static NSString*identifier2 = @"CGUserMyPrivilegeDetailTableViewCell";
  static NSString*identifier3 = @"CGUserMyPrivilegeHeaderTableViewCell";
  switch (indexPath.section) {
      case 0:
    {
      CGUserMyPrivilegeHeaderTableViewCell *cell = (CGUserMyPrivilegeHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier3];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeHeaderTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell getLevelWithNumber:@"2"];
      return cell;
    }
      break;
    case 1:
    {
      if (indexPath.row==0||indexPath.row==2) {
        CGUserMyPrivilegeTitleTableViewCell *cell = (CGUserMyPrivilegeTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeTitleTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = indexPath.row==0?@"我的特权":@"公司特权";
        return cell;
      }else{
        CGUserMyPrivilegeDetailTableViewCell *cell = (CGUserMyPrivilegeDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeDetailTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
          [cell setTitleWithArray:self.titleArray unitWithArray:self.myPrivilegeUnitArray numberWithArray:self.numberArray];
        }else{
          [cell setTitleWithArray:self.titleArray2 unitWithArray:self.companyPrivilegeUnitArray numberWithArray:self.numberArray2];
        }
        return cell;
      }
    }
      break;
    case 2:
    {
      CGUserMyPrivilegeBottomTableViewCell *cell = (CGUserMyPrivilegeBottomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMyPrivilegeBottomTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      if (indexPath.row ==0) {
        cell.titleLabel.text = @"积分记录";
      }else{
        cell.titleLabel.text = @"积分商城";
        cell.line.hidden = YES;
      }
      return cell;
    }
      break;
  }
  
  return nil;
}

@end
