//
//  CGKnowledgeBaseCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBaseCollectionViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "AttentionBiz.h"
#import "DiscoverDao.h"
#import "CGToolTableViewCell.h"
#import "HeadlineBiz.h"

@interface CGKnowledgeBaseCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, assign) NSInteger catePage;
@property (nonatomic, copy) NSString *navTypeId;
@property (nonatomic, copy) CGKnowledgeBaseCollectionBlock block;
@end

@implementation CGKnowledgeBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.separatorStyle = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.biz = [[AttentionBiz alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      weakSelf.entity.page = 1;
      if (weakSelf.catePage) {
        [weakSelf.biz headlinesSkillNavToolListWithID:weakSelf.navTypeId type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page success:^(NSMutableArray *result) {
          weakSelf.entity.data = result;
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_header endRefreshing];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          [DiscoverDao saveJobKnowledgeToDB:result type:weakSelf.entity.rolId.integerValue navTypeId:weakSelf.navTypeId];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        } fail:^(NSError *error) {
          [weakSelf.tableView.mj_header endRefreshing];
        }];
      }else{
        [weakSelf.biz radarGroupDetailsListScoopWithPage:weakSelf.entity.page navTypeId:weakSelf.navTypeId type:weakSelf.entity.rolId.integerValue success:^(NSMutableArray *result) {
          weakSelf.entity.data = result;
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_header endRefreshing];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          [DiscoverDao saveJobKnowledgeToDB:result type:weakSelf.entity.rolId.integerValue navTypeId:weakSelf.navTypeId];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        } fail:^(NSError *error) {
          [weakSelf.tableView.mj_header endRefreshing];
        }];
      }
    }];
  
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      weakSelf.entity.page = ++weakSelf.entity.page;
      if (weakSelf.catePage) {
        [weakSelf.biz headlinesSkillNavToolListWithID:weakSelf.navTypeId type:weakSelf.entity.rolId.integerValue page:weakSelf.entity.page success:^(NSMutableArray *result) {
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
      }else{
        [weakSelf.biz radarGroupDetailsListScoopWithPage:weakSelf.entity.page navTypeId:weakSelf.navTypeId type:weakSelf.entity.rolId.integerValue success:^(NSMutableArray *result) {
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

-(void)update:(CGHorrolEntity *)entity catePage:(NSInteger)catePage navTypeId:(NSString *)navTypeId{
  self.entity = entity;
  self.catePage = catePage;
  self.navTypeId = navTypeId;
  [self.tableView.mj_header beginRefreshing];
}

-(void)update:(CGHorrolEntity *)entity catePage:(NSInteger)catePage navTypeId:(NSString *)navTypeId block:(CGKnowledgeBaseCollectionBlock)block{
  self.block = block;
  self.entity = entity;
  self.catePage = catePage;
  self.navTypeId = navTypeId;
  __weak typeof(self) weakSelf = self;
  [DiscoverDao queryJobKnowledgeFromDBWithType:self.entity.rolId.integerValue navTypeId:self.navTypeId success:^(NSMutableArray *result,BOOL isRefresh) {
    weakSelf.entity.data = result;
    [weakSelf.tableView reloadData];
    if (isRefresh) {
      [weakSelf.tableView.mj_header beginRefreshing];
    }
  } fail:^(NSError *error) {
    [weakSelf.tableView.mj_header beginRefreshing];
  }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData) {
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
//  if(self.catePage == 1){
//    return 116;
//  }
  if (info.layout == ContentLayoutMorePic){//多图
    return [HeadlineMorePicTableViewCell height:info];;
  }else if (info.layout == ContentLayoutRightPic){//右图
    HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
    [cell updateItem:info];
    return cell.height;
  }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
    return [HeadlineOnlyTitleTableViewCell height:info];
  }else if(info.layout == ContentLayoutLeftPic){
    return 116;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
//  __weak typeof(self) weakSelf = self;
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  self.block(info);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  NSInteger fontSize = 17;
  switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
    case 1:
      fontSize = 17;
      break;
    case 2:
      fontSize = 19;
      break;
    case 3:
      fontSize = 20;
      break;
    case 4:
      fontSize = 24;
      break;
      
    default:
      break;
  }
//  if(self.catePage == 1){
//    CGToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTool];
//    cell.title.font = [UIFont systemFontOfSize:fontSize];
//    [cell updateItem:info];
//    return cell;
//  }
  if (info.layout == ContentLayoutLeftPic){//左图标
    static NSString*identifier = @"HeadlineLeftPicTableViewCell";
    HeadlineLeftPicTableViewCell *cell = (HeadlineLeftPicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineLeftPicTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.timeType = 1;
    [cell updateItem:info];
    cell.close.hidden = YES;
    return cell;
  }else if (info.layout == ContentLayoutMorePic){//多图
    static NSString*identifier = @"HeadlineMorePicTableViewCell";
    HeadlineMorePicTableViewCell *cell = (HeadlineMorePicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineMorePicTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.timeType = 1;
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
    cell.timeType = 1;
    [cell updateItem:info];
    cell.close.hidden = YES;
    return cell;
  }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
    static NSString*identifier = @"HeadlineOnlyTitleTableViewCell";
    HeadlineOnlyTitleTableViewCell *cell = (HeadlineOnlyTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineOnlyTitleTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.timeType = 1;
    [cell updateItem:info];
    cell.close.hidden = YES;
    return cell;
  }
  return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
    return YES;
  }else{
    return NO;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  return @"取消启用";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if (self.entity.data.count>indexPath.row) {
      CGInfoHeadEntity *info = self.entity.data[indexPath.row];
      __weak typeof(self) weakSelf = self;
      [[[HeadlineBiz alloc]init] headlinesManagerUpdateByAdminWithInfoId:info.infoId time:0 title:nil navtype:nil navtype2:nil choice:0 state:0 success:^{
        [weakSelf.entity.data removeObject:info];
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        
      }];
    }
    
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
  }
}
@end
