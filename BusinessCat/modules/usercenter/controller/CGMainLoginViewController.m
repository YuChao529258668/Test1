//
//  CGMainLoginViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMainLoginViewController.h"
#import <WXApi.h>
#import "CGUserCenterBiz.h"
#import "CGLoginController.h"
#import "UMessage.h"

@interface CGMainLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *WXButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneY;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property(nonatomic,retain)CGUserCenterBiz *userBiz;
@property (nonatomic, copy) CGLoginSuccessBlock loginSuccess;
@property (nonatomic, copy) CGLoginCancelBlock cancel;
@end

@implementation CGMainLoginViewController

-(instancetype)initWithBlock:(CGLoginSuccessBlock)success fail:(CGLoginCancelBlock)fail{
  self = [super init];
  if(self){
    self.loginSuccess = success;
    self.cancel = fail;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  self.title = @"登录";
    
//  self.WXButton.layer.cornerRadius = 4;
//  self.WXButton.layer.masksToBounds = YES;
//  self.WXButton.layer.borderColor = CTThemeMainColor.CGColor;
//  self.WXButton.layer.borderWidth = 1;
//  [self.WXButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
//  self.phoneButton.layer.cornerRadius = 4;
//  self.phoneButton.layer.masksToBounds = YES;
//  self.phoneButton.layer.borderColor = CTThemeMainColor.CGColor;
//  self.phoneButton.layer.borderWidth = 1;
//  [self.phoneButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  if ([WXApi isWXAppInstalled]) {
    //微信
    self.WXButton.hidden = NO;
    self.phoneY.constant = 110;
  }else{
    self.WXButton.hidden = YES;
    self.phoneY.constant = 40;
  }
  self.userBiz = [[CGUserCenterBiz alloc]init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccess_token:) name:NOTIFICATION_GETWEIXINCODE object:nil];
    // Do any additional setup after loading the view from its nib.
    
    self.navi.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)WXClick:(UIButton *)sender {
    [[CTNetWorkUtil sharedManager] startBlockAnimation];
  SendAuthReq *req = [[SendAuthReq alloc] init];
  req.scope = @"snsapi_userinfo";
  req.state = @"App";
  [WXApi sendReq:req];
}

-(void)getAccess_token:(NSNotification*)info
{
  NSString *code = [info object];
  __weak typeof(self) weakSelf = self;
  [self.userBiz queryUserDetailInfoWithCode:code success:^(CGUserEntity *user) {
      [[CTNetWorkUtil sharedManager] stopBlockAnimation]; // 停止发起微信登录时的菊花
      
    if ([CTStringUtil stringNotBlank:user.phone]) {
//      [WKWebViewController setPath:@"setUserInfoData" code:[ObjectShareTool sharedInstance].currentUser.mj_JSONString success:^(id response) {
//        
//      } fail:^{
//        
//      }];
      
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
      weakSelf.loginSuccess(user);
      [weakSelf.navigationController popViewControllerAnimated:YES];
    }else{
      CGLoginController *controller = [[CGLoginController alloc]initWithBlock:^(CGUserEntity *user) {
        weakSelf.loginSuccess(user);
      } fail:^(NSError *error) {
        weakSelf.cancel(error);
      }];
//      [weakSelf presentViewController:controller animated:YES completion:nil];
        controller.isChangePhone = 1;
      [weakSelf.navigationController pushViewController:controller animated:YES];
    }
    [weakSelf.userBiz userMessageTagsWithSuccess:^(NSMutableArray *result) {
      [UMessage addTag:result response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        
      }];
    } fail:^(NSError *error) {
      
    }];
  } fail:^(NSError *error) {
    
  }];
}


- (IBAction)phoneClick:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  CGLoginController *controller = [[CGLoginController alloc]initWithBlock:^(CGUserEntity *user) {
      if (weakSelf.loginSuccess) {
          weakSelf.loginSuccess(user);
      }
  } fail:^(NSError *error) {
    
  }];
  [self.navigationController pushViewController:controller animated:YES];
//  [self presentViewController:controller animated:YES completion:nil];
}
@end
