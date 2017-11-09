//
//  CGToolViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGToolViewController.h"
#import "KnowledgeBaseEntity.h"
#import "CGKnowledgeBaseTableViewCell.h"
#import "CGKnowledgeBaseDetailViewController.h"
#import "AttentionBiz.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGDiscoverBiz.h"
#import "CGDiscoverDataEntity.h"
#import "SDCycleScrollView.h"
#import "commonViewModel.h"
#import "CGDiscoverCircleNullTableViewCell.h"

@interface CGToolViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger isDetailClick;
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, strong) KnowledgeBaseEntity *entity;
@property (nonatomic, strong) SDCycleScrollView *topView;
@property (nonatomic, strong) CGDiscoverDataEntity *headerEntity;
@property (nonatomic, strong) commonViewModel *viewModel;
@property (nonatomic, assign) NSInteger isFirst;
@end

@implementation CGToolViewController

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

-(SDCycleScrollView *)topView{
  if(!_topView){
    _topView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPIMAGEHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"faxianmorentu"]];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _topView.currentPageDotColor = [UIColor colorWithWhite:0.7 alpha:0.5]; // 自定义分页控件小圆标颜色
    _topView.pageDotColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    _topView.autoScrollTimeInterval = 30;
  }
  return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.isDetailClick = YES;
  self.isFirst = YES;
  self.biz = [[AttentionBiz alloc]init];
  self.tableView.separatorStyle = NO;
  __weak typeof(self) weakSelf = self;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.tableHeaderView = self.topView;
  [self.biz headlinesSkillNavListWithID:@"c207e713-63b2-9da1-28cf-b22eb4ef8472" success:^(NSMutableArray *result) {
    weakSelf.isFirst = NO;
    if (result>0) {
      weakSelf.entity = result[0];
    }
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
  [self getLocalData];
  
}

-(void)getLocalData{
  NSMutableData *bannerData = [NSMutableData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],TOOL_TOP_DATA]];
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:bannerData];
  self.headerEntity = [unarchiver decodeObjectForKey:TOOL_TOP_DATA];
  NSMutableArray *array = [NSMutableArray array];
  for (BannerData *image in self.headerEntity.banner) {
    NSString *src = image.src;
    [array addObject:src];
  }
  if (array.count<=0) {
    self.topView.localizationImageNamesGroup = @[[UIImage imageNamed:@"gangweigongjumorentu"]];
  }else{
    self.topView.imageURLStringsGroup = array;
  }
  [self getData];
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  [biz discoverDataAction:3 navType:nil time:nil success:^(CGDiscoverDataEntity *entity) {
    weakSelf.headerEntity = entity;
    NSMutableArray *array = [NSMutableArray array];
    for (BannerData *image in weakSelf.headerEntity.banner) {
      NSString *src = image.src;
      [array addObject:src];
    }
    if (array.count<=0) {
      weakSelf.topView.localizationImageNamesGroup = @[[UIImage imageNamed:@"gangweigongjumorentu"]];
    }else{
      weakSelf.topView.imageURLStringsGroup = array;
    }
  } fail:^(NSError *error) {
  }];
}

-(void)rightBtnAction{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 25;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.isDetailClick = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  self.isDetailClick = YES;
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.isFirst) {
    return 0;
  }
  if (self.entity.list.count<=0) {
    return 1;
  }
  return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 0) {
    return 50;
  }
  ListEntity *listEntity = self.entity.list[indexPath.section];
  return [CGKnowledgeBaseTableViewCell height:listEntity.list];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.isFirst) {
    return 0;
  }
  if (self.entity.list.count<=0) {
    return 1;
  }
  return self.entity.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section > 0) {
    return 15;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (self.entity.list.count<=0) {
    NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
    CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  __weak typeof(self) weakSelf = self;
  ListEntity *listEntity = self.entity.list[indexPath.section];
  if (indexPath.row == 0) {
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
      cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
      cell.clipsToBounds = YES;
      cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = listEntity.name;
    return cell;
  }else{
    static NSString*productIdentifier = @"CGKnowledgeBaseTableViewCell";
    CGKnowledgeBaseTableViewCell *cell = (CGKnowledgeBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKnowledgeBaseTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell update:listEntity.list block:^(NavsEntity *entity,NSInteger index) {
      if (weakSelf.isDetailClick) {
        CGKnowledgeBaseDetailViewController *vc = [[CGKnowledgeBaseDetailViewController alloc]init];
        vc.array = weakSelf.entity.list;
        vc.navTypeId = entity.navsID;
        vc.catePage = entity.catePage;
        vc.index = indexPath.section;
        vc.title = entity.name;
        vc.secondaryIndex = index;
        [weakSelf.navigationController pushViewController:vc animated:YES];
      }
    }];
    return cell;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  if (self.headerEntity.banner.count>0) {
    BannerData *entity = self.headerEntity.banner[index];
    [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:nil typeArray:nil];
  }
}

@end
