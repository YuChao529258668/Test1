//
//  CGUserHelpCatePageViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserHelpCatePageViewController.h"
#import "CGUserCenterBiz.h"
#import "CGHelpCatePageTableViewCell.h"
#import "CGUserHelpCatePageEntity.h"

@interface CGUserHelpCatePageViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) CGUserHelpCatePageEntity *entity;
@end

@implementation CGUserHelpCatePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
  [self.view addSubview:self.webView];
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz authUserHelpCatePageWithID:self.pageId success:^(CGUserHelpCatePageEntity *reslut) {
    weakSelf.entity = reslut;
    weakSelf.title = reslut.title;
    if([CTStringUtil stringNotBlank:reslut.content]){
      NSString *filePath = [[NSBundle mainBundle]pathForResource:@"helpHtmlTemplate" ofType:@"html"];
      NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
      htmlString = [htmlString stringByReplacingOccurrencesOfString:@"#html#" withString:reslut.content];
      [weakSelf.webView loadHTMLString:htmlString baseURL:nil];
    }
    [weakSelf.biz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
  }];
    // Do any additional setup after loading the view from its nib.
}

-(UIWebView *)webView{
  if (!_webView) {
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
  }
  return _webView;
}

//- (void)webViewDidFinishLoad:(UIWebView *)wb
//{
//  CGRect frame = self.webView.frame;
//  frame.size.height = wb.scrollView.contentSize.height;
//  frame.origin.y = self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5;
//  self.webView.frame = frame;
//  self.sv.contentSize = CGSizeMake(0, self.webView.frame.origin.y+self.webView.frame.size.height);
//}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

//动态计算高度
-(CGFloat)heightWithFont:(CGFloat)font str:(NSString *)string{
  UIFont * fonts = [UIFont systemFontOfSize:font];
  CGSize size  =CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT);
  NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
  size = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
