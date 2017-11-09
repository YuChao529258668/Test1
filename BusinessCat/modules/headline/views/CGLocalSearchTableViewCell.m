//
//  CGLocalSearchTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGLocalSearchTableViewCell.h"

@interface CGLocalSearchTableViewCell ()
@property (nonatomic, copy) CGLocalSearchTableBlock block;
@end

@implementation CGLocalSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)block:(CGLocalSearchTableBlock)block{
  self.block = block;
}
-(void)update:(NSMutableArray *)array{
  for(UIView *view in [self.contentView subviews])
  {
    [view removeFromSuperview];
  }
  self.height = 10.0;
  CGFloat x = 15.0;
  for (int i =0 ; i<array.count; i++) {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, self.height, 10, 30)];
    [btn setTitle:array[i] forState:UIControlStateNormal];
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn sizeToFit];
    CGRect rect = btn.frame;
    rect.size.width = rect.size.width+10;
    rect.size.height = 30;
    btn.frame = rect;
    btn.tag = i;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = CTCommonViewControllerBg;
    [self.contentView addSubview:btn];
    x = btn.frame.origin.x+btn.frame.size.width+10;
    if (x>SCREEN_WIDTH) {
      x = 15;
      self.height = self.height+40;
      btn.frame = CGRectMake(x, self.height, rect.size.width+10, 30);
      x = btn.frame.origin.x+btn.frame.size.width+10;
    }
  }
  self.height = self.height + 40;
}

-(void)click:(UIButton *)sender{
  self.block(sender.tag);
}
@end
