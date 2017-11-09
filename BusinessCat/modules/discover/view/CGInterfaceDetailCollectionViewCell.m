//
//  CGInterfaceDetailCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceDetailCollectionViewCell.h"
#import "CGDiscoverBiz.h"
#import "CGInterfaceDetailTableViewCell.h"
#import "CGProductDetailsVersionEntity.h"
#import "CGInterfaceDetailTopTableViewCell.h"

@interface CGInterfaceDetailCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) CGInterfaceDetailViewBlock block;
@end

@implementation CGInterfaceDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.biz = [[CGDiscoverBiz alloc]init];
  
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity productID:(NSString *)productID block:(CGInterfaceDetailViewBlock)block{
  self.entity = entity;
  self.block = block;
  self.productID = productID;
  if (self.entity.data.count>0) {
    [self.tableView reloadData];
  }else{
    [self getData];
  }
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  [self.biz productDetailsVersionListWithID:self.productID platform:self.entity.rolId success:^(NSMutableArray *result) {
    weakSelf.entity.data = result;
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 60;
  }
  CGProductDetailsVersionEntity *entity = self.entity.data[indexPath.row];
  CGFloat height = [CTStringUtil heightWithFont:15 width:(SCREEN_WIDTH-87*2-15*2-20) str:entity.desc];
  CGFloat heights;
  if (height>98) {
    heights = height+20;
    if (!entity.isPush) {
      heights = 98+40;
    }else{
      heights = height+40;
    }
  }else{
    heights = 118;
  }
  return heights;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 0) {
    return 1;
  }
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    static NSString* cellIdentifier = @"CGInterfaceDetailTopTableViewCell";
    CGInterfaceDetailTopTableViewCell *cell = (CGInterfaceDetailTopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGInterfaceDetailTopTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  static NSString* cellIdentifier = @"CGInterfaceDetailTableViewCell";
  CGInterfaceDetailTableViewCell *cell = (CGInterfaceDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGInterfaceDetailTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGProductDetailsVersionEntity *entity = self.entity.data[indexPath.row];
  __weak typeof(self) weakSelf = self;
  [cell update:entity block:^(CGProductDetailsVersionEntity *entity) {
    weakSelf.block(entity);
  } pushBlock:^{
    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
  }];
  return cell;
}

@end
