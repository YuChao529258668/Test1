//
//  CGOrderProgressTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderProgressTableViewCell.h"

@interface CGOrderProgressTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation CGOrderProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  UIImage * backImage;
  backImage = [UIImage imageNamed:@"order_box"];
  backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
  self.bgImageView.image = backImage;
  self.pointButton.layer.cornerRadius = 4.5;
  self.pointButton.layer.masksToBounds = YES;
  self.title.textColor = CTThemeMainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGOrderProgressEntity *)entity{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.createtime/1000];
  NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
  self.time.text = [NSString stringWithFormat:@"%@",confromTimespStr];
  switch (entity.orderState) {
    case 1:
      self.title.text = @"待付款";
      break;
    case 2:
      self.title.text = @"待完成";
      break;
    case 3:
      self.title.text = @"已取消";
      break;
    case 4:
      self.title.text = @"待收货";
      break;
    case 5:
      self.title.text = @"已完成";
      break;
    case 6:
      self.title.text = @"售后中";
      break;
      
    default:
      break;
  }
  self.detail.text = entity.remarks;
}
@end
