//
//  CGUserMemberHeaderTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserMemberHeaderTableViewCell.h"

@implementation CGUserMemberHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  self.buyVIP.layer.cornerRadius = 4;
  self.buyVIP.layer.masksToBounds = YES;
  [self.buyVIP setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  self.InviteColleagues.layer.cornerRadius = 4;
  self.InviteColleagues.layer.masksToBounds = YES;
  [self.InviteColleagues setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  self.contentView.backgroundColor = CTThemeMainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
