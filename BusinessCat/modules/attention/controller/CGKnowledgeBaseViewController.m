//
//  CGKnowledgeBaseViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBaseViewController.h"
#import "CGKnowledgeBaseTableTopViewCell.h"
#import "CGKnowledgeBaseTableViewCell.h"
#import "KnowledgeBaseEntity.h"
#import "AttentionBiz.h"
#import "CGKnowledgeBaseDetailViewController.h"
#import "MonitoringDao.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGCompanyDao.h"
#import "CTKnowledgeMealViewController.h"
#import "CGHeadlineGlobalSearchCommonDetailViewController.h"
#import "CGHorrolView.h"
#import "CGSortView.h"
#import "HeadlineBiz.h"
#import "CGNoIdentityTableViewCell.h"
#import "CGMainLoginViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGBuyVIPViewController.h"
#import "AppDelegate.h"

@interface CGKnowledgeBaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, assign) BOOL isDetailClick; //点击详情响应判断
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) CGSortView *pushView;
@property (nonatomic, strong) HeadlineBiz *headlineBiz;
@property (nonatomic, strong) KnowledgeBaseEntity *selectNavType;
@end

@implementation CGKnowledgeBaseViewController

//加载完成分类回调，为了避免今日知识和岗位知识的分类的公用处理
-(void)loadNavTypeFinish{
    self.dataArray = [ObjectShareTool sharedInstance].knowledgeBigTypeData;
    [self.tableView reloadData];
    [self getTypeArray];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"岗位知识";
  self.isDetailClick = YES;
  [self hideCustomBackBtn];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.headlineBiz = [[HeadlineBiz alloc]init];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setImage:[UIImage imageNamed:@"common_search_white_icon"] forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
    self.dataArray = [ObjectShareTool sharedInstance].knowledgeBigTypeData;
  [self getTypeArray];
  [self.tableView reloadData];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knowledgeChange:) name:NOTIFICATION_JOBKNOWLEDGE object:nil];
  //购买会员成功回调
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bugVipSuccess) name:NOTIFICATION_BUYMEMBER object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOutAction) name:NOTIFICATION_LOGOUT object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAction) name:NOTIFICATION_LOGINSUCCESS object:nil];
}

-(void)bugVipSuccess{
  [self getNavTypeData];
}

-(void)logOutAction{
  [self getNavTypeData];
}

-(void)loginAction{
  [self getNavTypeData];
}

//收到推送处理
-(void)getPushDealWithRecordId:(NSString *)recordId{
  for (int i = 0; i<[ObjectShareTool sharedInstance].knowledgeBigTypeData.count; i++) {
    KnowledgeBaseEntity *bigtype = [ObjectShareTool sharedInstance].knowledgeBigTypeData[i];
    if ([bigtype.navType isEqualToString:recordId]) {
      self.selectNavType = bigtype;
      [self.bigTypeScrollView setSelectIndex:i];
      [self.tableView reloadData];
      break;
    }
  }
}

-(int)getSelectIndex{
  int seletIndex = 0;
  for (int i=0; i<self.dataArray.count; i++) {
    KnowledgeBaseEntity *entity = self.dataArray[i];
    if ([entity.navType isEqualToString:self.selectNavType.navType]) {
      seletIndex = i;
      break;
    }
  }
  return seletIndex;
}

-(void)getTypeArray{
  self.typeArray = [NSMutableArray array];
  for (KnowledgeBaseEntity *entity in self.dataArray) {
    CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:entity.categoryID rolName:entity.name sort:0];
    [self.typeArray addObject:entity1];
  }
  self.bigTypeScrollView.array = [NSMutableArray array];
  [self.topView addSubview:self.bigTypeScrollView];
  [self.bigTypeScrollView setSelectIndex:[self getSelectIndex]];
}

-(void)rightBtnAction{
  KnowledgeBaseEntity *entity = self.dataArray[[self getSelectIndex]];
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 1;
  vc.infoAction = 2;
  vc.level = 1;
  vc.typeID = entity.navType;
  [self.navigationController pushViewController:vc animated:YES];
  
}

-(void)knowledgeChange:(NSNotification*) notification{
  NSArray *array =  [notification object];
  self.dataArray =  array[0];
  self.selectNavType = self.dataArray[[array[1] intValue]];
  [self getTypeArray];
  [self.tableView reloadData];
  [CGCompanyDao saveJobKnowledgeStatistics:self.dataArray];
  NSMutableArray *dictArray = [NSMutableArray array];
  for(int i=0;i<self.dataArray.count;i++){
    KnowledgeBaseEntity *entity = self.dataArray[i];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:entity.navType,@"typeId",entity.name,@"typeName", nil];
    [dictArray addObject:dict];
  }
  [self.headlineBiz updateHeadlineBigtypeSortWithArray:dictArray success:^{
  } fail:^(NSError *error) {
  }];
  
}

- (IBAction)sortClick:(UIButton *)sender {
  self.pushView = [[CGSortView alloc]initWithArray:self.dataArray];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      weakSelf.selectNavType = weakSelf.dataArray[index];
      [weakSelf.tableView reloadData];
    }];
  }
  return _bigTypeScrollView;
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{

}

//获取token回调 state:YES-成功 NO-失败
-(void)tokenCheckComplete:(BOOL)state{
  if (state) {
    
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.isDetailClick = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  self.isDetailClick = YES;
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
  if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
    return 1;
  }
  return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
  if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
    return SCREEN_HEIGHT-64-40-44;
  }
  if (indexPath.row == 0) {
    return 50;
  }
  KnowledgeBaseEntity *entity = self.dataArray[[self getSelectIndex]];
  ListEntity *listEntity = entity.list[indexPath.section];
  return [CGKnowledgeBaseTableViewCell height:listEntity.list];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.dataArray && self.dataArray.count > 0){
      KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
      if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
        return 1;
      }
        KnowledgeBaseEntity *entity = self.dataArray[[self getSelectIndex]];
        return entity.list.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section > 0) {
    return 15;
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  __weak typeof(self) weakSelf = self;
    KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
  if (knowledgeBaseentity.state == 2 ||knowledgeBaseentity.viewPermit != 0) {
    static NSString*productIdentifier = @"CGNoIdentityTableViewCell";
    CGNoIdentityTableViewCell *cell = (CGNoIdentityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGNoIdentityTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (knowledgeBaseentity.viewPermit != 2) {
     [cell update:knowledgeBaseentity];
    }
    [cell.button addTarget:self action:@selector(viewPermit) forControlEvents:UIControlEventTouchUpInside];
    return cell;
  }
    ListEntity *listEntity = knowledgeBaseentity.list[indexPath.section];
    if (indexPath.row == 0) {
      NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
      if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.clipsToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.text = listEntity.name;
      return cell;
    }else{
      static NSString*productIdentifier = @"CGKnowledgeBaseTableViewCell";
      CGKnowledgeBaseTableViewCell *cell = (CGKnowledgeBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKnowledgeBaseTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle
      = UITableViewCellSelectionStyleNone;
      [cell update:listEntity.list block:^(NavsEntity *entity,NSInteger index) {
        if (weakSelf.isDetailClick) {
          CGKnowledgeBaseDetailViewController *vc = [[CGKnowledgeBaseDetailViewController alloc]init];
          vc.array = knowledgeBaseentity.list;
          vc.navTypeId = entity.navsID;
          vc.navName = entity.name;
          vc.bigTypeId = knowledgeBaseentity.navType;
          vc.bigName = knowledgeBaseentity.name;
          vc.catePage = entity.catePage;
          vc.index = indexPath.section;
          vc.title = entity.name;
          vc.secondaryIndex = index;
          [weakSelf.navigationController pushViewController:vc animated:YES];
        }
      }];
      return cell;
    }
//  }
  return nil;
}

-(void)viewPermit{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
  if (knowledgeBaseentity.viewPermit == -1||knowledgeBaseentity.viewPermit == 6) {
    [self clickToLoginAction];
  }else if (knowledgeBaseentity.viewPermit==1||knowledgeBaseentity.viewPermit == 7){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (knowledgeBaseentity.viewPermit==5){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (knowledgeBaseentity.viewPermit == 4||knowledgeBaseentity.viewPermit == 8){
    //初始化AlertView
    NSString *message = [NSString stringWithFormat:@"是否确定支付%ld知识币查看内容",knowledgeBaseentity.integral];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 1001;
    [alert show];
  }
}

//点击登录
-(void)clickToLoginAction{
//  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
//    [weakSelf getNavTypeData];
  } fail:^(NSError *error) {
    
  }];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == 1001) {
    if (buttonIndex == 1) {
      KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[[self getSelectIndex]];
      if ([ObjectShareTool sharedInstance].currentUser.integralNum<knowledgeBaseentity.integral) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"知识币不够提示"
                                                        message:@"你可以通过以下两个方式增加知识币：\n1）按知识币奖励规则完成任务获得知识币\n2）在线支付充值知识币"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"我要充值",nil];
        alert.tag = 1002;
        [alert show];
        return;
      }
      __weak typeof(self) weakSelf = self;
      [self.headlineBiz headlinesInfoDetailsIntegralPurchaseWithType:0 ID:knowledgeBaseentity.categoryID integral:knowledgeBaseentity.integral success:^{
        [weakSelf getNavTypeData];
      } fail:^(NSError *error) {
        
      }];
    }
  }else if (alertView.tag == 1002){
    if (buttonIndex ==1) {
      CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
      vc.type = 4;
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}

//获取分类数据
-(void)getNavTypeData{
  __weak typeof(self) weakSelf = self;
  [[[AttentionBiz alloc]init] headlinesSkillNavListSuccess:^(NSMutableArray *result) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf loadNavTypeFinish];
      AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
      [app.rootController.mealVC loadNavTypeFinish];
    });
  } fail:^(NSError *error) {
  }];
}
@end
