//
//  CGUserSearchCompanyTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserSearchCompanyTableViewCell.h"

@implementation CGUserSearchCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithEntity:(CGUserSearchCompanyEntity *)entity{
  self.nameLabel.text = entity.name;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
  self.icon.layer.cornerRadius = 8;
  self.icon.layer.borderWidth = 0.5;
  self.icon.layer.borderColor = CTCommonLineBg.CGColor;
  self.icon.layer.masksToBounds = YES;
  
  self.typeLabel.layer.cornerRadius = 2;
  self.typeLabel.layer.masksToBounds = YES;
  self.typeLabel.layer.borderWidth = 0.5;
  switch (entity.type) {
    case 1:
      {self.typeLabel.text = @"公司";
//          self.typeLabel.textColor = CTThemeMainColor;
//          self.typeLabel.layer.borderColor = CTThemeMainColor.CGColor;
          UIColor *color = [YCTool colorOfHex:0xf68731];
          self.typeLabel.textColor = color;
          self.typeLabel.layer.borderColor = color.CGColor;
      break;}
    case 2:
      self.typeLabel.text = @"学校";
      self.typeLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#ff9f9c"];
      self.typeLabel.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#ff9f9c"].CGColor;
      break;
    case 3:
      self.typeLabel.text = @"众创空间";
      self.typeLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#f9cc84"];
      self.typeLabel.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#f9cc84"].CGColor;
      break;
    case 4:
      self.typeLabel.text = @"其他组织";
      self.typeLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#beee8e"];
      self.typeLabel.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#beee8e"].CGColor;
      break;
      
    default:
      break;
  }
  [self.typeLabel sizeToFit];
  self.typeWidth.constant = self.typeLabel.frame.size.width+10;
}
@end
