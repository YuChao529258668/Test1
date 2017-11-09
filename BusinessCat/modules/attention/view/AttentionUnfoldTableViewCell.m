//
//  AttentionUnfoldTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionUnfoldTableViewCell.h"

@implementation AttentionUnfoldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(BOOL)isUnfold{
  if (isUnfold) {
    self.titleLabel.text = @"收起更多";
    self.icon.image = [UIImage imageNamed:@"Pull"];
  }else{
    self.titleLabel.text = @"展开更多";
    self.icon.image = [UIImage imageNamed:@"drop-down"];
  }
}
@end
