//
//  CGIntegralHeaderTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGIntegralHeaderTableViewCell.h"

@implementation CGIntegralHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.bgView.backgroundColor = CTThemeMainColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
