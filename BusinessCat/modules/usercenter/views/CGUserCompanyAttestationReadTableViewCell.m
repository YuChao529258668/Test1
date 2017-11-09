//
//  CGUserCompanyAttestationReadTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyAttestationReadTableViewCell.h"

@implementation CGUserCompanyAttestationReadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectClick:(UIButton *)sender {
  sender.selected = !sender.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
