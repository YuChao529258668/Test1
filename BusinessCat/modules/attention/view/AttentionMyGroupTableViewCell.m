//
//  AttentionMyGroupTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionMyGroupTableViewCell.h"

@implementation AttentionMyGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(AttentionMyGroupEntity *)entity{
  self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",entity.title,entity.conditionNum];
  self.dataNumber.text = [NSString stringWithFormat:@"%ld",entity.newNum];
  self.allCountLabel.text = [NSString stringWithFormat:@"%ld数据",entity.countNum];
}
@end
