//
//  CGOpponentView.m
//  CGSays
//
//  Created by zhu on 2016/12/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGOpponentView.h"

@interface CGOpponentView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@end

@implementation CGOpponentView{
  CGOpponentViewBlock reloadBlock;
}
-(instancetype)initWithFrame:(CGRect)frame block:(CGOpponentViewBlock)block{
  self = [super initWithFrame:frame];
  if(self){
    self.backgroundColor = [UIColor whiteColor];
    reloadBlock = block;
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, (self.frame.size.height-180)/2-44, 180, 180)];
    [self addSubview:iv];
    iv.image = [UIImage imageNamed:@"user_moren"];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+10, SCREEN_WIDTH, 20)];
    [self addSubview:self.label];
    self.label.textColor = TEXT_MAIN_CLR;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:15.0f];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, self.label.frame.origin.y+self.label.frame.size.height+10, 180,44)];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.backgroundColor = CTThemeMainColor;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4.0f;
    [self.button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
  }
  return self;
}

-(void)opponentType:(CGOpponentType)opponentType{
  self.opponentType = opponentType;
  switch (opponentType) {
    case CGOpponentTypeLogin:
      self.label.text = @"需登录后才能查看";
      [self.button setTitle:@"我要登录" forState:UIControlStateNormal];
      break;
    case CGOpponentTypeOrganization:
      self.label.text = @"需加入组织后才能查看";
      [self.button setTitle:@"加入组织" forState:UIControlStateNormal];
      break;
    case CGOpponentTypeIntelligencer:
      self.label.text = @"尚未设置竞争对手";
      [self.button setTitle:@"对手管理" forState:UIControlStateNormal];
      break;
    case CGOpponentTypeNullIntelligencer:
      self.label.text = @"请联系管理员设置竞争对手";
      self.button.hidden = YES;
      break;
    case CGOpponentTypeEmpty:
      self.label.text = @"没有数据";
      self.button.hidden = YES;
      break;
      
    default:
      break;
  }
}

-(void)clickAction{
  if(reloadBlock){
    reloadBlock(self.opponentType);
  }
}
@end
