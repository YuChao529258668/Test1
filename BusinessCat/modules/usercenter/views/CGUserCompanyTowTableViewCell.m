//
//  CGUserCompanyTowTableViewCell.m
//  CGSays
//
//  Created by zhu on 2016/12/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyTowTableViewCell.h"
#import "CGUserOrganizaJoinEntity.h"
#import "ChangeOrganizationViewModel.h"
#import "TeamCircleLastStateEntity.h"

@implementation CGUserCompanyTowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didSelectedButtonIndex:(SelectedButtonIndex)block{
  self.block = block;
}

- (void)info:(NSMutableArray *)array{
  CGFloat width = SCREEN_WIDTH/4;
  NSMutableArray *viewArray = [NSMutableArray array];
  [viewArray addObject:[self createBusinessCircleMenuWith:CGRectMake(0, 0, width, 70) method:@selector(enterpriseCircle)]];
  [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"企业文库" imageName:@"my_jingpinbaogao" method:@selector(enterpriseFire) count:0]];
  [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"企业管家" imageName:@"secretary" method:@selector(housekeeper) count:0]];
  switch ([ChangeOrganizationViewModel getChangeOrganizationState]) {
    case ChangeOrganizationTypeSuperAdminYetClaimed:
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"认领组织" imageName:@"authenticationgsi" method:@selector(claimOrganize) count:[ChangeOrganizationViewModel getOrganizationYetClaimedCount]]];
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"加入审核" imageName:@"toexamine" method:@selector(JoinAudit) count:[ObjectShareTool sharedInstance].currentUser.auditNum]];
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"通讯录" imageName:@"jurisdiction" method:@selector(teamAddressBook) count:0]];
      break;
    case ChangeOrganizationSuperAdmin:
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"加入审核" imageName:@"toexamine" method:@selector(JoinAudit) count:[ObjectShareTool sharedInstance].currentUser.auditNum]];
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"通讯录" imageName:@"jurisdiction" method:@selector(teamAddressBook) count:0]];
      break;
    case ChangeOrganizationYetClaimed:
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"认领组织" imageName:@"authenticationgsi" method:@selector(claimOrganize) count:[ChangeOrganizationViewModel getOrganizationYetClaimedCount]]];
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"通讯录" imageName:@"jurisdiction" method:@selector(teamAddressBook) count:0]];
      break;
    case ChangeOrganizationBasicPermissions:
      [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"通讯录" imageName:@"jurisdiction" method:@selector(teamAddressBook) count:0]];
      break;
    case ChangeOrganizationNone:
      
      break;
      
    default:
      break;
  }
  [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"邀请成员" imageName:@"yaoqingtongshi" method:@selector(inviteMember) count:0]];
  if ([ChangeOrganizationViewModel isOrganizationPrivilege]) {
    [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"VIP企业特权" imageName:@"user_companyprivilege" method:@selector(teamPrivilege) count:0]];
  }else{
    [viewArray addObject:[self createOrganizeMenuWith:CGRectMake(0, 0, width, 70) titleStr:@"成为VIP企业" imageName:@"user_companyprivilege" method:@selector(teamPrivilege) count:[ChangeOrganizationViewModel getOrganizationPrivilegeCount]]];
  }
  
  for(UIView *view in [self.contentView subviews])
  {
    [view removeFromSuperview];
  }
  for (int i = 0; i<viewArray.count; i++) {
    UIView *view = viewArray[i];
    view.frame = CGRectMake(i%4*width, i/4*70, width, 70);
    [self.contentView addSubview:view];
  }
}

-(UIView *)createOrganizeMenuWith:(CGRect)frame titleStr:(NSString *)titleStr imageName:(NSString *)imageName method:(SEL)method count:(NSInteger)count{
  UIView *view = [[UIView alloc]initWithFrame:frame];
  view.userInteractionEnabled = YES;
  UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25/2, 70/2-25, 25, 25)];
  image.image = [UIImage imageNamed:imageName];
  UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:method];
  [view addGestureRecognizer:tapGesture];
  UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), frame.size.width, 25)];
  title.textAlignment = NSTextAlignmentCenter;
  title.textColor = [UIColor darkGrayColor];
  title.font = [UIFont systemFontOfSize:13];
  title.text = titleStr;
  [view addSubview:title];
  [view addSubview:image];
  if (count>0) {
   UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view addSubview:countLabel];
    countLabel.font = [UIFont systemFontOfSize:10];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.layer.cornerRadius = 5;
    countLabel.layer.masksToBounds = YES;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.text = [NSString stringWithFormat:@"%ld",count];
    [countLabel sizeToFit];
    countLabel.frame = CGRectMake((frame.size.width-countLabel.frame.size.width-10-10), 5, countLabel.frame.size.width+10, countLabel.frame.size.height);
    countLabel.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#F55A5D"];
  }
  
  return view;
}

-(UIView *)createBusinessCircleMenuWith:(CGRect)frame method:(SEL)method{
  TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
  UIView *view = [[UIView alloc]initWithFrame:frame];
  view.userInteractionEnabled = YES;
  UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25/2, 70/2-25, 25, 25)];
  [image sd_setImageWithURL:[NSURL URLWithString:entity.badge.portrait] placeholderImage:[UIImage imageNamed:@"my_qiyecircle"]];
  UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:method];
  [view addGestureRecognizer:tapGesture];
  UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), frame.size.width, 25)];
  title.textAlignment = NSTextAlignmentCenter;
  title.textColor = [UIColor darkGrayColor];
  title.font = [UIFont systemFontOfSize:13];
  title.text = @"企业圈";
  [view addSubview:title];
  [view addSubview:image];
  if(entity.count > 0){
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view addSubview:countLabel];
    countLabel.font = [UIFont systemFontOfSize:10];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.layer.cornerRadius = 5;
    countLabel.layer.masksToBounds = YES;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.text = [NSString stringWithFormat:@"%d",entity.count > 99 ? 99 : entity.count];
    [countLabel sizeToFit];
    countLabel.frame = CGRectMake((frame.size.width-countLabel.frame.size.width-10-10), 5, countLabel.frame.size.width+10, countLabel.frame.size.height);
    countLabel.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#F55A5D"];
  }else if(entity.badge.portrait){
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-8-10-10), 3, 8, 8)];
    [view addSubview:countLabel];
    countLabel.layer.cornerRadius = 4;
    countLabel.layer.masksToBounds = YES;
    countLabel.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#F55A5D"];
  }
  return view;
}

-(void)claimOrganize{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeClaim);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)JoinAudit{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeJoinAudit);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)teamManagement{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeManagement);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)teamAddressBook{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeAddressbook);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)inviteMember{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeNviteMembers);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)teamPrivilege{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypePrivilege);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)enterpriseCircle{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeEnterpriseCircle);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)enterpriseFire{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeEnterpriseFire);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}

-(void)housekeeper{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin ==NO) {
    self.block(OrganisationSelectTypeIsLogOut);
  }else if ([ObjectShareTool sharedInstance].currentUser.companyList.count>0) {
    self.block(OrganisationSelectTypeHousekeeper);
  }else{
    self.block(OrganisationSelectTypeToSearch);
  }
}
@end
