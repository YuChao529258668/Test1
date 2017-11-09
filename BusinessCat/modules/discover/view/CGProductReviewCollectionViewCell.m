//
//  CGProductReviewCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGProductReviewCollectionViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineLeftPicAddTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "CGDiscoverBiz.h"
#import "DiscoverDao.h"

@interface CGProductReviewCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, copy) CGProductReviewCollectionViewBlock block;
@end

@implementation CGProductReviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  __weak typeof(self) weakSelf = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.biz = [[CGDiscoverBiz alloc]init];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
  //头条收藏回调通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfoCollectState) name:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
  //下拉刷新
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
    if (weakSelf.entity.data.count>0) {
      CGInfoHeadEntity *entity = weakSelf.entity.data[0];
      time = entity.createtime;
    }
    weakSelf.entity.page = 1;
//    if ([weakSelf.entity.rolName isEqualToString:@"全民推荐"]||weakSelf.type == 2) {
//      [weakSelf.biz discoverRecommendListWithTime:time mode:0 type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page action:weakSelf.entity.action success:^(NSMutableArray *result) {
//        [weakSelf.tableView.mj_header endRefreshing];
//        if(result && result.count > 0){
//          weakSelf.entity.data = result;
//          [weakSelf.tableView reloadData];
//          [DiscoverDao saveRecommendListToDB:result type:weakSelf.entity.rolId.integerValue action:weakSelf.entity.action];
//        }
//      } fail:^(NSError *error) {
//       [weakSelf.tableView.mj_header endRefreshing];
//      }];
//    }else
      if (weakSelf.type == 9){
        [weakSelf.biz discoverPackageListWithType:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page tagid:weakSelf.tagId success:^(NSMutableArray *result) {
      [weakSelf.tableView.mj_header endRefreshing];
      weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          if (![CTStringUtil stringNotBlank:weakSelf.tagId]) {
            [DiscoverDao saveProductInterfaceToDB:result type:weakSelf.entity.rolId.integerValue action:weakSelf.entity.action];
          }
      weakSelf.entity.data = result;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
    }else{
      [weakSelf.biz discoverCompeteKengPoListWithTime:time mode:0 type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page action:weakSelf.entity.action tagId:weakSelf.tagId success:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        if (![CTStringUtil stringNotBlank:weakSelf.tagId]) {
         [DiscoverDao saveProductInterfaceToDB:result type:weakSelf.entity.rolId.integerValue action:weakSelf.entity.action];
        }
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.entity.page = ++weakSelf.entity.page;
    NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
    if (weakSelf.entity.data.count>0) {
      CGInfoHeadEntity *entity = [weakSelf.entity.data lastObject];
      time = entity.createtime;
    }
//    if ([weakSelf.entity.rolName isEqualToString:@"全民推荐"]||weakSelf.type == 2) {
//      [weakSelf.biz discoverRecommendListWithTime:time mode:1 type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page action:weakSelf.entity.action success:^(NSMutableArray *result) {
//        if(result && result.count > 0){
//          [weakSelf.tableView.mj_footer endRefreshing];
//          [weakSelf.entity.data addObjectsFromArray:result];
//          [weakSelf.tableView reloadData];
//        }else {
//          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//        }
//      } fail:^(NSError *error) {
//        [weakSelf.tableView.mj_footer endRefreshing];
//      }];
//    }else
      if (weakSelf.type == 9){
    [weakSelf.biz discoverPackageListWithType:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page tagid:weakSelf.tagId success:^(NSMutableArray *result) {
      if(result && result.count > 0){
        [weakSelf.entity.data addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
      }else {
        weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
      }
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
    }else{
      [weakSelf.biz discoverCompeteKengPoListWithTime:time mode:1 type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page action:weakSelf.entity.action tagId:weakSelf.tagId success:^(NSMutableArray *result) {
        if(result && result.count > 0){
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_footer endRefreshing];
        }else {
          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }
  }];
}

-(void)notificationInfoCollectState{
  [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity type:(NSInteger)type tagId:(NSString *)tagId block:(CGProductReviewCollectionViewBlock)block{
  self.block = block;
  self.entity = entity;
  self.type = type;
  self.tagId = tagId;
  if (self.entity.data.count<=0) {
    __weak typeof(self) weakSelf = self;
    if (![self.tableView.mj_header isRefreshing]) {
//      if ([self.entity.rolName isEqualToString:@"全民推荐"]||weakSelf.type == 2) {
//      [DiscoverDao queryRecommendListFromDBWithType:self.entity.rolId.integerValue action:self.entity.action success:^(NSMutableArray *result) {
//        weakSelf.entity.data = result;
//        if (weakSelf.entity.data<=0) {
//          [weakSelf.tableView.mj_header beginRefreshing];
//        }else{
//          [weakSelf.tableView reloadData];
//        }
//      } fail:^(NSError *error) {
//        [weakSelf.tableView.mj_header beginRefreshing];
//      }];
//      }else{
        if ([CTStringUtil stringNotBlank:tagId]) {
          [self.tableView reloadData];
          [self.tableView.mj_header beginRefreshing];
        }else{
          [DiscoverDao queryProductInterfaceFromDBWithType:self.entity.rolId.integerValue action:self.entity.action success:^(NSMutableArray *result,BOOL isRefresh) {
            weakSelf.entity.data = result;
            if (weakSelf.entity.data<=0) {
              [weakSelf.tableView.mj_header beginRefreshing];
            }else{
              [weakSelf.tableView reloadData];
              if (isRefresh) {
                [weakSelf.tableView.mj_header beginRefreshing];
              }
            }
          } fail:^(NSError *error) {
            [weakSelf.tableView.mj_header beginRefreshing];
          }];
        }
//      }
//      [self.tableView.mj_header beginRefreshing];
    }
  }else{
    self.bgView.hidden = YES;
    [self.tableView reloadData];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.rolName isEqualToString:@"全民推荐"]||self.type == 2) {
    return 212;
  }else{
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.layout == ContentLayoutMorePic){//多图
      return [HeadlineMorePicTableViewCell height:info];
    }else if (info.layout == ContentLayoutRightPic){//右图
      HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
      [cell updateItem:info];
      return cell.height;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
      return [HeadlineOnlyTitleTableViewCell height:info];
    }else{
    return 116;
    }
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSLog(@"--------2------%ld",self.entity.data.count);
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  if ([self.entity.rolName isEqualToString:@"全民推荐"]||self.type == 2) {
    self.block(0, info);
  }else{
    self.block(1, info);
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  if ([self.entity.rolName isEqualToString:@"全民推荐"]||self.type == 2) {
    static NSString* cellIdentifier = @"RecommendTableViewCell";
    RecommendTableViewCell *cell = (RecommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecommendTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateInfo:info];
    return cell;
  }else{
    if (info.layout == ContentLayoutMorePic){//多图
      static NSString*identifier = @"HeadlineMorePicTableViewCell";
      HeadlineMorePicTableViewCell *cell = (HeadlineMorePicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineMorePicTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.timeType = self.type ==9?4:2;
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutRightPic){//右图
      static NSString*identifier = @"HeadlineRightPicTableViewCell";
      HeadlineRightPicTableViewCell *cell = (HeadlineRightPicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineRightPicTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.timeType = self.type ==9?4:2;
      cell.close.hidden = YES;
      [cell updateItem:info];
      return cell;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
      static NSString*identifier = @"HeadlineOnlyTitleTableViewCell";
      HeadlineOnlyTitleTableViewCell *cell = (HeadlineOnlyTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineOnlyTitleTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.timeType = self.type ==9?4:2;
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }else{
      static NSString*identifier = @"HeadlineLeftPicTableViewCell";
      HeadlineLeftPicTableViewCell *cell = (HeadlineLeftPicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineLeftPicTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.timeType = self.type ==9?4:2;
      [cell updateItem:info];
      cell.close.hidden = YES;
      return cell;
    }
  }
  return nil;
}
@end
