//
//  CGMessageDetailTextTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageDetailTextTableViewCell.h"

@implementation CGMessageDetailTextTableViewCell

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
  self.intro.text = [CTDateUtils getTimeFormatFromDateLong:entity.createTime];
  NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[entity.infoHtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
  self.desc.attributedText = attrStr;
  CGFloat height =  [self.desc.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
  self.descHeight.constant = height;
  self.height = height +150;

}
@end
