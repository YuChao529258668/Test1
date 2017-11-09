//
//  CommentaryTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/2/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CommentaryTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "HeadlineBiz.h"
#import "UIImage+Gallop.h"

@interface CommentaryTableViewCell ()
@property (nonatomic, strong) CGInfoHeadEntity *infoEntity;

@end

@implementation CommentaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.collectionBtn.layer.cornerRadius = 4;
  self.collectionBtn.layer.borderWidth = 0.5;
  self.collectionBtn.layer.borderColor = CTThemeMainColor.CGColor;
  [self.collectionBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  self.collectionBtn.layer.masksToBounds = YES;
  self.sourceLabel.layer.cornerRadius = 4;
  self.sourceLabel.layer.borderWidth = 0.5;
  self.sourceLabel.layer.borderColor = CTThemeMainColor.CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateInfo:(CGInfoHeadEntity *)entity{
  self.infoEntity = entity;
  if (entity.type == 17) {
   [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
    self.icon.hidden = NO;
    self.sourceLabel.hidden = YES;
    self.soruceWidth.constant = 40;
    self.descY.constant = 18;
  }else{
    self.icon.hidden = YES;
    self.sourceLabel.hidden = NO;
    self.sourceLabel.text = entity.tag;
    [self.sourceLabel sizeToFit];
    self.descY.constant = 9;
    self.soruceWidth.constant = self.sourceLabel.frame.size.width+10;
  }
  self.title.text = entity.title;
  self.desc.text = entity.desc;
  __weak typeof(self) weakSelf = self;
  [self.bigImage sd_setImageWithURL:[NSURL URLWithString:entity.cover] placeholderImage:[UIImage imageNamed:@"morentu"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    if (!error) {
     weakSelf.bigImage.image = [image lw_rescaleImageToSize:CGSizeMake(SCREEN_WIDTH-30, 125)]; 
    }
  }];
  self.time.text = [CTDateUtils getTimeFormatFromDateLong:entity.createtime];
}

- (IBAction)collectionClick:(UIButton *)sender {
  //收藏
  HeadlineBiz *biz = [[HeadlineBiz alloc]init];
  self.infoEntity.isFollow = !self.infoEntity.isFollow;
  sender.selected = self.infoEntity.isFollow;
  [self update];
  [biz collectWithId:self.infoEntity.infoId type:11 collect:self.infoEntity.isFollow success:^{
  } fail:^(NSError *error) {
  }];
}

-(void)update{
  if (self.infoEntity.isFollow) {
    [self.collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.collectionBtn.layer.borderColor = CTCommonLineBg.CGColor;
    //    [self.collectButton setUserInteractionEnabled:NO];
  }else{
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.collectionBtn.layer.borderColor = CTThemeMainColor.CGColor;
    //    [self.collectButton setUserInteractionEnabled:YES];
  }
}

+(CGFloat)height:(CGInfoHeadEntity *)entity{
   CGSize titleSize = [entity.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
  CGFloat height = 0.0;
  if (titleSize.height>63) {
    height = 63.0f;
  }else{
    height = titleSize.height;
  }
  height = height +246;
  return height;
}
@end
