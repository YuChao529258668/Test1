//
//  CGUserChoseDepartmentViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChoseDepartmentViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserEditDepartmentViewController.h"
#import "CGUserDepaEntity.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGDiscoverSourceCircleViewController.h"

@interface CGUserChoseDepartmentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) CGUserEntity *userInfo;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserChoseDepartmentViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.title = self.companyType==2?@"选择院系":@"选择部门";
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  if (self.isEditing == NO) {
    [self hideCustomBackBtn];
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
    [self.navi addSubview:self.rightBtn];
  }
  [self getData];
  self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)rightBtnAction:(UIButton *)sender{
  CGUserEditDepartmentViewController *vc = [[CGUserEditDepartmentViewController alloc]init];
//  vc.companyType = self.companyType;
//  vc.companyID = self.companyID;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
  [self.biz.component startBlockAnimation];
  [self.rightBtn setUserInteractionEnabled:NO];
  [self.biz authUserOrganizaDepaListWithOrganizaID:self.companyID type:self.companyType success:^(NSMutableArray *reslut) {
    weakSelf.dataArray = reslut;
    [weakSelf.biz.component stopBlockAnimation];
    [weakSelf.rightBtn setUserInteractionEnabled:YES];
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    [weakSelf.rightBtn setUserInteractionEnabled:YES];
  }];
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
  if (self.isEditing) {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectDepaID:depaName:)]){
      [self.delegate didSelectDepaID:entity.depaID depaName:entity.name];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }else{
//    [self.biz.component startBlockAnimation];
//    __weak typeof(self) weakSelf = self;
//    [self.biz updateUserInfoWithUsername:nil nickname:nil gender:nil portrait:nil position:nil departmentId:entity.depaID userIntro:nil addSkillIds:nil delSkillIds:nil addIndustryIds:nil delIndustryIds:nil success:^{
//      __strong typeof(weakSelf) swself = weakSelf;
//      if (swself.isDiscover) {
//        for (UIViewController *vc in swself.navigationController.viewControllers) {
//          if ([vc isKindOfClass:[CGDiscoverSourceCircleViewController class]]) {
//            [swself.navigationController popToViewController:vc  animated:NO];
//            break;
//          }
//        }
//      }else{
//        for (UIViewController *vc in swself.navigationController.viewControllers) {
//          if ([vc isKindOfClass:[CGUserChangeOrganizationViewController class]]) {
//            [swself.navigationController popToViewController:vc  animated:NO];
//            break;
//          }
//        }
//      }
//      
//      [weakSelf.biz.component stopBlockAnimation];
//    } fail:^(NSError *error) {
//      [weakSelf.biz.component stopBlockAnimation];
//    }];
  }
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
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
