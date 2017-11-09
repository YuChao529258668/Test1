//
//  CGMessageDetailViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageDetailViewController.h"
#import "CGMessageDetailEntity.h"
#import "CGMessageDetailImageTextTableViewCell.h"
#import "CGMessageDetailMoreGraphicTableViewCell.h"
#import "CGMessageDetailSingleGraphicTableViewCell.h"
#import "CGMessageDetailTextTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "commonViewModel.h"

@interface CGMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self getData];
  self.tableView.separatorStyle = NO;
    // Do any additional setup after loading the view from its nib.
}

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
  self.biz = [[CGUserCenterBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    weakSelf.page = 1;
    [weakSelf.biz authUserMessageSystemListWithID:weakSelf.ID page:weakSelf.page type:weakSelf.type success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      [weakSelf.tableView reloadData];
      [weakSelf.tableView.mj_header endRefreshing];
      weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
    }];
  }];
  
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    weakSelf.page = ++weakSelf.page;
    [weakSelf.biz authUserMessageSystemListWithID:weakSelf.ID page:weakSelf.page type:weakSelf.type success:^(NSMutableArray *reslut) {
      if (reslut.count>0) {
        [weakSelf.dataArray addObjectsFromArray:reslut];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
      }else{
        --weakSelf.page;
        weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
      }
    } fail:^(NSError *error) {
      --weakSelf.page;
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  }];
  [self.tableView.mj_header beginRefreshing];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGMessageDetailEntity *entity = self.dataArray[indexPath.section];
  if (entity.pushLayout == 0) {
    static NSString*identifier = @"CGMessageDetailTextTableViewCell";
    CGMessageDetailTextTableViewCell *cell = (CGMessageDetailTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMessageDetailTextTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    [cell update:entity];
    return cell.height;
  }else if (entity.pushLayout == 1){
    return [CGMessageDetailSingleGraphicTableViewCell height:entity];
  }else{
    if (indexPath.row == 0) {
      return 168;
    }
    return 60;
  }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
  view.backgroundColor = CTCommonViewControllerBg;
  return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
  view.backgroundColor = CTCommonViewControllerBg;
  CGMessageDetailEntity *entity = self.dataArray[section];
  UILabel *label = [[UILabel alloc]init];
  label.textColor = [UIColor whiteColor];
  label.font = [UIFont systemFontOfSize:13];
  label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
  label.layer.cornerRadius = 4;
  label.layer.masksToBounds = YES;
  label.textAlignment = NSTextAlignmentCenter;
  [view addSubview:label];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"MM月dd日 HH:mm"];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.createTime/1000];
  NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
  label.text = confromTimespStr;
  [label sizeToFit];
  label.frame = CGRectMake((SCREEN_WIDTH-label.frame.size.width-10)/2, 11, label.frame.size.width+10, 18);
  return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  CGMessageDetailEntity *entity = self.dataArray[section];
  if (entity.pushLayout == 2) {
    return entity.list.count+1;
  }
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGMessageDetailEntity *entity = self.dataArray[indexPath.section];
  if (entity.pushLayout == 0) {
    static NSString*identifier = @"CGMessageDetailTextTableViewCell";
    CGMessageDetailTextTableViewCell *cell = (CGMessageDetailTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMessageDetailTextTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell update:entity];
    return cell;
  }else if (entity.pushLayout == 1){
    static NSString*identifier = @"CGMessageDetailSingleGraphicTableViewCell";
    CGMessageDetailSingleGraphicTableViewCell *cell = (CGMessageDetailSingleGraphicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMessageDetailSingleGraphicTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell update:entity];
    return cell;
  }else{
    if (indexPath.row == 0) {
      static NSString*identifier = @"CGMessageDetailMoreGraphicTableViewCell";
      CGMessageDetailMoreGraphicTableViewCell *cell = (CGMessageDetailMoreGraphicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMessageDetailMoreGraphicTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell update:entity];
      return cell;
    }else{
      static NSString*identifier = @"CGMessageDetailImageTextTableViewCell";
      CGMessageDetailImageTextTableViewCell *cell = (CGMessageDetailImageTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMessageDetailImageTextTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      CGMessageDetailListEntity *detailEntity = entity.list[indexPath.row-1];
      if (indexPath.row == entity.list.count) {
        cell.bgView.layer.cornerRadius = 8;
        cell.bgView.layer.masksToBounds = YES;
        cell.bgView.layer.borderWidth = 0.5;
        cell.bgView.layer.borderColor = CTCommonLineBg.CGColor;
      }
      [cell update:detailEntity];
      return cell;
    }
  }
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGMessageDetailEntity *entity = self.dataArray[indexPath.section];
  if (entity.pushLayout == 0||entity.pushLayout == 1) {
   [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.recordType commpanyId:entity.companyId recordId:entity.recordId messageId:nil detial:nil typeArray:nil];
  }else{
    if (indexPath.row == 0) {
      [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.recordType commpanyId:entity.companyId recordId:entity.recordId messageId:nil detial:nil typeArray:nil];
    }else{
      CGMessageDetailListEntity *detailEntity = entity.list[indexPath.row-1];
      [self.viewModel messageCommandWithCommand:detailEntity.command parameterId:detailEntity.recordType commpanyId:detailEntity.companyId recordId:detailEntity.recordId messageId:nil detial:nil typeArray:nil];
    }
  }
}
@end
