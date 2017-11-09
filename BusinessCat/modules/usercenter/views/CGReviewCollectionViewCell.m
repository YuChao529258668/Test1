//
//  CGReviewCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGReviewCollectionViewCell.h"
#import "CGSearchSourceCircleTableViewCell.h"
#import "CGUserCenterBiz.h"

@interface CGReviewCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGReviewCollectionViewCell

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
    [weakSelf.biz  authUserCommentListWithType:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
      weakSelf.entity.data = [NSMutableArray array];
      for (int i =0; i<reslut.count; i++) {
        CGSearchSourceCircleEntity *entity = reslut[i];
        SearchCellLayout *layout = [weakSelf layoutWithStatusModel:entity];
        [weakSelf.entity.data addObject:layout];
      }
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_header endRefreshing];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
  }];
}

-(void)update:(CGHorrolEntity *)entity{
  self.entity = entity;
  if (self.entity.data.count<=0) {
    [self.tableView.mj_header beginRefreshing];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCellLayout* layout = self.entity.data[indexPath.row];
    return layout.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  SearchCellLayout* cellLayout = self.entity.data[indexPath.row];
  self.didSelectRowAtIndexPathCallback(cellLayout, self);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cellIdentifier";
    CGSearchSourceCircleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[CGSearchSourceCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)confirgueCell:(CGSearchSourceCircleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.indexPath = indexPath;
  SearchCellLayout* cellLayout = self.entity.data[indexPath.row];
  cell.cellLayout = cellLayout;
  [self callbackWithCell:cell];
}

- (void)callbackWithCell:(CGSearchSourceCircleTableViewCell *)cell {
  __weak typeof(self) weakSelf = self;
  cell.clickedReCommentCallback = ^(CGSearchSourceCircleTableViewCell* cell,SourceCircComments* model) {
    
  };
  //展开全文点击回调
  cell.clickedOpenCellCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
    __strong typeof(weakSelf) sself = weakSelf;
    [sself openTableViewCell:cell];
  };
  //收起全文点击回调
  cell.clickedCloseCellCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
    __strong typeof(weakSelf) sself = weakSelf;
    [sself closeTableViewCell:cell];
  };
  //头像点击回调
  cell.clickedAvatarCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
  };
  //图片点击回调
  cell.clickedImageCallback = ^(CGSearchSourceCircleTableViewCell* cell,NSInteger imageIndex) {
  };
  //点击链接回调
  cell.linkCallback = ^(CGSearchSourceCircleTableViewCell* cell,CGDiscoverLink *link){
    weakSelf.clickedLinkCallback(link);
  };
}

//展开Cell
- (void)openTableViewCell:(CGSearchSourceCircleTableViewCell *)cell {
  SearchCellLayout* layout =  self.entity.data[cell.indexPath.row];
  CGSearchSourceCircleEntity* model = layout.entity;
  SearchCellLayout* newLayout = [[SearchCellLayout alloc] initWithStatusModel:model isUnfold:YES dateFormatter:self.dateFormatter];
  [self.entity.data replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(CGSearchSourceCircleTableViewCell *)cell {
  SearchCellLayout* layout =  self.entity.data[cell.indexPath.row];
  CGSearchSourceCircleEntity* model = layout.entity;
  SearchCellLayout* newLayout = [[SearchCellLayout alloc] initWithStatusModel:model isUnfold:NO dateFormatter:self.dateFormatter];
  
  [self.entity.data replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

- (NSDateFormatter *)dateFormatter {
  static NSDateFormatter* dateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
  });
  return dateFormatter;
}

- (SearchCellLayout *)layoutWithStatusModel:(CGSearchSourceCircleEntity *)statusModel{
  SearchCellLayout* layout = [[SearchCellLayout alloc] initWithStatusModel:statusModel isUnfold:NO dateFormatter:self.dateFormatter];
  return layout;
}
@end
