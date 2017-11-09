//
//  CGAttentionMyGroupViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionMyGroupViewController.h"
#import "AttentionMyGroupTableViewCell.h"
#import "AttentionBiz.h"
#import "AttentionMyGroupEntity.h"
#import "CGMainLoginViewController.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"
#import "CGUserDao.h"
#import "CGAttentionCompetitorsViewController.h"
#import "MonitoringDao.h"

@interface CGAttentionMyGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) NSIndexPath *changeIndexPath;
@property (nonatomic, copy) CGAttentionMyGroupViewBlock cancel;
@end

@implementation CGAttentionMyGroupViewController

-(instancetype)initWithBlock:(CGAttentionMyGroupViewBlock)cancel{
  self = [super init];
  if(self){
    self.cancel = cancel;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.titleText;
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setTitle:@"新建" forState:UIControlStateNormal];
  self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.navi addSubview:self.rightBtn];
  self.tableView.separatorStyle = NO;
  self.biz = [[AttentionBiz alloc]init];
  [self getData];
  //关注回调
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProductSuccess) name:NOTIFICATION_ATTENTION object:nil];
}

-(void)updateProductSuccess{
  [self getData];
}

-(void)baseBackAction{
  BOOL isNoNewNum = NO;
  for (AttentionMyGroupEntity *entity in self.dataArray) {
    if (entity.newNum>0) {
      isNoNewNum = YES;
      break;
    }
  }
  if (!isNoNewNum) {
   self.cancel(YES);
  }
  [self.navigationController popViewControllerAnimated:YES];
  
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  [MonitoringDao queryGroupListFromDBWithGroupID:self.groupID success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    [weakSelf.tableView reloadData];
    [weakSelf.biz radarGroupListWithID:weakSelf.groupID type:weakSelf.type success:^(NSMutableArray *result) {
      weakSelf.dataArray = result;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      
    }];
  } fail:^(NSError *error) {
    [weakSelf.biz radarGroupListWithID:weakSelf.groupID type:weakSelf.type success:^(NSMutableArray *result) {
      weakSelf.dataArray = result;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      
    }];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)rightBtnAction{
  if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
    [self login];
    return;
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建分组" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
  alert.tag = 1000;
  UITextField *txtName = [alert textFieldAtIndex:0];
  txtName.placeholder = @"1-16个字符";
  [alert show];
}

#pragma UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if (section == 0) {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = CTCommonViewControllerBg;
    return view;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section == 0) {
    return 20;
  }
  return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"AttentionMyGroupTableViewCell";
    AttentionMyGroupTableViewCell *cell = (AttentionMyGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AttentionMyGroupTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
  AttentionMyGroupEntity *entity = [self.dataArray objectAtIndex:indexPath.row];
  [cell update:entity];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  AttentionMyGroupEntity *entity = [self.dataArray objectAtIndex:indexPath.row];
  if (entity.isCanDel) {
    return YES;
  }
  return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
  __weak typeof(self) weakSelf = self;
  UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
      [weakSelf login];
      return;
    }
    
    AttentionMyGroupEntity *entity = [weakSelf.dataArray objectAtIndex:indexPath.row];
    [weakSelf.biz authRadarGroupDeleteWithID:entity.groupID success:^{
      [MonitoringDao deleteGroupList:entity];
    } fail:^(NSError *error) {
      
    }];
    [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }];
  
  UITableViewRowAction *changeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
      [weakSelf login];
      return;
    }
    
    weakSelf.changeIndexPath = indexPath;
    [weakSelf changeTitle];
  }];
  return @[deleteRowAction,changeRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  AttentionMyGroupEntity *entity = [self.dataArray objectAtIndex:indexPath.row];
  CGAttentionCompetitorsViewController *vc = [[CGAttentionCompetitorsViewController alloc]init];
  vc.titleText = entity.title;
  vc.attentionID = entity.groupID;
  vc.type = 9;
  [self.navigationController pushViewController:vc animated:YES];
  entity.newNum = 0;
  [MonitoringDao updateGroupList:entity];
  [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(alertView.tag == 1000){
    if (buttonIndex == 1) {
      UITextField *text = [alertView textFieldAtIndex:0];
      if (text.text.length<=0) {
        [[CTToast makeText:@"组名不能为空！"]show:[UIApplication sharedApplication].keyWindow];
        return;
      }
      [self.rightBtn setUserInteractionEnabled:NO];
      __weak typeof(self) weakSelf = self;
      [self.biz.component startBlockAnimation];
      [self.biz authRadarGroupCreateWithID:self.groupID type:self.type title:text.text success:^(NSString *groupID) {
        AttentionMyGroupEntity *entity = [[AttentionMyGroupEntity alloc]init];
        entity.groupID = groupID;
        entity.title = text.text;
        [weakSelf.dataArray addObject:entity];
        [weakSelf.tableView reloadData];
        [self.biz.component stopBlockAnimation];
        [self.rightBtn setUserInteractionEnabled:YES];
      } fail:^(NSError *error) {
        [self.biz.component stopBlockAnimation];
        [self.rightBtn setUserInteractionEnabled:YES];
      }];
    }
  }else if (alertView.tag == 1001){
    if (buttonIndex == 1) {
      UITextField *text = [alertView textFieldAtIndex:0];
      if (text.text.length<=0) {
        [[CTToast makeText:@"组名不能为空！"]show:[UIApplication sharedApplication].keyWindow];
        return;
      }
      AttentionMyGroupEntity *entity = [self.dataArray objectAtIndex:self.changeIndexPath.row];
      entity.title = text.text;
      [self.tableView reloadRowsAtIndexPaths:@[self.changeIndexPath]withRowAnimation:UITableViewRowAnimationNone];
      [self.biz authRadarGroupUpdateWithID:entity.groupID title:text.text success:^{
        
      } fail:^(NSError *error) {
        
      }];
    }
  }
}

-(void)changeTitle{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改组名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
  alert.tag = 1001;
  UITextField *txtName = [alert textFieldAtIndex:0];
  txtName.placeholder = @"1-16个字符";
  [alert show];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)login{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
//  [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}
@end
