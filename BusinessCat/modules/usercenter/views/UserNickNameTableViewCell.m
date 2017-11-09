//
//  UserNickNameTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/3.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "UserNickNameTableViewCell.h"

@implementation UserNickNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
