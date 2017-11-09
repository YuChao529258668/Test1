//
//  DiscoverIndexTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "DiscoverIndexTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIColor+colorToImage.h"

@interface DiscoverIndexTableViewCell ()
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation DiscoverIndexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateApplyWithapplyList:(NSMutableArray *)lists{
  self.lists = lists;
  float width = SCREEN_WIDTH/4;
  for (int i=0; i<lists.count; i++) {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i%4*width, i/4*width, width, width)];
    [self.contentView addSubview:bgView];
    CGGropuAppsEntity *entity = lists[i];
    UIView *bgIV = [[UIView alloc]initWithFrame:CGRectMake((width-width/5*2)/2, (width-width/5*2)/2-10, width/5*2, width/5*2)];
    bgIV.layer.cornerRadius = 8;
    bgIV.layer.masksToBounds = YES;
    [bgView addSubview:bgIV];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((bgIV.frame.size.width-bgIV.frame.size.width/4*3)/2, (bgIV.frame.size.width-bgIV.frame.size.width/4*3)/2, bgIV.frame.size.width/4*3, bgIV.frame.size.width/4*3)];
    [bgIV addSubview:image];
    [image sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, bgIV.frame.origin.y+bgIV.frame.size.height+5, width, 20)];
    [bgView addSubview:label];
    label.text = entity.name;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment =NSTextAlignmentCenter;
    if (entity.activation == 0) {
      bgIV.backgroundColor = [UIColor lightGrayColor];
      label.textColor = [UIColor lightGrayColor];
    }else{
      bgIV.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.color];
      label.textColor = TEXT_MAIN_CLR;
    }
    UIButton *btn = [[UIButton alloc]initWithFrame:bgView.bounds];
    [bgView addSubview:btn];
    [btn setImage:[UIColor createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] Rect:btn.bounds] forState:UIControlStateHighlighted];
    btn.tag = i;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    if (i%4 == 0) {
      UIImageView *horizontalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, width*(i/4), SCREEN_WIDTH, 0.5)];
      [self.contentView addSubview:horizontalLine];
      horizontalLine.backgroundColor = CTCommonLineBg;
    }
    if (i==lists.count-1) {
      UIImageView *horizontalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, width*(i/4+1), SCREEN_WIDTH, 0.5)];
      [self.contentView addSubview:horizontalLine];
      horizontalLine.backgroundColor = CTCommonLineBg;
    }
  }
  NSInteger count = lists.count%4==0?lists.count/4:(lists.count/4+1);
  for (int i = 0; i < 3; i++) {
    UIImageView *verticalLine = [[UIImageView alloc]initWithFrame:CGRectMake(width*(i+1), 0, 0.5, width*count)];
    [self.contentView addSubview:verticalLine];
    verticalLine.backgroundColor = CTCommonLineBg;
  }
}

+(float)heightWithArray:(NSMutableArray *)list{
  float width = SCREEN_WIDTH/4;
  NSInteger count = list.count%4==0?list.count/4:(list.count/4+1);
  float height = width*count;
  return height;
}

- (void)click:(UIButton *)sender{
  CGGropuAppsEntity *entity = self.lists[sender.tag];
  self.block(entity);
}

- (void)didSelectedButtonIndex:(ClickAtIndexBlock)block{
  self.block = block;
}
@end
