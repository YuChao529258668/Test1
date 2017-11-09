//
//  CGCopyrightTipsView.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGCopyrightTipsView.h"

@interface CGCopyrightTipsView ()
@property (nonatomic, strong) CGInfoDetailEntity *info;
@property (nonatomic, copy) CGCopyrightTipsBlock block;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation CGCopyrightTipsView

- (instancetype)initWithInfo:(CGInfoDetailEntity *)info block:(CGCopyrightTipsBlock)block{
  self.info = info;
  self.block = block;
  if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
//    self.bgButton.alpha = 0;
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    [self initItem];
  }
  return self;
}

-(void)initItem{
  self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  self.bgView.backgroundColor = [UIColor whiteColor];
  [self addSubview:self.bgView];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
  [self.bgView addSubview:view];
  UIButton *urlButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95, 5, 80, 30)];
  [view addSubview:urlButton];
  urlButton.layer.cornerRadius = 4;
  urlButton.layer.borderColor = CTCommonLineBg.CGColor;
  urlButton.layer.borderWidth = 0.5;
  [urlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  urlButton.titleLabel.font = [UIFont systemFontOfSize:15];
  [urlButton addTarget:self action:@selector(urlClick) forControlEvents:UIControlEventTouchUpInside];
  if (![CTStringUtil stringNotBlank:self.info.url]) {
    urlButton.hidden = YES;
    urlButton.frame = CGRectMake(SCREEN_WIDTH-95, 5, 0, 30);
  }
  if (![CTStringUtil stringNotBlank:self.info.authorName]&&![CTStringUtil stringNotBlank:self.info.source]) {
    [urlButton setTitle:@"打开网址" forState:UIControlStateNormal];
  }else{
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 77, 30)];
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [UIColor blackColor];
    text.text = @"内容来源于";
    [view addSubview:text];
    UILabel *source = [[UILabel alloc]initWithFrame:CGRectMake(97, 5, 76, 30)];
    source.font = [UIFont systemFontOfSize:15];
    source.text = self.info.source;
    source.textColor = CTThemeMainColor;
    source.textAlignment = NSTextAlignmentCenter;
    source.layer.cornerRadius = 4;
    source.layer.borderWidth = 0.5;
    source.layer.borderColor = CTThemeMainColor.CGColor;
    [source sizeToFit];
    source.frame = CGRectMake(96, 10, source.frame.size.width+10, 20);
    if (![CTStringUtil stringNotBlank:self.info.source]) {
      source.hidden = YES;
    }
    [view addSubview:source];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(source.frame.origin.x+source.frame.size.width+5, 5, SCREEN_WIDTH-source.frame.origin.x-source.frame.size.width-5-15-urlButton.frame.size.width, 30)];
    title.text = self.info.authorName;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:15];
    [view addSubview:title];
    [urlButton setTitle:@"访问原网址" forState:UIControlStateNormal];
  }
  
  NSString *str = self.info.notice;
  CGFloat height = [CTStringUtil heightWithFont:15 width:SCREEN_WIDTH-30 str:str];
  UIView *copyrightView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, height+50)];
  UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 10, 80, 20)];
  [copyrightView addSubview:tipLabel];
  tipLabel.textColor = [UIColor lightGrayColor];
  tipLabel.font = [UIFont systemFontOfSize:15];
  tipLabel.text = @"版权提示";
  tipLabel.textAlignment = NSTextAlignmentCenter;
  copyrightView.backgroundColor = [UIColor whiteColor];
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-30, height)];
  [copyrightView addSubview:label];
  label.text = str;
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = [UIColor lightGrayColor];
  UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, height+48, SCREEN_WIDTH-30, 2)];
  bottomLine.backgroundColor = CTCommonLineBg;
  [copyrightView addSubview:bottomLine];
  UIImageView *leftLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, (SCREEN_WIDTH-80-30)/2, 2)];
  leftLine.backgroundColor = CTCommonLineBg;
  [copyrightView addSubview:leftLine];
  UIImageView *rightLine = [[UIImageView alloc]initWithFrame:CGRectMake(tipLabel.frame.size.width+tipLabel.frame.origin.x, 20, (SCREEN_WIDTH-80-30)/2, 2)];
  rightLine.backgroundColor = CTCommonLineBg;
  [copyrightView addSubview:rightLine];
  [self.bgView addSubview:copyrightView];
  
  self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT-(40+height+50), SCREEN_WIDTH, 40+height+50);
}

-(void)bgButtonClick{
  [self dismiss];
}

-(void)dismiss{
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.2 animations:^{
    weakSelf.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.bgView.frame.size.height);
    weakSelf.bgButton.alpha = 0;
  }completion:^(BOOL finished) {
    [weakSelf removeFromSuperview];
  }];
}

-(void)urlClick{
  self.block(self.info.url);
}

@end
