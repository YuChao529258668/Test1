//
//  CGKnowledgeMealCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeMealCollectionViewCell.h"
#import "CGKnowledgeMealTableViewCell.h"
#import "CGKnowledgeBiz.h"
#import "CGKnowledgeCatalogController.h"
#import "CGDiscoverCircleNullTableViewCell.h"

#import "CGKnowLedgeListEntity.h"
#import "CGKonwledgeMoreTableViewCell.h"
#import "CGKonwledgeLeftTableViewCell.h"
#import "CGKonwledgeRightTableViewCell.h"
#import "CGKonwledgeTextTableViewCell.h"
#import "SDCycleScrollView.h"
#import "CGDiscoverBiz.h"

@interface CGKnowledgeMealCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) CGKnowledgeMealCollectionBlock block;
@property (nonatomic, strong) CGKnowledgeMealTopCollectionBlock topBlock;
@property(nonatomic,retain)CGHorrolEntity *navType;
@property(nonatomic,retain)NSString *time;
@property (nonatomic, assign) NSInteger isNonetwork;
@property (nonatomic, strong) SDCycleScrollView *topView;
@property (nonatomic, assign) NSInteger isfrist;
@end

@implementation CGKnowledgeMealCollectionViewCell

-(SDCycleScrollView *)topView{
  if(!_topView){
    _topView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPIMAGEHEIGHT) delegate:self placeholderImage:nil];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _topView.currentPageDotColor = [UIColor colorWithWhite:0.7 alpha:0.5]; // 自定义分页控件小圆标颜色
    _topView.pageDotColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    _topView.autoScrollTimeInterval = 30;
  }
  return _topView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationLogout) name:NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationLogout) name:NOTIFICATION_LOGINSUCCESS object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      weakSelf.entity.page = 1;
      weakSelf.isfrist = NO;
        if(weakSelf.entity.rolId && weakSelf.navType){
          [weakSelf getDiscoverData];
            CGKnowledgeBiz *biz = [[CGKnowledgeBiz alloc]init];
          [biz headlinesKnowledgePackageIndexWithTime:weakSelf.entity.rolId navType:weakSelf.navType.rolId page:weakSelf.entity.page type:0 success:^(NSMutableArray *result) {
              weakSelf.entity.data = result;
              [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
          } fail:^(NSError *error) {
                  [weakSelf.tableView reloadData];
                            [weakSelf.tableView.mj_header endRefreshing];
                          if (error.code == 10086&&weakSelf.entity.data.count<=0) {
                            weakSelf.isNonetwork = YES;
                          }
          }];
//            [biz queryKnowledgeListWithNavType:self.navType.rolId time:self.entity.rolId success:^(NSMutableArray<KnowledgeAlbumEntity *> *list) {
//                weakSelf.entity.data = list;
//                [weakSelf.tableView reloadData];
//                [weakSelf.tableView.mj_header endRefreshing];
//            } fail:^(NSError *error) {
//                [weakSelf.tableView.mj_header endRefreshing];
//              if (error.code == 10086&&weakSelf.entity.data.count<=0) {
//                weakSelf.isNonetwork = YES;
//              }
//            }];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
  
//  //上拉加载更多
//  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//    weakSelf.entity.page = ++weakSelf.entity.page;
//    if(weakSelf.entity.rolId && weakSelf.navType){
//      CGKnowledgeBiz *biz = [[CGKnowledgeBiz alloc]init];
//      [biz headlinesKnowledgePackageIndexWithTime:weakSelf.entity.rolId navType:self.navType.rolId page:weakSelf.entity.page type:0 success:^(NSMutableArray *result) {
//        if(result && result.count > 0){
//          [weakSelf.entity.data addObjectsFromArray:result];
//          [weakSelf.tableView reloadData];
//          [weakSelf.tableView.mj_footer endRefreshing];
//        }else {
//          weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//        }
//      } fail:^(NSError *error) {
//        [weakSelf.tableView.mj_footer endRefreshing];
//        if (error.code == 10086&&weakSelf.entity.data.count<=0) {
//          weakSelf.isNonetwork = YES;
//        }
//      }];
//    }else{
//      [self.tableView.mj_footer endRefreshing];
//    }
//    }];
//    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"玩命加载中" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}

-(void)getDiscoverData{
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
  [biz discoverDataAction:4 navType:self.navType.rolId time:self.entity.rolId success:^(CGDiscoverDataEntity *entity) {
    weakSelf.entity.discoverEntity = entity;
    NSMutableArray *array = [NSMutableArray array];
    for (BannerData *image in weakSelf.entity.discoverEntity.banner) {
      NSString *src = image.src;
      [array addObject:src];
    }
    if (array.count<=0) {
      weakSelf.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    }else{
      weakSelf.tableView.tableHeaderView = weakSelf.topView;
      weakSelf.topView.imageURLStringsGroup = array;
    }
  } fail:^(NSError *error) {
    weakSelf.topView.localizationImageNamesGroup = @[[UIImage imageNamed:@"gangweigongjumorentu"]];
  }];
}

-(void)notificationLogout{
    [self.tableView.mj_header beginRefreshing];
}

-(void)updateCell:(CGHorrolEntity *)entity navType:(CGHorrolEntity *)navType block:(CGKnowledgeMealCollectionBlock)block topBlock:(CGKnowledgeMealTopCollectionBlock)topBlock{
    self.block = block;
  self.topBlock = topBlock;
  self.entity = entity;
  self.navType = navType;
  if (self.entity.discoverEntity.banner.count<=0) {
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    [self getDiscoverData];
  }else{
    NSMutableArray *array = [NSMutableArray array];
    for (BannerData *image in self.entity.discoverEntity.banner) {
      NSString *src = image.src;
      [array addObject:src];
    }
    self.tableView.tableHeaderView = self.topView;
    self.topView.imageURLStringsGroup = array;
  }
  if (self.entity.data.count>0) {
    self.isfrist = NO;
    [self.tableView reloadData];
  }else{
  self.isfrist = YES;
  [self.tableView reloadData];
  [self.tableView.mj_header beginRefreshing];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      if(!self.entity.data || self.entity.data.count <= 0){
          return tableView.bounds.size.height-TOPIMAGEHEIGHT;
      }
  CGKnowLedgeListEntity *entity = self.entity.data[indexPath.section];
  CGInfoHeadEntity *info = entity.list[indexPath.row];
    if (entity.direction == 1){//左图
      if (info.imglist.count<=0) {
        return 70;
      }
      return 100;
    }else if (entity.direction == 2){//右图
      if (info.imglist.count<=0) {
        return 70;
      }
      return 100;
    }else if (entity.direction == 0){//仅标题
      return 70;
    }else{
      return [CGKonwledgeMoreTableViewCell height:entity.list];
    }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.isfrist ) {
    return 0;
  }
      if(!self.entity.data || self.entity.data.count <= 0){
          return 1;
      }
  return self.entity.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      if(!self.entity.data || self.entity.data.count <= 0){
          return 0.001;
      }
  if (section == 0) {
    return 50;
  }
  return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
      if(!self.entity.data || self.entity.data.count <= 0){
          return nil;
      }
  CGKnowLedgeListEntity *entity = self.entity.data[section];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
  view.backgroundColor = [UIColor whiteColor];
  CGFloat labelY = 0;
  if (section > 0) {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [view addSubview:topView];
    topView.backgroundColor = CTCommonViewControllerBg;
    labelY = 10;
  }
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, labelY, SCREEN_WIDTH-30, 50)];
  label.text = entity.title;
  label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  label.textColor = TEXT_MAIN_CLR;
  [view addSubview:label];
  
  UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(15, labelY, SCREEN_WIDTH-30, 50)];
  tip.text = entity.tip;
  tip.font = [UIFont systemFontOfSize:13];
  tip.textColor = [UIColor lightGrayColor];
  [view addSubview:tip];
  tip.textAlignment = NSTextAlignmentRight;
  
  UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5+labelY, SCREEN_WIDTH-30, 0.5)];
  line.backgroundColor = CTCommonLineBg;
  [view addSubview:line];
  
  return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      if(!self.entity.data || self.entity.data.count <= 0){
          return 1;
      }
  CGKnowLedgeListEntity *entity = self.entity.data[section];
  if (entity.direction == 3) {
    return 1;
  }
  return entity.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if(!self.entity.data || self.entity.data.count <= 0){
    return ;
  }
  CGKnowLedgeListEntity *entity = self.entity.data[indexPath.section];
  if (entity.direction == 3) {
    return;
  }
  CGInfoHeadEntity *info = entity.list[indexPath.row];
  self.block(info);
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if(!self.entity.data || self.entity.data.count <= 0){
          NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
          CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
          if (cell == nil) {
              NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
              cell = [array objectAtIndex:0];
              cell.backgroundColor = [UIColor clearColor];
          }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NetworkStatus status = [[ObjectShareTool sharedInstance].reachability currentReachabilityStatus];
          if(self.isNonetwork){
            cell.titleLabel.text = @"服务正在升级";
            cell.icon.image = [UIImage imageNamed:@"Check_network"];
          }else if (status == NotReachable) {
          cell.titleLabel.text = @"断网了 ~T_T~ 请检查网络";
          cell.icon.image = [UIImage imageNamed:@"Check_network"];
        }else{
          cell.titleLabel.text = @"暂无数据~";
          cell.icon.image = [UIImage imageNamed:@"no_data"];
        }
          return cell;
      }
  
  CGKnowLedgeListEntity *entity = self.entity.data[indexPath.section];
  CGInfoHeadEntity *info = entity.list[indexPath.row];
    if (entity.direction == 1){//左图
      NSString*identifier = @"CGKonwledgeLeftTableViewCell";
      CGKonwledgeLeftTableViewCell *cell = (CGKonwledgeLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeLeftTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
      }
      cell.titleLabel.text = info.title;
      NSString *url;
      if (info.imglist.count>0) {
        NSDictionary *dic = info.imglist[0];
        url = dic[@"src"];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morentu"]];
        cell.titleTrailing.constant = 120;
        cell.icon.hidden = NO;
      }else{
        cell.titleTrailing.constant = 15;
        cell.icon.hidden = YES;
      }
      return cell;
    }else if (entity.direction == 2){//右图
      NSString*identifier = @"CGKonwledgeRightTableViewCell";
      CGKonwledgeRightTableViewCell *cell = (CGKonwledgeRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeRightTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
      }
      cell.titleLabel.text = info.title;
      NSString *url;
      if (info.imglist.count>0) {
        NSDictionary *dic = info.imglist[0];
        url = dic[@"src"];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morentu"]];
        cell.titleLeading.constant = 120;
        cell.icon.hidden = NO;
      }else{
        cell.titleLeading.constant = 15;
        cell.icon.hidden = YES;
      }
      return cell;
    }else if (entity.direction == 0){//仅标题
      NSString*identifier = @"CGKonwledgeTextTableViewCell";
      CGKonwledgeTextTableViewCell *cell = (CGKonwledgeTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeTextTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
      }
      cell.titleLabel.text = info.title;
      return cell;
    }else{
      NSString*identifier = @"CGKonwledgeMoreTableViewCell";
      CGKonwledgeMoreTableViewCell *cell = (CGKonwledgeMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeMoreTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      __weak typeof(self) weakSelf = self;
      [cell update:entity.list block:^(CGInfoHeadEntity *item) {
        weakSelf.block(item);
      }];
      return cell;
    }
  return nil;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  if (self.entity.discoverEntity.banner.count>0) {
    BannerData *entity = self.entity.discoverEntity.banner[index];
    self.topBlock(entity);
  }
}

//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(!self.entity.data || self.entity.data.count <= 0){
//        return 0;
//    }
//    return 15;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]init];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(!self.entity.data || self.entity.data.count <= 0){
//        return tableView.bounds.size.height;
//    }
//    if(indexPath.row == 0){
//        return 40;
//    }
//    return TOPIMAGEHEIGHT+55;//50为上面的高度，40为下面的高度
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if(!self.entity.data || self.entity.data.count <= 0){
//        return 1;
//    }
//    return self.entity.data.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(!self.entity.data || self.entity.data.count <= 0){
//        return 1;
//    }
//    KnowledgeAlbumEntity *header = self.entity.data[section];
//    return header.groupList.count+1;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(self.entity.data && self.entity.data.count > 0 && indexPath.row > 0){
//        KnowledgeAlbumEntity *header = self.entity.data[indexPath.section];
//        KnowledgeHeaderEntity *entity = header.groupList[indexPath.row-1];
//        long endOfToday = [CTDateUtils endOfDate:[NSDate date]].timeIntervalSince1970*1000;
//        if(header.isVip && header.groupTime < endOfToday){
//             self.block(entity);
//        }else{
//            NSDate *cud = [NSDate date];
//            long cu = cud.timeIntervalSince1970;
//            long st = header.groupTime/1000;
//            if(cu < st){
//                [[CTToast makeText:@"未到开放时间，暂不能查看"]show:[UIApplication sharedApplication].keyWindow];
//            }else{
//                self.block(entity);
//            }
//        }
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(!self.entity.data || self.entity.data.count <= 0){
//        NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
//        CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
//            cell = [array objectAtIndex:0];
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//      NetworkStatus status = [[ObjectShareTool sharedInstance].reachability currentReachabilityStatus];
//      if (self.isNonetwork||status == NotReachable) {
//        cell.titleLabel.text = @"断网了 ~T_T~ 请检查网络";
//        cell.icon.image = [UIImage imageNamed:@"Check_network"];
//      }else{
//        cell.titleLabel.text = @"暂无数据~";
//        cell.icon.image = [UIImage imageNamed:@"no_data"];
//      }
//        return cell;
//    }
//    
//    KnowledgeAlbumEntity *header = self.entity.data[indexPath.section];
//    if(indexPath.row == 0){
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if(!cell){
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
//            line.backgroundColor = CTCommonLineBg;
//            [cell.contentView addSubview:line];
//            
//            UIButton *icon = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
//            icon.tag = 1000;
//            [cell.contentView addSubview:icon];
//            
//            UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+30, 0, SCREEN_WIDTH, 40)];
//            title.titleLabel.font = [UIFont systemFontOfSize:16];
//            [title setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            [title setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
//            title.tag = 1001;
//            [cell.contentView addSubview:title];
//            
//            UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-85, 0, 85, 40)];
//            start.textColor = [UIColor lightGrayColor];
//            start.font = [UIFont systemFontOfSize:12];
//            start.tag = 1002;
//            [cell.contentView addSubview:start];
//        }
//        
//        UIButton *icon = [cell.contentView viewWithTag:1000];
//        UIButton *title = [cell.contentView viewWithTag:1001];
//        UILabel *start = [cell.contentView viewWithTag:1002];
//        [title setTitle:header.groupName forState:UIControlStateNormal];
//        
//        NSString *normalImageName = nil;
//        NSString *selectedImageName = nil;
//        if(header.groupType == 1){//早餐
//            normalImageName = @"breakfast-gray";
//            selectedImageName = @"breakfast";
//        }else if(header.groupType == 2){//上午茶
//            normalImageName = @"morningtea-gray";
//            selectedImageName = @"morningtea";
//        }else if(header.groupType == 3){//午餐
//            normalImageName = @"lunch-gray";
//            selectedImageName = @"lunch";
//        }else if(header.groupType == 4){//下午茶
//            normalImageName = @"afternoontea-gray";
//            selectedImageName = @"afternoontea";
//        }else if(header.groupType == 5){//晚餐
//            normalImageName = @"dinner-gray";
//            selectedImageName = @"dinner";
//        }else if(header.groupType == 6){//宵夜
//            normalImageName = @"supper-gray";
//            selectedImageName = @"supper";
//        }
//        [icon setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
//        [icon setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
//        
//        NSDate *cud = [NSDate date];
//        long cu = cud.timeIntervalSince1970;
//        long st = header.groupTime/1000;
//        long endOfToday = [CTDateUtils endOfDate:[NSDate date]].timeIntervalSince1970*1000;
//        if((header.isVip || (cu > st)) && header.groupTime < endOfToday){//可用
//            icon.selected = YES;
//        }else{//不可用
//            icon.selected = NO;
//        }
//        if(!icon.selected){
//            start.hidden = NO;
//            start.text = [NSString stringWithFormat:@" %@点开始",[CTDateUtils formatDateFromLong:header.groupTime format:@"HH:mm"]];
//        }else{
//            start.hidden = YES;
//        }
//        title.selected = icon.selected;
//        [title sizeToFit];
//        title.frame = CGRectMake(CGRectGetMaxX(icon.frame)+5, 0, title.frame.size.width, 40);
//        return cell;
//    }else{
//        CGKnowledgeMealTableViewCell *cell = (CGKnowledgeMealTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!cell){
//            cell = [[CGKnowledgeMealTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        }
//        
//        KnowledgeHeaderEntity *entity = header.groupList[indexPath.row-1];
//        [cell updateItem:entity header:header];
//        return cell;
//    }
//}
@end
