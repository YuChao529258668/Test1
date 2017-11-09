//
//  CGUserAttestationImageTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserAttestationImageTableViewCell.h"

@implementation CGUserAttestationImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.icon.layer.cornerRadius = 4;
  self.icon.layer.borderColor = CTCommonLineBg.CGColor;
  self.icon.layer.borderWidth = 0.5;
  self.icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
