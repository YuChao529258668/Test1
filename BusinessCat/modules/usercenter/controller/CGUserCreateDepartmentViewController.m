//
//  CGUserCreateDepartmentViewController.m
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCreateDepartmentViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGUserTextViewController.h"
#import "CGUserChoseTimeViewController.h"
#import "CGUserTextViewController.h"
#import "CGUserChoseCompanyViewController.h"
#import "CGUserChoseSchoolViewController.h"

@interface CGUserCreateDepartmentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserCreateDepartmentViewController

-(instancetype)initWithBlock:(CGUserCreateDepartmentBlock)block{
  self = [super init];
  if(self){
    resultBlock = block;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.tableView.tableFooterView = [[UIView alloc]init];
  [self getdata];
  if (self.type == UserCreateTypePosition) {
    self.title =@"编辑职位";
    self.tableViewHeight.constant = 0;
    [self.createBtn setTitle:@"我要创建职位" forState:UIControlStateNormal];
  }else if(self.type ==UserCreateTypeClasses){
    self.title =@"选择班级";
    [self.createBtn setTitle:@"我要创建班级" forState:UIControlStateNormal];
  }else if (self.type == UserCreateTypeCollect){
    self.title =@"选择院系";
    self.tableViewHeight.constant = 0;
  }else{
    self.title =@"选择部门";
    self.tableViewHeight.constant = 0;
  }
  self.createBtn.backgroundColor = CTThemeMainColor;
}

- (void)getdata{
    __weak typeof(self) weakSelf = self;
  [self.biz.component startBlockAnimation];
  if (self.type == UserCreateTypeDepartment) {
    [self.biz authUserOrganizaDepaListWithOrganizaID:self.organizeID type:self.choseType success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      [weakSelf.biz.component stopBlockAnimation];
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }else if (self.type == UserCreateTypePosition){
    [self.biz organizaRoleListWithType:self.choseType success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      [weakSelf.biz.component stopBlockAnimation];
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }else if (self.type == UserCreateTypeCollect){
    [self.biz authUserOrganizaDepaListWithOrganizaID:self.organizeID type:self.choseType success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      [weakSelf.biz.component stopBlockAnimation];
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }else if(self.type == UserCreateTypeClasses){
    [self.biz organizaClassListWithSchoolID:self.organizeID depaId:self.depaID success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      [weakSelf.biz.component stopBlockAnimation];
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
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
  CGUserDepaEntity *entity = self.dataArray[indexPath.row];
  cell.nameLabel.text = entity.name;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGUserDepaEntity *entity = self.dataArray[indexPath.row];
  if (self.isChoseView&&self.type != UserCreateTypeClasses&&self.type != UserCreateTypeCollect) {
    resultBlock(entity);
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  
  if (self.type == UserCreateTypeCollect) {
    self.info.depaID = entity.depaID;
    self.info.depaName = entity.name;
    CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]init];
    vc.choseType = self.choseType;
    vc.type = UserCreateTypeClasses;
    vc.organizeID = self.info.organizaID;
    vc.depaID = self.info.depaID;
    vc.info = self.info;
    vc.isChoseView = self.isChoseView;
    vc.isDiscover = self.isDiscover;
    [self.navigationController pushViewController:vc animated:YES];
  }
  
  if (self.type == UserCreateTypeDepartment) {
    self.info.depaID = entity.depaID;
    self.info.depaName = entity.name;
    CGUserTextViewController *vc = [[CGUserTextViewController alloc]init];
    vc.textType = UserTextTypeChosePosition;
    vc.info = self.info;
    vc.isChose = YES;
    vc.info = self.info;
    [self.navigationController pushViewController:vc animated:YES];
  }
  
  if (self.type == UserCreateTypePosition) {
    self.info.roleID = entity.depaID;
    self.info.roleName = entity.name;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
    for (UIViewController *vc in self.navigationController.viewControllers) {
      if ([vc isKindOfClass:[CGUserChoseCompanyViewController class]]||[vc isKindOfClass:[CGUserChoseSchoolViewController class]]) {
        [self.navigationController popToViewController:vc  animated:YES];
        return;
      }
    }
  }
  
  if (self.type == UserCreateTypeClasses) {
    self.info.classID = entity.depaID;
    self.info.className = entity.name;
    if (self.isChoseView) {
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
      for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CGUserChoseCompanyViewController class]]||[vc isKindOfClass:[CGUserChoseSchoolViewController class]]) {
          [self.navigationController popToViewController:vc  animated:YES];
          return;
        }
      }
    }else{
      CGUserChoseTimeViewController *vc = [[CGUserChoseTimeViewController alloc]init];
      vc.info = self.info;
      vc.isFirst = YES;
      vc.isDiscover = self.isDiscover;
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}

- (IBAction)createClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    [weakSelf getdata];
  }];
  if (self.type == UserCreateTypeClasses){
    vc.textType = UserTextTypeCreatClasses;
    vc.depaId = self.depaID;
  }else if (self.type == UserCreateTypeDepartment){
    vc.textType = UserTextTypeCreatDepartment;
  }
  
  if (self.choseType == UserChoseOrganizeTypeCompany) {
    vc.type = 1;
  }else if (self.choseType == UserChoseOrganizeTypeGenSpace){
    vc.type = 3;
  }else if (self.choseType == UserChoseOrganizeTypeOther){
    vc.type = 4;
  }
  vc.organizeID = self.organizeID;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
}
@end
