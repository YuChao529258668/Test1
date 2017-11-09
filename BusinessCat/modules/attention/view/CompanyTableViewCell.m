//
//  CompanyTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CompanyTableViewCell.h"

@implementation CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(AttentionHead *)entity{
  //  NSUserDefaults *fontSize = [NSUserDefaults standardUserDefaults];
  //  NSDictionary *dic = [fontSize objectForKey:NSUSERDEFAULT_FONTSIZE];
  //  NSNumber *systemFontSize = dic[@"systemFontSize"];
  //  desc.font = [UIFont systemFontOfSize:(systemFontSize.floatValue-3)];
  //  title.font = [UIFont systemFontOfSize:systemFontSize.floatValue];
  //  CGFloat titleHeight = title.frame.size.height;
  //  titleHeight = systemFontSize.floatValue;
  //  desc.frame = CGRectMake(desc.frame.origin.x, 75-(systemFontSize.floatValue+3), desc.frame.size.width, systemFontSize.floatValue-3);
  
  self.title.text = entity.title;
  NSString *lastDataNumStr = [NSString stringWithFormat:@"%d",entity.newNum];
//  if(entity.newNum > 999){
//    lastDataNumStr = @"999";
//  }
  self.dataNumber.text = lastDataNumStr;
  if (entity.newNum<=0) {
    self.dataNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#A2A2A2"];
  }else{
    self.dataNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#F07E36"];
  }
  NSString *allDataNumStr = [NSString stringWithFormat:@"%d",entity.countNum];
//  if(entity.countNum > 999){
//    allDataNumStr = @"999";
//  }
  
  self.allDataNumber.text = [NSString stringWithFormat:@"%@数据",allDataNumStr];
  self.time.text = [NSString stringWithFormat:@"%@",[CTDateUtils getTimeFormatFromDateLong:entity.attentionTime]];
}
@end
