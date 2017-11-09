//
//  AttentionHeaderCell.m
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionHeaderCell.h"
#import "AttentionHead.h"
#import <UIImageView+WebCache.h>

@interface AttentionHeaderCell ()<UIScrollViewDelegate>

@end

@implementation AttentionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.scrollView.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithArray:(NSMutableArray *)array{
  
  for(UIView *view in [self.scrollView subviews])
  {
    [view removeFromSuperview];
  }
  NSInteger count = array.count/8 == 0? array.count/8:(array.count/8+1);
  for (NSInteger j = 0; j<count; j++) {
    int number = 8;
    if (j == count-1) {
      number = array.count%8==0?8:array.count%8;
    }
    for (NSInteger i=0; i<number; i++) {
      AttentionHead *entity = array[i+j*8];
      CGFloat width = SCREEN_WIDTH/4.0;
      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(j*SCREEN_WIDTH+i%4*width, i/4*70, width, 70)];
      UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width-30)/2, 10, 30, 30)];
      [imageView sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
      imageView.layer.cornerRadius = 4;
      imageView.layer.masksToBounds = YES;
      [view addSubview:imageView];
      UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, width, 20)];
      label.font = [UIFont systemFontOfSize:13];
      label.textColor = TEXT_MAIN_CLR;
      label.text = entity.title;
      label.textAlignment = NSTextAlignmentCenter;
      [view addSubview:label];
      UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
      [view addSubview:btn];
      [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
      btn.tag = i+j*8;
      [self.scrollView addSubview:view];
    }
  }
  self.scrollView.contentSize = CGSizeMake(count*SCREEN_WIDTH, 0);
  self.scrollView.pagingEnabled = YES;
}

- (void)click:(UIButton *)sender{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}
@end
