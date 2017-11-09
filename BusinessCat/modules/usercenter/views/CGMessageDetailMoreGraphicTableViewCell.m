//
//  CGMessageDetailMoreGraphicTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageDetailMoreGraphicTableViewCell.h"

@implementation CGMessageDetailMoreGraphicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.bgView.layer.cornerRadius = 8;
  self.bgView.layer.masksToBounds = YES;
  self.bgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.bgView.layer.borderWidth = 0.5;
  self.bgLineView.layer.borderColor = CTCommonLineBg.CGColor;
  self.bgLineView.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGMessageDetailEntity *)entity{
  self.title.text = entity.infoTitle;
  self.headerIV.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.headerColor];
  [self.headerIV sd_setImageWithURL:[NSURL URLWithString:entity.headerImg]];
  [self.IV sd_setImageWithURL:[NSURL URLWithString:entity.infoPic] placeholderImage:[UIImage imageNamed:@"morentu"]];
}
@end
