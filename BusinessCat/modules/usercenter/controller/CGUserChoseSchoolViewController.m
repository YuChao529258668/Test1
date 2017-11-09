//
//  CGUserChoseSchoolViewController.m
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChoseSchoolViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserSearchViewController.h"
#import "CGUserCreateDepartmentViewController.h"
#import "CGUserChoseTimeViewController.h"
#import "CGUserDepaEntity.h"
#import "CGUserCenterBiz.h"
#import "CGDiscoverSourceCircleViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGUserFireViewController.h"

@interface CGUserChoseSchoolViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserChoseSchoolViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.title = @"加入学校";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString*identifier = @"CGUserTextArrowTableViewCell";
  CGUserTextArrowTableViewCell *cell = (CGUserTextArrowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserTextArrowTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  switch (indexPath.row) {
    case 0:
      if (self.info.organizaName.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择学校";
      }else{
        cell.nameLabel.text = self.info.organizaName;
      }
      break;
    case 1:
      if (self.info.depaName.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择院系";
      }else{
        cell.nameLabel.text = self.info.depaName;
      }
      break;
    case 2:
      if (self.info.className.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择班级";
      }else{
        cell.nameLabel.text = self.info.className;
      }
      break;
    case 3:
      if (self.info.startTime.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择入学年份";
      }else{
        cell.nameLabel.text = [NSString stringWithFormat:@"%@年",self.info.startTime];
      }
      break;
      
    default:
      break;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.row) {
    case 0:
    {
          for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[CGUserSearchViewController class]]) {
              [self.navigationController popToViewController:vc  animated:NO];
              break;
            }
          }
    }
      break;
    case 1:
    {
      if (self.info.organizaID.length<=0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"选择学校后才能选院系"]show:window];
        return;
      }
      CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]initWithBlock:^(CGUserDepaEntity *result) {
      }];
      vc.type = UserCreateTypeCollect;
      vc.choseType = UserChoseOrganizeTypeSchool;
      vc.organizeID = self.info.organizaID;
      vc.info = self.info;
      vc.isChoseView = YES;
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    case 2:
    {
      if (self.info.depaID.length<=0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"选择院系后才能选班级"]show:window];
        return;
      }
      CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]initWithBlock:^(CGUserDepaEntity *result) {
      }];
      vc.type = UserCreateTypeClasses;
      vc.organizeID = self.info.organizaID;
      vc.depaID = self.info.depaID;
      vc.info = self.info;
      vc.isChoseView = YES;
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    case 3:
    {
      CGUserChoseTimeViewController *vc = [[CGUserChoseTimeViewController alloc]initWithBlock:^(NSString *result) {
        weakSelf.info.startTime = result;
        [weakSelf.tableView reloadData];
      }];
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    default:
      break;
  }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
  self.addButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 40, 150 ,40)];
  [self.addButton setBackgroundColor:CTThemeMainColor];
  [view addSubview:self.addButton];
  [self.addButton setTitle:@"申请加入" forState:UIControlStateNormal];
  [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.addButton.layer.cornerRadius = 8;
  self.addButton.layer.masksToBounds = YES;
  [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
  [self.addButton setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:@"#CFCFCF"] size:self.addButton.frame.size] forState:UIControlStateSelected];
  [self.addButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:self.addButton.frame.size] forState:UIControlStateNormal];
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 100;
}


- (void)addClick{
    __weak typeof(self) weakSelf = self;
  [self.biz.component startBlockAnimation];
  if (self.info.organizaName.length<=0) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"学校不能为空"]show:window];
    return;
  }else if (self.info.depaName.length<=0){
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"院系不能为空"]show:window];
    return;
  }else if (self.info.startTime.length<=0){
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"班级不能为空"]show:window];
    return;
  }else if (self.info.className<=0){
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"入学年份不能为空"]show:window];
    return;
  }
  self.addButton.selected = YES;
  [self.addButton setUserInteractionEnabled:NO];
  [self.biz userCompanyJoinWithCompangyID:self.info.organizaID depaId:self.info.depaID type:2 classId:self.info.classID position:nil startTime:self.info.startTime success:^(NSMutableArray *result) {
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
    [weakSelf.biz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    weakSelf.addButton.selected = NO;
    [weakSelf.addButton setUserInteractionEnabled:YES];
  }];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

@end
