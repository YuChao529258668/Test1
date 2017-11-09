//
//  CGUserChoseOrganizeViewController.m
//  CGSays
//
//  Created by zhu on 16/10/21.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChoseOrganizeViewController.h"
#import "CGUserCompanyTypeTableViewCell.h"
#import "CGUserCompanyHeaderTableViewCell.h"
#import "CGUserDao.h"
#import "CGUserCreateGroupViewController.h"

@interface CGUserChoseOrganizeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *iconArray;

@end

@implementation CGUserChoseOrganizeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"选择组织";
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.array = @[@"我要创建公司",@"我要创建众创空间"];
  self.iconArray = @[@"wodegongsi",@"wodechuangke"];
  self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 60;
  }
  return 105;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.array.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGUserCreateGroupViewController *vc = [[CGUserCreateGroupViewController alloc]init];
  switch (indexPath.row) {
    case 1:
    {
      vc.type = 1;
    }
      break;
    case 2:
    {
      vc.type = 3;
    }
      break;
    case 3:
    {
      vc.type = 4;
    }
      break;
      
    default:
      break;
  }
  vc.keyWord = self.keyWord;
  vc.isDiscover = self.isDiscover;
  [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 0) {
    static NSString*identifier1 = @"CGUserCompanyHeaderTableViewCell";
    CGUserCompanyHeaderTableViewCell *cell = (CGUserCompanyHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanyHeaderTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }else{
    static NSString*identifier = @"CGUserCompanyTypeTableViewCell";
    CGUserCompanyTypeTableViewCell *cell = (CGUserCompanyTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanyTypeTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = self.array[indexPath.row-1];
    NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:str];
    if (indexPath.row==3 || indexPath.row == 2) {
      [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(4, 4)];
    }else{
      [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(4, 2)];
    }
    cell.titleLabel.attributedText = colorContentString;
    cell.icon.image = [UIImage imageNamed:self.iconArray[indexPath.row-1]];
    return cell;
  }
}

@end
