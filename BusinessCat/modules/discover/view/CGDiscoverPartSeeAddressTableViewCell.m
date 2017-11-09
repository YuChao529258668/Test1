//
//  CGDiscoverPartSeeAddressTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverPartSeeAddressTableViewCell.h"

@implementation CGDiscoverPartSeeAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didSelectedButtonIndex:(ButtomClickBlock)block{
  self.buttonBlock = block;
}

- (IBAction)click:(UIButton *)sender {
  self.buttonBlock(sender);
}

@end
