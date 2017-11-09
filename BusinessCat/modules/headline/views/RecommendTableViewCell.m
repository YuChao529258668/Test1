//
//  RecommendTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/1/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "HeadlineBiz.h"

@interface RecommendTableViewCell ()
@property (nonatomic, strong) CGInfoHeadEntity *info;
@end

@implementation RecommendTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.collectButton.layer.cornerRadius = 4;
  self.collectButton.layer.borderWidth = 0.5;
  self.collectButton.layer.borderColor = CTThemeMainColor.CGColor;
  self.collectButton.layer.masksToBounds = YES;
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

-(void)updateInfo:(CGInfoHeadEntity *)info{
  self.info = info;
  NSArray *array = [info.icon componentsSeparatedByString:@"@"];
  NSString *str = array[0];
  NSString *str1 = [NSString stringWithFormat:@"%@@640w_256h",str];
  [self.icon sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"faxianmorentu"]];
  self.titleLabel.text = [NSString stringWithFormat:@"(%ld项)%@",info.count,info.title];
  [self update];
  self.timeLabel.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
}

- (IBAction)collectClick:(UIButton *)sender {
    //收藏
    HeadlineBiz *biz = [[HeadlineBiz alloc]init];
    self.info.isFollow = !self.info.isFollow;
    sender.selected = self.info.isFollow;
    [self update];
    [biz collectWithId:self.info.infoId type:11 collect:self.info.isFollow success:^{
    } fail:^(NSError *error) {
    }];
}

-(void)update{
  if (self.info.isFollow) {
    [self.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.collectButton.layer.borderColor = CTCommonLineBg.CGColor;
  }else{
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.collectButton.layer.borderColor = CTThemeMainColor.CGColor;
  }
}

@end
