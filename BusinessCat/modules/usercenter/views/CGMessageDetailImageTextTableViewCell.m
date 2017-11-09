//
//  CGMessageDetailImageTextTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageDetailImageTextTableViewCell.h"

@implementation CGMessageDetailImageTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGMessageDetailListEntity *)entity{
  self.title.text = entity.infoTitle;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.infoPic] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
}

@end
