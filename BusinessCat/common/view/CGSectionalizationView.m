//
//  CGSectionalizationView.m
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSectionalizationView.h"
#import "CGCompanyDao.h"
#import "SectionalizationCell.h"
#import "AttentionMyGroupEntity.h"
#import "AttentionBiz.h"
#import "GroupJoinEntity.h"
#import "MonitoringDao.h"

@interface CGSectionalizationView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GroupJoinEntity *groupEntity;
@property (nonatomic, strong) AttentionBiz *biz;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;
@property (nonatomic, copy) CGSectionalizationViewBlock sectionBlock;
@property (nonatomic, strong) CGInfoHeadEntity *headEntity;
@end

@implementation CGSectionalizationView
-(instancetype)initWithBlock:(CGSectionalizationViewBlock)block
{
  self = [super init];
  self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  if (self) {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = NO;
    self.biz = [[AttentionBiz alloc]init];
    self.sectionBlock = block;
  }
  return self;
}

+ (instancetype)userHeaderView {
  return [[[NSBundle mainBundle] loadNibNamed:@"CGSectionalizationView"
                                        owner:nil
                                      options:nil] lastObject];
}

-(void)showWithEntity:(CGInfoHeadEntity *)entity{
  self.headEntity = entity;
    __weak typeof(self) weakSelf = self;
  [[UIApplication sharedApplication].keyWindow addSubview:self];
  [MonitoringDao queryGroupListFromDBWithGroupID:nil success:^(NSMutableArray *result) {
    GroupJoinEntity *entity1 = [[GroupJoinEntity alloc]init];
    entity1.isSubscribe = NO;
    entity1.list = [NSMutableArray array];
    for (AttentionMyGroupEntity *info in result) {
      JoinEntity *jEntity = [[JoinEntity alloc]init];
      jEntity.groupID = info.groupID;
      jEntity.title = info.title;
      jEntity.isJoin = NO;
      [entity1.list addObject:jEntity];
    }
    weakSelf.groupEntity = entity1;
    [weakSelf.tableView reloadData];
    [weakSelf.biz radarGroupJoinListID:entity.infoId type:entity.type success:^(GroupJoinEntity *result) {
      weakSelf.groupEntity = result;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz radarGroupJoinListID:entity.infoId type:entity.type success:^(GroupJoinEntity *result) {
        weakSelf.groupEntity = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        
      }];
    }];
  } fail:^(NSError *error) {
    [weakSelf.biz radarGroupJoinListID:entity.infoId type:entity.type success:^(GroupJoinEntity *result) {
      weakSelf.groupEntity = result;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.biz radarGroupJoinListID:entity.infoId type:entity.type success:^(GroupJoinEntity *result) {
        weakSelf.groupEntity = result;
        [weakSelf.tableView reloadData];
      } fail:^(NSError *error) {
        
      }];
    }];
  }];
}

- (IBAction)addGroupClick:(UIButton *)sender {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建分组" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
  alert.tag = 1000;
  UITextField *txtName = [alert textFieldAtIndex:0];
  txtName.placeholder = @"1-16个字符";
  [alert show];
}

- (IBAction)bottomClick:(UIButton *)sender {
  BOOL isMonitoring = NO;
  if (self.groupEntity.isSubscribe == YES) {
    isMonitoring = YES;
  }else{
    for (JoinEntity *entity in self.groupEntity.list) {
      if (entity.isJoin == YES) {
        isMonitoring = YES;
        break;
      }
    }
  }
  self.sectionBlock(isMonitoring);
  [self removeFromSuperview];
}

#pragma UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.groupEntity.list.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*productIdentifier = @"SectionalizationCell";
  SectionalizationCell *cell = (SectionalizationCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SectionalizationCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  if (indexPath.row == 0) {
    cell.titleLabel.text = @"监控列表";
    __weak typeof(self) weakSelf = self;
    [cell headInfo:self.headEntity isSubscribe:self.groupEntity.isSubscribe block:^(BOOL isSubscribe) {
      weakSelf.groupEntity.isSubscribe = isSubscribe;
    }];
  }else{
    JoinEntity *entity = self.groupEntity.list[indexPath.row-1];
    cell.titleLabel.text = entity.title;
    [cell groupInfo:entity headInfo:self.headEntity];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(alertView.tag == 1000){
    if (buttonIndex == 1) {
      UITextField *text = [alertView textFieldAtIndex:0];
      if (text.text.length<=0) {
        [[CTToast makeText:@"组名不能为空！"]show:[UIApplication sharedApplication].keyWindow];
        return;
      }
      [self.addGroupButton setUserInteractionEnabled:NO];
      __weak typeof(self) weakSelf = self;
      [self.biz.component startBlockAnimation];
      [self.biz authRadarGroupCreateWithID:nil type:1 title:text.text success:^(NSString *groupID) {
        JoinEntity *entity = [[JoinEntity alloc]init];
        entity.groupID = groupID;
        entity.title = text.text;
        entity.isJoin = NO;
        [weakSelf.groupEntity.list addObject:entity];
        [weakSelf.tableView reloadData];
        [self.biz.component stopBlockAnimation];
        [self.addGroupButton setUserInteractionEnabled:YES];
      } fail:^(NSError *error) {
        [self.biz.component stopBlockAnimation];
        [self.addGroupButton setUserInteractionEnabled:YES];
      }];
    }
  }
}
@end
