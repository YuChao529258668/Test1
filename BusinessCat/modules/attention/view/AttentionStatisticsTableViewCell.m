//
//  AttentionStatisticsTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionStatisticsTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface AttentionStatisticsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftNumber;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightNumber;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@end

@implementation AttentionStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct1:(AttentionStatisticsEntity *)product1 {
  _product1 = product1;
  self.leftView.hidden = NO;
  [self.leftIcon sd_setImageWithURL:[NSURL URLWithString:product1.icon]];
  self.leftTitle.text = product1.typeName;
  if (product1.count<=0) {
    self.leftNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#B1B1B1"];
  }else{
    self.leftNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#F07E36"];
  }
  self.leftNumber.text = [NSString stringWithFormat:@"%ld",product1.count];
}

- (void)setProduct2:(AttentionStatisticsEntity *)product2 {
  _product2 = product2;
  self.rightView.hidden = NO;
  [self.rightIcon sd_setImageWithURL:[NSURL URLWithString:product2.icon]];
  self.rightTitle.text = product2.typeName;
  if (product2.count<=0) {
    self.rightNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#B1B1B1"];
  }else{
    self.rightNumber.textColor = [CTCommonUtil convert16BinaryColor:@"#F07E36"];
  }
  self.rightNumber.text = [NSString stringWithFormat:@"%ld",product2.count];
}

- (IBAction)leftClick:(UIButton *)sender {
  [self.delegate doProductDetailWithEntity:self.product1];
}

- (IBAction)rightClick:(UIButton *)sender {
  [self.delegate doProductDetailWithEntity:self.product2];
}

@end
