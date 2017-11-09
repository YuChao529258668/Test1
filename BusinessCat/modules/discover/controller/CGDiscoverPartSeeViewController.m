//
//  CGDiscoverPartSeeViewController.m
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverPartSeeViewController.h"
#import "CGPartSeeTableViewCell.h"
#import "CGDiscoverOtherCompanyViewController.h"
#import "CGUserSearchCompanyEntity.h"
#import "CGPartSeeAddressEntity.h"
#import "CGChoseOrganizationViewController.h"

@interface CGDiscoverPartSeeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CGHorrolEntity *currentSelectEntity;
@end

@implementation CGDiscoverPartSeeViewController

-(instancetype)initWithBlock:(CGPartSeeSureBlock)release{
  self = [super init];
  if(self){
    block = release;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"发表到";
  self.tableView.tableFooterView = [[UIView alloc]init];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.navi addSubview:rightBtn];
  if (self.isHeadlineDetail) {
    self.currentSelectEntity = [[CGHorrolEntity alloc]initWithRolId:self.currentEntity.rolId rolName:self.currentEntity.rolName sort:0];
    self.currentSelectEntity.rolType = self.currentEntity.rolType;
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rightBtnAction{
  if (self.isHeadlineDetail) {
    self.currentEntity.rolName = self.currentSelectEntity.rolName;
    self.currentEntity.rolType = self.currentSelectEntity.rolType;
    self.currentEntity.rolId = self.currentSelectEntity.rolId;
  }
  block(self.selectEntity,self.selectIndex);
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.row) {
    case 0:
      self.selectIndex = 0;
      [self.tableView reloadData];
      if (self.isHeadlineDetail) {
        __weak typeof(self) weakSelf = self;
        CGChoseOrganizationViewController *vc = [[CGChoseOrganizationViewController alloc]initWithBlock:^(CGUserOrganizaJoinEntity *entity,NSInteger selectIndex) {
          weakSelf.selectIndex = selectIndex;
          weakSelf.currentSelectEntity.rolName = entity.companyName;
          if (entity.companyType == 2) {
           weakSelf.currentSelectEntity.rolId = entity.classId;
          }else{
            weakSelf.currentSelectEntity.rolId = entity.companyId;
          }
          weakSelf.currentSelectEntity.rolType = [NSString stringWithFormat:@"%d",entity.companyType];
          [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
      }
      break;
    case 1:
    {
      __weak typeof(self) weakSelf = self;
      CGDiscoverOtherCompanyViewController *vc = [[CGDiscoverOtherCompanyViewController alloc]initWithBlock:^(CGUserSearchCompanyEntity *entity) {
        __strong typeof(weakSelf) swself = weakSelf;
        weakSelf.selectIndex = 1;
        swself.selectEntity = entity;
        [swself.tableView reloadData];
      }];
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    default:
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*identifier = @"CGPartSeeTableViewCell";
  CGPartSeeTableViewCell *cell = (CGPartSeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGPartSeeTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.row == self.selectIndex) {
    cell.gou.selected = YES;
  }
  switch (indexPath.row) {
    case 0:
      cell.titleLabel.text = @"当前组织";
      cell.rightArrow.hidden = self.isHeadlineDetail?NO:YES;
      cell.detailLabel.text = self.isHeadlineDetail? self.currentSelectEntity.rolName : self.currentEntity.rolName;
      break;
    case 1:
    {
      cell.titleLabel.text = @"其他公司";
      cell.rightArrow.hidden = NO;
      cell.detailLabel.text = self.selectEntity.name;
    }
      break;
      
    default:
      break;
  }
  return cell;
  
}

@end
