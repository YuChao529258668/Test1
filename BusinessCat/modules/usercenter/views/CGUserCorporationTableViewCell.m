//
//  CGUserCorporationTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCorporationTableViewCell.h"

@implementation CGUserCorporationTableViewCell

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
- (void)didSelectedButtonIndex:(SelectedButtonIndex)block{
  self.block = block;
}

- (void)info:(CGUserEntity *)userInfo{
//  if (userInfo.organizaType == 2) {
//    self.addressBookLabel.text = @"班级通讯录";
//    self.inviteLabel.text = @"邀请同学";
//    self.attestationLabel.text = @"认证班级";
//  }else{
//    self.addressBookLabel.text = @"通讯录";
//    self.inviteLabel.text = @"邀请同事";
//    self.attestationLabel.text = @"认证企业";
//  }
}

@end
