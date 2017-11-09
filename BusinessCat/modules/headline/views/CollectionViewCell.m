//
//  CollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2016/11/14.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CollectionViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "CGDiscoverBiz.h"
#import "CGUserDao.h"
#import "CGSearchSourceCircleTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "InterfaceTableViewCell.h"
#import "HeadlineLeftPicAddTableViewCell.h"
#import "CommentaryTableViewCell.h"
#import "SearchCompanyTableViewCell.h"
#import "SearchProductTableViewCell.h"

@interface CollectionViewCell ()<UITableViewDataSource ,UITableViewDelegate,InterfaceDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *juhua;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, assign) NSInteger page;
@end

@implementation CollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
    __weak typeof(self) weakSelf = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
    // Initialization code
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicAddTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicCompany];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchProductTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicProduct];
  //头条收藏回调通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfoCollectState) name:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
  //下拉刷新
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if ([weakSelf.entity.rolId isEqualToString:@"18"]) {
      [weakSelf.entity.biz discoverSubjectSearchKeyword:weakSelf.keyWord ID:weakSelf.subjectId success:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        if (result.count<=0) {
          weakSelf.bgView.hidden = NO;
        }else{
          weakSelf.bgView.hidden = YES;
          weakSelf.entity.data = result;
          [weakSelf.tableView reloadData];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }else if ([weakSelf.entity.rolId isEqualToString:@"1"]){
      weakSelf.entity.page = 1;
      [weakSelf.entity.biz commonSearchInfoWithKeyword:weakSelf.keyWord pageNo:1 level:0 action:1 ID:nil success:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        if (result.count<=0) {
          weakSelf.bgView.hidden = NO;
        }else{
          weakSelf.bgView.hidden = YES;
          weakSelf.entity.data = result;
          [weakSelf.tableView reloadData];
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
    }else{
    NSString *subType = nil;
    if ([weakSelf.entity.rolId isEqualToString:@"14"]) {
      subType = @"1,2,3,4,5,7,9,14,15";
    }
    weakSelf.entity.page = 1;
    [weakSelf.entity.biz commonSearchWithKeyword:weakSelf.keyWord pageNo:1 type:weakSelf.entity.rolId.intValue action:weakSelf.action ID:weakSelf.typeID subType:subType success:^(NSMutableArray *result) {
      [weakSelf.tableView.mj_header endRefreshing];
      if (result.count<=0) {
        weakSelf.bgView.hidden = NO;
      }else{
        weakSelf.bgView.hidden = YES;
        weakSelf.entity.data = result;
        [weakSelf.tableView reloadData];
      }
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
    }
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.entity.page = weakSelf.entity.page+1;
    if ([weakSelf.entity.rolId isEqualToString:@"1"]){
      [weakSelf.entity.biz commonSearchInfoWithKeyword:weakSelf.keyWord pageNo:++weakSelf.entity.page level:0 action:1 ID:nil success:^(NSMutableArray *result) {
        if (result.count>0) {
          [weakSelf.tableView.mj_footer endRefreshing];
          [weakSelf.entity.data addObjectsFromArray:result];
          [weakSelf.tableView reloadData];
        }else{
          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
      }];
    }else{
    NSString *subType = nil;
    if ([weakSelf.entity.rolId isEqualToString:@"14"]) {
      subType = @"1,2,3,4,5,7,9,14,15";
    }
    [weakSelf.entity.biz commonSearchWithKeyword:weakSelf.keyWord pageNo:++weakSelf.entity.page type:weakSelf.entity.rolId.intValue action:weakSelf.action ID:weakSelf.typeID subType:subType success:^(NSMutableArray *result) {
      if (result.count>0) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.entity.data addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
      }else{
      weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
      }
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
    }
  }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

-(void)notificationInfoCollectState{
  [self.tableView reloadData];
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity keyWord:(NSString *)keyWord action:(NSString *)action typeID:(NSString *)typeID didSelectEntityBlock:(CollectionViewCellBlock)block interfaceSelectIndex:(InterfaceSelectIndexBlock)interfaceIndexBlock{
  self.action = action;
  self.typeID = typeID;
  self.entity = entity;
  [self.tableView reloadData];
  didBlock = block;
  interfaceBlock = interfaceIndexBlock;
  self.keyWord = keyWord;
  if (self.entity.data.count<=0) {
    if (![self.tableView.mj_header isRefreshing]) {
      [self.tableView.mj_header beginRefreshing];
    }
  }else{
    self.bgView.hidden = YES;
    [self.tableView reloadData];
  }
//  if (self.entity.rolId.intValue != 1||self.entity.rolId.intValue != 18) {
//    self.tableView.mj_footer = nil;
//  }
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
  [self.entity.biz.component startBlockAnimation];
  NSString *subType = nil;
  if ([self.entity.rolId isEqualToString:@"14"]) {
    subType = @"1,2,3,4,5,7,9,14,15";
  }
  [self.entity.biz commonSearchWithKeyword:self.keyWord pageNo:self.entity.page type:self.entity.rolId.intValue action:self.action ID:self.typeID subType:subType success:^(NSMutableArray *result) {
    [weakSelf.entity.biz.component stopBlockAnimation];
    if (result.count<=0) {
      weakSelf.bgView.hidden = NO;
    }else{
      weakSelf.bgView.hidden = YES;
      weakSelf.entity.data = result;
      [weakSelf.tableView reloadData];
    }
  } fail:^(NSError *error) {
    [weakSelf.entity.biz.component stopBlockAnimation];
  }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.entity.data[indexPath.row] isKindOfClass:[CGInfoHeadEntity class]]) {
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.type == 11) {
      return 212;
    }else if (info.type == 17|| info.type ==21){
      return [CommentaryTableViewCell height:info];
    }else if (info.type == 15){
      return 395;
    }else if (info.type == 1||info.type == 14){
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
    }
    if (info.type == 3 ||info.type == 4 || info.type ==8) {
      return 70;
    }else{
      return 122;
    }
  }else if ([self.entity.rolId isEqualToString:@"18"]){
    return 70;
  }else{
    SearchCellLayout* SearchCellLayout = [self layoutWithStatusModel:self.entity.data[indexPath.row]];
    return SearchCellLayout.cellHeight;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.entity.rolId.integerValue == 15) {
    return (self.entity.data.count / 2) + (self.entity.data.count % 2);
  }
  return self.entity.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (self.entity.data.count<indexPath.row) {
    return;
  }
  didBlock(self.entity.data[indexPath.row]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self.entity.data[indexPath.row] isKindOfClass:[CGInfoHeadEntity class]]) {
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.type == 11) {
      static NSString* cellIdentifier = @"RecommendTableViewCell";
      RecommendTableViewCell *cell = (RecommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecommendTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateInfo:info];
      return cell;
    }else if (info.type == 17|| info.type ==21){
      static NSString* cellIdentifier = @"CommentaryTableViewCell";
      CommentaryTableViewCell *cell = (CommentaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentaryTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateInfo:info];
      return cell;
    }else if (info.type == 15){
      static NSString* cellIdentifier = @"InterfaceTableViewCell";
      InterfaceTableViewCell *cell = (InterfaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InterfaceTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //可能是奇数可能是偶数
      CGInfoHeadEntity *product1 = self.entity.data[indexPath.row * 2];
      cell.product1 = product1;
      cell.leftButton.tag = indexPath.row * 2;
      NSInteger lastcount = self.entity.data.count%2 == 0?self.entity.data.count/2:self.entity.data.count/2+1;
      if (lastcount-1==indexPath.row) {
        if (self.entity.data.count % 2 == 0) {
          CGInfoHeadEntity *product2 = self.entity.data[indexPath.row * 2 + 1];
          cell.product2 = product2;
          cell.rightButton.tag = indexPath.row * 2 + 1;
        }
      }else{
        CGInfoHeadEntity *product2 = self.entity.data[indexPath.row * 2 + 1];
        cell.product2 = product2;
        cell.rightButton.tag = indexPath.row * 2 + 1;
      }
      cell.delegate = self;
      return cell;
    }else if (info.type == 1||info.type==14){
      if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        cell.timeType = 0;
        [cell updateItem:info];
        cell.close.hidden = YES;
        return cell;
      }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        cell.close.hidden = YES;
        cell.timeType = 0;
        [cell updateItem:info];
        return cell;
      }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        cell.timeType = 0;
        [cell updateItem:info];
        cell.close.hidden = YES;
        return cell;
      }else{
        HeadlineLeftPicAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
        cell.timeType = 0;
        [cell updateItem:info action:self.action type:self.entity.rolId.intValue typeID:self.typeID groupId:nil isAttention:self.isAttention subjectId:self.subjectId];
        return cell;
      }
    }else{
      SearchProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPicProduct];
      [cell updateItem:info action:self.action type:self.entity.rolId.intValue typeID:self.typeID groupId:nil isAttention:self.isAttention subjectId:self.subjectId];
      return cell;
    }
  }else if ([self.entity.rolId isEqualToString:@"18"]){
  CGSearchKeyWordEntity *info = self.entity.data[indexPath.row];
    SearchProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPicProduct];
    [cell updatekeyWordItem:info action:self.action type:self.entity.rolId.intValue typeID:self.typeID groupId:nil isAttention:self.isAttention subjectId:self.subjectId];
    return cell;
  }else{
    static NSString* cellIdentifier = @"cellIdentifier";
    CGSearchSourceCircleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[CGSearchSourceCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
  }
  return nil;
}

- (void)confirgueCell:(CGSearchSourceCircleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.indexPath = indexPath;
  SearchCellLayout* SearchCellLayout = [self layoutWithStatusModel:self.entity.data[indexPath.row]];
  cell.cellLayout = SearchCellLayout;
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
    didBlock(link);
  };
}

//展开Cell
- (void)openTableViewCell:(CGSearchSourceCircleTableViewCell *)cell {
  SearchCellLayout* layout =  [self layoutWithStatusModel:self.entity.data[cell.indexPath.row]];
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
  SearchCellLayout* layout =  [self layoutWithStatusModel:self.entity.data[cell.indexPath.row]];
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

//界面点击事件
- (void)doProductDetailWithIndex:(NSInteger )index{
//  NSMutableArray *array = [NSMutableArray array];
//  for (int i = 0; i<self.entity.data.count; i++) {
//    CGInfoHeadEntity *entity = self.entity.data[i];
//    NSString *cover = entity.cover;
//    [array addObject:cover];
//  }
  interfaceBlock(self.entity.data,index);
}

- (SearchCellLayout *)layoutWithStatusModel:(CGSearchSourceCircleEntity *)statusModel{
  SearchCellLayout* layout = [[SearchCellLayout alloc] initWithStatusModel:statusModel isUnfold:NO dateFormatter:self.dateFormatter];
  return layout;
}

@end
