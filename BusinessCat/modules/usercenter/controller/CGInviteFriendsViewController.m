//
//  CGInviteFriendsViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInviteFriendsViewController.h"
#import "ShareUtil.h"
#import "CGUserCenterBiz.h"
#import "CGCompanyDao.h"

@interface CGInviteFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *copButton;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberViewWidth;
@property (nonatomic, copy) NSString *number;
@property (weak, nonatomic) IBOutlet UILabel *inviteCode;
@property (nonatomic, strong) ShareUtil *shareUtil;
@property (weak, nonatomic) IBOutlet UILabel *friendNum;
@property (weak, nonatomic) IBOutlet UILabel *inviteNum;
@end

@implementation CGInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"邀请好友";
  self.inviteButton.backgroundColor = CTThemeMainColor;
  self.inviteButton.layer.cornerRadius = 4;
  self.inviteButton.layer.masksToBounds = YES;
  [self.copButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  __weak typeof(self) weakSelf = self;
  [[[CGUserCenterBiz alloc] init] authUserInviteFriendsSuccess:^(CGInviteFriendEntity *reslut) {
    [CGCompanyDao saveInviteFriendsStatistics:reslut];
    [ObjectShareTool sharedInstance].inviteFriend = reslut;
    [weakSelf updateNumberView];
  } fail:^(NSError *error) {
    [ObjectShareTool sharedInstance].inviteFriend = [CGCompanyDao getInviteFriendsStatisticsFromLocal];
  }];
  [self updateNumberView];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateNumberView{
  self.number = [NSString stringWithFormat:@"%ld",[ObjectShareTool sharedInstance].inviteFriend.countInvite];
  for (UIView *view in self.numberView.subviews) {
    [view removeFromSuperview];
  }
  for (int i = 0; i<self.number.length; i++) {
    NSString *str = [self.number substringWithRange:NSMakeRange(i,1)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*21, 2, 16, 16)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.text = str;
    label.layer.cornerRadius = 2;
    label.layer.masksToBounds = YES;
    label.backgroundColor = TEXT_MAIN_CLR;
    [self.numberView addSubview:label];
  }
  self.numberViewWidth.constant = 21*self.number.length-5;
  self.inviteCode.text = [ObjectShareTool sharedInstance].inviteFriend.invitationCode;
  self.friendNum.text = [NSString stringWithFormat:@"%ld",[ObjectShareTool sharedInstance].inviteFriend.inviteNum];
  self.inviteNum.text = [NSString stringWithFormat:@"%ld",[ObjectShareTool sharedInstance].inviteFriend.bonusPoints];
}

- (IBAction)copyClick:(UIButton *)sender {
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  NSString *str = [NSString stringWithFormat:@"%@",[ObjectShareTool sharedInstance].inviteFriend.invitationCode];
  pasteboard.string = str;
}

- (IBAction)inviteClick:(UIButton *)sender {
  [self ShareAction];
}

//分享
-(void)ShareAction{
  NSString *url = [ObjectShareTool sharedInstance].inviteFriend.invitationUrl;
  NSString *title = [NSString stringWithFormat:@"%@邀请你加入广州创将。马上点击链接%@ ,下载app后通过微信或手机号登录，团队成员都在等你了，点击链接快快加入哦！",[ObjectShareTool sharedInstance].currentUser.username,[ObjectShareTool sharedInstance].inviteFriend.invitationUrl];
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  UIImage *image = [UIImage imageNamed:@"login_image"];
  [self.shareUtil showShareMenuWithTitle:@"" desc:title isqrcode:1 image:image url:url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
