//
//  CGIntegralTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGIntegralTableViewCell.h"

@implementation CGIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(IntegralListEntity *)entity{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY年MM月DD日"];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.dateTime/1000];
  NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
  self.title.text = confromTimespStr;
  self.title.text = entity.title;
  if (entity.rewardType == 1) {
    self.integral.textColor = CTThemeMainColor;
    self.integral.text = [NSString stringWithFormat:@"+%@",entity.rewardInfo];
  }else{
    self.integral.textColor = [CTCommonUtil convert16BinaryColor:@"#EF5457"];
    self.integral.text = [NSString stringWithFormat:@"-%@",entity.rewardInfo];
  }
}

@end
