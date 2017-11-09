//
//  CGUserHelpViewController.m
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserHelpViewController.h"
#import "CGUserCenterBiz.h"
#import "CGHelpCateTableViewCell.h"
#import "CGUserHelpCateEntity.h"
#import "CGUserHelpCateViewController.h"
#import "CGCompanyDao.h"
#import "CGTutorialViewController.h"
#import "CGFeedbackViewController.h"

@interface CGUserHelpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) NSMutableArray *directoryFristArray;
@end

@implementation CGUserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"帮助";
  self.biz = [[CGUserCenterBiz alloc]init];
  self.dataArray = [CGCompanyDao getHelpListStatisticsFromLocal];
  [self.tableView reloadData];
  self.tableView.tableFooterView = [[UIView alloc]init];
  __weak typeof(self) weakSelf = self;
  [self.biz authUserHelpCateSuccess:^(NSMutableArray *reslut) {
    weakSelf.dataArray = reslut;
    [CGCompanyDao saveHelpListStatistics:reslut];
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
  }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString*identifier = @"CGHelpCateTableViewCell";
  CGHelpCateTableViewCell *cell = (CGHelpCateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGHelpCateTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGUserHelpCateEntity *entity = self.dataArray[indexPath.row];
  cell.title.text = entity.cateTitle;
  [cell.icon sd_setImageWithURL:[NSURL URLWithString:entity.cateIcon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
  cell.icon.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.cateColor];
  return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGUserHelpCateEntity *entity = self.dataArray[indexPath.row];
  CGUserHelpCateViewController *vc = [[CGUserHelpCateViewController alloc]init];
  vc.cateId = entity.cateId;
  vc.title = entity.cateTitle;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)quickTutorialAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.biz.component startBlockAnimation];
    [self.biz authUserHelpCateListWithID:@"9f8209ca-827d-3a3a-da72-f51a1e4eddde" success:^(NSMutableArray *reslut) {
      weakSelf.directoryFristArray = reslut;
      [weakSelf.biz authUserHelpCateListWithID:@"ec3b8780-81f7-02a0-6df0-4793c6651e7c" success:^(NSMutableArray *reslut) {
        [weakSelf.biz.component stopBlockAnimation];
        CGTutorialViewController *vc = [[CGTutorialViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.directoryFristArray = weakSelf.directoryFristArray;
        vc.directorySecondArray = reslut;
        [weakSelf presentViewController:vc animated:YES completion:nil];
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
      }];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
}
@end
