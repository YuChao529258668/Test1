//
//  CGBuyMethodPaymentTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGBuyMethodPaymentTableViewCell.h"

@implementation CGBuyMethodPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGPayMethodEntity *)entity{
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
  self.title.text = entity.title;
}
@end
