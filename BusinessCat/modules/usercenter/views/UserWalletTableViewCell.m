//
//  UserWalletTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "UserWalletTableViewCell.h"

@interface UserWalletTableViewCell ()
@property (nonatomic, copy) UserWalletBlock block;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;
@property (nonatomic, strong) IntegralListEntity *entity;
@end

@implementation UserWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.contentView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)info:(IntegralListEntity *)entity block:(UserWalletBlock)block{
  self.block = block;
  self.entity = entity;
  self.titleLabel.text = entity.title;
  self.rewardInfoLabel.text = entity.rewardInfo;
  if (entity.rewardType == 2) {
    self.moneyLabel.text = [NSString stringWithFormat:@"-%@币",[YCTool numberStringOf:entity.rewardNum]];
    self.moneyLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#EC4836"];
  }else{
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@币",[YCTool numberStringOf:entity.rewardNum]];
//    self.moneyLabel.textColor = CTThemeMainColor;
      self.moneyLabel.textColor = [YCTool colorOfHex:0xf68731];
  }
    
  self.title.text = entity.relationInfo.title;
  if ([CTStringUtil stringNotBlank:entity.relationInfo.desc]) {
    self.titleCenter.constant = -10;
    self.desc.text = entity.relationInfo.desc;
  }else{
    self.desc.text = @"";
    self.titleCenter.constant = 0;
  }
  
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.relationInfo.icon]];
  if ([CTStringUtil stringNotBlank:entity.relationInfo.infoID]) {
    self.bgView.hidden = NO;
  }else{
    self.bgView.hidden = YES;
  }
}

- (IBAction)click:(UIButton *)sender {
  self.block(self.entity.relationInfo);
}
@end
