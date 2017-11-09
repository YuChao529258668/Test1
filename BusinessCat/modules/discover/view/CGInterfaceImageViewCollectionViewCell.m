//
//  CGInterfaceImageViewCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceImageViewCollectionViewCell.h"
#import <UIButton+WebCache.h>
#import "HeadlineBiz.h"
#import "DiscoverDao.h"

@implementation CGInterfaceImageViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.littleIcon.layer.cornerRadius = 4;
  self.littleIcon.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setInterface:(CGProductInterfaceEntity *)interface{
  _interface = interface;
  if (interface.isIcon) {
    self.icon.hidden = YES;
    self.littleIcon.hidden = NO;
    [self.littleIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100/thumbnail/!50p",interface.cover]]];
  }else{
    self.icon.hidden = NO;
    self.littleIcon.hidden = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100/thumbnail/!50p",interface.cover]] forState:UIControlStateNormal placeholderImage:nil];
  }
  self.title.text = interface.name;
  self.collectBtn.selected = interface.isFollow;
}

- (void)setProduct:(CGInfoHeadEntity *)product{
  _product = product;
  if (product.layout == ContentLayoutCatalog) {
    self.title.text = product.title;
    [self.icon setImage:[UIImage imageNamed:@"pdocument"] forState:UIControlStateNormal];
    self.collectBtn.hidden = YES;
    self.collectBtnWidth.constant = 0;
//    self.title.textAlignment = NSTextAlignmentCenter;
  }else{
    self.collectBtn.hidden = NO;
    self.collectBtnWidth.constant = 22;
//    self.title.textAlignment = NSTextAlignmentLeft;
    if (product.isIcon) {
      self.icon.hidden = YES;
      self.littleIcon.hidden = NO;
      [self.littleIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100/thumbnail/!50p",product.cover]]];
    }else{
      self.icon.hidden = NO;
      self.littleIcon.hidden = YES;
    [self.icon sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100/thumbnail/!50p",product.cover]] forState:UIControlStateNormal placeholderImage:nil];
    }
    self.title.text = product.name;
  }
  self.collectBtn.selected = product.isFollow;
}

- (IBAction)collectClick:(UIButton *)sender {
  if (_product) {
    if (_product.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_product.infoId type:15 collect:1 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_product.infoId isFollow:YES];
      } fail:^(NSError *error) {
        _product.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_product.infoId type:15 collect:0 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_product.infoId isFollow:NO];
      } fail:^(NSError *error) {
        _product.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }else{
    if (_interface.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_interface.interfaceID type:15 collect:1 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_interface.interfaceID isFollow:YES];
      } fail:^(NSError *error) {
        _interface.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_interface.interfaceID type:15 collect:0 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_interface.interfaceID isFollow:NO];
      } fail:^(NSError *error) {
        _interface.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }
}

- (IBAction)closeAction:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  if (_product) {
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _product.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_product.infoId type:15 collect:0 success:^{
        if ([weakSelf.delegate respondsToSelector:@selector(cancelCollectionWithIndex:)])
        {
          [weakSelf.delegate cancelCollectionWithIndex:sender.tag];
        }
        [ObjectShareTool sharedInstance].currentUser.followNum -=1;
        [DiscoverDao updateInterfaceListFromDBWithID:_product.infoId isFollow:NO];
      } fail:^(NSError *error) {
        _product.isFollow = YES;
        sender.selected = YES;
      }];
  }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_interface.interfaceID type:15 collect:0 success:^{
        if ([weakSelf.delegate respondsToSelector:@selector(cancelCollectionWithIndex:)])
        {
          [weakSelf.delegate cancelCollectionWithIndex:sender.tag];
        }
        [ObjectShareTool sharedInstance].currentUser.followNum -=1;
        [DiscoverDao updateInterfaceListFromDBWithID:_product.infoId isFollow:NO];
      } fail:^(NSError *error) {
        _interface.isFollow = YES;
        sender.selected = YES;
      }];
    }
}


@end
