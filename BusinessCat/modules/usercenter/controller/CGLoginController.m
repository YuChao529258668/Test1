//
//  CGLoginController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGLoginController.h"
#import "CGUserCenterBiz.h"
#import "CTVerifyTool.h"
#import "UMessage.h"

@interface CGLoginController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *operator;
@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveViewCenter;

@property (retain, nonatomic) UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UILabel *verifyCode1;
@property (weak, nonatomic) IBOutlet UILabel *verifyCode2;
@property (weak, nonatomic) IBOutlet UILabel *verifyCode3;
@property (weak, nonatomic) IBOutlet UILabel *verifyCode4;
@property (weak, nonatomic) IBOutlet UILabel *voiceBtn;
@property(nonatomic,retain)CGUserCenterBiz *userBiz;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyCodeX;

@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
@property(nonatomic,assign)BOOL statusBarHidden;

@property (nonatomic, copy) CGLoginSuccessBlock loginSuccess;
@property (nonatomic, copy) CGLoginCancelBlock cancel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation CGLoginController

-(CGUserCenterBiz *)userBiz{
    if(!_userBiz){
        _userBiz = [[CGUserCenterBiz alloc]init];
    }
    return _userBiz;
}

-(instancetype)initWithBlock:(CGLoginSuccessBlock)success fail:(CGLoginCancelBlock)fail{
    self = [super init];
    if(self){
        self.loginSuccess = success;
        self.cancel = fail;
    }
    return self;
}

//0:获取验证码(灰色) 1:获取验证码(主题色) 2:重新获取(灰色) 3:重新获取(主题色) 4:登录中
-(void)setOperatorState:(int)state str:(NSString *)str{
    NSString *title = nil;
    switch (state) {
        case 0:{
            self.operator.enabled = NO;
            self.operator.textColor = [UIColor lightGrayColor];
            title = @"获取验证码";
        }
            break;
        case 1:{
            self.operator.enabled = YES;
//            self.operator.textColor = CTThemeMainColor;
            self.operator.textColor = [UIColor blackColor];
            title = @"获取验证码";
        }
            break;
        case 2:{
            self.operator.enabled = NO;
            self.operator.textColor = [UIColor lightGrayColor];
            title = @"重新获取";
        }
            break;
        case 3:{
            self.operator.enabled = YES;
//            self.operator.textColor = CTThemeMainColor;
            self.operator.textColor = [UIColor blackColor];
            title = @"重新获取";
        }
            break;
        case 4:{
            self.operator.enabled = NO;
            self.operator.textColor = [UIColor lightGrayColor];
          title = self.isChangePhone?@"修改中...":@"登录中...";
        }
            break;
        default:
            break;
    }
    if(str){
        title = [title stringByAppendingString:str];
    }
    self.operator.text = title;
    self.operator.tag = state;
}

//由于登录界面是不经过navigation，所以在这里处理状态栏的状态
-(void)viewWillAppear:(BOOL)animated{
    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if(!self.phoneNum.hidden){
      [self.phoneNum becomeFirstResponder];
    }else{
      [self.verifyCode becomeFirstResponder];
    }
  //禁止滑动返回
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
  }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden withAnimation:UIStatusBarAnimationNone];
  //开启滑动返回
  if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
}

- (void)viewDidLoad {
  if (self.isChangePhone) {
    self.title = @"重新绑定手机";
    self.icon.hidden = YES;
    self.tipsLabel.hidden = NO;
  }else{
//   self.title = @"手机登录";
      self.title = @"";
  }
    [super viewDidLoad];
  
    self.verifyCode = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.verifyCode.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCode.alpha = 0;
    self.verifyCode.delegate = self;
    [self.view addSubview:self.verifyCode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.phoneNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.verifyCode];
    
    //弹出键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    //收起键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.verifyCode1.layer addSublayer:[self generatorLayerWithFrame:CGRectMake(0, self.verifyCode1.frame.size.height-2, self.verifyCode1.frame.size.width, 2)]];
    [self.verifyCode2.layer addSublayer:[self generatorLayerWithFrame:CGRectMake(0, self.verifyCode2.frame.size.height-2, self.verifyCode2.frame.size.width, 2)]];
    [self.verifyCode3.layer addSublayer:[self generatorLayerWithFrame:CGRectMake(0, self.verifyCode3.frame.size.height-2, self.verifyCode3.frame.size.width, 2)]];
    [self.verifyCode4.layer addSublayer:[self generatorLayerWithFrame:CGRectMake(0, self.verifyCode4.frame.size.height-2, self.verifyCode4.frame.size.width, 2)]];
    [self.phoneNum.layer addSublayer:[self generatorLayerWithFrame:CGRectMake(0, self.phoneNum.frame.size.height-2, SCREEN_WIDTH, 2)]];
    
    UITapGestureRecognizer *operatorTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(operatorBtnAction)];
    [self.operator addGestureRecognizer:operatorTap];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.voiceBtn.text];
//    [str addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(8,5)]; //设置字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(8,5)]; //设置字体颜色
    self.voiceBtn.attributedText = str;
    
    operatorTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageClick)];
    [self.voiceBtn addGestureRecognizer:operatorTap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationLoginVerifyTimer:) name:NOTIFICATION_LOGIN_TIMER object:nil];
    
    if([ObjectShareTool sharedInstance].loginPhoneNum){
        self.phoneNum.text = [ObjectShareTool sharedInstance].loginPhoneNum;//把上次登录的号码赋值到输入框
        if(![ObjectShareTool sharedInstance].loginVerifyTimer){
            [self setOperatorState:1 str:nil];
        }
    }
    
    if([ObjectShareTool sharedInstance].loginVerifyTimer){
        [self changeView:1];
        self.voiceBtn.hidden = NO;
    }
    
    self.navi.backgroundColor= [UIColor clearColor];
    [self setupTap];
}

//倒计时通知
-(void)notificationLoginVerifyTimer:(NSNotification *)notification{
    int count = [notification.object intValue];
    NSLog(@"定时器的通知:%d",count);
    if(self.operator.tag != 4){//正在登录中，不做更新
        if(count > 0){
            [self setOperatorState:2 str:[NSString stringWithFormat:@"(%d秒)",count]];
        }else{
            if([self.phoneNum isEditing]){
                [self setOperatorState:1 str:nil];
            }else{
                [self setOperatorState:3 str:nil];
            }
        }
    }
}

-(CALayer *)generatorLayerWithFrame:(CGRect)frame{
    CALayer *borderView = [CALayer layer];
    borderView.frame = frame;
//    borderView.backgroundColor = CTThemeMainColor.CGColor; // 输入框横线
    borderView.backgroundColor = [UIColor blackColor].CGColor; // 输入框横线
    return borderView;
}

-(void)closeKeyBoard{
    [self.phoneNum resignFirstResponder];
    [self.verifyCode resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)note {
    __weak typeof(self) weakSelf = self;
    //取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect moveRect = self.moveView.frame;
    float y = SCREEN_HEIGHT - rect.size.height - moveRect.size.height-30;
    if(y < 130){
        moveRect.origin.y = y;
        [UIView animateWithDuration:duration animations:^{
          weakSelf.moveViewCenter.constant = -60;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    __weak typeof(self) weakSelf = self;
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect moveRect = self.moveView.frame;
//    moveRect.origin.y = 130;
    [UIView animateWithDuration:duration animations:^{
//        weakSelf.moveView.frame = moveRect;
      weakSelf.moveViewCenter.constant = 60;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)baseBackAction{
    if([self.verifyCode isEditing]){
        [self changeView:0];
    }else{
        [self closeKeyBoard];
        [super baseBackAction];
    }
}


-(void)textFieldChanged:(NSNotification *)notification{
    UITextField *textField = notification.object;
    if(textField == self.phoneNum){
        if(textField.text.length > 11){
            textField.text = [textField.text substringToIndex:11];
        }
        if([CTVerifyTool isTelePhone:textField.text]){
            [self setOperatorState:1 str:nil];
        }else{
            [self setOperatorState:0 str:nil];
        }
    }else if (textField == self.verifyCode){
        if(textField.text.length > 4){
            textField.text = [textField.text substringToIndex:4];
        }
        [self setVerifyCode];
        if(textField.text.length == 4){
          if (self.isChangePhone) {
            [self changePhone];
          }else{
           [self login];//登录
          }
        }
    }
}

-(void)setVerifyCode{
    NSString *code = self.verifyCode.text;
    if(code.length <= 0){
        self.verifyCode1.text = nil;
        self.verifyCode2.text = nil;
        self.verifyCode3.text = nil;
        self.verifyCode4.text = nil;
    }else if (code.length == 1){
        self.verifyCode1.text = code;
        self.verifyCode2.text = nil;
        self.verifyCode3.text = nil;
        self.verifyCode4.text = nil;
    }else if (code.length == 2){
        self.verifyCode2.text = [code substringWithRange:NSMakeRange(1, 1)];
        self.verifyCode3.text = nil;
        self.verifyCode4.text = nil;
    }else if (code.length == 3){
        self.verifyCode3.text = [code substringWithRange:NSMakeRange(2, 1)];
        self.verifyCode4.text = nil;
    }else if (code.length == 4){
        self.verifyCode4.text = [code substringWithRange:NSMakeRange(3, 1)];
    }
}

#pragma mark - 发送验证码

//0:获取验证码(灰色) 1:获取验证码(主题色) 2:重新获取(灰色) 3:重新获取(主题色) 4:登录中
-(void)operatorBtnAction{
    __weak typeof(self) weakSelf = self;
    self.operator.enabled = NO;
    self.operator.textColor = [UIColor lightGrayColor];
    if(self.operator.tag == 1 || self.operator.tag == 3){
        [self.userBiz.component startBlockAnimation];
        //获取短信验证码
        [self.userBiz getLoginVerifyCodeByPhone:self.phoneNum.text success:^(void) {
            [[CTToast makeText:@"短信验证码已发送，请稍候"]show:weakSelf.view];
            weakSelf.voiceBtn.hidden = NO;
            [weakSelf.userBiz.component stopBlockAnimation];
            weakSelf.verifyCode.text = nil;
            [weakSelf setVerifyCode];
            [weakSelf changeView:1];//切换到输入验证码的状态
            [ObjectShareTool sharedInstance].loginPhoneNum = weakSelf.phoneNum.text;
            [[ObjectShareTool sharedInstance] startLoginTimer];
        } fail:^(NSError *error) {
            [weakSelf.userBiz.component stopBlockAnimation];
            weakSelf.operator.enabled = YES;
//            weakSelf.operator.textColor = CTThemeMainColor;
            weakSelf.operator.textColor = [UIColor blackColor];
        }];
    }
}


-(void)changeView:(int)state{
    __weak typeof(self) weakSelf = self;
//    CGRect phoneNumRect = weakSelf.phoneNum.frame;
//    CGRect verifyCodeRect = weakSelf.verifyCodeView.frame;
  
    if(state == 0){
        if(![self.phoneNum isEditing]){
//            phoneNumRect.origin.x = 0;
          weakSelf.phoneNumX.constant = 0;
          weakSelf.verifyCodeX.constant = SCREEN_WIDTH;
//            verifyCodeRect.origin.x = SCREEN_WIDTH;
        }
    }else if(state == 1){
        if(![self.verifyCode isEditing]){
          weakSelf.phoneNumX.constant = -SCREEN_WIDTH;
          weakSelf.verifyCodeX.constant = 0;
//            phoneNumRect.origin.x = -SCREEN_WIDTH;
//            verifyCodeRect.origin.x = SCREEN_WIDTH;
//            weakSelf.verifyCodeView.frame = verifyCodeRect;
            weakSelf.verifyCodeView.hidden = NO;
//            verifyCodeRect.origin.x = 0;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.phoneNum.frame = phoneNumRect;
//        weakSelf.verifyCodeView.frame = verifyCodeRect;
    }completion:^(BOOL finished) {
        if(state == 0){
            [weakSelf.phoneNum becomeFirstResponder];
        }else if (state == 1){
            [weakSelf.verifyCode becomeFirstResponder];
        }
    }];
}

//登录
-(void)login{
    __weak typeof(self) weakSelf = self;
    [self setOperatorState:4 str:nil];
    [self.userBiz loginWithPhone:self.phoneNum.text verifyCode:self.verifyCode.text success:^(CGUserEntity *user) {
        [[ObjectShareTool sharedInstance] stopLoginTimer];
        //登录成功，加载用户信息
        [weakSelf.userBiz queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
          [weakSelf.userBiz userMessageTagsWithSuccess:^(NSMutableArray *result) {
            [UMessage addTag:result response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
              
            }];
          } fail:^(NSError *error) {
            
          }];
          
          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil];
          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
          if(weakSelf.loginSuccess){
            weakSelf.loginSuccess(user);
          }
          [self closeKeyBoard];
            [weakSelf dismiss];
        } fail:^(NSError *error) {
          
        }];
    } fail:^(NSError *error) {
        weakSelf.verifyCode.text = nil;
        [weakSelf setVerifyCode];
        if([ObjectShareTool sharedInstance].loginVerifyTimer){
            weakSelf.operator.tag = 2;
        }else{
            [weakSelf setOperatorState:3 str:nil];
        }
    }];
}

//重新绑定手机
-(void)changePhone{
  __weak typeof(self) weakSelf = self;
  [self setOperatorState:4 str:nil];
  [self.userBiz authUserChangephoneWithPhone:self.phoneNum.text verifyCode:self.verifyCode.text success:^{
    [[ObjectShareTool sharedInstance] stopLoginTimer];
    //登录成功，加载用户信息
    [weakSelf.userBiz queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
      if(weakSelf.loginSuccess){
        weakSelf.loginSuccess(user);
      }
      [self closeKeyBoard];
      NSInteger index = [[weakSelf.navigationController viewControllers]indexOfObject:weakSelf];
      [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    } fail:^(NSError *error) {
      
    }];
  } fail:^(NSError *error) {
//      NSDictionary *dic = error.userInfo;
//      [CTToast showWithText:[NSString stringWithFormat:@"绑定手机号失败 : %@",  dic[@"message"]]];
      
    weakSelf.verifyCode.text = nil;
    [weakSelf setVerifyCode];
    if([ObjectShareTool sharedInstance].loginVerifyTimer){
      weakSelf.operator.tag = 2;
    }else{
      [weakSelf setOperatorState:3 str:nil];
    }
  }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)messageClick{
    __weak typeof(self) weakSelf = self;
    [self.voiceBtn setUserInteractionEnabled:NO];
    [self.userBiz userVoiceVerifycodeWithPhone:self.phoneNum.text success:^{
        [[CTToast makeText:@"你马上将收到来电播放验证码"]show:weakSelf.view];
        [weakSelf.voiceBtn setUserInteractionEnabled:YES];
    } fail:^(NSError *error) {
        [weakSelf.voiceBtn setUserInteractionEnabled:YES];
    }];
}

- (IBAction)verifyCodeClick:(UIButton *)sender {
  [self.verifyCode becomeFirstResponder];
}

- (void)handleTap {
    [self.view endEditing:YES];
}

- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismiss {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
}

@end
