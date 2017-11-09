//
//  UserWalletCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "UserWalletCollectionViewCell.h"
#import "CGUserCenterBiz.h"
#import "UserWalletTableViewCell.h"
#import "CGIntegralEntity.h"
#import "CGHeadlineInfoDetailController.h"

@interface UserWalletCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) UserWalletCollectionViewBlock block;
@end

@implementation UserWalletCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.biz = [[CGUserCenterBiz alloc]init];
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf.biz authUserIntegralHistoryWithTime:[NSDate date].timeIntervalSince1970*1000 type:weakSelf.entity.rolId.integerValue success:^(CGIntegralEntity *reslut) {
      weakSelf.entity.data = [NSMutableArray array];
      [weakSelf.entity.data addObject:reslut];
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_header endRefreshing];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    NSInteger time;
    if (weakSelf.entity.data.count<=0) {
      time = [NSDate date].timeIntervalSince1970*1000;
    }else{
      CGIntegralEntity *entity = [weakSelf.entity.data lastObject];
      IntegralListEntity *info = [entity.list lastObject];
      time = info.dateTime;
    }
      if(time <= 0){
          [weakSelf.tableView.mj_footer endRefreshing];
          return;
      }
    [weakSelf.biz authUserIntegralHistoryWithTime:time type:weakSelf.entity.rolId.integerValue success:^(CGIntegralEntity *reslut) {
//      [weakSelf.dataArray addObjectsFromArray:reslut];
      [weakSelf.entity.data addObject:reslut];
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  }];
}

-(void)updateDataWithType:(CGHorrolEntity *)entity block:(UserWalletCollectionViewBlock)block{
  self.entity = entity;
  self.block = block;
  if (self.entity.data.count<=0) {
    [self.tableView.mj_header beginRefreshing];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGIntegralEntity *entity = self.entity.data[indexPath.section];
  IntegralListEntity *integral = entity.list[indexPath.row];
  if ([CTStringUtil stringNotBlank:integral.relationInfo.infoID]) {
    return 125;
  }
  return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.entity.data.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  CGIntegralEntity *entity = self.entity.data[section];
  if (entity.list.count>0) {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    CGIntegralEntity *entity = self.entity.data[section];
    label.text = [self timeWithTimeIntervalString:entity.dateTime];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, SCREEN_WIDTH-30, 0.5)];
    line.backgroundColor = CTCommonLineBg;
    [view addSubview:line];
    return view;
  }
  return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  CGIntegralEntity *entity = self.entity.data[section];
  if (entity.list.count>0) {
    return 50;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  CGIntegralEntity *entity = self.entity.data[section];
  return entity.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*identifier = @"UserWalletTableViewCell";
  UserWalletTableViewCell *cell = (UserWalletTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserWalletTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGIntegralEntity *entity = self.entity.data[indexPath.section];
  IntegralListEntity *listEntity = entity.list[indexPath.row];
  __weak typeof(self) weakSelf = self;
  [cell info:listEntity block:^(RelationInfoEntity *entity) {
    weakSelf.block(entity);
  }];
  return cell;
}

- (NSString *)timeWithTimeIntervalString:(NSInteger)time
{
  // 格式化时间
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"MM月dd日"];
  
  // 毫秒值转化为秒
  NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
  NSString* dateString = [formatter stringFromDate:date];
  return dateString;
}
@end
