//
//  CGSourceTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/4/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSourceTableViewCell.h"

@implementation CGSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.layer.masksToBounds = YES;
    // Initialization code
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.layer.borderColor = CTCommonLineBg.CGColor;
  self.button.layer.borderWidth = 1;
  self.source.textColor = CTThemeMainColor;
  self.source.layer.cornerRadius = 4;
  self.source.layer.borderColor = CTThemeMainColor.CGColor;
  self.source.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)update:(CGInfoDetailEntity *)entity{
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.authorIcon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (error) {
      self.icon.hidden = YES;
      self.iconWidth.constant = 0;
    }
  }];
  self.title.text = entity.authorName;
  self.source.text = entity.source;
  [self.source sizeToFit];
  if ([CTStringUtil stringNotBlank:entity.source]) {
   self.sourceWidth.constant = self.source.frame.size.width+10;
  }else{
    self.sourceWidth.constant = 0;
  }
  self.button.hidden = [CTStringUtil stringNotBlank:entity.url]?NO:YES;
  self.buttonWidth.constant = [CTStringUtil stringNotBlank:entity.url]?75:0;
  if (![CTStringUtil stringNotBlank:entity.authorName]&&![CTStringUtil stringNotBlank:entity.source]) {
    self.text.hidden = YES;
    [self.button setTitle:@"打开网址" forState:UIControlStateNormal];
  }else{
    self.text.hidden = NO;
    [self.button setTitle:@"访问原网址" forState:UIControlStateNormal];
  }
}
@end
