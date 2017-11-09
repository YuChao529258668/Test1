//
//  HeadLineDelConfirmView.m
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadLineDelConfirmView.h"

#define WhiteViewHeight 195

@interface HeadLineDelConfirmView(){
    UIView *grayView;
    UIImageView *whiteView;
    float startX,startY;
    
    CGHeadlineDelBlock delBlock;
    CGHeadlineCancelBlock cancelBlock;
}

@end

@implementation HeadLineDelConfirmView

-(instancetype)initWithX:(float)x y:(float)y del:(CGHeadlineDelBlock)del cancel:(CGHeadlineCancelBlock)cancel{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        startX = x;
        startY = y;
        self.backgroundColor = [UIColor clearColor];
        delBlock = del;
        cancelBlock = cancel;
        grayView = [[UIView alloc]initWithFrame:self.bounds];
        grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        grayView.alpha = 0;
        grayView.userInteractionEnabled = YES;
        [self addSubview:grayView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMySelf)];
        [grayView addGestureRecognizer:tap];
        
        whiteView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 0, 0)];
        whiteView.backgroundColor = [UIColor clearColor];
        whiteView.clipsToBounds = YES;
        whiteView.userInteractionEnabled = YES;
        [self addSubview:whiteView];
      
        BOOL isDown = (SCREEN_HEIGHT-y)>WhiteViewHeight?YES:NO;
        CGFloat sumaryY = 15;
        if (isDown) {
          sumaryY = 15+12;
        }
        UILabel *sumary = [[UILabel alloc]initWithFrame:CGRectMake(15, sumaryY,SCREEN_WIDTH-30-30, 17)];
        sumary.textColor = [UIColor darkGrayColor];
        sumary.text = @"可选理由，精准屏蔽";
        [whiteView addSubview:sumary];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(sumary.frame), CGRectGetMaxY(sumary.frame)+15, (SCREEN_WIDTH-75)/2, 30)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderColor = [CTCommonLineBg CGColor];
        button.layer.cornerRadius = 3;
        button.tag = 0;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+15, CGRectGetMinY(button.frame), button.frame.size.width, button.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"重复、旧闻" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderColor = [CTCommonLineBg CGColor];
        button.layer.cornerRadius = 3;
        button.tag = 1;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(sumary.frame), CGRectGetMaxY(button.frame)+15, button.frame.size.width, button.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"内容质量差" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderColor = [CTCommonLineBg CGColor];
        button.layer.cornerRadius = 3;
        button.tag = 2;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+15,CGRectGetMinY(button.frame), button.frame.size.width, button.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"已看过了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderColor = [CTCommonLineBg CGColor];
        button.layer.cornerRadius = 3;
        button.tag = 5;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
      
      button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(sumary.frame), CGRectGetMaxY(button.frame)+15, button.frame.size.width, button.frame.size.height)];
      button.titleLabel.font = [UIFont systemFontOfSize:14];
      [button setTitle:@"推荐不精准" forState:UIControlStateNormal];
      [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      button.layer.borderColor = [CTCommonLineBg CGColor];
      button.layer.cornerRadius = 3;
      button.tag = 6;
      button.layer.borderWidth = 0.5;
      [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [whiteView addSubview:button];
      
      button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+15,CGRectGetMinY(button.frame), button.frame.size.width, button.frame.size.height)];
      button.titleLabel.font = [UIFont systemFontOfSize:14];
      [button setTitle:@"内容分类错误" forState:UIControlStateNormal];
      [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      button.layer.borderColor = [CTCommonLineBg CGColor];
      button.layer.cornerRadius = 3;
      button.tag = 7;
      button.layer.borderWidth = 0.5;
      [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [whiteView addSubview:button];
      
    }
    return self;
}

-(void)closeMySelf{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(startX, startY, 0, 0);
        grayView.alpha = 0;
        whiteView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)clickButtonAction:(UIButton *)button{
    if(delBlock){
        delBlock((int)button.tag);
    }
    [self closeMySelf];
}

-(void)showInView:(UIView *)view position:(HeadlineColseShowPosition)position y:(float)y{
    [view addSubview:self];
  BOOL isDown = (SCREEN_HEIGHT-y)>WhiteViewHeight?YES:NO;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.85
          initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              grayView.alpha = 1;
              if(position == HeadlineColseShowPositionCenter){
                if (isDown) {
                  whiteView.image = [UIImage imageNamed:@"headline_delete_confirm_center"];
                }else{
                  whiteView.image = [UIImage imageNamed:@"headline_delete_confirm_center_back"];
                }
              }else{
                if (isDown) {
                  whiteView.image = [UIImage imageNamed:@"headline_delete_confirm_right"];
                }else{
                  whiteView.image = [UIImage imageNamed:@"headline_delete_confirm_right_back"];
                }
              }
            if (isDown) {
             whiteView.frame = CGRectMake(15, y, SCREEN_WIDTH - 30, WhiteViewHeight);
            }else{
              whiteView.frame = CGRectMake(15, y-WhiteViewHeight-30, SCREEN_WIDTH - 30, WhiteViewHeight);
            }
          }completion:^(BOOL finished) {
              
          }];
}
@end
