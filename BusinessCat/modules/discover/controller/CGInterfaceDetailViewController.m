//
//  CGInterfaceDetailViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceDetailViewController.h"
#import "CGHorrolView.h"
#import "CGInterfaceDetailCollectionViewCell.h"
#import "CGDiscoverBiz.h"
#import "CGDetailsPlatformEnitity.h"
#import "CGProductInterfaceViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGMainLoginViewController.h"
#import "HeadlineBiz.h"
#import "CGBuyVIPViewController.h"

@interface CGInterfaceDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionY;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *viewPromptLabel;
@property (nonatomic, strong) CGPermissionsEntity *permission;
@end

@implementation CGInterfaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"产品版本";
  self.biz = [[CGDiscoverBiz alloc]init];
  [self getData];
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.backgroundColor = CTThemeMainColor;
    // Do any additional setup after loading the view from its nib.
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  [self.biz productDetailsPlatformListWithID:self.productID success:^(NSMutableArray *result,CGPermissionsEntity *entity) {
    if (entity) {
      weakSelf.permission = entity;
      [weakSelf updateWith:entity];
    }else{
      weakSelf.bgView.hidden = YES;
      for (CGDetailsPlatformEnitity *entity in result) {
        CGHorrolEntity *horrolEntity = [[CGHorrolEntity alloc]initWithRolId:entity.platformId rolName:entity.platformName sort:0];
        if ([entity.platformId isEqualToString:@"P2973"]||[entity.platformId isEqualToString:@"P2784"]||[entity.platformId isEqualToString:@"P3498"]||[entity.platformId isEqualToString:@"P4948"]||[entity.platformId isEqualToString:@"P8492"]||[entity.platformId isEqualToString:@"P7484"]||[entity.platformId isEqualToString:@"P2819"]) {
          horrolEntity.action = 1;
        }else if ([entity.platformId isEqualToString:@"P9402"]){
          horrolEntity.action = 2;
        }else if ([entity.platformId isEqualToString:@"P2888"]){
          horrolEntity.action = 3;
        }else if ([entity.platformId isEqualToString:@"P3312"]){
          horrolEntity.action = 4;
        }
        [weakSelf.typeArray addObject:horrolEntity];
      }
      if (result.count<2) {
        weakSelf.collectionY.constant = 64;
      }else{
        [weakSelf.view addSubview:weakSelf.bigTypeScrollView];
      }
      [weakSelf.collectionView reloadData];
    }
  } fail:^(NSError *error) {
    
  }];
}

-(void)updateWith:(CGPermissionsEntity *)entity{
  self.bgView.hidden = NO;
  if (entity.viewPermit == -1) {
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = NO;
    [self.button setTitle:@"登录" forState:UIControlStateNormal];
  }else if (entity.viewPermit==2||entity.viewPermit==3) {
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = YES;
  }else if (entity.viewPermit==1||entity.viewPermit==5){
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = NO;
    [self.button setTitle:entity.viewPermit==1?@"我要升级":@"我要成为VIP企业" forState:UIControlStateNormal];
    if (entity.viewPermit == 5 &&[ObjectShareTool sharedInstance].currentUser.companyList.count!=1) {
      self.button.hidden = YES;
      self.viewPromptLabel.text = @"你无权限阅读";
    }
  }else if (entity.viewPermit==4){
      NSString *integral = [NSString stringWithFormat:@"%ld",entity.integral];
      NSString *str = [NSString stringWithFormat:@"需支付%ld金币才能查看",entity.integral];
      NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
      [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
      [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [str length])];
      [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, integral.length+3)];
      
      self.viewPromptLabel.attributedText = attributedString;
      self.button.hidden = NO;
      [self.button setTitle:@"付费" forState:UIControlStateNormal];
  }
}

- (IBAction)permissionClick:(UIButton *)sender {
  if (self.permission.viewPermit == -1) {
    [self clickToLoginAction];
  }else if (self.permission.viewPermit==1){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (self.permission.viewPermit==5){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (self.permission.viewPermit == 4||self.permission.viewPermit == 8){
    //初始化AlertView
    NSString *message = [NSString stringWithFormat:@"是否确定支付%ld金币查看内容",self.permission.integral];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 1001;
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == 1001) {
    if (buttonIndex == 1) {
      if ([ObjectShareTool sharedInstance].currentUser.integralNum<self.permission.integral) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"金币不够提示"
                                                        message:@"你可以通过以下两个方式增加金币：\n1）按金币奖励规则完成任务获得金币\n2）在线支付充值金币"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"我要充值",nil];
        alert.tag = 1000;
        [alert show];
        return;
      }
      __weak typeof(self) weakSelf = self;
      [[[HeadlineBiz alloc]init] headlinesInfoDetailsIntegralPurchaseWithType:0 ID:self.productID integral:self.permission.integral success:^{
        [weakSelf getData];
      } fail:^(NSError *error) {
        
      }];
    }
  }else if (alertView.tag == 1000){
    if (buttonIndex == 1) {
      CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
      vc.type = 4;
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}

//点击登录
-(void)clickToLoginAction{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf getData];
  } fail:^(NSError *error) {
    
  }];
  //    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)typeArray{
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
  }
  return _typeArray;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        weakSelf.selectIndex = index;
      }completion:^(BOOL finished) {
        
      }];
    }];
  }
  return _bigTypeScrollView;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
}

#pragma mark UICollectionViewDelegate&UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return self.typeArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGInterfaceDetailCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGInterfaceDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  __weak typeof(self) weakSelf = self;
  [cell updateUIWithEntity:self.typeArray[indexPath.section] productID:self.productID block:^(CGProductDetailsVersionEntity *entity) {
        CGProductInterfaceViewController *vc = [[CGProductInterfaceViewController alloc]init];
        vc.productID = entity.ID;
        vc.title = entity.name;
    CGHorrolEntity *horrolEntity = weakSelf.typeArray[weakSelf.selectIndex];
    vc.action = horrolEntity.action;
        [weakSelf.navigationController pushViewController:vc animated:YES];
  }];
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

@end
