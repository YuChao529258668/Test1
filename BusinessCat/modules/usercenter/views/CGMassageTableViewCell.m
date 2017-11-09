//
//  CGMassageTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMassageTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CGMassageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.icon.layer.cornerRadius = 4;
  self.icon.layer.masksToBounds = YES;
  self.numberLabel.layer.cornerRadius = 9;
  self.numberLabel.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGMessageEntity *)entity{
  self.title.text = entity.name;
  self.desc.text = entity.message;
  self.time.text = [CTDateUtils getTimeFormatFromDateLong:entity.time];
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
  self.icon.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.color];
  if (entity.count>0) {
    self.numberLabel.hidden = NO;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",entity.count];
    [self.numberLabel sizeToFit];
    self.numberLabelWidth.constant = self.numberLabel.frame.size.width+12;
  }else{
    self.numberLabel.hidden = YES;
  }
}

@end
