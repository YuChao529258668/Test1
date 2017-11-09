//
//  CGFristOpenView.m
//  CGSays
//
//  Created by zhu on 2017/1/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGFristOpenView.h"

@interface CGFristOpenView(){
  
  CGFristOpenViewBlock reloadBlock;
  
}

@end

@implementation CGFristOpenView

-(instancetype)initWithBlock:(CGFristOpenViewBlock)block{
  self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  if(self){
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    reloadBlock = block;
    [self updateView];
  }
  return self;
}

-(void)updateView{
  UIButton *close = [[UIButton alloc]initWithFrame:self.bounds];
  [self addSubview:close];
  [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, (SCREEN_HEIGHT-350)/2, 270, 350)];
  [self addSubview:view];
  view.backgroundColor = [UIColor whiteColor];
  view.layer.cornerRadius = 8;
  view.layer.masksToBounds = YES;
  
  UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((view.frame.size.width-134)/2, 50, 134, 80)];
  imageView.image = [UIImage imageNamed:@"firsthint"];
  [view addSubview:imageView];
  
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+20, view.frame.size.width, 20)];
  label.font = [UIFont systemFontOfSize:18];
  label.text = @"欢迎来到荐识";
  label.textAlignment = NSTextAlignmentCenter;
  [view addSubview:label];
  label.textColor = CTThemeMainColor;
  
  UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, label.frame.origin.y +label.frame.size.height+20, view.frame.size.width-30, 10)];
  detailLabel.text = @"首次使用建议你设置好个人档案，档案中加入所属组织后可以获得更多专属的数据服务及组织功能。";
  detailLabel.font = [UIFont systemFontOfSize:15];
  detailLabel.textColor = TEXT_GRAY_CLR;
  [view addSubview:detailLabel];
  detailLabel.numberOfLines = 0;
  [detailLabel sizeToFit];
  
  UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, view.frame.size.height-50, view.frame.size.width, 50)];
  [btn setTitle:@"开始设置" forState:UIControlStateNormal];
  btn.titleLabel.font = [UIFont systemFontOfSize:17];
  [btn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  [view addSubview:btn];
  [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
  
  UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 0.5)];
  [btn addSubview:line];
  line.backgroundColor = CTCommonLineBg;
}

-(void)click{
  if(reloadBlock){
    reloadBlock();
  }
  [self removeFromSuperview];
}

- (void)closeView{
  [self removeFromSuperview];
}
@end
