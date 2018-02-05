//
//  CGBuyVIPViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGBuyVIPViewController.h"
#import "CGBuyPackageTableViewCell.h"
#import "CGBuyMethodPaymentTableViewCell.h"
#import "CGCommonBiz.h"
#import "CGGradesPackageEntity.h"
#import "CGUserCenterBiz.h"
#import <StoreKit/StoreKit.h>
#import<CommonCrypto/CommonDigest.h>
#import "CGPayMethodEntity.h"
#import "CGUserHelpCateViewController.h"

@interface CGBuyVIPViewController ()<UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger methodIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *methodArray;
@property (nonatomic, strong) CGCommonBiz *commonBiz;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) CGRewardEntity *entity;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, assign) BOOL check;
@end

@implementation CGBuyVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  // 监听购买结果
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  self.selectIndex = 0;
  self.methodIndex = 0;
  self.commonBiz = [[CGCommonBiz alloc]init];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.payButton.backgroundColor = CTThemeMainColor;
  self.tableView.tableFooterView = [[UIView alloc]init];
  if (self.type == 4) {
    //购买知识分；
    self.title = @"充值金币";
  }else if (self.type == 5){
    //购买VIP会员；
    self.title = @"购买下载套餐";
  }else{
    self.title = self.titleText;
  }
  __weak typeof(self) weakSelf = self;
  [self.biz.component startBlockAnimation];
  
  if (self.type ==4 ||self.type == 5) {
    [self.biz authUserPackageListWithType:self.type ==4?1:2 success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      if (reslut.count>0) {
        CGGradesPackageEntity *entity = reslut[0];
        weakSelf.payMoney.text = [NSString stringWithFormat:@"￥%.2f",entity.packagePrice/100.0];
      }
      [weakSelf.tableView reloadData];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }else{
    [self.biz authUserGradesPackageWithGradesId:self.gradeID success:^(NSMutableArray *reslut) {
      weakSelf.dataArray = reslut;
      if (reslut.count>0) {
        CGGradesPackageEntity *entity = reslut[0];
        weakSelf.payMoney.text = [NSString stringWithFormat:@"￥%.2f",entity.packagePrice/100.0];
      }
      [weakSelf.tableView reloadData];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }
  
  [self.commonBiz authUserWalletPayMethodSuccess:^(NSMutableArray *result) {
    weakSelf.methodArray = result;
      [weakSelf.tableView reloadData];
//    if (result.count == 1) {
//      CGPayMethodEntity *entity = self.methodArray[0];
//      if ([entity.method isEqualToString:@"ApplePay"]) {
//        [weakSelf.webView loadHTMLString:entity.prompt baseURL:nil];
//        [weakSelf.bottomButton setTitle:entity.helpTitle forState:UIControlStateNormal];
//      }
//    }
    weakSelf.tableView.tableFooterView = [self getMehodView];
  } fail:^(NSError *error) {
    
  }];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRemoteUserDetailInfo) name:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
    // Do any additional setup after loading the view from its nib.
}



-(void)dealloc{
    [self.biz.component stopBlockAnimation];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)queryRemoteUserDetailInfo{
//  [self.navigationController popToRootViewControllerAnimated:YES];
  [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

  return 0.01;
}

-(UIView *)getMehodView{
  self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
  self.footView.backgroundColor = CTCommonViewControllerBg;
  CGPayMethodEntity *methodEntity = self.methodArray[self.methodIndex];
  for (int i =0; i<methodEntity.list.count; i++) {
    CGPromptEntity *entity = methodEntity.list[i];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, i*40, SCREEN_WIDTH-30, 40)];
    [btn setTitle:entity.title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.footView addSubview:btn];
    btn.tag = i;
    [btn addTarget:self action:@selector(methodAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40*methodEntity.list.count);
  return self.footView;
}

-(void)methodAction:(UIButton *)sender{
  CGPayMethodEntity *methodEntity = self.methodArray[self.methodIndex];
  CGPromptEntity *entity = methodEntity.list[sender.tag];
  if ([CTStringUtil stringNotBlank:entity.cateId]) {
    CGUserHelpCateViewController *vc = [[CGUserHelpCateViewController alloc]init];
    vc.cateId = entity.cateId;
    [self.navigationController pushViewController:vc animated:YES];
  }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
  view.backgroundColor = CTCommonViewControllerBg;
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
  [view addSubview:label];
  label.font = [UIFont systemFontOfSize:17];
  label.textColor = TEXT_MAIN_CLR;
  if (section == 0) {
    label.text = @"费用套餐";
  }else{
    label.text = @"支付方式";
  }
  return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.methodArray.count == 1) {
    CGPayMethodEntity *entity = self.methodArray[0];
    if ([entity.method isEqualToString:@"ApplePay"]) {
      return 1;
    }
  }
  if (self.methodArray.count<=0) {
    return 1;
  }
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 0) {
    return self.dataArray.count;
  }
  return self.methodArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 0) {
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    CGGradesPackageEntity *entity = self.dataArray[indexPath.row];
    self.payMoney.text = [NSString stringWithFormat:@"￥%ld",entity.packagePrice/100];
  }else{
    self.methodIndex = indexPath.row;
    [self.tableView reloadData];
    self.tableView.tableFooterView = [self getMehodView];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 1) {
    static NSString*identifier = @"CGBuyMethodPaymentTableViewCell";
    CGBuyMethodPaymentTableViewCell *cell = (CGBuyMethodPaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGBuyMethodPaymentTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.methodIndex == indexPath.row) {
      [cell.selectButton setImage:[UIImage imageNamed:@"user_chose"] forState:UIControlStateNormal];
    }else{
      [cell.selectButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    [cell update:self.methodArray[indexPath.row]];
    return cell;
  }else{
    static NSString*identifier = @"CGBuyPackageTableViewCell";
    CGBuyPackageTableViewCell *cell = (CGBuyPackageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGBuyPackageTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.selectIndex == indexPath.row) {
      cell.selectIcon.image = [UIImage imageNamed:@"user_chose"];
    }else{
      cell.selectIcon.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    CGGradesPackageEntity *entity = self.dataArray[indexPath.row];
    cell.title.text = entity.packageTitle;
    cell.money.text = [NSString stringWithFormat:@"￥%.2f",entity.packagePrice/100.0];
    cell.desc.text = entity.packageDesc;
    return cell;
  }
  return nil;
}

- (IBAction)clickPay:(UIButton *)sender {
  if (self.dataArray.count<=0) {
    return;
  }
  CGGradesPackageEntity *packEntity = self.dataArray[self.selectIndex];
  CGPayMethodEntity *methodEntity = [[CGPayMethodEntity alloc]init];
  if (self.methodArray.count>0) {
  methodEntity = self.methodArray[self.methodIndex];
  }else{
    methodEntity.title = @"Apple Pay";
    methodEntity.method = @"ApplePay";
  }
  __weak typeof(self) weakSelf = self;
  [self.commonBiz.component startBlockAnimation];
  NSString * body;
  NSInteger payType = 0;
  if (self.type == 4) {//0购买会员 1购买企业会员 4知识分套餐 5下载套餐
    //购买知识分；
    payType = 1002;
//      body = @"充值金币";
      body = @"充值金币";
  }else if (self.type == 5){
    //购买下载；
    payType = 1003;
    body = @"购买下载套餐";
  }else if (self.type == 0){
    body = self.titleText;
    payType = 1010;
  }else if (self.type == 1){
    body = self.titleText;
    payType = 1011;
  }
  [self.payButton setUserInteractionEnabled:NO];
  self.payButton.backgroundColor = [UIColor lightGrayColor];
  NSString *identifier = [CTDeviceTool getUniqueDeviceIdentifierAsString];
  NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:packEntity.packageId,@"packageid",identifier,@"identity", nil];
  NSString *toid;
  if (self.type == 1) {
    toid = self.companyID;
  }else{
    toid = [ObjectShareTool sharedInstance].currentUser.uuid;
  }
  self.check = YES;
  [self.commonBiz authUserPlaceOrderWithToId:toid toType:self.type ==1?3:24 subType:self.companyType payType:payType payMethod:methodEntity.method toUserId:@"123" body:body detail:nil attach:dic trade_type:@"APP" device_info:nil total_fee:packEntity.packagePrice notify_url:nil order_type:0 iOSProductId:packEntity.iOSProductId success:^(CGRewardEntity *entity) {
    weakSelf.entity = entity;
    [weakSelf.commonBiz.component stopBlockAnimation];
    if ([methodEntity.method isEqualToString:@"ApplePay"]) {
      if ([CTStringUtil stringNotBlank:entity.orderId]) {
        [weakSelf appPayWith:packEntity.iOSProductId];
      }else{
        [weakSelf.payButton setUserInteractionEnabled:YES];
        weakSelf.payButton.backgroundColor = CTThemeMainColor;
        [[CTToast makeText:@"失败，订单号为空"]show:[UIApplication sharedApplication].keyWindow];
      }
    }else if ([methodEntity.method isEqualToString:@"WECHATPAY"]){
      [weakSelf.commonBiz jumpToBizPayWithEntity:entity];
      [self.payButton setUserInteractionEnabled:YES];
      self.payButton.backgroundColor = CTThemeMainColor;
    }
  } fail:^(NSError *error) {
    [weakSelf.commonBiz.component stopBlockAnimation];
    [weakSelf.payButton setUserInteractionEnabled:YES];
    weakSelf.payButton.backgroundColor = CTThemeMainColor;
  }];
}

-(void)appPayWith:(NSString *)iOSProductId{
  if ([SKPaymentQueue canMakePayments]) {
    // 执行下面提到的第5步：
    [self getProductInfo:iOSProductId];
  } else {
    [self.payButton setUserInteractionEnabled:YES];
    self.payButton.backgroundColor = CTThemeMainColor;
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
    [self.payButton setUserInteractionEnabled:YES];
    self.payButton.backgroundColor = CTThemeMainColor;
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
  NSString *md5str = [SecurityUtil md5ByString:[NSString stringWithFormat:@"%@%@2781EFB84EE34032AB22829E324723CA",self.entity.orderId,receipt]];
  __weak typeof(self) weakSelf = self;
  if (self.check) {
    self.check = NO;
    [self.commonBiz authUserOrderAppleVerifyWithOrderId:self.entity.orderId receipt:receipt sign:md5str success:^{
      [weakSelf.biz.component stopBlockAnimation];
      [[CTToast makeText:@"交易成功"]show:[UIApplication sharedApplication].keyWindow];
      [weakSelf.payButton setUserInteractionEnabled:YES];
      weakSelf.payButton.backgroundColor = CTThemeMainColor;
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_BUYMEMBER object:nil];
      [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
      [[CTToast makeText:@"交易失败"]show:[UIApplication sharedApplication].keyWindow];
      [weakSelf.payButton setUserInteractionEnabled:YES];
      weakSelf.payButton.backgroundColor = CTThemeMainColor;
      self.check = YES;
    }];
  }
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  [self.biz.component stopBlockAnimation];
  [self.payButton setUserInteractionEnabled:YES];
  self.payButton.backgroundColor = CTThemeMainColor;
    
//  if(transaction.error.code != SKErrorPaymentCancelled) {
////    NSLog(@"购买失败");
//    [[CTToast makeText:@"购买失败"]show:[UIApplication sharedApplication].keyWindow];
//  } else {
////    NSLog(@"用户取消交易");
//    [[CTToast makeText:@"用户取消交易"]show:[UIApplication sharedApplication].keyWindow];
//  }
    
    if(transaction.error.code == SKErrorPaymentCancelled) {
        [[CTToast makeText:@"用户取消交易"]show:[UIApplication sharedApplication].keyWindow];
    } else {
        NSString *msg = [NSString stringWithFormat:@"购买失败：%@", transaction.error.userInfo[@"NSLocalizedDescription"]];
        [CTToast showWithText:msg];
    }
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  // 对于已购商品，处理恢复购买的逻辑
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
