//
//  CGUserCompanyHeaderTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyHeaderTableViewCell.h"

@implementation CGUserCompanyHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.title.textColor = CTThemeMainColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
