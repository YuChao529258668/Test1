//
//  CGHeadlineDetailView.m
//  CGSays
//
//  Created by zhu on 2017/3/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGHeadlineDetailView.h"
#import "UIColor+colorToImage.h"
#import "CGBigdataEntity.h"
#import <UIImageView+WebCache.h>

@interface CGHeadlineDetailView ()
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation CGHeadlineDetailView

+ (instancetype)userHeaderView{
  return [[[NSBundle mainBundle] loadNibNamed:@"CGHeadlineDetailView"
                                        owner:nil
                                      options:nil] lastObject];
}
+ (float)height{
  return 120;
}

- (void)updateData:(NSMutableArray *)array{
  for (int i = 0; i<array.count; i++) {
    cate *entity = array[i];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*80, 0, 80, 64)];
    [self.scrollView addSubview:view];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 64)];
    [button setBackgroundImage:[UIColor createImageWithColor:[CTCommonUtil convert16BinaryColor:@"#EEEEEE"] Rect:button.bounds] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:button.bounds] forState:UIControlStateNormal];
    [button setTitle:entity.name forState:UIControlStateNormal];
    [button setTitleColor:[CTCommonUtil convert16BinaryColor:@"#A2A2A2"] forState:UIControlStateNormal];
    [button setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = i;
    if (i == 0) {
      button.selected = YES;
      self.selectBtn = button;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 30, 30)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
    [view addSubview:imageView];
  }
  [self.scrollView setContentSize:CGSizeMake(80*array.count, 0)];
}

-(instancetype)init{
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)click:(UIButton *)sender {
  self.selectBtn.selected = NO;
  sender.selected = YES;
  self.selectBtn = sender;
  if(self.delegate && [self.delegate respondsToSelector:@selector(headerDidSelectButtonWithIndex:)]){
    [self.delegate headerDidSelectButtonWithIndex:sender.tag];
  }
  
}

@end
