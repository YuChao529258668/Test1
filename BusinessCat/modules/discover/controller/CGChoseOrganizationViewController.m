//
//  CGChoseOrganizationViewController.m
//  CGSays
//
//  Created by zhu on 2017/4/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChoseOrganizationViewController.h"
#import "CGUserCompanySearchTableViewCell.h"
#import "CGDiscoverBiz.h"

@interface CGChoseOrganizationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGDiscoverBiz *biz;

@end

@implementation CGChoseOrganizationViewController

-(instancetype)initWithBlock:(CGChoseOrganizationSureBlock)sure{
  self = [super init];
  if(self){
    success = sure;
  }
  return self;
}

-(NSMutableArray *)dataArray{
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
  }
  return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"选择组织";
  if (self.type) {
    for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (companyEntity.auditStete == 1&&companyEntity.companyType == 4) {
        [self.dataArray addObject:companyEntity];
      }
    }
  }else{
    for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (companyEntity.auditStete == 1&&companyEntity.companyType !=4) {
        [self.dataArray addObject:companyEntity];
      }
    }
  }
  self.tableView.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString*identifier = @"CGUserCompanySearchTableViewCell";
  CGUserCompanySearchTableViewCell *cell = (CGUserCompanySearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanySearchTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  CGUserOrganizaJoinEntity *companyEntity = self.dataArray[indexPath.row];
  cell.titleLabel.text = companyEntity.companyName;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGUserOrganizaJoinEntity *companyEntity = self.dataArray[indexPath.row];
  success(companyEntity,indexPath.row);
  [self.navigationController popViewControllerAnimated:YES];
}
@end
