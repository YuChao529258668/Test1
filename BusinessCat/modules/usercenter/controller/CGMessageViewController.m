//
//  CGMessageViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageViewController.h"
#import "CGPartSeeAddressEntity.h"
#import "CGDiscoverPartSeeAddressTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "CGSearchController.h"
#import "CGSearchVoiceView.h"
#import "CGMassageTableViewCell.h"
#import "CGMessageEntity.h"
#import "CGUserCenterBiz.h"
#import "CGMessageDetailViewController.h"

@interface CGMessageViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (nonatomic, strong) NSMutableArray *cancelArray;
@property (nonatomic, strong) CGSearchVoiceView *searchView;
@property (nonatomic, assign) BOOL isSearchKeyWord;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, assign) NSInteger page;
@end

@implementation CGMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"消息";
  self.dataSource = [NSMutableArray array];
  self.tableView.sectionIndexColor = [UIColor blackColor];
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.page = 1;
  [self getdata];
  __weak typeof(self) weakSelf = self;
  self.searchView = [[CGSearchVoiceView alloc]initWithPlaceholder:@"搜索" voiceBlock:^(NSString *content) {
    if([CTStringUtil stringNotBlank:content]){//word为语音识别结果
      weakSelf.isSearchKeyWord = YES;
      weakSelf.searchDataSource = [weakSelf searchDataWith:weakSelf.dataSource searchText:content];
    }
  } changeText:^(NSString *content) {
    weakSelf.searchDataSource = [weakSelf searchDataWith:weakSelf.dataSource searchText:content];
    [weakSelf.tableView reloadData];
  }];
  self.searchView.textField.delegate = self;
//  [self.tableView setTableHeaderView:self.searchView];
    // Do any additional setup after loading the view from its nib.
}

- (void)getdata{
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    weakSelf.page = 1;
    [weakSelf.biz authUserMessageListWithPage:weakSelf.page success:^(NSMutableArray *reslut) {
      weakSelf.dataSource = reslut;
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
    [weakSelf.biz authUserMessageListWithPage:weakSelf.page success:^(NSMutableArray *reslut) {
      if (reslut.count>0) {
        [weakSelf.dataSource addObjectsFromArray:reslut];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  self.isSearchKeyWord = YES;
  [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
  if (textField.text.length<=0) {
    self.isSearchKeyWord = NO;
    [self.tableView reloadData];
  }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  [self.searchView.textField resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:YES];
}

-(void)baseBackAction{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField.returnKeyType==UIReturnKeySearch)
  {
    self.searchDataSource = [self searchDataWith:self.dataSource searchText:textField.text];
    [self.tableView reloadData];
  }
  return YES;
}

-(NSMutableArray *)searchDataWith:(NSMutableArray *)array searchText:(NSString *)searchText{
  NSMutableArray *searchArray = [NSMutableArray array];
  for (CGMessageEntity *entity in array) {
    if ([entity.name rangeOfString:searchText].location != NSNotFound) {
      [searchArray addObject:entity];
    }
  }
  return searchArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!self.isSearchKeyWord) {
    return _dataSource.count;
  }else {
    return _searchDataSource.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString*identifier = @"CGMassageTableViewCell";
  CGMassageTableViewCell *cell = (CGMassageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGMassageTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGMessageEntity *entity;
  if (!self.isSearchKeyWord) {
    entity = self.dataSource[indexPath.row];
  }else {
    entity = self.searchDataSource[indexPath.row];
  }
  [cell update:entity];
  return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGMessageEntity *entity;
  if (!self.isSearchKeyWord) {
    entity = self.dataSource[indexPath.row];
  }else {
    entity = self.searchDataSource[indexPath.row];
  }
  entity.count = 0;
  [self.tableView reloadData];
  CGMessageDetailViewController *vc = [[CGMessageDetailViewController alloc]init];
  vc.title = entity.name;
  vc.type = entity.type;
  vc.ID = entity.messageID;
  [self.navigationController pushViewController:vc animated:YES];
}
@end
