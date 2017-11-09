//
//  CGInterfaceDetailTopTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/31.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceDetailTopTableViewCell.h"

@implementation CGInterfaceDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  self.leftBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.leftBgView.layer.borderWidth = 0.5;
  self.rightBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.rightBgView.layer.borderWidth = 0.5;
  self.centerBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.centerBgView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
