//
//  CGUserChangeDepartmentViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserChangeDepartmentViewController.h"
#import "CGUserTextViewController.h"
#import "CGUserCreateDepartmentViewController.h"
#import "CGUserCenterBiz.h"
#import "CGCompanyDao.h"

@interface CGUserChangeDepartmentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, copy) CGUserChangeDepartmentSuccessBlock block;
@end

@implementation CGUserChangeDepartmentViewController

-(instancetype)initWithBlock:(CGUserChangeDepartmentSuccessBlock)block{
  self = [super init];
  if(self){
    self.block = block;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.navi addSubview:rightBtn];
  self.biz = [[CGUserCenterBiz alloc]init];
  if ([CTStringUtil stringNotBlank:self.departmentName]) {
    self.departmentLabel.text = self.departmentName;
  }else{
    self.departmentLabel.text = @"未设置";
  }
  if ([CTStringUtil stringNotBlank:self.position]) {
    self.positionLabel.text = self.position;
  }else{
    self.positionLabel.text = @"未设置";
  }
}

-(void)rightBtnAction:(UIButton *)sender{
  if (![CTStringUtil stringNotBlank:self.position]) {
    [[CTToast makeText:@"请输入职位"]show:[UIApplication sharedApplication].keyWindow];
    return;
  }
  if (![CTStringUtil stringNotBlank:self.departmentID]) {
    [[CTToast makeText:@"请选择部门"]show:[UIApplication sharedApplication].keyWindow];
  }
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  sender.userInteractionEnabled = NO;
  [self.biz authUserOrganizingUpdateWithID:self.companyID type:self.companyType departmentId:self.departmentID position:self.position success:^{
    [weakSelf.biz.component stopBlockAnimation];
    weakSelf.block(weakSelf.position,weakSelf.departmentName,weakSelf.departmentID);
    sender.userInteractionEnabled = YES;
    [weakSelf.navigationController popViewControllerAnimated:YES];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    sender.userInteractionEnabled = YES;
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)positionClick:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    weakSelf.position = text;
    weakSelf.positionLabel.text = text;
  }];
  vc.textType = UserTextTypeChosePosition;
  vc.text = self.position;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)departmentClick:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]initWithBlock:^(CGUserDepaEntity *result) {
    weakSelf.departmentLabel.text = result.name;
    weakSelf.departmentName = result.name;
    weakSelf.departmentID = result.depaID;
  }];
  vc.isChoseView = YES;
  vc.type = UserCreateTypeDepartment;
  vc.organizeID = self.companyID;
  vc.choseType = self.companyType;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
