//
//  CGTeamDocumentCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGTeamDocumentCollectionViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineCatalogTableViewCell.h"
#import "CGDiscoverCircleNullTableViewCell.h"
#import "CGKnowledgeBiz.h"

@interface CGTeamDocumentCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,HeadlineLeftPicTableViewCellDelegate,HeadlineMorePicTableViewCellDelegate,HeadlineRightPicTableViewCellDelegate,HeadlineOnlyTitleTableViewCellDelegate,HeadlineCatalogTableViewCellDelegate>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) CGTeamDocumentCollectionViewBlock block;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, assign) NSInteger type;
@end

@implementation CGTeamDocumentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.separatorColor = CTCommonLineBg;
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineCatalogTableViewCell" bundle:nil] forCellReuseIdentifier:identifierCatalog];
    // Initialization code
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    weakSelf.entity.page = 1;
    [self queryListWithMode:0 page:weakSelf.entity.page];
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.entity.page += 1;
    [self queryListWithMode:1 page:weakSelf.entity.page];
  }];
}

-(void)queryListWithMode:(int)mode page:(NSInteger)page{
  __weak typeof(self) weakSelf = self;
    CGKnowledgeBiz *biz = [[CGKnowledgeBiz alloc]init];
  if (self.type == 2) {
    [biz queryKnowledgePackageWithMainId:nil packageId:nil companyId:weakSelf.entity.rolId cataId:@"" page:page type:0 success:^(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity) {
        //把列表放到内存
        if(mode == 0){
          weakSelf.entity.data = result.list;
          [weakSelf.tableView.mj_header endRefreshing];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        }else{
          if (result.list.count == 0) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
          }else{
          [weakSelf.entity.data addObjectsFromArray:result.list];
            [weakSelf.tableView.mj_footer endRefreshing];
          }
        }
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  } else if (self.type == 999) {
      // 我的文档
      [biz getMyDocumentWithPage:1 success:^(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity) {
          //把列表放到内存
          if(mode == 0){
              weakSelf.entity.data = result.list;
              [weakSelf.tableView.mj_header endRefreshing];
              weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          }else{
              if (result.list.count == 0) {
                  weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
              }else{
                  [weakSelf.entity.data addObjectsFromArray:result.list];
                  [weakSelf.tableView.mj_footer endRefreshing];
              }
          }
          [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
          [weakSelf.tableView.mj_header endRefreshing];
          [weakSelf.tableView.mj_footer endRefreshing];

      }];
  }
  else{
    [biz queryKnowledgePackageWithMainId:nil packageId:weakSelf.entity.rolId companyId:nil cataId:@"" page:page type:0 success:^(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity) {
        //把列表放到内存
        if(mode == 0){
          weakSelf.entity.data = result.list;
          [weakSelf.tableView.mj_header endRefreshing];
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        }else{
          if (result.list.count == 0) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
          }else{
           [weakSelf.entity.data addObjectsFromArray:result.list];
            [weakSelf.tableView.mj_footer endRefreshing];
          }
        }
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  }
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity type:(NSInteger)type showType:(NSInteger)showType block:(CGTeamDocumentCollectionViewBlock)block{
  self.entity = entity;
  self.block = block;
  self.type = type;
  self.showType = showType;
  if (self.entity.data.count<=0) {
    [self.tableView.mj_header beginRefreshing];
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if(self.entity.data.count <= 0){
    NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
    CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = @"暂无数据~";
    cell.icon.image = [UIImage imageNamed:@"no_data"];
    return cell;
  }
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
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
    HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
    cell.close.hidden = YES;
    cell.timeType = 0;
    [cell updateItem:info];
    cell.title.font = [UIFont systemFontOfSize:fontSize];
    cell.delegate = self;
    return cell;
  }else if (info.layout == ContentLayoutMorePic){//多图
    HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
    cell.close.hidden = YES;
    cell.timeType = 0;
    [cell updateItem:info];
    cell.title.font = [UIFont systemFontOfSize:fontSize];
    cell.delegate = self;
    return cell;
  }else if (info.layout == ContentLayoutRightPic){//右图
    HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
    cell.close.hidden = YES;
    cell.timeType = 0;
    [cell updateItem:info];
    cell.title.font = [UIFont systemFontOfSize:fontSize];
    cell.delegate = self;
    return cell;
  }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
    HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
    cell.close.hidden = YES;
    cell.timeType = 0;
    [cell updateItem:info];
    cell.title.font = [UIFont systemFontOfSize:fontSize];
    cell.delegate = self;
    return cell;
  }else if(info.layout == ContentLayoutCatalog){//目录
    HeadlineCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCatalog];
    [cell updateItem:info];
    cell.textLabel.font = [UIFont systemFontOfSize:fontSize];
    cell.delegate = self;
    return cell;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if(self.entity.data.count<=0){
    return tableView.bounds.size.height;
  }
  
  CGInfoHeadEntity *info = self.entity.data[indexPath.row];
  
  if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
    return 116;
  }else if (info.layout == ContentLayoutMorePic){//多图
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
  }else if(info.layout == ContentLayoutCatalog){//目录
    return 55;
  }
  return 0;
}

#pragma CellDelegate

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY{
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if(self.entity.data.count <= 0){
    return;
  }
  CGInfoHeadEntity *item = self.entity.data[indexPath.row];
  self.block(item);
}

@end
