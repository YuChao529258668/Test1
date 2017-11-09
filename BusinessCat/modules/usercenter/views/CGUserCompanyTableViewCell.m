//
//  CGUserCompanyTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyTableViewCell.h"

@interface CGUserCompanyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *firstIcon;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *privilegeLabel;

@end

@implementation CGUserCompanyTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}
- (IBAction)click:(UIButton *)sender {
  self.block(sender.tag);
}

- (void)info:(CGUserEntity *)userInfo{
//  if (userInfo.auditStete==1&&userInfo.companyManage==0&&userInfo.companyState==1) {
//    if (userInfo.organizaType == 2) {
//      self.firstLabel.text = @"班级通讯录";
//      self.inviteLabel.text = @"邀请同学";
//    }else{
//      self.firstLabel.text = @"通讯录";
//      self.inviteLabel.text = @"邀请同事";
//    }
//    self.firstIcon.image = [UIImage imageNamed:@"user_companyaddressbook"];
//  }else{
//    if (userInfo.organizaType == 2) {
//      self.firstLabel.text = @"认证班级";
//    }else{
//      self.firstLabel.text = @"认证企业";
//    }
//    self.firstIcon.image = [UIImage imageNamed:@"certification_company"];
//  }
}

- (void)didSelectedButtonIndex:(SelectedButtonIndex)block{
  self.block = block;
}
@end
