//
//  CGUserCreateGroupChooseViewController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCreateGroupChooseViewController.h"
#import "CGUserCenterBiz.h"

@interface CGUserCreateGroupChooseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *scaleArray;
@property (nonatomic, strong) NSMutableArray *industryArray;
@end

@implementation CGUserCreateGroupChooseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
  self.title = @"创建组织";
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.scaleArray = @[@"59人及以下",@"50~99人",@"100~499人",@"500~999人",@"1000~4999人",@"5000~9999人",@"10000人及以上"];
  if (self.state == CreatGroupIndustryStatus) {
    self.title = @"选择行业";
    CGUserCenterBiz *userMassageBiz = [[CGUserCenterBiz alloc]init];
    [userMassageBiz commonTagsListWith:1 success:^(NSMutableArray *reslut) {
      weakSelf.industryArray = reslut;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      
    }];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedButtonIndex:(industryListBackClickBlock)industryListblock tagsBlock:(tagsBackClickBlock)tagsBlock{
  self.industryBlock = industryListblock;
  self.tagsBlock = tagsBlock;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  switch (self.state) {
    case 1:
      return self.industryArray.count;
      break;
    case 2:
      return self.scaleArray.count;
      break;
      
    default:
      break;
  }
  return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (self.state) {
    case 1:{
      CGTagsEntity *entity = [self.industryArray objectAtIndex:indexPath.row];
      self.tagsBlock(entity);
    }
      break;
    case 2:
    {
      CGUserIndustryListEntity *entity = [CGUserIndustryListEntity new];
      entity.name = [self.scaleArray objectAtIndex:indexPath.row];
      entity.industryID = [NSString stringWithFormat:@"%ld",indexPath.row+1];
      self.industryBlock(entity);
    }
      break;
      
    default:
      break;
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString * showUserInfoCellIdentifier = @"cell";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
  if (cell == nil)
  {
    // Create a cell to display an ingredient.
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:showUserInfoCellIdentifier];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont systemFontOfSize:15];
  NSString *text;
  switch (self.state) {
    case 1:{
      CGTagsEntity *entity = [self.industryArray objectAtIndex:indexPath.row];
      text = entity.name;
    }
      break;
    case 2:
      text =  [self.scaleArray objectAtIndex:indexPath.row];
      break;
      
    default:
      break;
  }
  cell.textLabel.text = text;
  return cell;
}

@end
