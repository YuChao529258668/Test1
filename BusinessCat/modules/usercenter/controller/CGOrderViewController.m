//
//  CGOrderViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderViewController.h"
#import "CGOrderEntity.h"
#import "CGOrderCollectionViewCell.h"
#import "CGHorrolEntity.h"
#import "CGOrderDetailViewController.h"
#import "CGHorrolView.h"
#import "CGUserCenterBiz.h"
#import <StoreKit/StoreKit.h>
#import<CommonCrypto/CommonDigest.h>

@interface CGOrderViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) CGCommonBiz *commonBiz;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) CGOrderEntity *selectEntity;
@end

@implementation CGOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"订单";
  self.selectIndex = 0;
  self.commonBiz = [[CGCommonBiz alloc]init];
  self.biz = [[CGUserCenterBiz alloc]init];
  [self.view addSubview:self.bigTypeScrollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) array:self.dataArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        weakSelf.selectIndex = index;
      }completion:^(BOOL finished) {
        
      }];
    }];
  }
  return _bigTypeScrollView;
}

-(void)refresh{
  for (CGHorrolEntity *entity in self.dataArray) {
    entity.data = [NSMutableArray array];
  }
  [self.collectionView reloadData];
}

-(NSMutableArray *)dataArray{
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"0" rolName:@"全部" sort:0]];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"待完成" sort:0]];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"5" rolName:@"已完成" sort:0]];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"待付款" sort:0]];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"3" rolName:@"已取消" sort:0]];
  }
  return _dataArray;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
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
  return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGOrderCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  [cell update:self.dataArray[indexPath.section]];
  __weak typeof(self) weakSelf = self;
  [cell didSelectIndexWithBlock:^(CGOrderEntity *entity) {
//    CGOrderDetailViewController *vc = [[CGOrderDetailViewController alloc]init];
//    vc.entity = entity;
//    [weakSelf.navigationController pushViewController:vc animated:YES];
  } tableViewButtonBlock:^(CGOrderEntity *entity, NSInteger type) {
    weakSelf.selectEntity = entity;
    if ([CTStringUtil stringNotBlank:entity.iosProductId]) {
     [weakSelf appPayWith:entity.iosProductId];
    }
//    [weakSelf.commonBiz jumpToBizPayWithEntity:entity.payResult];
  }];
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

-(void)appPayWith:(NSString *)iOSProductId{
  if ([SKPaymentQueue canMakePayments]) {
    // 执行下面提到的第5步：
    [self getProductInfo:iOSProductId];
  } else {
    [[CTToast makeText:@"失败，用户禁止应用内付费购买."]show:[UIApplication sharedApplication].keyWindow];
  }
}

// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo:(NSString *)iOSProductId {
  NSSet * set = [NSSet setWithArray:@[iOSProductId]];
  SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
  request.delegate = self;
  [request start];
  [self.biz.component startBlockAnimation];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  NSArray *myProduct = response.products;
  if (myProduct.count == 0) {
    [self.biz.component stopBlockAnimation];
    [[CTToast makeText:@"无法获取产品信息，购买失败。"]show:[UIApplication sharedApplication].keyWindow];
    return;
  }
  SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions)
  {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased://交易完成
        [self.biz.component startBlockAnimation];
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed://交易失败
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored://已经购买过该商品
        [self restoreTransaction:transaction];
        break;
      case SKPaymentTransactionStatePurchasing:      //商品添加进列表
        
        [self.biz.component startBlockAnimation];
        break;
      default:
        break;
    }
  }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  // Your application should implement these two methods.
  //  NSString * productIdentifier = transaction.payment.productIdentifier;
  //  NSString * receipt = [CTBase64 stringByEncodingData:transaction.transactionReceipt];
  //  if ([productIdentifier length] > 0) {
  //    // 向自己的服务器验证购买凭证
  //  }
  
  //  //交易验证
  NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
  NSString *receipt =  [[NSData dataWithContentsOfURL:recepitURL] base64EncodedStringWithOptions:0];
  receipt =  [receipt stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
  receipt =  [receipt stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
  //  NSString *receiptEncoding = [receipt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *md5str = [SecurityUtil md5ByString:[NSString stringWithFormat:@"%@%@2781EFB84EE34032AB22829E324723CA",self.selectEntity.orderId,receipt]];
  __weak typeof(self) weakSelf = self;
  [self.commonBiz authUserOrderAppleVerifyWithOrderId:self.selectEntity.orderId receipt:receipt sign:md5str success:^{
    [weakSelf.biz.component stopBlockAnimation];
    [[CTToast makeText:@"交易成功"]show:[UIApplication sharedApplication].keyWindow];
//    [weakSelf.payButton setUserInteractionEnabled:YES];
//    weakSelf.payButton.backgroundColor = CTThemeMainColor;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
//    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    [[CTToast makeText:@"交易失败"]show:[UIApplication sharedApplication].keyWindow];
//    [weakSelf.payButton setUserInteractionEnabled:YES];
//    weakSelf.payButton.backgroundColor = CTThemeMainColor;
  }];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  [self.biz.component stopBlockAnimation];
//  [self.payButton setUserInteractionEnabled:YES];
//  self.payButton.backgroundColor = CTThemeMainColor;
  if(transaction.error.code != SKErrorPaymentCancelled) {
    //    NSLog(@"购买失败");
    [[CTToast makeText:@"购买失败"]show:[UIApplication sharedApplication].keyWindow];
  } else {
    //    NSLog(@"用户取消交易");
    [[CTToast makeText:@"用户取消交易"]show:[UIApplication sharedApplication].keyWindow];
  }
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  // 对于已购商品，处理恢复购买的逻辑
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
