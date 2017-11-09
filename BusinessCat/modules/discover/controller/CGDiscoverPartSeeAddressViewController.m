//
//  CGDiscoverPartSeeAddressViewController.m
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverPartSeeAddressViewController.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "CGPartSeeAddressEntity.h"
#import "CGDiscoverPartSeeAddressTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "CGDiscoverBiz.h"
#import "CGSearchController.h"
#import "CGSearchVoiceView.h"

@interface CGDiscoverPartSeeAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (nonatomic, strong) NSMutableArray *cancelArray;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) CGSearchVoiceView *searchView;
@property (nonatomic, assign) BOOL isSearchKeyWord;
@end

@implementation CGDiscoverPartSeeAddressViewController

-(instancetype)initWithBlock:(CGPartSeeAddressSureBlock)sure{
  self = [super init];
  if(self){
    success = sure;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGDiscoverBiz alloc]init];
  self.dataSource = [NSMutableArray array];
  self.tableView.sectionIndexColor = [UIColor blackColor];
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  [self getdata];
  __weak typeof(self) weakSelf = self;
  self.searchView = [[CGSearchVoiceView alloc]initWithPlaceholder:@"请输入关键字" voiceBlock:^(NSString *content) {
        if([CTStringUtil stringNotBlank:content]){//word为语音识别结果
          weakSelf.isSearchKeyWord = YES;
          [weakSelf.searchDataSource removeAllObjects];
          NSArray *ary = [NSArray new];
          //对排序好的数据进行搜索
          ary = [HCSortString getAllValuesFromDict:weakSelf.allDataSource];
          ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:content andSearchByPropertyName:@"userName"];
          [weakSelf.searchDataSource addObjectsFromArray:ary];
          [weakSelf.tableView reloadData];
        }
  } changeText:^(NSString *content) {
      [weakSelf.searchDataSource removeAllObjects];
      NSArray *ary = [NSArray new];
      //对排序好的数据进行搜索
      ary = [HCSortString getAllValuesFromDict:weakSelf.allDataSource];
    
      if (content.length == 0) {
        [weakSelf.searchDataSource addObjectsFromArray:ary];
      }else {
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:content andSearchByPropertyName:@"userName"];
        [weakSelf.searchDataSource addObjectsFromArray:ary];
      }
      [weakSelf.tableView reloadData];
  }];
  self.searchView.textField.delegate = self;
  [self.tableView setTableHeaderView:self.searchView];
  self.cancelArray = [self.selectArray mutableCopy];
  [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld/50)",self.selectArray.count] forState:UIControlStateNormal];
  [self updateScrollView];
    
    self.sureBtn.backgroundColor = CTThemeMainColor;
}

- (void)getdata{
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz discoverSscoopMemberWithCompanyID:self.currentEntity.rolId companyType:self.currentEntity.rolType.integerValue success:^(NSMutableArray *result) {

    [weakSelf.biz.component stopBlockAnimation];
    weakSelf.dataSource = result;
    [weakSelf updateData];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
  }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  [self.searchView.textField resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:YES];
  [self.biz.component stopBlockAnimation];
}

-(void)baseBackAction{
  success(self.cancelArray,YES);
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - -------
- (void)updateData {
  self.allDataSource = [HCSortString sortAndGroupForArray:self.dataSource PropertyName:@"userName"];
  self.indexDataSource = [HCSortString sortForStringAry:[self.allDataSource allKeys]];
  self.searchDataSource = [NSMutableArray new];
  [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField.returnKeyType==UIReturnKeySearch)
  {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [NSArray new];
    //对排序好的数据进行搜索
    ary = [HCSortString getAllValuesFromDict:_allDataSource];
    ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:textField.text andSearchByPropertyName:@"userName"];
    [_searchDataSource addObjectsFromArray:ary];
    [self.tableView reloadData];
  }
  return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (!self.isSearchKeyWord) {
    return _indexDataSource.count;
  }else {
    return 1;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!self.isSearchKeyWord) {
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
    return value.count;
  }else {
    return _searchDataSource.count;
  }
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (!self.isSearchKeyWord) {
    return _indexDataSource[section];
  }else {
    return nil;
  }
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (!self.isSearchKeyWord) {
    return _indexDataSource;
  }else {
    return nil;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString*identifier = @"CGDiscoverPartSeeAddressTableViewCell";
  CGDiscoverPartSeeAddressTableViewCell *cell = (CGDiscoverPartSeeAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverPartSeeAddressTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGPartSeeAddressEntity *entity;
  if (!self.isSearchKeyWord) {
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
    entity = value[indexPath.row];
  }else{
    entity = _searchDataSource[indexPath.row];
  }
  cell.entity = entity;
  [cell.icon sd_setImageWithURL:[NSURL URLWithString:entity.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
  cell.nameLabel.text = entity.userName;
  for (CGPartSeeAddressEntity *select in self.selectArray) {
    if ([entity.userId isEqualToString:select.userId]) {
      cell.selectBtn.selected = YES;
    }
  }
  if (entity.position.length<=0&&entity.department.length<=0) {
    cell.detailLabel.text = @"";
  }else if (entity.position.length<=0){
    cell.detailLabel.text = entity.department;
  }else if (entity.department.length<=0){
    cell.detailLabel.text = entity.position;
  }else{
    cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",entity.position,entity.department];
  }
    __weak typeof(self) weakSelf = self;
  [cell didSelectedButtonIndex:^(UIButton *sender) {
    if (weakSelf.selectArray.count>=50) {
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      [[CTToast makeText:@"最多只能选择50家公司"]show:window];
      return;
    }
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if (cell.selectBtn.selected) {
      [weakSelf.selectArray insertObject:cell.entity atIndex:0];
    }else{
      for (CGPartSeeAddressEntity *select in weakSelf.selectArray) {
        if ([cell.entity.userId isEqualToString:select.userId]) {
          [weakSelf.selectArray removeObject:select];
          break;
        }
      }
    }
    [weakSelf updateScrollView];
    [weakSelf.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld/50)",weakSelf.selectArray.count] forState:UIControlStateNormal];
  }];
  return cell;
}

//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectArray.count>=50) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"最多只能选择50家公司"]show:window];
    return;
  }
  CGDiscoverPartSeeAddressTableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
  cell.selectBtn.selected = !cell.selectBtn.selected;
  if (cell.selectBtn.selected) {
      [self.selectArray insertObject:cell.entity atIndex:0];
  }else{
    for (CGPartSeeAddressEntity *select in self.selectArray) {
      if ([cell.entity.userId isEqualToString:select.userId]) {
        [self.selectArray removeObject:select];
        break;
      }
    }
  }
  [self updateScrollView];
  [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld/50)",self.selectArray.count] forState:UIControlStateNormal];
  
}

- (IBAction)sureClick:(UIButton *)sender {
  success(self.selectArray,NO);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateScrollView{
  for(UIView *view in [self.sv subviews])
  {
    [view removeFromSuperview];
  }
  for (int i = 0; i<self.selectArray.count; i++) {
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(15+i*45, 12.5f, 35, 35)];
    [self.sv addSubview:iv];
    CGPartSeeAddressEntity *entity = self.selectArray[i];
    [iv sd_setImageWithURL:[NSURL URLWithString:entity.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
  }
  self.sv.contentSize = CGSizeMake(15+self.selectArray.count*45, 0);
}

@end
