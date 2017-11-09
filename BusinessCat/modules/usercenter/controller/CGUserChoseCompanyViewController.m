//
//  CGUserChoseCompanyViewController.m
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChoseCompanyViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserSearchViewController.h"
#import "CGUserCreateDepartmentViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserSearchCompanyEntity.h"
#import "CGUserDepaEntity.h"
#import "CGUserTextViewController.h"
#import "CGUserChangeOrganizationViewController.h"

@interface CGUserChoseCompanyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) CGUserCenterBiz *biz;

@end

@implementation CGUserChoseCompanyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.title = @"加入组织";
}

- (void)dealloc{
  
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
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
        cell.nameLabel.text = @"选择组织";
      }else{
        cell.nameLabel.text = self.info.organizaName;
      }
      break;
    case 1:
      if (self.info.depaName.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择部门";
      }else{
        cell.nameLabel.text = self.info.depaName;
      }
      break;
    case 2:
      if (self.info.position.length<=0) {
        cell.nameLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#D4D4D9"];
        cell.nameLabel.text = @"选择职位";
      }else{
        cell.nameLabel.text = self.info.position;
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
        }
      }
    }
      break;
    case 1:
    {
      if (self.info.organizaID.length<=0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"选择组织后才能选部门"]show:window];
        return;
      }
      CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]initWithBlock:^(CGUserDepaEntity *result) {
        weakSelf.info.depaID = result.depaID;
        weakSelf.info.depaName = result.name;
        [weakSelf.tableView reloadData];
      }];
      vc.isChoseView = NO;
      vc.type = UserCreateTypeDepartment;
      vc.organizeID = self.info.organizaID;
      vc.info = self.info;
      vc.choseType = self.choseType;
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    case 2:
    {
      CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
        weakSelf.info.position = text;
        [weakSelf.tableView reloadData];
      }];
      vc.isChose = NO;
      vc.text = self.info.position;
      vc.textType = UserTextTypeChosePosition;
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
    [[CTToast makeText:@"组织不能为空"]show:window];
    return;
  }else if (self.info.depaName.length<=0){
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"部门不能为空"]show:window];
    return;
  }else if (self.info.position<=0){
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"职位不能为空"]show:window];
    return;
  }
  self.addButton.selected = YES;
  [self.addButton setUserInteractionEnabled:NO];
  [self.biz userCompanyJoinWithCompangyID:self.info.organizaID depaId:self.info.depaID type:(self.choseType+1) classId:nil position:self.info.position startTime:nil success:^(NSMutableArray *result) {
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
      if ([vc isKindOfClass:[CGUserChangeOrganizationViewController class]]) {
        [weakSelf.navigationController popToViewController:vc  animated:NO];
        break;
      }
    }
    [weakSelf.biz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    weakSelf.addButton.selected = NO;
    [weakSelf.addButton setUserInteractionEnabled:YES];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
}
@end
