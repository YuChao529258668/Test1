//
//  CGOrderTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderTableViewCell.h"
#import <UIButton+WebCache.h>

@interface CGOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *massage;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIView *relationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relationVIewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relationViewY;
@property (weak, nonatomic) IBOutlet UILabel *relationName;
@property (weak, nonatomic) IBOutlet UILabel *relationDsec;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *rightTwoButton;
@property (nonatomic, strong) CGOrderEntity *entity;
@property (nonatomic, copy) CGOrderTableButtonViewCellBlock block;
@end

@implementation CGOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.rightButton.layer.borderColor = TEXT_MAIN_CLR.CGColor;
  self.rightButton.layer.borderWidth = 1;
  self.rightButton.layer.masksToBounds = YES;
  self.rightButton.layer.cornerRadius = 4;
  self.rightTwoButton.layer.borderColor = TEXT_MAIN_CLR.CGColor;
  self.rightTwoButton.layer.borderWidth = 1;
  self.rightTwoButton.layer.masksToBounds = YES;
  self.rightTwoButton.layer.cornerRadius = 4;
  self.relationView.layer.cornerRadius = 4;
  self.relationView.layer.masksToBounds = YES;

}

-(void)update:(CGOrderEntity *)entity block:(CGOrderTableButtonViewCellBlock)block{
  self.entity = entity;
  self.block = block;
  self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",entity.orderId];
  switch (entity.orderState) {
    case 1:
      self.massage.text = @"待付款";//
      break;
    case 2:
      self.massage.text = @"待完成";//
      break;
    case 3:
      self.massage.text = @"已取消";//
      break;
    case 4:
      self.massage.text = @"待收货";
      break;
    case 5:
      self.massage.text = @"已完成";
      break;
    case 6:
      self.massage.text = @"售后中";
      break;
      
    default:
      break;
  }
  self.title.text = entity.orderTitle;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.orderTime/1000];
  NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
  self.time.text = [NSString stringWithFormat:@"%@",confromTimespStr];
  
  switch (entity.payState) {
    case 0:
      self.massage.text = [NSString stringWithFormat:@"%@,未支付",self.massage.text];
      self.money.text = [NSString stringWithFormat:@"需付款：%.2f",entity.orderAmount/100.0];
      break;
    case 1:
      self.massage.text = [NSString stringWithFormat:@"%@,已支付",self.massage.text];
      self.money.text = [NSString stringWithFormat:@"已付款：%.2f",entity.orderAmount/100.0];
      break;
    case 2:
      self.massage.text = [NSString stringWithFormat:@"%@,支付失败",self.massage.text];
      self.money.text = [NSString stringWithFormat:@"已付款：%.2f",entity.orderAmount/100.0];
      break;
    case 3:
      self.massage.text = [NSString stringWithFormat:@"%@,已退款",self.massage.text];
      self.money.text = [NSString stringWithFormat:@"已付款：%.2f",entity.orderAmount/100.0];
      break;
      
    default:
      break;
  }
  
  NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.massage.text];
  [attrStr addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:12.0f]
                  range:NSMakeRange(0, self.massage.text.length)];
  [attrStr addAttribute:NSForegroundColorAttributeName
                  value:TEXT_MAIN_CLR
                  range:NSMakeRange(0, self.massage.text.length)];
  if (entity.orderState == 1||entity.orderState == 2||entity.orderState == 3) {
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TEXT_RED_CLR
                    range:NSMakeRange(0, 3)];
  }
  self.massage.attributedText = attrStr;
  
  if (entity.relationList.count>0) {
    self.relationVIewHeight.constant = 60;
    self.relationViewY.constant = 10;
    if (entity.relationList.count == 1) {
      RelationEntity *relation = entity.relationList[0];
      self.relationName.hidden = NO;
      self.relationDsec.hidden = NO;
      self.relationName.text = relation.name;
      self.relationDsec.text = relation.companyName;
    }else{
      self.relationName.hidden = YES;
      self.relationDsec.hidden = YES;
    }
    for(UIView *view in [self.sv subviews])
    {
      [view removeFromSuperview];
    }
    
    for (int i = 0; i<entity.relationList.count; i++) {
      UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+i*50, 10, 40, 40)];
      [self.sv addSubview:btn];
      RelationEntity *relation = entity.relationList[i];
      [btn sd_setImageWithURL:[NSURL URLWithString:relation.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
    }
    [self.sv setContentSize:CGSizeMake(15+entity.relationList.count*50, 0)];
  }else{
    self.relationVIewHeight.constant = 0;
    self.relationViewY.constant = 0;
  }
  
  if ((entity.orderState == 1&&entity.payState == 0)||(entity.orderState == 1&&entity.payState == 2)) {
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightTwoButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
  }else if ((entity.orderState == 2&&entity.payState == 1)||(entity.orderState == 3&&entity.payState == 1)){
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
  }else if (entity.orderState == 3&&entity.payState == 1){
    self.rightButton.hidden = NO;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
  }else if (entity.orderState == 5&&entity.payState == 1){
    self.rightButton.hidden = YES;
    self.rightTwoButton.hidden = YES;
    [self.rightButton setTitle:@"申请售后" forState:UIControlStateNormal];
  }else{
    self.rightButton.hidden = YES;
    self.rightTwoButton.hidden = YES;
  }
  
}

+(CGFloat)height:(CGOrderEntity *)entity{
  CGFloat height = 0;
  if ((entity.orderState == 1&&entity.payState == 0)||(entity.orderState == 1&&entity.payState == 2)||(entity.orderState == 2&&entity.payState == 1)||(entity.orderState == 3&&entity.payState == 1)||(entity.orderState == 3&&entity.payState == 1)) {
    height = 0;
  }else{
    height = 45;
  }
  if (entity.relationList.count<=0) {
    return 163-height;
  }
  return 238-height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)rightTwoClick:(UIButton *)sender {
  self.block(self.entity, 1,sender);
}

- (IBAction)rightClick:(UIButton *)sender {
  self.block(self.entity, 2,sender);
}
@end
