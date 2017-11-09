//
//  CGUrlView.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUrlView.h"
#import "AppDelegate.h"
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
@interface CGUrlView ()<UIWebViewDelegate>
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (strong,nonatomic)UIWebView *webView;
@property (nonatomic, copy) CGUrlViewBlock block;
@property (nonatomic, assign) NSInteger first;
@end

@implementation CGUrlView
static CGUrlView *instance;

- (instancetype)initWithUrl:(NSString *)url block:(CGUrlViewBlock)block{
  self.url = url;
  self.block = block;
  if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-120, SCREEN_WIDTH-20, 120)];
    [self addSubview:self.bgView];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"发现网址";
    label.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:label];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, self.bgView.frame.size.width-30, 20)];
    self.label.textColor = [UIColor lightGrayColor];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.text = self.url;
    [self.bgView addSubview:self.label];
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 75, self.bgView.frame.size.width-30, 30)];
    [self.bgView addSubview:self.btn];
    [self.btn setTitle:@"发表到企业圈" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btn.backgroundColor = CTThemeMainColor;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.first = 1;
  }
  return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  NSString *articleImageUrl = [self.webView stringByEvaluatingJavaScriptFromString:@"document.images[0].src"];
  self.icon = articleImageUrl;
  if (self.first == 1) {
   [APPDELEGATE.window addSubview:self];
  }
  self.first =  self.first + 1;
}

-(void)bgButtonClick{
  [self dismiss];
}

-(void)btnClick{
  self.block(self.title, self.icon);
  [self dismiss];
}

- (void)dismiss{
  [self removeFromSuperview];
}
@end
