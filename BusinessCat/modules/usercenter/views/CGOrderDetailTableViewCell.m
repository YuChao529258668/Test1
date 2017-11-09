//
//  CGOrderDetailTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOrderDetailTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface CGOrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *massage;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *relationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relationVIewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relationViewY;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation CGOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)height:(CGOrderEntity *)entity{
  CGFloat height = 137;
  if (entity.relationList.count>0) {
    height = height+entity.relationList.count*70;
  }
  if (entity.relationInfo.length>0) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:entity.relationInfo];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [entity.relationInfo length])];
    CGSize titleSize =  [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSString *companyName = @"";
    for (int i = 0; i<entity.relationList.count; i++) {
      RelationEntity *relation = entity.relationList[i];
      if (i == 0) {
        companyName = relation.name;
      }else{
        companyName = [NSString stringWithFormat:@"%@、%@",companyName,relation.name];
      }
    }
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"针对%@输出一下内容：",companyName]];
    [descAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [companyName length])];
    CGSize descSize =  [descAttributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    height = height+titleSize.height+descSize.height+25;
  }
  return height;
}

-(void)update:(CGOrderEntity *)entity{
  self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",entity.orderId];
  switch (entity.orderState) {
    case 1:
      self.massage.text = @"待付款";
      break;
    case 2:
      self.massage.text = @"待完成";
      break;
    case 3:
      self.massage.text = @"已取消";
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
  NSString *companyName = @"";
  if (entity.relationList.count>0) {
    for (UIView *view in self.relationView.subviews) {
      [view removeFromSuperview];
    }
    for (int i = 0; i<entity.relationList.count; i++) {
      RelationEntity *relation = entity.relationList[i];
      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*70, SCREEN_WIDTH-50, 60)];
      [self.relationView addSubview:view];
      view.backgroundColor = CTCommonViewControllerBg;
      UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
      [view addSubview:imageView];
      [imageView sd_setImageWithURL:[NSURL URLWithString:relation.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
      UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 12, view.frame.size.width-125, 15)];
      titleLabel.text = relation.name;
      titleLabel.font = [UIFont systemFontOfSize:12];
      titleLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#232323"];
      [view addSubview:titleLabel];
      UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 33, view.frame.size.width-125, 13)];
      companyLabel.text = relation.companyName;
      companyLabel.font = [UIFont systemFontOfSize:11];
      companyLabel.textColor = [UIColor lightGrayColor];
      [view addSubview:companyLabel];
      UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-60, 10, 40, 40)];
      [btn setImage:[UIImage imageNamed:@"myorder"] forState:UIControlStateNormal];
      [view addSubview:btn];
      if (i == 0) {
        companyName = relation.name;
      }else{
        companyName = [NSString stringWithFormat:@"%@、%@",companyName,relation.name];
      }
    }
    self.relationVIewHeight.constant = entity.relationList.count*70;
  }else{
    self.relationVIewHeight.constant = 0;
    self.relationViewY.constant = 0;
  }
  if (entity.relationInfo.length>0) {
    self.companyLabel.text = [NSString stringWithFormat:@"针对%@输出一下内容：",companyName];
    self.descLabel.text = entity.relationInfo;
  }else{
    self.companyLabel.hidden = YES;
    self.descLabel.hidden = YES;
  }
}
@end
