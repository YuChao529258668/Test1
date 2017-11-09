//
//  CGRedPacketViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGRedPacketViewController.h"
#import "CGWithdrawViewController.h"
#import "UserWalletCollectionViewCell.h"
#import "CGUserCenterBiz.h"

@interface CGRedPacketViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) CGUserWalletInfoEntity *reslut;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGRedPacketViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"我的钱包";
    self.headerView.backgroundColor = CTThemeMainColor;
    self.tabView.tintColor = CTThemeMainColor;
  self.biz = [[CGUserCenterBiz alloc]init];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:NOTIFICATION_WITHDRAWDEPOSIT object:nil];
  [rightBtn setTitle:@"提现" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.navi addSubview:rightBtn];
  [self getData];
  // Do any additional setup after loading the view from its nib.
}

-(void)getData{
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz authUserWalletInfoSuccess:^(CGUserWalletInfoEntity *reslut) {
    weakSelf.reslut = reslut;
    weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",reslut.totalAmount/100];
    [self.biz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [self.biz.component stopBlockAnimation];
  }];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)rightBtnAction{
  CGWithdrawViewController *vc = [[CGWithdrawViewController alloc]init];
  vc.reslut = self.reslut;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)Click:(UISegmentedControl *)sender {
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
  return 3;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"UserWalletCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  UserWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//  [cell updateDataWithType:indexPath.section+1];
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
