//
//  CGUserHelpCateViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserHelpCateViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserHelpCateListEntity.h"
#import "CGUserHelpCatePageViewController.h"
#import "DiscoverDao.h"

@interface CGUserHelpCateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserHelpCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.tableView.tableFooterView = [[UIView alloc]init];
  __weak typeof(self) weakSelf = self;
  [DiscoverDao queryHelpCateListFromDBWithcateID:self.cateId success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    [weakSelf.tableView reloadData];
    [weakSelf getData];
  } fail:^(NSError *error) {
    [weakSelf getData];
  }];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  [self.biz authUserHelpCateListWithID:self.cateId success:^(NSMutableArray *reslut) {
    weakSelf.dataArray = reslut;
    [DiscoverDao saveHelpCateListToDB:reslut cateID:weakSelf.cateId];
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//  view.backgroundColor = CTCommonViewControllerBg;
//  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
//  label.font = [UIFont systemFontOfSize:15];
//  label.textColor = [UIColor darkGrayColor];
//  label.text = @"常见问题和全部帮助 过滤";
//  [view addSubview:label];
//  return view;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//  return 50;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *identifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(!cell){
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  CGUserHelpCateListEntity *entity = self.dataArray[indexPath.row];
  cell.textLabel.text = entity.title;
  
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGUserHelpCateListEntity *entity = self.dataArray[indexPath.row];
  CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
  vc.pageId = entity.pageId;
  vc.title = entity.title;
  [self.navigationController pushViewController:vc animated:YES];
}
@end
