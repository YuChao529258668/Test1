//
//  CGOrderDetailViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderDetailViewController.h"
#import "CGHorrolEntity.h"
#import "CGOrderDetailCollectionViewCell.h"

@interface CGOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *orderProgress;
@property (weak, nonatomic) IBOutlet UIButton *orderDetail;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *rightTwoButton;
@end

@implementation CGOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"订单详情";
  self.orderProgress.selected = YES;
  self.selectButton = self.orderProgress;
  self.selectIndex = 0;
  [self.orderProgress setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
  [self.orderDetail setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
  self.line.backgroundColor = CTThemeMainColor;
  self.rightButton.layer.borderColor = TEXT_MAIN_CLR.CGColor;
  self.rightButton.layer.borderWidth = 1;
  self.rightButton.layer.masksToBounds = YES;
  self.rightButton.layer.cornerRadius = 4;
  self.rightTwoButton.layer.borderColor = TEXT_MAIN_CLR.CGColor;
  self.rightTwoButton.layer.borderWidth = 1;
  self.rightTwoButton.layer.masksToBounds = YES;
  self.rightTwoButton.layer.cornerRadius = 4;
  if ((self.entity.orderState == 1&&self.entity.payState == 0)||(self.entity.orderState == 1&&self.entity.payState == 2)) {
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = NO;
    [self.rightTwoButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
  }else if ((self.entity.orderState == 2&&self.entity.payState == 1)||(self.entity.orderState == 3&&self.entity.payState == 1)){
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
  }else if (self.entity.orderState == 3&&self.entity.payState == 1){
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
  }else if (self.entity.orderState == 5&&self.entity.payState == 1){
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"申请售后" forState:UIControlStateNormal];
  }else{
    self.rightButton.hidden = YES;
    self.rightTwoButton.hidden = YES;
    self.buttomViewHeight.constant = 0;
  }
  
}

-(NSMutableArray *)dataArray{
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:self.entity.orderId rolName:@"订单进度" sort:0]];
    CGHorrolEntity *entity = [[CGHorrolEntity alloc]initWithRolId:self.entity.orderId rolName:@"订单详情" sort:0];
    entity.data = [NSMutableArray array];
    [entity.data addObject:self.entity];
    [_dataArray addObject:entity];
  }
  return _dataArray;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
  self.selectButton.selected = NO;
  switch ([self currentPage]) {
    case 0:
      self.orderProgress.selected = YES;
      self.selectButton = self.orderProgress;
      break;
    case 1:
      self.orderDetail.selected = YES;
      self.selectButton = self.orderDetail;
      break;
    default:
      break;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake([self currentPage]*150+40, 38, 70, 2);
  }];
}

- (IBAction)topButtonClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  self.selectIndex = sender.tag;
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake(sender.tag*150+40, 38, 70, 2);
  }];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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
  return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGOrderDetailCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGOrderDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  [cell update:self.dataArray[indexPath.section]];
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
