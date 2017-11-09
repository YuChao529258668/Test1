//
//  CGMessageDetailSingleGraphicTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageDetailSingleGraphicTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CGMessageDetailSingleGraphicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.bgView.layer.cornerRadius = 8;
  self.bgView.layer.masksToBounds = YES;
  self.bgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.bgView.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGMessageDetailEntity *)entity{
  self.headerIV.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.headerColor];
  [self.headerIV sd_setImageWithURL:[NSURL URLWithString:entity.headerImg]];
  self.title.text = entity.infoTitle;
  self.time.text = [CTDateUtils getTimeFormatFromDateLong:entity.createTime];
  [self.IV sd_setImageWithURL:[NSURL URLWithString:entity.infoPic] placeholderImage:[UIImage imageNamed:@"morentu"]];
  self.desc.text = entity.infoIntro;
  
  
}

+(CGFloat)height:(CGMessageDetailEntity *)entity{
  CGFloat height = 268;
  NSMutableAttributedString *infoTitleAts = [[NSMutableAttributedString alloc] initWithString:entity.infoTitle];
  [infoTitleAts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, [entity.infoTitle length])];
  CGSize titleSize =  [infoTitleAts boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  
  NSMutableAttributedString *descAts = [[NSMutableAttributedString alloc] initWithString:entity.infoIntro];
  [descAts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [entity.infoIntro length])];
  CGSize descSize =  [descAts boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  return height+titleSize.height+descSize.height;
}

@end
