//
//  CGQrCodeView.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGQrCodeView.h"
#import"QRCodeGenerator.h"

@interface CGQrCodeView ()
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIImageView *iv;
@end

@implementation CGQrCodeView

- (instancetype)initWithUrl:(NSString *)url{
  if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    //    self.bgButton.alpha = 0;
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200)/2, 200, 200)];
    [self addSubview:self.iv];
    self.iv.image = [QRCodeGenerator qrImageForString:url imageSize:self.iv.frame.size.width];
    self.iv.backgroundColor = [UIColor whiteColor];
    self.iv.layer.cornerRadius = 4;
    self.iv.layer.masksToBounds = YES;
  }
  return self;
}

- (instancetype)init{
  if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    //    self.bgButton.alpha = 0;
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200)/2, 200, 200)];
    [self addSubview:self.iv];
    self.iv.image = [UIImage imageNamed:@"WechatIMG"];
    self.iv.backgroundColor = [UIColor whiteColor];
    self.iv.layer.cornerRadius = 4;
    self.iv.layer.masksToBounds = YES;
  }
  return self;
}

-(void)bgButtonClick{
  [self removeFromSuperview];
}

@end
