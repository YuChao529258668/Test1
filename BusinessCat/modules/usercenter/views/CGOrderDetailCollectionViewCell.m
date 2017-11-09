//
//  CGOrderDetailCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderDetailCollectionViewCell.h"
#import "CGOrderProgressTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGOrderProgressEntity.h"
#import "CGOrderDetailTableViewCell.h"

@interface CGOrderDetailCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGOrderDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.biz = [[CGUserCenterBiz alloc]init];
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolName isEqualToString:@"订单进度"]) {
      [weakSelf.biz authUserOrderScheduleListWIthOrderId:weakSelf.entity.rolId success:^(NSMutableArray *reslut) {
        weakSelf.entity.data = reslut;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }
  }];
}

-(void)update:(CGHorrolEntity *)entity{
  self.entity = entity;
  if ([entity.rolName isEqualToString:@"订单进度"]) {
    if (entity.data.count<=0) {
      [self.tableView.mj_header beginRefreshing];
    }
  }else{
    self.tableView.mj_header = nil;
    [self.tableView reloadData];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.rolName isEqualToString:@"订单进度"]) {
    return 145;
  }
  return [CGOrderDetailTableViewCell height:self.entity.data[indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.entity.rolName isEqualToString:@"订单进度"]) {
    
  }else{
  
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self.entity.rolName isEqualToString:@"订单进度"]) {
    static NSString*towIdentifier = @"CGOrderProgressTableViewCell";
    CGOrderProgressTableViewCell *cell = (CGOrderProgressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:towIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGOrderProgressTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGOrderProgressEntity *entity = self.entity.data[indexPath.row];
    [cell update:entity];
    if (self.entity.data.count == indexPath.row+1) {
      [cell.pointButton setImage:[UIImage imageNamed:@"originedge"] forState:UIControlStateNormal];
    }
    return cell;
  }else{
    static NSString*towIdentifier = @"CGOrderDetailTableViewCell";
    CGOrderDetailTableViewCell *cell = (CGOrderDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:towIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGOrderDetailTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell update:self.entity.data[indexPath.row]];
    return cell;
  }
}
@end
