//
//  InterfaceTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/1/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "InterfaceTableViewCell.h"
#import <UIButton+WebCache.h>
#import "HeadlineBiz.h"
#import "UIImage+Gallop.h"

@implementation InterfaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInterface1:(CGProductInterfaceEntity *)interface1{
  _interface1 = interface1;
  self.leftView.hidden = NO;
//  __weak typeof(self) weakSelf = self;
  [self.leftButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg",interface1.cover]] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
  }];
  self.leftLabel.text = interface1.name;
  self.leftCollect.selected = interface1.isFollow;
}

-(void)setInterface2:(CGProductInterfaceEntity *)interface2{
  _interface2 = interface2;
  self.rightView.hidden = NO;
//  __weak typeof(self) weakSelf = self;
  [self.rightButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg",interface2.cover]] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    [weakSelf.rightButton setImage:[image lw_rescaleImageToSize:CGSizeMake((SCREEN_WIDTH-30)/2, 335)] forState:UIControlStateNormal];
  }];
  self.rightLabel.text = interface2.name;
  self.rightCollect.selected = interface2.isFollow;
}


- (void)setProduct1:(CGInfoHeadEntity *)product1 {
  _product1 = product1;
  self.leftView.hidden = NO;
  [self.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg",product1.cover]] forState:UIControlStateNormal placeholderImage:nil];
  self.leftLabel.text = product1.name;
  self.leftCollect.selected = product1.isFollow;
}

- (void)setProduct2:(CGInfoHeadEntity *)product2 {
  _product2 = product2;
  self.rightView.hidden = NO;
  [self.rightButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg",product2.cover]] forState:UIControlStateNormal placeholderImage:nil];
  self.rightLabel.text = product2.name;
  self.rightCollect.selected = product2.isFollow;
}

- (IBAction)leftClick:(UIButton *)sender {
  [self.delegate doProductDetailWithIndex:sender.tag];
}

- (IBAction)rightClick:(UIButton *)sender {
  [self.delegate doProductDetailWithIndex:sender.tag];
}

- (IBAction)leftCollectClick:(UIButton *)sender {
  if (_product1) {
    if (_product1.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product1.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_product1.infoId type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        _product1.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product1.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_product1.infoId type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        _product1.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }else{
    if (_interface1.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface1.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_interface1.interfaceID type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        _interface1.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface1.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_interface1.interfaceID type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        _interface1.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }
}

- (IBAction)rightCollectClick:(UIButton *)sender {
  if (_product2) {
    if (_product2.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product2.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_product2.infoId type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        _product2.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product2.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_product2.infoId type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        _product1.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }else{
    if (_interface2.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface2.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_interface2.interfaceID type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        _interface2.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface2.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_interface2.interfaceID type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        _interface2.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }
}

@end
