//
//  CGAttentionDynamicViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionDynamicViewController.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "AttentionBiz.h"

#import "CGHeadlineInfoDetailController.h"

@interface CGAttentionDynamicViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, assign) NSInteger isClick;
@end

@implementation CGAttentionDynamicViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[AttentionBiz alloc]init];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.page = 1;
  self.isClick = YES;
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
  [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicAddTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicCompany];
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchProductTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicProduct];
//  [self getData];
  __weak typeof(self) weakSelf = self;
  //下拉刷新
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      weakSelf.page = 1;
    [weakSelf.biz radarGroupDetailsListWithType:weakSelf.type time:0 page:weakSelf.page ID:weakSelf.dynamicID navTypeId:weakSelf.navTypeId success:^(NSMutableArray *result) {
        weakSelf.dataArray = result;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
      } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
      }];
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.page = ++weakSelf.page;
    NSInteger time = 0;
    if (weakSelf.dataArray.count>0) {
      CGInfoHeadEntity *info = [weakSelf.dataArray lastObject];
      time = info.createtime;
    }
    [weakSelf.biz radarGroupDetailsListWithType:weakSelf.type time:time page:weakSelf.page ID:weakSelf.dynamicID navTypeId:weakSelf.navTypeId success:^(NSMutableArray *result) {
      if (result.count>0) {
        [weakSelf.dataArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
      }else{
        --weakSelf.page;
      }
      [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
      --weakSelf.page;
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  }];
  [self.tableView.mj_header beginRefreshing];
}


//-(void)getData{
//  __weak typeof(self) weakSelf = self;
//  [self.biz.component startBlockAnimation];
//  [self.biz radarGroupDetailsListWithType:self.type page:self.page ID:self.dynamicID navTypeId:self.navTypeId success:^(NSMutableArray *result) {
//    [weakSelf.biz.component stopBlockAnimation];
//    weakSelf.dataArray = result;
//    [weakSelf.tableView reloadData];
//  } fail:^(NSError *error) {
//    [weakSelf.biz.component stopBlockAnimation];
//  }];
//}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
//  [self.biz.component stopBlockAnimation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGInfoHeadEntity *info = self.dataArray[indexPath.row];
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
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
//  __weak typeof(self) weakSelf = self;
  CGInfoHeadEntity *info = self.dataArray[indexPath.row];
  if (info.infoId.length<=0 || info.type == 15) {
    return;
  }
  CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
    
  }];
  detail.info = info;
  [self.navigationController pushViewController:detail animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGInfoHeadEntity *info = self.dataArray[indexPath.row];
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
    if (info.layout == ContentLayoutLeftPic){//左图标
      HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
      [cell updateItem:info];
      cell.title.font = [UIFont systemFontOfSize:fontSize];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutMorePic){//多图
      HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
      [cell updateItem:info];
      cell.title.font = [UIFont systemFontOfSize:fontSize];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutRightPic){//右图
      HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
      [cell updateItem:info];
      cell.title.font = [UIFont systemFontOfSize:fontSize];
      cell.close.hidden = YES;
      return cell;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
      HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
      [cell updateItem:info];
      cell.title.font = [UIFont systemFontOfSize:fontSize];
      cell.close.hidden = YES;
      return cell;
    }
  return nil;
}
@end
