//
//  CGInviteMembersViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInviteMembersViewController.h"
#import "CGHorrolView.h"
#import "CGUserOrganizaJoinEntity.h"
#import"QRCodeGenerator.h"
#import "ShareUtil.h"

@interface CGInviteMembersViewController ()
@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property (nonatomic, strong) NSMutableArray *headViewEntitys;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *ercodeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewY;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) ShareUtil *shareUtil;
@end

@implementation CGInviteMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"邀请成员";
  [self.topView addSubview:self.organizaHeaderView];
  self.shareButton.backgroundColor = CTThemeMainColor;
  self.shareButton.layer.cornerRadius = 4;
  self.shareButton.layer.masksToBounds = YES;
  if (self.headViewEntitys.count<=1) {
    self.bgViewY.constant = 64;
  }
  [self.organizaHeaderView setSelectIndex:(int)self.currentIndex];
}

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
  __weak typeof(self) weakSelf = self;
  if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
    _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      weakSelf.currentIndex = index;
      CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[index];
      self.ercodeImageView.image = [QRCodeGenerator qrImageForString:local.inviteUrl imageSize:250];
    }];
  }
  return _organizaHeaderView;
}

-(NSMutableArray *)headViewEntitys{
  if(!_headViewEntitys){
    _headViewEntitys = [NSMutableArray array];
    if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
      for(int i=0;i<[ObjectShareTool sharedInstance].currentUser.companyList.count;i++){
        CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[i];
        if (local.companyType !=4) {
          CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyName sort:i];
          if (i == 0) {
            self.ercodeImageView.image = [QRCodeGenerator qrImageForString:local.inviteUrl imageSize:250];
          }
          if ([self.companyID isEqualToString:local.companyId]) {
            self.currentIndex = i;
            self.ercodeImageView.image = [QRCodeGenerator qrImageForString:local.inviteUrl imageSize:250];
          }
          [_headViewEntitys addObject:organiza];
        }
      }
    }
  }
  return _headViewEntitys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareAction:(UIButton *)sender {
  CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[self.currentIndex];
  NSString *url = local.inviteUrl;
  NSString *desc = [NSString stringWithFormat:@"%@邀请你加入%@，很多成员已在里面，尽快加入哦。",[ObjectShareTool sharedInstance].currentUser.username,local.companyName];
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  UIImage *image = [UIImage imageNamed:@"login_image"];
  [self.shareUtil showShareMenuWithTitle:@"邀请你加入组织" desc:desc isqrcode:1 image:image url:url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}
@end
