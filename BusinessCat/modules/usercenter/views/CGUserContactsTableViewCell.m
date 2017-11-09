//
//  CGUserContactsTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserContactsTableViewCell.h"
#import "UIColor+colorToImage.h"

@implementation CGUserContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  [self.button setTitle:@"邀请" forState:UIControlStateNormal];
  [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.button setBackgroundImage:[UIColor createImageWithColor:CTThemeMainColor Rect:self.button.bounds] forState:UIControlStateNormal];
  [self.button setTitle:@"已邀请" forState:UIControlStateSelected];
  [self.button setTitleColor:TEXT_GRAY_CLR forState:UIControlStateSelected];
  [self.button setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:self.button.bounds] forState:UIControlStateSelected];
  
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)updateEntity:(CGUserPhoneContactEntity *)entity didSelectedButtonIndex:(SelectedButtonIndex)block{
  self.nameLabel.text = entity.name;
  self.detailLabel.text = entity.phone;
  if (entity.isInvite == 1) {
    self.button.selected = YES;
    [self.button setTitle:@"已邀请" forState:UIControlStateSelected];
    [self.button setTitleColor:TEXT_GRAY_CLR forState:UIControlStateSelected];
    [self.button setUserInteractionEnabled:NO];
  }else if(entity.isInvite == 0){
    self.button.selected = NO;
    [self.button setUserInteractionEnabled:YES];
  }else if (entity.isInvite == 4){
    self.button.selected = YES;
    [self.button setTitle:@"邀请中" forState:UIControlStateSelected];
    [self.button setTitleColor:TEXT_RED_CLR forState:UIControlStateSelected];
    [self.button setUserInteractionEnabled:NO];
  }
  self.block = block;
}

- (IBAction)click:(UIButton *)sender {
  if (self.block) {
   self.block(sender);
  }
}
@end
