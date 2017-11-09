//
//  CGInterfaceDetailTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/31.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceDetailTableViewCell.h"

@interface CGInterfaceDetailTableViewCell ()
@property (nonatomic, copy) CGInterfaceDetailViewBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descBotttom;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (nonatomic, strong) CGProductDetailsVersionEntity *entity;
@property (nonatomic, copy) CGInterfaceDetailPushViewBlock pushBlock;
@end

@implementation CGInterfaceDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.leftBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.leftBgView.layer.borderWidth = 0.5;
  self.rightBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.rightBgView.layer.borderWidth = 0.5;
  self.centerBgView.layer.borderColor = CTCommonLineBg.CGColor;
  self.centerBgView.layer.borderWidth = 0.5;
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.layer.borderWidth = 1;
  self.button.layer.borderColor = CTThemeMainColor.CGColor;
  [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(CGProductDetailsVersionEntity *)entity block:(CGInterfaceDetailViewBlock)block pushBlock:(CGInterfaceDetailPushViewBlock)pushBlock{
  self.entity = entity;
  self.pushBlock = pushBlock;
  self.versionLabel.text = entity.version;
  self.block = block;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY年MM月DD日"];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:entity.createtime/1000];
  NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
  self.timeLabel.text = confromTimespStr;
  __weak typeof(self) weakSelf = self;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (error) {
      weakSelf.iconHeight.constant = 0;
      weakSelf.timeCenter.constant = 0;
    }else{
      weakSelf.iconHeight.constant = 40;
      weakSelf.timeCenter.constant = -20;
    }
  }];
  self.titleLabel.text = entity.name;
  self.descLabel.text = entity.desc;
  CGFloat height = [CTStringUtil heightWithFont:15 width:(SCREEN_WIDTH-87*2-15*2-20) str:entity.desc];
  if (height>98) {
    self.pushButton.hidden = NO;
  }else{
    self.pushButton.hidden = YES;
  }
  if (entity.isPush) {
    [self.pushButton setTitle:@"收起" forState:UIControlStateNormal];
  }else{
    [self.pushButton setTitle:@"展开全部" forState:UIControlStateNormal];
  }
  
}

- (IBAction)click:(UIButton *)sender {
  self.block(self.entity);
}

- (IBAction)pushClick:(UIButton *)sender {
  self.entity.isPush = !self.entity.isPush;
  self.pushBlock();
}

@end
