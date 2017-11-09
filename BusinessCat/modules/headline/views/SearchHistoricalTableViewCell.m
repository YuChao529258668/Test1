//
//  SearchHistoricalTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/11/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "SearchHistoricalTableViewCell.h"

@implementation SearchHistoricalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didClickDeleteIndexButtonWithString:(NSString *)string{
  self.nameLabel.text = string;
}

@end
