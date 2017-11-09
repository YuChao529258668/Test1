//
//  CGUserCompanyTypeTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyTypeTableViewCell.h"

@implementation CGUserCompanyTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.bgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.bgView.layer.borderWidth = 0.5;
    self.icon.backgroundColor = CTThemeMainColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
