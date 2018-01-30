//
//  CGUserTextViewController.m
//  CGSays
//
//  Created by zhu on 16/11/2.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserTextViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserChoseCompanyViewController.h"
#import "CGUserChoseSchoolViewController.h"
#import "LightExpBiz.h"

@interface CGUserTextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger maxLenght;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) LightExpBiz *ligbiz;
@property (nonatomic, copy) CGUserTextBlock block;
@end

@implementation CGUserTextViewController

-(instancetype)initWithBlock:(CGUserTextBlock)release{
  self = [super init];
  if(self){
    self.block = release;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  self.ligbiz = [[LightExpBiz alloc]init];
  self.maxLenght = 100;
  switch (self.textType) {
    case UserTextTypeNickName:
      self.title = @"设置昵称";
      self.maxLenght = 20;
      break;
    case UserTextTypeUserName:
      self.title = @"设置姓名";
      self.maxLenght = 20;
      break;
    case UserTextTypeDepartment:
      self.title = @"部门";
      break;
    case UserTextTypePosition:
      self.title = @"职位";
      break;
    case UserTextTypeCompanyName:
      self.title = @"公司名";
      break;
    case UserTextTypeUserIntro:
      self.title = @"一句话介绍";
      break;
    case UserTextTypeidCardCode:
      self.title = @"身份证";
      self.maxLenght = 18;
      break;
    case UserTextTypeCreatClasses:
      self.title = @"创建班级";
      break;
    case UserTextTypeCreatDepartment:
      self.title = @"创建部门";
      break;
    case UserTextTypeChosePosition:
      self.title = @"编辑职位";
      break;
    case UserTextTypeAddGroup:
      self.title = @"添加组";
      break;
    case UserTextTypeEditDepartment:
      self.title = @"修改部门名称";
      break;
    case UserTextTypeEmail:
      self.title = @"设置邮箱";
      break;
    case UserTextTypeAbbreviation:
      self.title = @"设置企业简称";
      break;
    case UserTextTypeFullName:
      self.title = @"设置企业全称";
      break;
    case UserTextTypeTelephone:
      self.title = @"设置固定电话";
      break;
    case UserTextTypeOfficialWebsite:
      self.title = @"设置官方电话";
      break;
    case UserTextTypeOfficialMailbox:
      self.title = @"设置官方邮箱";
      break;
    case UserTextTypeAffiliation:
      self.title = @"设置所属行业";
      break;
    case UserTextTypeNumberEmployees:
      self.title = @"设置员工人数";
      break;
    case UserTextTypeArea:
      self.title = @"设置所在地区";
      break;
    case UserTextTypeDetailedAddress:
      self.title = @"设置详细地址";
      break;
    case UserTextTypeCorrectionTitle:
      self.title = @"修改标题";
      break;
    case UserTextTypeCorrectionTime:
      self.title = @"修改创建时间";
      self.textField.placeholder = @"格式：20170602123042";
      break;
    case UserTextTypeCorrectionUrl:
      self.title = @"设置网址";
      break;
    default:
      break;
  }
  self.textField.text = self.text;
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
  self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
  [self.navi addSubview:self.rightBtn];
  [self.textField becomeFirstResponder];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                              name:@"UITextFieldTextDidChangeNotification"
                                            object:self.textField];
}


- (void)rightBtnAction:(UIButton *)sender{
  __weak typeof(self) weakSelf = self;
  if (self.textField.text.length<=0) {
    NSString *title;
    switch (self.textType) {
      case UserTextTypeNickName:
        title = @"昵称不能为空";
        break;
      case UserTextTypeUserName:
        title = @"姓名不能为空";
        break;
      case UserTextTypeDepartment:
        title = @"部门名字不能为空";
        break;
      case UserTextTypePosition:
        title = @"职位不能为空";
        break;
      case UserTextTypeCompanyName:
        title = @"公司名不能为空";
        break;
      case UserTextTypeidCardCode:
        title = @"身份证不能为空";
        break;
      case UserTextTypeCreatClasses:
        title = @"班级名字不能为空";
        break;
      case UserTextTypeCreatDepartment:
        title = @"部门名字不能为空";
        break;
      case UserTextTypeChosePosition:
        title = @"职位不能为空";
        break;
      case UserTextTypeAddGroup:
        title = @"组名不能为空";
        break;
      case UserTextTypeEditDepartment:
        title = @"部门名称不能为空";
        break;
      case UserTextTypeAbbreviation:
        title = @"企业简称不能为空";
        break;
      case UserTextTypeFullName:
        title = @"企业全称不能为空";
        break;
      case UserTextTypeTelephone:
        title = @"固定电话不能为空";
        break;
      case UserTextTypeOfficialWebsite:
        title = @"官方电话不能为空";
        break;
      case UserTextTypeOfficialMailbox:
        title = @"官方邮箱不能为空";
        break;
      case UserTextTypeAffiliation:
        title = @"所属行业不能为空";
        break;
      case UserTextTypeNumberEmployees:
        title = @"员工人数不能为空";
        break;
      case UserTextTypeArea:
        title = @"所在地区不能为空";
        break;
      case UserTextTypeDetailedAddress:
        title = @"详细地址不能为空";
        break;
      case UserTextTypeCorrectionTitle:
        title = @"标题不能为空";
        break;
      case UserTextTypeCorrectionTime:
        title = @"时间不能为空";
        break;
      case UserTextTypeCorrectionUrl:
        title = @"网址不能为空";
        break;
      default:
        break;
    }
    if(title){
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      [[CTToast makeText:title]show:window];
      return;
    }
  }else{
    if(self.textType == UserTextTypeEmail||self.textType == UserTextTypeOfficialMailbox){
      if(![CTVerifyTool isEmail:self.textField.text]){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"请输入正确的邮箱"]show:window];
        return;
      }
    }
  }
  
  if (self.textType == UserTextTypeCreatClasses) {
    sender.selected = YES;
    [sender setUserInteractionEnabled:NO];
    [self.biz.component startBlockAnimation];
    [self.biz organizaCreateClassWithClassID:self.organizeID depaId:self.depaId name:self.textField.text success:^{
      weakSelf.block(weakSelf.textField.text,@"",weakSelf.textType);
      [weakSelf.navigationController
       popViewControllerAnimated:YES];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
      [sender setUserInteractionEnabled:YES];
      sender.selected = NO;
    }];
  }else if (self.textType == UserTextTypeCreatDepartment){
    sender.selected = YES;
    [sender setUserInteractionEnabled:NO];
    [self.biz.component startBlockAnimation];
    [self.biz organizaCreateDepaWithDepaID:self.organizeID type:self.type name:self.textField.text success:^(NSString *depaID){
      weakSelf.block(weakSelf.textField.text,depaID,weakSelf.textType);
      [weakSelf.navigationController
       popViewControllerAnimated:YES];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      //            [[CTToast makeText:[NSString stringWithFormat:@"部门%@，请重新修改",[error.userInfo objectForKey:@"message"]]]show:self.view];
      [weakSelf.biz.component stopBlockAnimation];
      [sender setUserInteractionEnabled:YES];
      sender.selected = NO;
    }];
  }else if (self.textType == UserTextTypeChosePosition&& self.isChose == YES){
    self.info.position = self.textField.text;
    CGUserChoseCompanyViewController *vc = [[CGUserChoseCompanyViewController alloc]init];
    vc.info = self.info;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (self.textType == UserTextTypeEditDepartment){
    [self.biz.component startBlockAnimation];
    [self.biz userOrganizaDepaUpdateWithOrganizaId:self.organizeID depaId:self.depaId type:self.type name:self.textField.text success:^{
      weakSelf.block(weakSelf.textField.text,@"",weakSelf.textType);
      [weakSelf.navigationController
       popViewControllerAnimated:YES];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      //            [[CTToast makeText:[NSString stringWithFormat:@"部门%@",[error.userInfo objectForKey:@"message"]]]show:self.view];
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }else{
    [self.textField resignFirstResponder];
    weakSelf.block(self.textField.text,@"",self.textType);
    [self.navigationController
     popViewControllerAnimated:YES];
  }
  
}

-(void)textFiledEditChanged:(NSNotification *)obj{
  UITextField *textField = (UITextField *)obj.object;
  
  NSString *toBeString = textField.text;
  NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
  if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
      if (toBeString.length > self.maxLenght) {
        textField.text = [toBeString substringToIndex:self.maxLenght];
      }
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
      
    }
  }
  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
  else{
    if (toBeString.length > self.maxLenght) {
      textField.text = [toBeString substringToIndex:self.maxLenght];
    }
  }
}

-(void)dealloc{
  [[NSNotificationCenter defaultCenter]removeObserver:self
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:self.textField];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
  [self.ligbiz.component stopBlockAnimation];
}

@end
