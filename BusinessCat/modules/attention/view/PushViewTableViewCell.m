//
//  PushViewTableViewCell.m
//  CGSays
//
//  Created by zhu on 2016/11/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "PushViewTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation PushViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateData:(InterfaceCatalogEntity *)entity{
  self.titleLabel.text = entity.name;
  [self.titleLabel sizeToFit];
//  if (entity.isRed) {
//    self.redLabel.hidden = NO;
//  }else{
//    self.redLabel.hidden = YES;
//  }
  self.titleWidth.constant = self.titleLabel.frame.size.width;
//  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
}
@end
