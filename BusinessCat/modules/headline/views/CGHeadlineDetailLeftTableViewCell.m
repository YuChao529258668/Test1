//
//  CGHeadlineDetailLeftTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGHeadlineDetailLeftTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CGHeadlineDetailLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(CGInfoHeadEntity *)entity{
  if (entity.type == 3) {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analytics"]];
  }else if (entity.type == 4){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analysis_character"]];
  }else if (entity.type == 8){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"defaultgraph"]];
  }
  self.titleLabel.text = entity.title;
  if (entity.type == 4 ||entity.type == 8) {
    if ([CTStringUtil stringNotBlank:entity.source]) {
      self.descLabel.text = entity.source;
      self.titleCenterY.constant = -12;
    }else{
      self.descLabel.text = @"";
      self.titleCenterY.constant = 0;
    }
  }else{
    self.descLabel.text = @"";
    self.titleCenterY.constant = 0;
  }
  
}

@end
