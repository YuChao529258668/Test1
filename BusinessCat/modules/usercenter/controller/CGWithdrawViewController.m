//
//  CGWithdrawViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGWithdrawViewController.h"
#import "CGUserCenterBiz.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

@interface CGWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) CGUserCenterBiz *biz;;
@end

@implementation CGWithdrawViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"提现";
  self.biz = [[CGUserCenterBiz alloc]init];
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//  [self.rightBtn setTitle:@"历史" forState:UIControlStateNormal];
//  self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//  [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//  [self.rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
//  [self.navi addSubview:self.rightBtn];
  
  self.sureButton.layer.cornerRadius = 4;
  self.sureButton.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#F55A5D"].CGColor;
  self.sureButton.layer.borderWidth = 0.5f;
  self.sureButton.layer.masksToBounds = YES;
  self.textField.keyboardType = UIKeyboardTypeDecimalPad;
  self.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.reslut.totalAmount/100];
  self.bindingButton.selected = self.reslut.isBind;
  self.attentionButton.selected = self.reslut.isSubscribe;
    
    self.allMoneyLabel.textColor = CTThemeMainColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccess_token:) name:NOTIFICATION_GETWEIXINCODE object:nil];
}

-(void)rightBtnAction{

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)bindingClick:(UIButton *)sender {
  if (sender.selected == NO) {
    if ([WXApi isWXAppInstalled]) {
      SendAuthReq* req =[[SendAuthReq alloc ] init];
      req.scope = @"snsapi_userinfo,snsapi_base";
      req.state = @"0744" ;
      [WXApi sendReq:req];
    }else {
      [self setupAlertController];
    }
  }
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
  [alert addAction:actionConfirm];
  [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)backClick:(id)sender {
  [self.textField resignFirstResponder];
}

- (IBAction)sureClick:(UIButton *)sender {
  NSString *money = self.textField.text;
  double payMoney = money.doubleValue;
  if (payMoney<0.01) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"金额不能少于一分"]show:window];
    return;
  }
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  [self.biz authRedpackWithdrawWithAmount:payMoney*100 client_ip:[self getIPAddress:YES] success:^{
    [weakSelf.biz.component stopBlockAnimation];
    [[CTToast makeText:@"提现成功"]show:window];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WITHDRAWDEPOSIT object:nil];
    [weakSelf.navigationController popViewControllerAnimated:YES];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
  }];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
  
}

#pragma mark - 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
  NSArray *searchArray = preferIPv4 ?
  @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
  @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
  
  NSDictionary *addresses = [self getIPAddresses];
  NSLog(@"addresses: %@", addresses);
  
  __block NSString *address;
  [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
   {
     address = addresses[key];
     //筛选出IP地址格式
     if([self isValidatIP:address]) *stop = YES;
   } ];
  return address ? address : @"0.0.0.0";
}

- (BOOL)isValidatIP:(NSString *)ipAddress {
  if (ipAddress.length == 0) {
    return NO;
  }
  NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
  
  if (regex != nil) {
    NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
    
    if (firstMatch) {
      NSRange resultRange = [firstMatch rangeAtIndex:0];
      NSString *result=[ipAddress substringWithRange:resultRange];
      //输出结果
      NSLog(@"%@",result);
      return YES;
    }
  }
  return NO;
}

- (NSDictionary *)getIPAddresses
{
  NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
  
  // retrieve the current interfaces - returns 0 on success
  struct ifaddrs *interfaces;
  if(!getifaddrs(&interfaces)) {
    // Loop through linked list of interfaces
    struct ifaddrs *interface;
    for(interface=interfaces; interface; interface=interface->ifa_next) {
      if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
        continue; // deeply nested code harder to read
      }
      const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
      char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
      if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
        NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
        NSString *type;
        if(addr->sin_family == AF_INET) {
          if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
            type = IP_ADDR_IPv4;
          }
        } else {
          const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
          if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
            type = IP_ADDR_IPv6;
          }
        }
        if(type) {
          NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
          addresses[key] = [NSString stringWithUTF8String:addrBuf];
        }
      }
    }
    // Free memory
    freeifaddrs(interfaces);
  }
  return [addresses count] ? addresses : nil;
}

-(void)getAccess_token:(NSNotification*)info
{
  NSString *code = [info object];
  //  __weak typeof(self) weakSelf = self;
  [self.biz queryUserDetailInfoWithCode:code success:^(CGUserEntity *user) {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];

//  NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
//  
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSURL *zoneUrl = [NSURL URLWithString:url];
//    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//    dispatch_async(dispatch_get_main_queue(), ^{
//      if (data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [self getWeiXinUserInfoWithAccess_token:[dic objectForKey:@"access_token"] openid:[dic objectForKey:@"openid"]];
//      }
//    });
//  });
}

//-(void)getWeiXinUserInfoWithAccess_token:(NSString *)access_token openid:(NSString *)openid
//{
//  __weak typeof(self) weakSelf = self;
//  NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
//  
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSURL *zoneUrl = [NSURL URLWithString:url];
//    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//    dispatch_async(dispatch_get_main_queue(), ^{
//      if (data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [weakSelf.biz wechatInfoUpdateWithNickname:dic[@"nickname"] gender:[dic[@"sex"] intValue] openid:dic[@"openid"] portrait:dic[@"headimgurl"] unionid:dic[@"unionid"] op:YES success:^{
//          [ObjectShareTool sharedInstance].currentUser.nickname = dic[@"nickname"];
//          if ([CTStringUtil stringNotBlank:dic[@"headimgurl"]]) {
//            [ObjectShareTool sharedInstance].currentUser.portrait = dic[@"headimgurl"];
//          }
//          [ObjectShareTool sharedInstance].currentUser.openid = dic[@"openid"];
//          [ObjectShareTool sharedInstance].currentUser.gender = [dic[@"sex"] intValue]==1?@"男":@"女";
//          [weakSelf.tableview reloadData];
//          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
//          weakSelf.reslut.isBind = YES;
//          weakSelf.bindingButton.selected = YES;
//        } fail:^(NSError *error) {
//          
//        }];
//      }
//    });
//    
//  });
//}
@end
