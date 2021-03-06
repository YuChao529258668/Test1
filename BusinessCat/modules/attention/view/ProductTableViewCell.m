//
//  ProductTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "ProductTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation ProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:0.8]CGColor];
    self.icon.layer.borderWidth = 0.3;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(AttentionHead *)entity{  
  if (entity.type == 4) {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analysis_character"]];
  }else if (entity.type == 8){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"defaultgraph"]];
  }else if (entity.type == 3){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analytics"]];
  }else{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
  }
  self.contentView.backgroundColor = entity.isTop?[CTCommonUtil convert16BinaryColor:@"#f3f3f7"]:[UIColor whiteColor];
  self.title.text = entity.title;
  NSString *lastDataNumStr = [NSString stringWithFormat:@"%d",entity.newNum];
  if (entity.newNum<=0) {
    self.dataNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#A2A2A2"];
  }else{
    self.dataNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#F07E36"];
  }
  self.dataNumber.text = lastDataNumStr;
  NSString *allDataNumStr = [NSString stringWithFormat:@"%d",entity.countNum];
  self.allDataNumber.text = [NSString stringWithFormat:@"%@数据",allDataNumStr];
  if (entity.dataLatestTime<=0) {
    self.time.text = @"刚刚";
  }else{
  self.time.text = [NSString stringWithFormat:@"%@",[CTDateUtils getTimeFormatFromDateLong:entity.dataLatestTime]];
  }
}
@end
