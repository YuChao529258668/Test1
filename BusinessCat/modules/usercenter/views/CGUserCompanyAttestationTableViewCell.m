//
//  CGUserCompanyAttestationTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCompanyAttestationTableViewCell.h"

@implementation CGUserCompanyAttestationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(UIButton *)sender {
  self.buttonBlock(sender.tag);
}

- (void)didSelectedButtonIndex:(ButtomClickIndexBlock)block{
  self.buttonBlock = block;
}
@end
