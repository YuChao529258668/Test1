//
//  CGChooseFocusKnowledgeViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChooseFocusKnowledgeViewController.h"
#import "CGHorrolView.h"
#import "CGCompanyDao.h"
#import "CGChooseFocusKnowledgeTableViewCell.h"
#import "CGNoIdentityTableViewCell.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGMainLoginViewController.h"
#import "CGBuyVIPViewController.h"
#import "AttentionBiz.h"
#import "AppDelegate.h"
#import "CGChooseFocusKnowledgeTableViewCell.h"
#import "CGOrganizationEntity.h"

@interface CGChooseFocusKnowledgeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int selectIndex;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) HeadlineBiz *headlineBiz;
@property (nonatomic, copy) CGChooseFocusKnowledgeBlock block;
@property (nonatomic, copy) CGSelectFocusKnowledgeBlock selectBlock;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger isCategory;
@end

@implementation CGChooseFocusKnowledgeViewController

-(NSMutableArray *)selectArray{
  if (!_selectArray) {
    _selectArray = [NSMutableArray array];
  }
  return _selectArray;
}

-(instancetype)initWithBlock:(CGSelectFocusKnowledgeBlock)selectBlock{
  self = [super init];
  if(self){
    self.title = @"所属分类";
    self.isSelect = YES;
    self.isCategory = YES;
    self.selectBlock = selectBlock;
  }
  return self;
}

-(instancetype)initWithArray:(NSMutableArray *)array block:(CGChooseFocusKnowledgeBlock)block{
  self = [super init];
  if(self){
    self.title = @"选择关心的知识";
    self.block = block;
    for (CGknowledgeEntity *entity in array) {
      NavsEntity *navs = [[NavsEntity alloc]init];
      navs.name = entity.cateName;
      navs.navsID = entity.cateId;
      navs.isSelect = YES;
      [self.selectArray addObject:navs];
    }
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.selectIndex = 0;
  self.headlineBiz = [[HeadlineBiz alloc]init];
  if (!self.isCategory) {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navi addSubview:rightBtn];
  }
  self.dataArray = [ObjectShareTool sharedInstance].knowledgeBigTypeData;
  [self getTypeArray];
  [self.tableView reloadData];
  //购买会员成功回调
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bugVipSuccess) name:NOTIFICATION_BUYMEMBER object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)bugVipSuccess{
  [self getNavTypeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTypeArray{
  self.typeArray = [NSMutableArray array];
  for (KnowledgeBaseEntity *entity in self.dataArray) {
    CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:entity.categoryID rolName:entity.name sort:0];
    [self.typeArray addObject:entity1];
  }
  self.bigTypeScrollView.array = [NSMutableArray array];
  [self.topView addSubview:self.bigTypeScrollView];
  [self.bigTypeScrollView setSelectIndex:self.selectIndex];
}

-(void)rightBtnAction{
  NSMutableArray *array = [NSMutableArray array];
  for (NavsEntity *navs in self.selectArray) {
    CGknowledgeEntity *entity = [[CGknowledgeEntity alloc]init];
    entity.cateName = navs.name;
    entity.cateId = navs.navsID;
    [array addObject:entity];
  }
  self.block(array);
  [self.navigationController popViewControllerAnimated:YES];
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      weakSelf.selectIndex = index;
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

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
  if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
    return 1;
  }
  return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
  if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
    return SCREEN_HEIGHT-64-40-44;
  }
  if (indexPath.row == 0) {
    return 50;
  }
  KnowledgeBaseEntity *entity = self.dataArray[self.selectIndex];
  ListEntity *listEntity = entity.list[indexPath.section];
  return [CGChooseFocusKnowledgeTableViewCell height:listEntity.list];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if(self.dataArray && self.dataArray.count > 0){
    KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
    if (knowledgeBaseentity.state == 2||knowledgeBaseentity.viewPermit != 0) {
      return 1;
    }
    KnowledgeBaseEntity *entity = self.dataArray[self.selectIndex];
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
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
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
    static NSString*productIdentifier = @"CGChooseFocusKnowledgeTableViewCell";
    CGChooseFocusKnowledgeTableViewCell *cell = (CGChooseFocusKnowledgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGChooseFocusKnowledgeTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle
    = UITableViewCellSelectionStyleNone;
    if (self.isSelect) {
      __weak typeof(self) weakSelf = self;
      [cell update:listEntity.list block:^(NavsEntity *navsEntity) {
        weakSelf.selectBlock(knowledgeBaseentity, navsEntity);
        [weakSelf.navigationController popViewControllerAnimated:YES];
      }];
    }else{
     [cell update:listEntity.list selectArray:self.selectArray];
    }
    return cell;
  }
  //  }
  return nil;
}

-(void)viewPermit{
  KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
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
    NSString *message = [NSString stringWithFormat:@"是否确定支付%ld金币查看内容",knowledgeBaseentity.integral];
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
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf getNavTypeData];
  } fail:^(NSError *error) {
    
  }];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == 1001) {
    if (buttonIndex == 1) {
      KnowledgeBaseEntity *knowledgeBaseentity = self.dataArray[self.selectIndex];
      if ([ObjectShareTool sharedInstance].currentUser.integralNum<knowledgeBaseentity.integral) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"金币不够提示"
                                                        message:@"你可以通过以下两个方式增加金币：\n1）按金币奖励规则完成任务获得金币\n2）在线支付充值金币"
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

-(void)loadNavTypeFinish{
  self.dataArray = [ObjectShareTool sharedInstance].knowledgeBigTypeData;
  [self.tableView reloadData];
  [self getTypeArray];
}
@end
