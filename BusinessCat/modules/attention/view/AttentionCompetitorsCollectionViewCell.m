//
//  AttentionCompetitorsCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionCompetitorsCollectionViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "AttentionBiz.h"
#import "ThemeTableViewCell.h"
#import "ProductTableViewCell.h"
#import "AttentionHead.h"
#import "AttentionStatisticsTableViewCell.h"
#import "AttentionStatisticsEntity.h"
#import "MonitoringDao.h"
#import "CGCompanyDao.h"

@interface AttentionCompetitorsCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,AttentionStatisticsTableViewDelegate>
@property (nonatomic, strong) CGAttentionEntity *entity;
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, copy) AttentionCompetitorsDynamicBlock dynamicBlock;
@property (nonatomic, copy) AttentionCompetitorsListBlock listBlock;
@property (nonatomic, copy) AttentionStatisticsBlock statisticsBlock;
@end

@implementation AttentionCompetitorsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.biz = [[AttentionBiz alloc]init];
  // Initialization code
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicAddTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicCompany];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchProductTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicProduct];
  __weak typeof(self) weakSelf = self;
  //下拉刷新
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolName isEqualToString:@"名单"]) {
      weakSelf.entity.page = 1;
      [weakSelf.biz radarGroupConditionListWithID:weakSelf.entity.rolId page:weakSelf.entity.page success:^(NSMutableArray *result) {
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }else if ([weakSelf.entity.rolName isEqualToString:@"动态"]){
      weakSelf.entity.page = 1;
      [weakSelf.biz radarGroupDetailsListWithType:weakSelf.entity.type time:0 page:weakSelf.entity.page ID:weakSelf.entity.rolId navTypeId:nil success:^(NSMutableArray *result) {
      weakSelf.entity.data = result;
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
    }
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolName isEqualToString:@"名单"]) {
      [weakSelf.biz radarGroupConditionListWithID:weakSelf.entity.rolId page:++weakSelf.entity.page success:^(NSMutableArray *result) {
        if (result.count>0) {
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_footer endRefreshing];
        }else{
          --weakSelf.entity.page;
          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
      } fail:^(NSError *error) {
        --weakSelf.entity.page;
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }else if ([weakSelf.entity.rolName isEqualToString:@"动态"]){
      NSInteger time = 0;
      if (weakSelf.entity.data.count>0) {
        CGInfoHeadEntity *info = [weakSelf.entity.data lastObject];
        time = info.createtime;
      }
      [weakSelf.biz radarGroupDetailsListWithType:weakSelf.entity.type time:time page:++weakSelf.entity.page ID:weakSelf.entity.rolId navTypeId:nil success:^(NSMutableArray *result) {
        if (result.count>0) {
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_footer endRefreshing];
        }else{
          --weakSelf.entity.page;
          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
      } fail:^(NSError *error) {
        --weakSelf.entity.page;
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }
  }];
}

- (void)updateUIWithEntity:(CGAttentionEntity *)entity didSelectEntityDynamicBlock:(AttentionCompetitorsDynamicBlock)dynamicBlock listBlock:(AttentionCompetitorsListBlock)listBlock statisticsBlock:(AttentionStatisticsBlock)statisticsBlock{
  self.entity = entity;
  self.dynamicBlock = dynamicBlock;
  self.listBlock = listBlock;
  self.statisticsBlock = statisticsBlock;
  if (self.entity.data.count<=0) {
    __weak typeof(self) weakSelf = self;
    if ([weakSelf.entity.rolName isEqualToString:@"动态"]){
      [MonitoringDao queryMonitorinListFromDBWithdynamicID:self.entity.rolId success:^(NSMutableArray *result) {
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header beginRefreshing];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header beginRefreshing];
      }];
    }else{
      [weakSelf.tableView.mj_header beginRefreshing];
    }
  }
  if ([self.entity.rolName isEqualToString:@"统计"]) {
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    if (self.entity.data.count<=0) {
      [self getStatisticsData];
    }
  }
}


-(void)getStatisticsData{
  __weak typeof(self) weakSelf = self;
  [self.biz radarGroupDetailsStatisticsWithType:self.entity.type ID:self.entity.rolId page:0 success:^(NSMutableArray *result) {
    weakSelf.entity.data = result;
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
  
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.rolName isEqualToString:@"名单"]) {
    return 70;
  }else if ([self.entity.rolName isEqualToString:@"动态"]){
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
      if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        [cell updateItem:info];
        return cell.height;
      }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        [cell updateItem:info];
        return cell.height;
      }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        [cell updateItem:info];
        return cell.height;
      }
  }else if ([self.entity.rolName isEqualToString:@"统计"]){
    return 50;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ([self.entity.rolName isEqualToString:@"统计"]) {
    return self.entity.data.count%2 == 0?self.entity.data.count/2:self.entity.data.count/2+1;
  }
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.entity.rolName isEqualToString:@"名单"]) {
    AttentionHead *entity = self.entity.data[indexPath.row];
    self.listBlock(entity);
  }else if ([self.entity.rolName isEqualToString:@"动态"]){
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    self.dynamicBlock(info);
  }else if ([self.entity.rolName isEqualToString:@"统计"]){
    
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self.entity.rolName isEqualToString:@"名单"]) {
    AttentionHead *entity = self.entity.data[indexPath.row];
    if ([CTStringUtil stringNotBlank:entity.source]) {
      static NSString* cellIdentifier = @"ThemeTableViewCell";
      ThemeTableViewCell *cell = (ThemeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ThemeTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateItem:entity];
      return cell;
    }else{
      static NSString* cellIdentifier = @"ProductTableViewCell";
      ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateItem:entity];
      return cell;
    }
  }else if ([self.entity.rolName isEqualToString:@"动态"]){
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.layout == ContentLayoutLeftPic){//左图标
      HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutMorePic){//多图
      HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutRightPic){//右图
      HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
      HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }
  }else if ([self.entity.rolName isEqualToString:@"统计"]){
    static NSString* cellIdentifier = @"AttentionStatisticsTableViewCell";
    AttentionStatisticsTableViewCell *cell = (AttentionStatisticsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AttentionStatisticsTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //可能是奇数可能是偶数
    AttentionStatisticsEntity *product1 = self.entity.data[indexPath.row * 2];
    cell.product1 = product1;
    NSInteger lastcount = self.entity.data.count%2 == 0?self.entity.data.count/2:self.entity.data.count/2+1;
    if (lastcount-1==indexPath.row) {
      if (self.entity.data.count % 2 == 0) {
        AttentionStatisticsEntity *product2 = self.entity.data[indexPath.row * 2 + 1];
        cell.product2 = product2;
      }
    }else{
      AttentionStatisticsEntity *product2 = self.entity.data[indexPath.row * 2+1];
      cell.product2 = product2;
    }
    cell.delegate = self;
    return cell;
  }
  return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.rolName isEqualToString:@"名单"]){
    return YES;
  }
  return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    AttentionHead *entity = self.entity.data[indexPath.row];
    [self.biz authRadarGroupConditionAddWithID:entity.infoId type:entity.type subjectId:self.entity.rolId op:NO success:^{
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:@NO];
    } fail:^(NSError *error) {
      
    }];
    [self.entity.data removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

- (void)doProductDetailWithEntity:(AttentionStatisticsEntity *)entity{
  self.statisticsBlock(entity);
}
@end
