//
//  UserAuditCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "UserAuditCollectionViewCell.h"
#import "CGUserAuditTableViewCell.h"
#import "UserAuditNoDataTableViewCell.h"
#import "CGUserCenterBiz.h"

@interface UserAuditCollectionViewCell ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, assign) NSInteger page;
@end

@implementation UserAuditCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
   self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.biz = [[CGUserCenterBiz alloc]init];
//    self.tableView.bounces    = NO;
      // Initialization code
  //下拉刷新
//  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    __weak typeof(self) weakSelf = self;
//    [self.biz userCompanyAuditListWithType:self.type page:1 success:^(NSMutableArray *result) {
//      [weakSelf.tableView.mj_header endRefreshing];
//      weakSelf.page = 1;
//      __strong typeof(weakSelf) swself = weakSelf;
//      swself.dataArray = result;
//      [swself.tableView reloadData];
//    } fail:^(NSError *error) {
//      __strong typeof(weakSelf) swself = weakSelf;
//      [swself.tableView.mj_header endRefreshing];
//    }];
//  }];
//  
  //上拉加载更多
//  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//    __weak typeof(self) weakSelf = self;
//    [self.biz userCompanyAuditListWithType:weakSelf.type page:++weakSelf.page success:^(NSMutableArray *result) {
//      __strong typeof(weakSelf) swself = weakSelf;
//      [swself.dataArray addObjectsFromArray:result];
//      [swself.tableView.mj_footer endRefreshing];
//      [swself.tableView reloadData];
//    } fail:^(NSError *error) {
//      __strong typeof(weakSelf) swself = weakSelf;
//      [swself.tableView.mj_footer endRefreshing];
//    }];
//  }];
}

-(void)updateDataWithType:(NSInteger)type{
  self.page = 1;
  self.type = type;
  [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.count<=0) {
    return SCREEN_HEIGHT-64-44;
  }
  return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.dataArray.count<=0) {
    return 1;
  }
  return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (self.dataArray.count<=0) {
    static NSString*identifier1 = @"UserAuditNoDataTableViewCell";
    UserAuditNoDataTableViewCell *cell = (UserAuditNoDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserAuditNoDataTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (self.type) {
      case 0:
        cell.title.text = @"还没有待审核的申请";
        break;
      case 1:
        cell.title.text = @"还没有同意审核的申请";
        break;
      case 2:
        cell.title.text = @"还没有拒绝审核的申请";
        break;
      default:
        break;
    }
    return cell;
  }
  
  static NSString*identifier = @"CGUserAuditTableViewCell";
  CGUserAuditTableViewCell *cell = (CGUserAuditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAuditTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.tag = indexPath.row;
  CGUserCompanyAuditListEntity *entity = self.dataArray[indexPath.row];
  [cell.icon sd_setImageWithURL:[NSURL URLWithString:entity.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
  cell.nameLabel.text = entity.userName;
  cell.phoneLabel.text = entity.userMobile;
  if (self.type == 0) {
    [cell.button setTitle:@"审核" forState:UIControlStateNormal];
  }else if (self.type == 1){
    [cell.button setTitle:@"拒绝" forState:UIControlStateNormal];
  }else{
    [cell.button setTitle:@"同意" forState:UIControlStateNormal];
  }
  cell.timeLabel.text = [CTDateUtils getTimeFormatFromDateLong:entity.applyTime.integerValue];;
  cell.button.tag = indexPath.row;
  [cell.button addTarget:self action:@selector(auditClick:) forControlEvents:UIControlEventTouchUpInside];
  return cell;
}

- (void)auditClick:(UIButton *)sender{
  if (self.type == 0) {
    self.index = sender.tag;
    [self callActionSheetFunc];
  }else if (self.type == 1){
    self.index = sender.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 1000;
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入拒绝理由";
    [alert show];
  }else{
//    CGUserCompanyAuditListEntity *entity = self.dataArray[sender.tag];
//    __weak typeof(self) weakSelf = self;
    //同意
//    [self.biz userCompanyAuditWithUserID:entity.userId type:1 reason:@"" success:^{
//      __strong typeof(weakSelf) swself = weakSelf;
//      [swself.dataArray removeObjectAtIndex:swself.index];  //删除_data数组里的数据
//      [weakSelf.tableView reloadData];
////      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.index inSection:0];
////      [swself.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
//    } fail:^(NSError *error) {
//
//    }];
  }
}

- (void)callActionSheetFunc{
  self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"审核" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意", @"拒绝",nil];
  self.actionSheet.tag = 1000;
  [self.actionSheet showInView:self];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//  CGUserCompanyAuditListEntity *entity = self.dataArray[self.index];
//  __weak typeof(self) weakSelf = self;
  if (actionSheet.tag == 1000) {
      switch (buttonIndex) {
      case 0:
        {
        //同意
//          [self.biz userCompanyAuditWithUserID:entity.userId type:1 reason:@"" success:^{
//            __strong typeof(weakSelf) swself = weakSelf;
//            [swself.dataArray removeObjectAtIndex:swself.index];  //删除_data数组里的数据
//            [weakSelf.tableView reloadData];
//          } fail:^(NSError *error) {
//
//          }];
        }
        break;
      case 1:
        {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
          [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
          alert.tag = 1000;
          UITextField *txtName = [alert textFieldAtIndex:0];
          txtName.placeholder = @"请输入拒绝理由";
          [alert show];
        }
        //拒绝
        break;
      case 2:
        return;
    }
  }
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
      UITextField *text = [alertView textFieldAtIndex:0];
      if (text.text.length<=0) {
        [[CTToast makeText:@"拒绝理由不能为空！"]show:[UIApplication sharedApplication].keyWindow];
        return;
      }
    //拒绝
//    CGUserCompanyAuditListEntity *entity = self.dataArray[self.index];
//    __weak typeof(self) weakSelf = self;
//    [self.biz userCompanyAuditWithUserID:entity.userId type:2 reason:text.text success:^{
//      [weakSelf.dataArray removeObjectAtIndex:weakSelf.index];  //删除_data数组里的数据
////      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.index inSection:0];
////      [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
//      [weakSelf.tableView reloadData];
//    } fail:^(NSError *error) {
//
//    }];
  }
}
@end
