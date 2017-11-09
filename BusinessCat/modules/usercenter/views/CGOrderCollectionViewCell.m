//
//  CGOrderCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderCollectionViewCell.h"
#import "CGOrderTableViewCell.h"
#import "CGUserCenterBiz.h"

@interface CGOrderCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, copy) CGOrderTableViewDidSelectIndexBlock indexBlock;
@property (nonatomic, copy) CGOrderTableViewCellBlock tableViewButtonBlock;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *button;
@end

@implementation CGOrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.biz = [[CGUserCenterBiz alloc]init];
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    weakSelf.entity.page = 1;
    [weakSelf.biz authUserOrderListWithOrderStatus:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
      weakSelf.entity.data = reslut;
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_header endRefreshing];
      weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.entity.page = ++weakSelf.entity.page;
    [weakSelf.biz authUserOrderListWithOrderStatus:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
      if (reslut.count>0) {
        [weakSelf.entity.data addObjectsFromArray:reslut];
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
  }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRemoteUserDetailInfo) name:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
}
-(void)update:(CGHorrolEntity *)entity{
  self.entity = entity;
  if (self.entity.data.count<=0) {
    [self.tableView.mj_header beginRefreshing];
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData) {
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

-(void)queryRemoteUserDetailInfo{
  __weak typeof(self) weakSelf = self;
  CGOrderEntity *entity = self.entity.data[self.indexPath.row];
  [self.biz authUserOrderDetailsWithOrderId:entity.orderId success:^(CGOrderEntity *reslut) {
    [weakSelf.entity.data replaceObjectAtIndex:weakSelf.indexPath.row withObject:reslut];
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
}

-(void)didSelectIndexWithBlock:(CGOrderTableViewDidSelectIndexBlock)block tableViewButtonBlock:(CGOrderTableViewCellBlock)tableViewButtonBlock{
  self.indexBlock = block;
  self.tableViewButtonBlock = tableViewButtonBlock;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGOrderEntity *entity = self.entity.data[indexPath.row];
  return [CGOrderTableViewCell height:entity];
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
  CGOrderEntity *entity = self.entity.data[indexPath.row];
  self.indexBlock(entity);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*towIdentifier = @"CGOrderTableViewCell";
  CGOrderTableViewCell *cell = (CGOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:towIdentifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGOrderTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  __weak typeof(self) weakSelf = self;
  CGOrderEntity *entity = self.entity.data[indexPath.row];
  [cell update:entity block:^(CGOrderEntity *entity, NSInteger type, UIButton *button) {
    weakSelf.indexPath = indexPath;
    weakSelf.button = button;
    if ((entity.orderState == 1&&entity.payState == 0)||(entity.orderState == 1&&entity.payState == 2)) {
      //去支付 取消订单
      if (type == 1) {
        weakSelf.tableViewButtonBlock(entity,type);
      }else{
        [weakSelf cancelOrder];
      }
    }else if ((entity.orderState == 2&&entity.payState == 1)||(entity.orderState == 3&&entity.payState == 1)){
      //取消订单
    }else if (entity.orderState == 3&&entity.payState == 1){
      //申请退款
    }else if (entity.orderState == 5&&entity.payState == 1){
      //申请售后
    }else{
    }
  }];
  return cell;
}

-(void)cancelOrder{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"是否取消订单"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定",nil];
  [alert show];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  __weak typeof(self) weakSelf = self;
  if (buttonIndex == 1) {
    [self.biz.component startBlockAnimation];
    CGOrderEntity *entity = self.entity.data[self.indexPath.row];
    [self.button setUserInteractionEnabled:NO];
    [self.biz authUserOrderCancelWithOrderId:entity.orderId success:^{
      [weakSelf.biz authUserOrderDetailsWithOrderId:entity.orderId success:^(CGOrderEntity *reslut) {
        [weakSelf.entity.data replaceObjectAtIndex:weakSelf.indexPath.row withObject:reslut];
        [weakSelf.tableView reloadData];
        [weakSelf.biz.component stopBlockAnimation];
        [self.button setUserInteractionEnabled:YES];
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
        [self.button setUserInteractionEnabled:YES];
      }];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
      [self.button setUserInteractionEnabled:YES];
    }];
  }
}
@end
