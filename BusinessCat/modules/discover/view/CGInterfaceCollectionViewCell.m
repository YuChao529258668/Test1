//
//  CGInterfaceCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceCollectionViewCell.h"
#import "InterfaceTableViewCell.h"
#import "CGDiscoverBiz.h"
#import "CGExpListTableViewCell.h"
#import "DiscoverDao.h"

@interface CGInterfaceCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,InterfaceDelegate>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, copy) CGInterfaceCollectionViewBlock interfaceBlock;
@property (nonatomic, copy) CGInterfaceProductCollectionViewBlock productBlock;
@property (nonatomic, copy) NSString *catalogId;
@end

@implementation CGInterfaceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.biz = [[CGDiscoverBiz alloc]init];
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolName isEqualToString:@"素材"]) {
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGProductInterfaceEntity *entity = weakSelf.entity.data[0];
        time = entity.createtime;
      }
      weakSelf.entity.page = 1;
      [weakSelf.biz discoverInterfaceListWithPage:weakSelf.entity.page tagId:self.entity.rolId ID:nil verId:nil catalogId:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        [DiscoverDao saveInterfaceListToDB:result action:weakSelf.entity.action];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }else{
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGExpListEntity *entity = weakSelf.entity.data[0];
        time = entity.createtime;
      }
      [weakSelf.biz discoverExpListTime:time mode:0 type:1 page:1 tags:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        [DiscoverDao saveInterfaceProductListToDB:result action:weakSelf.entity.action];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }
  }];
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolName isEqualToString:@"素材"]) {
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGProductInterfaceEntity *entity = [weakSelf.entity.data lastObject];
        time = entity.createtime;
      }
      weakSelf.entity.page = weakSelf.entity.page+1;
      [weakSelf.biz discoverInterfaceListWithPage:weakSelf.entity.page tagId:self.entity.rolId ID:nil verId:nil catalogId:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if(result && result.count > 0){
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }else{
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGExpListEntity *entity = [weakSelf.entity.data lastObject];
        time = entity.createtime;
      }
      weakSelf.entity.page = weakSelf.entity.page+1;
      [weakSelf.biz discoverExpListTime:time mode:1 type:1 page:weakSelf.entity.page tags:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if(result && result.count > 0){
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }
  }];
  
}

- (void)update:(CGHorrolEntity *)entity{
  self.entity = entity;
  [self.tableView.mj_header beginRefreshing];
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity interfaceBlock:(CGInterfaceCollectionViewBlock)interfaceBlock productBlock:(CGInterfaceProductCollectionViewBlock)productBlock{
  self.entity = entity;
  self.interfaceBlock = interfaceBlock;
  self.productBlock = productBlock;
  if (entity.data.count<=0) {
    __weak typeof(self) weakSelf = self;
    if ([entity.rolName isEqualToString:@"素材"]) {
      [DiscoverDao queryInterfaceListFromDBWithAction:entity.action success:^(NSMutableArray *result,BOOL isRefresh) {
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
        if (isRefresh) {
          [weakSelf.tableView.mj_header beginRefreshing];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header beginRefreshing];
      }];
    }else{
      [DiscoverDao queryInterfaceProductListFromDBWithAction:entity.action success:^(NSMutableArray *result,BOOL isRefresh) {
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
        if (isRefresh) {
         [weakSelf.tableView.mj_header beginRefreshing];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header beginRefreshing];
      }];
    }
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.rolName isEqualToString:@"素材"]) {
    return 395;
  }else{
    return 95;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ([self.entity.rolName isEqualToString:@"素材"]) {
   return (self.entity.data.count / 2) + (self.entity.data.count % 2);
  }else{
    return self.entity.data.count;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.entity.rolName isEqualToString:@"产品"]) {
    CGExpListEntity *entity = self.entity.data[indexPath.row];
    self.productBlock(entity);
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self.entity.rolName isEqualToString:@"素材"]) {
    static NSString* cellIdentifier = @"InterfaceTableViewCell";
    InterfaceTableViewCell *cell = (InterfaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InterfaceTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //可能是奇数可能是偶数
    CGProductInterfaceEntity *interface1 = self.entity.data[indexPath.row * 2];
    cell.interface1 = interface1;
    cell.leftButton.tag = indexPath.row * 2;
    NSInteger lastcount = self.entity.data.count%2 == 0?self.entity.data.count/2:self.entity.data.count/2+1;
    if (lastcount-1==indexPath.row) {
      if (self.entity.data.count % 2 == 0) {
        CGProductInterfaceEntity *interface2 = self.entity.data[indexPath.row * 2 + 1];
        cell.interface2 = interface2;
        cell.rightButton.tag = indexPath.row * 2 + 1;
      }
    }else{
      CGProductInterfaceEntity *interface2 = self.entity.data[indexPath.row * 2 + 1];
      cell.interface2 = interface2;
      cell.rightButton.tag = indexPath.row * 2 + 1;
    }
    cell.delegate = self;
    return cell;
  }else{
    static NSString* cellIdentifier = @"CGExpListTableViewCell";
    CGExpListTableViewCell *cell = (CGExpListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGExpListTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGExpListEntity *entity = self.entity.data[indexPath.row];
    [cell update:entity];
    return cell;
  }
}

- (void)doProductDetailWithIndex:(NSInteger )index{
  self.interfaceBlock(index);
}

@end
