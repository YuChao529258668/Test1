//
//  CGExceptionalViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGExceptionalViewController.h"
#import "CGDiscoverBiz.h"
#import "UIColor+colorToImage.h"
#import "CGUserDao.h"
#import <UIButton+WebCache.h>
#import "CGCommonBiz.h"
#import "CGBuyVIPViewController.h"
#import "CGUserCenterBiz.h"
#import "CGIntegralMainController.h"

@interface CGExceptionalViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSArray *moneyArray;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) CGCommonBiz *commonBiz;
@property (nonatomic, strong) UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *originalIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingPoints;
@end

@implementation CGExceptionalViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"打赏";
  self.biz = [[CGDiscoverBiz alloc]init];
  self.commonBiz = [[CGCommonBiz alloc]init];
  for (UIButton *btn in self.buttons) {
    [btn setBackgroundImage:[UIColor createImageWithColor:[CTCommonUtil convert16BinaryColor:@"#F55A5D"] Rect:btn.bounds] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:btn.bounds] forState:UIControlStateNormal];
    [btn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#F55A5D"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.layer.borderColor = CTCommonLineBg.CGColor;
    btn.layer.borderWidth = 0.5f;
  }
  self.moneyArray = @[@"10",@"50",@"80",@"100",@"500",@"1000"];
  self.selectButton = self.buttons[0];
  self.sureButton.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#F55A5D"].CGColor;
  self.sureButton.layer.borderWidth = 0.5f;
  self.sureButton.layer.cornerRadius = 4;
  self.sureButton.layer.masksToBounds = YES;
  self.textField.keyboardType = UIKeyboardTypeDecimalPad;
  self.textField.delegate = self;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:self.iconImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"]];
  self.name.text = self.userName;
  
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setTitle:@"历史" forState:UIControlStateNormal];
  self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
  [self.navi addSubview:self.rightBtn];
  self.originalIntegralLabel.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum];
  NSString *str = self.moneyArray[self.selectButton.tag];
  self.remainingPoints.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum-str.intValue];
  [self.textField addTarget:self action:@selector(textChange:) forControlEvents:
   UIControlEventEditingChanged];
  // Do any  additional setup after loading the view from its nib.
}

- (void)textChange:(UITextField *)textField {
  if ([textField.text hasSuffix:@"."]) {
    NSString * subString2 = [textField.text substringToIndex:textField.text.length-1];
    textField.text = subString2;
  }
  self.remainingPoints.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum-textField.text.intValue];
}

-(void)paySuccess{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnAction{
  CGIntegralMainController *controller = [[CGIntegralMainController alloc]init];
  controller.selectIndex = 2;
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)moneyClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  if (sender.tag<6) {
    [self.textField resignFirstResponder];
    NSString *str = self.moneyArray[sender.tag];
    self.remainingPoints.text = [NSString stringWithFormat:@"%d币",[ObjectShareTool sharedInstance].currentUser.integralNum-str.intValue];
  }else{
    [self.textField becomeFirstResponder];
  }
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:YES];
  [self.commonBiz.component stopBlockAnimation];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  UIButton *btn = self.buttons[6];
  self.selectButton.selected = NO;
  btn.selected = YES;
  self.selectButton = btn;
}

- (IBAction)sureClick:(UIButton *)sender {
  NSString *money = @"0";
  if (self.selectButton.tag == 6) {
    money = self.textField.text;
  }else{
    money = self.moneyArray[self.selectButton.tag];
  }
  double payMoney = money.doubleValue;
  if (payMoney<10) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"金币不能少于10币"]show:window];
    return;
  }
  if ([ObjectShareTool sharedInstance].currentUser.integralNum<money.intValue) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"金币不够提示"
                                                    message:@"你可以通过以下两个方式增加金币：\n1）按金币奖励规则完成任务获得金币\n2）在线支付充值金币"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"我要充值",nil];
    [alert show];
    return;
  }
    //金钱单位分
//    NSString *spbill_create_ip = [CTCommonUtil getIPAddress:YES];
  __weak typeof(self) weakSelf = self;
  [sender setUserInteractionEnabled:NO];
  [self.commonBiz.component startBlockAnimation];
  [self.commonBiz authDiscoverScoopRewardIntegralWithUserId:self.toUserID scoopId:self.sourceCircleID integral:payMoney success:^{
    [[CTToast makeText:@"打赏成功"]show:[UIApplication sharedApplication].keyWindow];
    [weakSelf.commonBiz.component stopBlockAnimation];
    [sender setUserInteractionEnabled:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_INTEGRALEXCEPTIONALSUCCESS object:nil];
    [weakSelf queryRemoteUserDetailInfo];
    [weakSelf.navigationController popViewControllerAnimated:YES];
  } fail:^(NSError *error) {
    [weakSelf.commonBiz.component stopBlockAnimation];
    [sender setUserInteractionEnabled:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:[error.userInfo objectForKey:@"message"]]show:window];
  }];
}

//查询服务器的用户详细信息
-(void)queryRemoteUserDetailInfo{
  __weak typeof(self) weakSelf = self;
  [[[CGUserCenterBiz alloc]init] queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];
}

- (IBAction)closeClick:(UIButton *)sender {
  [self.textField resignFirstResponder];
}

-(void)dealloc{
  //移除通知
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex ==1) {
    CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
    vc.type = 4;
    [self.navigationController pushViewController:vc animated:YES];
  }
}
@end
