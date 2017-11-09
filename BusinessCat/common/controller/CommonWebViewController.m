//
//  CommonWebViewController.m
//  CGSays
//
//  Created by zhu on 2017/2/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CommonWebViewController.h"
#import "ShareUtil.h"
#import "CGCommonWebView.h"
#import "LWProgeressHUD.h"
#import "KxMenu.h"

@interface CommonWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
@property(nonatomic,retain)CGCommonWebView *webview;
@property (nonatomic, strong) ShareUtil *share;
@property (nonatomic, copy) NSString *shareTitle;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTopY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refresTopY;
@property (nonatomic, strong) LWProgeressHUD* progressHUD;
@property (nonatomic, assign) NSInteger currentPostion;
@property (nonatomic, assign) BOOL manMadeScroll;
@property (nonatomic, assign) NSInteger isStatusBar;//是否显示时间栏
@end

@implementation CommonWebViewController

- (BOOL)shouldAutorotate{
  //是否允许转屏
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  //viewController所支持的全部旋转方向
  return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  //viewController初始显示的方向
  return UIInterfaceOrientationPortrait;
}

//屏幕旋转完成的状态
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}

//获取将要旋转的状态
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

//获取旋转中的状态
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  CGFloat height = self.isStatusBar?0:20;
  self.webview.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height);
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
  //强制转换
  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self hideCustomNavi];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.webview = [CGCommonWebView sharedInstance];
    self.webview.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
  self.webview.scrollView.delegate = self;
  self.webview.navigationDelegate = self;
  self.webview.UIDelegate = self;
  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
  [self.view addSubview:self.webview];
  [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
  [self.view bringSubviewToFront:self.backButton];
  [self.view bringSubviewToFront:self.refreshButton];
}
- (IBAction)refreshBtnAction:(UIButton *)sender {
  NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:[KxMenuItem menuItem:@"分享"
                                                                              image:[UIImage imageNamed:@"datasharing"]
                                                                             target:self
                                                                             action:@selector(shareBtnAction)],
                                                                [KxMenuItem menuItem:@"刷新"
                                                                                                                              image:[UIImage imageNamed:@"refresh"]
                                                                                                                             target:self
                                                                                                                             action:@selector(refreshAction)], nil];
  CGRect fromRect = sender.frame;
  [KxMenu setTintColor:[UIColor blackColor]];
  
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
}

-(void)refreshAction{
  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)shareBtnAction {
  UIGraphicsBeginImageContext(self.webview.bounds.size);
  
  [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  self.share =[[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  [self.share showShareMenuWithTitle:self.shareTitle desc:self.shareTitle isqrcode:1 image:image url:self.url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}

- (IBAction)backAction:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
  self.progressHUD = [LWProgeressHUD showHUDAddedTo:self.view];
}

////改变字体
//-(void)executeFontSize{
//    NSUserDefaults *fontSize = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dic = [fontSize objectForKey:NSUSERDEFAULT_FONTSIZE];
//    NSNumber *systemFontSize = dic[@"webFontSize"];
//    NSString *fontSizeJS = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",systemFontSize.intValue];
//    [self.webview evaluateJavaScript:fontSizeJS completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"改变字体完成");
//    }];
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//  [GiFHUD dismiss];
  NSString *js = [NSString stringWithFormat:@"document.title"];
    __weak typeof(self) weakSelf = self;
  [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    weakSelf.shareTitle = result;
  }];
  [LWProgeressHUD hideAllHUDForView:self.view];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == self.webview && [keyPath isEqualToString:@"estimatedProgress"]) {
    CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//    if (newprogress > 0.3) {
//      [GiFHUD dismiss];
//    }
    self.progressHUD.progress = newprogress;
  }
}

// 记得取消监听
- (void)dealloc {
  self.webview.scrollView.delegate = nil;
  [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.manMadeScroll = YES;
  [LWProgeressHUD hideAllHUDForView:self.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  self.currentPostion = scrollView.contentOffset.y;
  if(self.manMadeScroll){
    if(self.currentPostion <= 0){
      [self hideStatusBar:NO];
    }else{
      [self hideStatusBar:YES];
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  self.manMadeScroll = NO;
  [self hideStatusBar:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  self.manMadeScroll = NO;
}

//显示/隐藏状态栏
-(void)hideStatusBar:(BOOL)show{
  self.isStatusBar = show;
  CGRect bgScrollViewRect = self.webview.frame;
  UIColor *btnColor;
  if(show){
    self.backTopY.constant = 10;
    self.refresTopY.constant = 10;
    bgScrollViewRect.origin.y = 0;
    bgScrollViewRect.size.height = SCREEN_HEIGHT;
    btnColor = [CTCommonUtil convert16BinaryColor:@"#F9F9F9"];
  }else{
    if(self.currentPostion <= 0){
      btnColor = [UIColor clearColor];
      self.backTopY.constant = 30;
      self.refresTopY.constant = 30;
      bgScrollViewRect.size.height = SCREEN_HEIGHT -20;
      bgScrollViewRect.origin.y = 20;
    }else{
      btnColor = [CTCommonUtil convert16BinaryColor:@"#F9F9F9"];
    }
  }
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:!(weakSelf.currentPostion <= 0) withAnimation:UIStatusBarAnimationSlide];
    weakSelf.webview.frame = bgScrollViewRect;
    [weakSelf.backButton setBackgroundImage:[CTCommonUtil generateImageWithColor:btnColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [weakSelf.refreshButton setBackgroundImage:[CTCommonUtil generateImageWithColor:btnColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
  }];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//  [GiFHUD dismiss];
}
@end
