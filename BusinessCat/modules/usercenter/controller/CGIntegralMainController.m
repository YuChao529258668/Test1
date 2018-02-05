//
//  CGIntegralMainController.m
//  CGSays
//
//  Created by mochenyang on 2017/3/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGIntegralMainController.h"
#import "CGIntegralHeaderTableViewCell.h"
#import "CGIntegralTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGIntegralEntity.h"
#import "UserWalletCollectionViewCell.h"
#import "CGBuyVIPViewController.h"
#import "CGHorrolEntity.h"
#import "CGUserHelpCatePageViewController.h"
#import "CGLineLayout.h"
#import "CGHeadlineInfoDetailController.h"

@interface CGIntegralMainController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topSegmentButton;
@property (weak, nonatomic) IBOutlet UIButton *howEarnBtn;// 如何赚取金币按钮
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGIntegralMainController

- (void)viewDidLoad {
    self.title = @"我的钱包";
    [super viewDidLoad];
  self.bgView.backgroundColor = CTThemeMainColor;
  self.integralLabel.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum];
  UIView *view = [[UIView alloc]init];
  view.backgroundColor = [UIColor whiteColor];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-52.5f, 22, 50, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"充值" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.navi addSubview:rightBtn];
  self.topSegmentButton.selectedSegmentIndex = self.selectIndex;
    // Do any additional setup after loading the view from its nib.
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NOTIFICATION_BUYMEMBER object:nil];
    
    self.howEarnBtn.hidden = YES;
    NSDictionary *dic = @{NSForegroundColorAttributeName: [YCTool colorOfHex:0x000000]};
    NSDictionary *dic2 = @{NSForegroundColorAttributeName: [YCTool colorOfHex:0x777777]};
    [self.topSegmentButton setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.topSegmentButton setTitleTextAttributes:dic2 forState:UIControlStateNormal];
//    self.topSegmentButton.tintColor = [YCTool colorOfHex:0xf68731];
}

-(NSMutableArray *)typeArray{
  if (!_typeArray) {
    _typeArray = [NSMutableArray array];
    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"收入" sort:0]];
    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"3" rolName:@"支出" sort:0]];
//    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"我收到的" sort:0]];
  }
  return _typeArray;
}

-(void)update{
  for (CGHorrolEntity *entity in self.typeArray) {
    entity.data = [NSMutableArray array];
  }
  [self.collectionView reloadData];
  [self.tableview reloadData];
  self.integralLabel.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum];
}

-(void)refresh{
  __weak typeof(self) weakSelf = self;
  [[[CGUserCenterBiz alloc]init] queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
    weakSelf.integralLabel.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];
  for (CGHorrolEntity *entity in self.typeArray) {
    entity.data = [NSMutableArray array];
  }
  [self.collectionView reloadData];
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
}

- (IBAction)howBuyIntegralAction:(UIButton *)sender {
  CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
  vc.title = @"如何赚取和增加金币";
  vc.pageId = @"b5c497f6-f1de-f208-060a-7b2804b0268f";
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightBtnAction{
  CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
  vc.type = 4;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)topClick:(UISegmentedControl *)sender {
  self.selectIndex = sender.selectedSegmentIndex;
  NSInteger index = sender.selectedSegmentIndex;
  NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
  [self.collectionView reloadSections:indexSet];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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
  [collectionView registerNib:[UINib nibWithNibName:@"UserWalletCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  UserWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  __weak typeof(self) weakSelf = self;
  [cell updateDataWithType:self.typeArray[indexPath.section] block:^(RelationInfoEntity *entity) {
    CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:entity.infoID type:entity.type block:^{
      
    }];
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
