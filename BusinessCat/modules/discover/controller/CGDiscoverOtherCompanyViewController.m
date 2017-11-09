//
//  CGDiscoverOtherCompanyViewController.m
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverOtherCompanyViewController.h"
#import "CGUserCompanySearchTableViewCell.h"
#import "HCSortString.h"
#import "CGUserCenterBiz.h"
#import <MJRefresh.h>
#import "CGUserCompanySearchNullTableViewCell.h"
#import "CGUserCreateGroupViewController.h"
#import <UIImageView+WebCache.h>
#import "SelectCompanyView.h"
#import "HeadlineBiz.h"
#import "SearchHistoricalTableViewCell.h"
#import "CGSearchVoiceView.h"

@interface CGDiscoverOtherCompanyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) UIButton *cellSelectBtn;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSMutableArray *cancelArray;
@property (nonatomic, strong) SelectCompanyView *selectCompanyView;
@property (nonatomic, strong) NSMutableArray *keyWordArray;
@property (nonatomic, assign) BOOL isSearchKeyWord;
@property (nonatomic, strong) CGSearchVoiceView *searchView;
@end

@implementation CGDiscoverOtherCompanyViewController

-(instancetype)initWithBlock:(CGOtherCompanySureBlock)sure{
  self = [super init];
  if(self){
    success = sure;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"其他公司";
  self.selectIndexPath = nil;
  self.cellSelectBtn = nil;
  self.isSearchKeyWord = YES;
  self.keyWord = @"";
  self.page = 1;
  __weak typeof(self) weakSelf = self;
  self.searchView = [[CGSearchVoiceView alloc]initWithPlaceholder:@"请输入名称" voiceBlock:^(NSString *content) {
          weakSelf.isSearchKeyWord = YES;
          HeadlineBiz *biz = [[HeadlineBiz alloc]init];
          [biz jpSearchWithKeyword:content success:^(NSMutableArray *result) {
            weakSelf.keyWordArray = result;
            [weakSelf.tableView reloadData];
          } fail:^(NSError *error) {
            
          }];
  } changeText:^(NSString *content) {
      weakSelf.isSearchKeyWord = YES;
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      [biz jpSearchWithKeyword:content success:^(NSMutableArray *result) {
        weakSelf.keyWordArray = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        
      }];
  }];
  self.searchView.textField.delegate = self;
  [self.tableView setTableHeaderView:self.searchView];
  self.tableView.sectionIndexColor = [UIColor blackColor];
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  [self getUserInfoWithKeyWord:self.keyWord];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField.returnKeyType==UIReturnKeySearch)
  {
    self.isSearchKeyWord = NO;
    [self getUserInfoWithKeyWord:textField.text];
    [self.searchView.textField resignFirstResponder];
  }
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  self.isSearchKeyWord = YES;
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfoWithKeyWord:(NSString *)keyWord{
    if(!keyWord || keyWord.length <= 0)return;
  __weak typeof(self) weakSelf = self;
  self.page = 1;
  self.tableView.mj_footer.state = MJRefreshStateIdle;
  CGUserCenterBiz *userMassageBiz = [[CGUserCenterBiz alloc]init];
    [userMassageBiz.component startBlockAnimation];
  [userMassageBiz userCompanySearchWithkeyword:keyWord type:[NSNumber numberWithInt:1] success:^(NSMutableArray *result) {
    __strong typeof(weakSelf) swself = weakSelf;
    swself.dataArray = result;
    [swself.tableView reloadData];
      [userMassageBiz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [userMassageBiz.component stopBlockAnimation];
  }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  [self.searchView.textField resignFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isSearchKeyWord) {
    return self.keyWordArray.count;
  }
   return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isSearchKeyWord ) {
    return 50;
  }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isSearchKeyWord) {
    NSString*identifier = @"SearchHistoricalTableViewCell";
    SearchHistoricalTableViewCell *cell = (SearchHistoricalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchHistoricalTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.keyWordArray[indexPath.row];
    return cell;
  }else{
    static NSString*identifier = @"CGUserCompanySearchTableViewCell";
    CGUserCompanySearchTableViewCell *cell = (CGUserCompanySearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanySearchTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGUserSearchCompanyEntity *entity = self.dataArray[indexPath.row];
    cell.titleLabel.text = entity.name;
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isSearchKeyWord) {
    self.searchView.textField.text = self.keyWordArray[indexPath.row];
    self.isSearchKeyWord = NO;
    [self getUserInfoWithKeyWord:self.keyWordArray[indexPath.row]];
    [self.searchView.textField resignFirstResponder];
    [self.tableView reloadData];
  }else{
    CGUserSearchCompanyEntity *entity = self.dataArray[indexPath.row];
    success(entity);
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
