//
//  CGToolTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGToolTableViewCell.h"

@implementation CGToolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.layer.borderWidth = 1;
  self.button.layer.borderColor = CTThemeMainColor.CGColor;
  [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  self.label.layer.cornerRadius = 4;
  self.label.layer.borderColor = CTThemeMainColor.CGColor;
  self.label.layer.borderWidth = 1;
  self.label.textColor = CTThemeMainColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(CGInfoHeadEntity *)info{
  if (info.title.length>0) {
    NSInteger fontSize = 17;
    switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
      case 1:
        fontSize = 17;
        break;
      case 2:
        fontSize = 19;
        break;
      case 3:
        fontSize = 20;
        break;
      case 4:
        fontSize = 24;
        break;
        
      default:
        break;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
    self.title.attributedText = attributedString;
  }else{
    self.title.text = @"";
  }
  if ([CTStringUtil stringNotBlank:info.label]) {
    self.label.text = info.label;
    [self.label sizeToFit];
    self.labelWidth.constant = self.label.frame.size.width;
  }else{
    self.labelWidth.constant = 0;
    self.sourceTrailing.constant = 0;
  }
  
  if([CTStringUtil stringNotBlank:info.source]){
    self.source.text = [NSString stringWithFormat:@"%@ %@",info.source,[CTDateUtils getTimeFormatFromDateLong:info.createtime]];
  }else{
    self.source.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
  }
  
  if ([CTStringUtil stringNotBlank:info.navtype]) {
    self.source.text = [NSString stringWithFormat:@"%@ %@",info.navtype,self.source.text];
  }
  
  if ([CTStringUtil stringNotBlank:info.desc]) {
    self.titleCenter.constant = -20;
    self.desc.text = info.desc;
  }else{
    self.desc.text = @"";
    self.titleCenter.constant = 0;
  }
  
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
}
@end
