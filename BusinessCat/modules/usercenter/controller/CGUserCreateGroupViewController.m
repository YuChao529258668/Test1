//
//  CGUserCreateGroupViewController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCreateGroupViewController.h"
#import "CGUserCreateGroupTableViewCell.h"
#import "CGUserCreateGroupChooseViewController.h"
#import "CGUserIndustryListEntity.h"
#import "CGUserCenterBiz.h"
#import "CGTagsEntity.h"
#import "CGUserChoseDepartmentViewController.h"
#import "CGDiscoverSourceCircleViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGUserFireViewController.h"

@interface CGUserCreateGroupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CGTagsEntity *industryEntity;
@property (nonatomic, strong) CGUserIndustryListEntity *scaleEntity;
@property (nonatomic, strong) UIButton *creatButton;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserCreateGroupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  if (self.type == 1) {
    self.title = @"创建公司";
  }else if (self.type == 3){
    self.title = @"创建众创空间";
  }else if (self.type == 4){
    self.title = @"创建其他组织";
  }
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.titleArray = @[@"名称",@"行业",@"规模"];
  
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  [self.textField resignFirstResponder];
}

- (void)createClick{
  if (self.textField.text.length<=0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写完资料" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
  }else{
    self.creatButton.selected = YES;
    [self.creatButton setUserInteractionEnabled:NO];
    [self.biz.component startBlockAnimation];
    __weak typeof(self) weakSelf = self;
    [self.biz companyCreateWithCompanyName:self.textField?self.textField.text:self.keyWord companyType:self.type industryId:self.industryEntity.tagID scaleLevel:self.scaleEntity.industryID.intValue success:^(NSString *companyID,NSNumber *companyType) {
      [weakSelf.biz.component stopBlockAnimation];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
      if (weakSelf.isDiscover) {
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
          if ([vc isKindOfClass:[CGDiscoverSourceCircleViewController class]]) {
            [weakSelf.navigationController popToViewController:vc  animated:NO];
            break;
          }
        }
      }else{
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
          if ([vc isKindOfClass:[CGUserChangeOrganizationViewController class]]||[vc isKindOfClass:[CGUserFireViewController class]]) {
            [weakSelf.navigationController popToViewController:vc  animated:NO];
            break;
          }
        }
      }
    } fail:^(NSError *error) {
      weakSelf.creatButton.selected = NO;
      [weakSelf.creatButton setUserInteractionEnabled:YES];
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 64;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 64)];
  self.creatButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 44)];
  [view addSubview:self.creatButton];
//  [self.creatButton setBackgroundColor:[CTCommonUtil convert16BinaryColor:@"#44BBFC"]];
  [self.creatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.creatButton setTitle:@"创建" forState:UIControlStateNormal];
  self.creatButton.titleLabel.font = [UIFont systemFontOfSize:15];
  self.creatButton.layer.cornerRadius =22;
  self.creatButton.layer.masksToBounds = YES;
  [self.creatButton addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
  [self.creatButton setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:@"#CFCFCF"] size:self.creatButton.frame.size] forState:UIControlStateSelected];
  [self.creatButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:self.creatButton.frame.size] forState:UIControlStateNormal];
  return view;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row>0) {
    CGUserCreateGroupChooseViewController *vc = [[CGUserCreateGroupChooseViewController alloc] init];
    switch (indexPath.row) {
      case 1:
        vc.state = CreatGroupIndustryStatus;
        break;
      case 2:
        vc.state = CreatGroupScaleStatus;
        break;
        
      default:
        break;
    }
    [vc didSelectedButtonIndex:^(CGUserIndustryListEntity *entity) {
      weakSelf.scaleEntity = entity;
      [weakSelf.tableView reloadData];
    } tagsBlock:^(CGTagsEntity *entity) {
      weakSelf.industryEntity =entity;
      [weakSelf.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*identifier = @"CGUserCreateGroupTableViewCell";
  CGUserCreateGroupTableViewCell *cell = (CGUserCreateGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCreateGroupTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
  if (indexPath.row==0) {
    cell.companyTextField.text = self.textField?self.textField.text:self.keyWord;
    self.textField = cell.companyTextField;
    cell.choseTextField.hidden = YES;
    cell.arrow.hidden = YES;
    cell.companyTextField.hidden = NO;
    if (self.type == 1) {
      cell.companyTextField.placeholder = @"请输入公司名";
    }else if (self.type == 3){
      cell.companyTextField.placeholder = @"请输入众创空间名";
    }else if (self.type == 4){
      cell.companyTextField.placeholder = @"请输入其他组织名";
    }
  }else{
    cell.choseTextField.hidden = NO;
    cell.arrow.hidden = NO;
    cell.companyTextField.hidden = YES;
    if (indexPath.row == 1){
      cell.choseTextField.text = self.industryEntity.name;
    }else{
      cell.choseTextField.text = self.scaleEntity.name;
    }
  }
  return cell;
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
}
@end
