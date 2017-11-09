//
//  DiscoverPushView.m
//  CGSays
//
//  Created by zhu on 16/11/7.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "DiscoverPushView.h"

@implementation DiscoverPushView{
  UIImageView *whiteView;
  CGRect Startframe;
  
  DiscoverPushBlock indexBlock;
  DiscoverPushCancelBlock cancelBlock;
}

//初始化 x:弹出的开始位置x y:弹出的开始位置y
-(instancetype)initWithFrame:(CGRect)frame title1:(NSString *)title1 title2:(NSString *)title2 selectIndex:(DiscoverPushBlock)index cancel:(DiscoverPushCancelBlock)cancel{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if(self){
    Startframe = frame;
    self.backgroundColor = [UIColor clearColor];
    indexBlock = index;
    cancelBlock = cancel;
    self.grayView = [[UIView alloc]initWithFrame:self.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.grayView.alpha = 0;
    self.grayView.userInteractionEnabled = YES;
    [self addSubview:self.grayView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMySelf)];
    [self.grayView addGestureRecognizer:tap];
    
    whiteView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 0, 0)];
    whiteView.backgroundColor = [UIColor clearColor];
    whiteView.clipsToBounds = YES;
    whiteView.userInteractionEnabled = YES;
    whiteView.image = [UIImage imageNamed:@"tuanduiquantanchuang"];
    [self addSubview:whiteView];
    
    UIButton *dynamic = [[UIButton alloc]initWithFrame:CGRectMake(0, 11, 110, 33)];
    [whiteView addSubview:dynamic];
    [dynamic setTitle:title1 forState:UIControlStateNormal];
    dynamic.tag = 0;
    [dynamic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dynamic.titleLabel.font = [UIFont systemFontOfSize:15];
    [dynamic addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *source = [[UIButton alloc]initWithFrame:CGRectMake(0, 44, 110, 33)];
    [whiteView addSubview:source];
    [source setTitle:title2 forState:UIControlStateNormal];
    source.tag = 1;
    [source setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    source.titleLabel.font = [UIFont systemFontOfSize:15];
    [source addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
  }
  return self;
}

-(void)closeMySelf{
    __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.2 animations:^{
    whiteView.frame = CGRectMake(Startframe.origin.x+Startframe.size.width-110, Startframe.origin.y+Startframe.size.height, 110, 0);
    weakSelf.grayView.alpha = 0;
    whiteView.alpha = 0;
  } completion:^(BOOL finished) {
    [weakSelf removeFromSuperview];
  }];
}

-(void)clickButtonAction:(UIButton *)button{
  if(indexBlock){
    indexBlock((int)button.tag);
  }
  [self closeMySelf];
}

//弹出
-(void)showInView:(UIView *)view frame:(CGRect)frame{
    __weak typeof(self) weakSelf = self;
  [view addSubview:self];
  [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.85
        initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
          weakSelf.grayView.alpha = 1;
          whiteView.frame = CGRectMake(frame.origin.x+frame.size.width-110, frame.origin.y+frame.size.height, 110, 77);
        }completion:^(BOOL finished) {
          
        }];
}
@end
