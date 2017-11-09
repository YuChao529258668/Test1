//
//  AttentionGroupTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionGroupTableViewCell.h"

@implementation AttentionGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(companyEntity *)entity{
  self.red.hidden = !entity.update;
  if (entity.auditState == 1) {
    self.titleWidth.constant = 20;
    self.arrow.hidden = NO;
  }else{
    self.arrow.hidden = YES;
    self.typeLabel.hidden = NO;
    self.typeLabel.text = @"加入审核中,暂时无法看";
    self.titleWidth.constant = 130;
  }
    if(entity.type == 2){//学校
      if ([CTStringUtil stringNotBlank:entity.className]) {
       self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",entity.depaName,entity.className];
      }else{
        self.titleLabel.text = entity.depaName;
      }
      self.descLabel.text = entity.title;
      self.redY.constant = 5;
      self.titleCenter.constant = -10;
    }else{
        self.titleLabel.text = entity.title;
      self.descLabel.text = @"";
      self.redY.constant = 15;
      self.titleCenter.constant = 0;
    }
}
@end
