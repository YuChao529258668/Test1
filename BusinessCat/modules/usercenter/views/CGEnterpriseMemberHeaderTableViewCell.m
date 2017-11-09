//
//  CGEnterpriseMemberHeaderTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGEnterpriseMemberHeaderTableViewCell.h"

@interface CGEnterpriseMemberHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) CGCorporateMemberEntity *entity;

@property (weak, nonatomic) IBOutlet UIImageView *vip;
@property (weak, nonatomic) IBOutlet UILabel *gradeName;
@property (weak, nonatomic) IBOutlet UILabel *expireDate;
@property (weak, nonatomic) IBOutlet UILabel *vipDay;

@end

@implementation CGEnterpriseMemberHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.contentView.backgroundColor = CTThemeMainColor;
  self.contentView.layer.masksToBounds = YES;

}

-(void)update:(CGCorporateMemberEntity *)item type:(int)type{
    self.gradeName.text = item.gradeName;
    self.expireDate.textColor = [UIColor whiteColor];
    if(item.isVip == 1){
        self.expireDate.text = [NSString stringWithFormat:@"有效期至%@",item.vipTime];
        self.vipDay.text = [NSString stringWithFormat:@"(还有%d天到期)",item.vipDays];
    }else if(item.isVip == 0){
      if (type) {
       self.expireDate.text = @"享受更多服务请购买VIP企业";
      }else{
        self.expireDate.text = @"享受更多服务请购买VIP会员";
      }
        self.vipDay.text = @"";
    }else if(item.isVip == 2){//过期
        self.vip.alpha = 0.5;
        self.expireDate.text = @"已过期";
        self.expireDate.textColor = [UIColor redColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)click:(UIButton *)sender{
//  CGGradeList *grade = self.entity.gradeList[sender.tag];
//  self.block(grade);
}

@end
