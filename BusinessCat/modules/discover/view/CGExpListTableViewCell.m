//
//  CGExpListTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGExpListTableViewCell.h"

@interface CGExpListTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;

@end

@implementation CGExpListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.icon.layer.cornerRadius = 4;
  self.icon.layer.masksToBounds = YES;
  self.lock.textColor = CTThemeMainColor;
  self.lock.layer.cornerRadius = 4;
  self.lock.layer.masksToBounds = YES;
  self.lock.layer.borderColor = CTThemeMainColor.CGColor;
  self.lock.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGExpListEntity *)entity{
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
  self.title.text = entity.title;
  if ([CTStringUtil stringNotBlank:entity.source]) {
   self.desc.text = [NSString stringWithFormat:@"%@",entity.source];
    self.iconCenter.constant = -13;
    self.titleCenter.constant = -13;
  }else{
    self.iconCenter.constant = 0;
    self.titleCenter.constant = 0;
  }
}

@end
