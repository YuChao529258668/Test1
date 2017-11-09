//
//  CGAttentionIndexController.m
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionIndexController.h"
#import "AttentionHeaderCell.h"
#import "ProductTableViewCell.h"
#import "ThemeTableViewCell.h"
#import "CompanyTableViewCell.h"
#import "CGUserDao.h"
#import "CGAttentionSearchKeyWordViewController.h"
#import "AttentionBiz.h"
#import "AttentionSearchTableViewCell.h"
#import "AttentionGroupTableViewCell.h"
#import "CGAttentionMyGroupViewController.h"
#import "AttentionUnfoldTableViewCell.h"
#import "CGAttentionProductViewController.h"
#import "MonitoringDao.h"
#import "CGCompanyDao.h"
#import "CGUserChangeOrganizationViewController.h"
#import "MonitoringNoDataTableViewCell.h"

@interface CGAttentionIndexController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, strong) AttentionCompanyEntity *entity;
@property (nonatomic, strong) companyEntity *myGroupEntity;
@property (nonatomic, assign) BOOL isUnfold;
@end

@implementation CGAttentionIndexController

-(AttentionCompanyEntity *)entity{
  if (!_entity) {
    _entity = [[AttentionCompanyEntity alloc]init];
  }
  return _entity;
}

-(companyEntity *)myGroupEntity{
  if (!_myGroupEntity) {
    _myGroupEntity = [[companyEntity alloc]init];
    _myGroupEntity.title = @"我的分组";
    _myGroupEntity.auditState = 1;
  }
  return _myGroupEntity;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"雷达";
  [self hideCustomBackBtn];
  self.tableView.separatorStyle = NO;
  self.biz = [[AttentionBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf getData];
  }];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
  rightBtn.contentMode = UIViewContentModeScaleToFill;
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setBackgroundImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(organizaChange) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGOUT object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLoginSuccess) name:NOTIFICATION_LOGINSUCCESS object:nil];
  //关注回调
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProductSuccess) name:NOTIFICATION_ATTENTION object:nil];
}

//关注回调
-(void)updateProductSuccess{
  __weak typeof(self) weakSelf = self;
  [self.biz queryAttentionHeadListWithTime:0 mode:0 url:URL_ATTENTION_MY_LIST success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [weakSelf.tableView.mj_header endRefreshing];
  } fail:^(NSError *error) {
    [weakSelf.tableView.mj_header endRefreshing];
  }];
}

//登录后收到的通知
-(void)notificationLoginSuccess{
  [self.tableView.mj_header beginRefreshing];
}

-(void)logout{
   [self.tableView.mj_header beginRefreshing];
}


-(void)organizaChange{
  __weak typeof(self) weakSelf = self;
  [self.biz radarCompanyListSuccess:^(AttentionCompanyEntity *result) {
    weakSelf.entity = result;
    weakSelf.myGroupEntity.update = result.defaultUpdate;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  } fail:^(NSError *error) {
    
  }];
}

-(void)rightBtnAction{
  CGAttentionSearchKeyWordViewController *vc = [[CGAttentionSearchKeyWordViewController alloc]init];
  vc.action = @"library";
  vc.isAttentionIndex = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)getLocalityData{
  __weak typeof(self) weakSelf = self;
  [MonitoringDao queryMonitorinListFromDBSuccess:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [weakSelf.biz queryAttentionHeadListWithTime:0 mode:0 url:URL_ATTENTION_MY_LIST success:^(NSMutableArray *result) {
      weakSelf.dataArray = result;
      NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
      [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSError *error) {
    }];
  } fail:^(NSError *error) {
    
  }];
  
  self.entity = [CGCompanyDao getMonitoringGroupListFromLocal];
  self.myGroupEntity.update = self.entity.defaultUpdate;
  NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
  [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.biz radarCompanyListSuccess:^(AttentionCompanyEntity *result) {
    weakSelf.entity = result;
    weakSelf.myGroupEntity.update = result.defaultUpdate;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  } fail:^(NSError *error) {
    
  }];
}

- (void)getData{
  __weak typeof(self) weakSelf = self;
  [self.biz radarCompanyListSuccess:^(AttentionCompanyEntity *result) {
    weakSelf.entity = result;
    weakSelf.myGroupEntity.update = result.defaultUpdate;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  } fail:^(NSError *error) {
    
  }];
  
  [self.biz queryAttentionHeadListWithTime:0 mode:0 url:URL_ATTENTION_MY_LIST success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [weakSelf.tableView.mj_header endRefreshing];
  } fail:^(NSError *error) {
    [weakSelf.tableView.mj_header endRefreshing];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 0){
    if (self.entity.list.count+1>3&&self.isUnfold == NO) {
      return 4;
    }else if(self.entity.list.count+1>3&&self.isUnfold == YES){
      return self.entity.list.count+2;
    }
    if (self.entity.list.count == 0) {
      return 2;
    }
    return self.entity.list.count+1;
  }
  if (self.dataArray.count==0) {
    return 1;
  }
  return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0){
    return 50;
  }
  if (self.dataArray.count == 0) {
    return 300;
  }
  return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if (section == 1||section == 0) {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = CTCommonViewControllerBg;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-90, 40)];
    label.textColor = [UIColor grayColor];
    label.text = section==0?@"监控组":@"监控列表";
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    return view;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section == 0 || section == 1) {
    return 40;
  }
  return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0){
    if (self.entity.list.count+1>3) {
      NSInteger count = self.isUnfold?(self.entity.list.count+1):3;
      if (indexPath.row == count) {
        static NSString*identifier = @"AttentionUnfoldTableViewCell";
        AttentionUnfoldTableViewCell *cell = (AttentionUnfoldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AttentionUnfoldTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        [cell update:self.isUnfold];
        return cell;
      }
    }
    static NSString*identifier = @"AttentionGroupTableViewCell";
    AttentionGroupTableViewCell *cell = (AttentionGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AttentionGroupTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    if (indexPath.row == 0) {
      [cell update:self.myGroupEntity];
    }else{
      if (self.entity.list.count == 0) {
        cell.titleLabel.text = @"组织分组";
        cell.typeLabel.text = @"单击加入你的组织";
        cell.typeLabel.hidden = NO;
        cell.typeLabelTrailing.constant = 25;
      }else{
        companyEntity *entity = self.entity.list[indexPath.row-1];
        [cell update:entity];
      }
    }
    return cell;
  }else{
    if (self.dataArray.count == 0) {
      static NSString*productIdentifier = @"MonitoringNoDataTableViewCell";
      MonitoringNoDataTableViewCell *cell = (MonitoringNoDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MonitoringNoDataTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      [cell.button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
      return cell;
    }
    AttentionHead *entity = self.dataArray[indexPath.row];
    if ([CTStringUtil stringNotBlank:entity.source]) {
      static NSString*productIdentifier = @"ThemeTableViewCell";
      ThemeTableViewCell *cell = (ThemeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ThemeTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      [cell updateItem:entity];
      return cell;
    }else{
      static NSString*productIdentifier = @"ProductTableViewCell";
      ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      [cell updateItem:entity];
      return cell;
    }
  }
  return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    return YES;
  }
  return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
  __weak typeof(self) weakSelf = self;
  AttentionHead *entity = self.dataArray[indexPath.row];
  UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    [weakSelf.biz subscribeAddWithId:entity.infoId type:entity.type success:^(NSInteger status) {
      [MonitoringDao deleteMonitoringToDB:entity];
      [MonitoringDao deleteDynamicWithDynamicID:entity.infoId];
    } fail:^(NSError *error) {
      
    }];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }];
  NSString *topStr = entity.isTop?@"取消置顶":@"置顶";
  UITableViewRowAction *changeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:topStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    if (!entity.isTop) {
            entity.isTop = !entity.isTop;
            [weakSelf.dataArray removeObject:entity];
            [weakSelf.dataArray insertObject:entity atIndex:0];
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }else{
      NSInteger index = 0;
      for (int i=0; i<weakSelf.dataArray.count; i++) {
        AttentionHead *attentity = self.dataArray[i];
        if (attentity.isTop) {
          index = i;
        }else{
          break;
        }
      }
      entity.isTop = !entity.isTop;
      [weakSelf.dataArray removeObject:entity];
      [weakSelf.dataArray insertObject:entity atIndex:index];
      NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
      [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    [MonitoringDao savemonitoringToDB:self.dataArray];
    [weakSelf.biz radarSubscribeTopWithID:entity.infoId type:entity.type op:entity.isTop success:^{
    } fail:^(NSError *error) {
    }];
  }];
  return @[deleteRowAction,changeRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 0){
    if (self.entity.list.count+1>3) {
      NSInteger count = self.isUnfold?(self.entity.list.count+1):3;
      if (indexPath.row == count) {
        self.isUnfold = !self.isUnfold;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
      }
    }
    
    companyEntity *entity;
    if (indexPath.row == 0) {
      entity = self.myGroupEntity;
    }else{
      if (self.entity.list.count == 0) {
          CGUserChangeOrganizationViewController *vc = [[CGUserChangeOrganizationViewController alloc]init];
          [self.navigationController pushViewController:vc animated:YES];
        return;
      }
      entity = self.entity.list[indexPath.row-1];
    }
    
    if (entity.auditState !=1) {
      return;
    }
    __weak typeof(self) weakSelf = self;
    CGAttentionMyGroupViewController *vc = [[CGAttentionMyGroupViewController alloc]initWithBlock:^(BOOL cancelRed) {
      if (cancelRed) {
        entity.update =NO;
        if (indexPath.row == 0) {
          weakSelf.entity.defaultUpdate = NO;
        }
        [CGCompanyDao saveMonitoringGroupListInLocal:weakSelf.entity];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
      }
    }];
    vc.titleText = entity.title;
    vc.type = entity.type;
    vc.groupID = entity.companyID;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (indexPath.section == 1){
    AttentionHead *entity = self.dataArray[indexPath.row];
    CGAttentionProductViewController *vc = [[CGAttentionProductViewController alloc]init];
    vc.titleText = entity.title;
    vc.attentionID = entity.infoId;
    vc.type = entity.type;
    [self.navigationController pushViewController:vc animated:YES];
    entity.newNum = 0;
    //self.dataArray = [self sort:self.dataArray];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [MonitoringDao updateMonitoring:entity];
  }
}

-(NSMutableArray *)sort:(NSMutableArray *)array{
  
  NSComparator cmptr = ^(id obj1, id obj2){
    AttentionHead *entity = obj1;
    AttentionHead *entity2 = obj2;
    if (entity.attentionTime < entity2.attentionTime) {
      
      return (NSComparisonResult)NSOrderedDescending;
      
    }
    if (entity.attentionTime > entity2.attentionTime) {
      
      return (NSComparisonResult)NSOrderedAscending;
      
    }
    
    return (NSComparisonResult)NSOrderedSame;
    
  };
  
  NSMutableArray *array1 = [[array sortedArrayUsingComparator:cmptr] mutableCopy];
  int index = 0;
  for (int i = 0; i<array1.count; i++) {
    AttentionHead *entity = array1[i];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.attentionTime/1000];
    if ([[NSDate date] timeIntervalSinceDate:confromTimesp] > 60.0f*30) {
      index = i;
      break;
    }
  }
  
  NSMutableArray *newarray = [NSMutableArray array];
  for (AttentionHead *entity in array1) {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.attentionTime/1000];
    if (entity.newNum>0) {
      if ([[NSDate date] timeIntervalSinceDate:confromTimesp] > 60.0f*30) {
        [newarray addObject:entity];
      }
    }
  }
  NSComparator newcmptr = ^(id obj1, id obj2){
    AttentionHead *entity = obj1;
    AttentionHead *entity2 = obj2;
    if (entity.newNum > entity2.newNum) {
      
      return (NSComparisonResult)NSOrderedDescending;
      
    }
    if (entity.newNum < entity2.newNum) {
      
      return (NSComparisonResult)NSOrderedAscending;
      
    }
    
    return (NSComparisonResult)NSOrderedSame;
    
  };
  if (newarray.count>0) {
   NSArray *array2 = [newarray sortedArrayUsingComparator:newcmptr];
    for (AttentionHead *entity in array2) {
      [array1 removeObject:entity];
    }
    for (AttentionHead *entity in array2) {
      [array1 insertObject:entity atIndex:index];
    }
  }
  
  return array1;
}
@end
