//
//  CGDetailTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/21.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGDetailTableViewCell.h"

@implementation CGDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.iv.layer.shadowColor = [UIColor blackColor].CGColor;
  self.iv.layer.shadowOpacity = 0.8f;
  self.iv.layer.shadowRadius = 4.f;
  self.iv.layer.shadowOffset = CGSizeMake(4,4);
  self.iv.layer.shadowOffset = CGSizeMake(0,0);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDetailString:(NSString *)url{
  [self.iv sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end
