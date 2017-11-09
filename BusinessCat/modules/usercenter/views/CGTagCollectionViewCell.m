//
//  CGTagCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTagCollectionViewCell.h"

@implementation CGTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.titleLabel.frame = self.bounds;
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.titleLabel.text = @"";
}

@end
