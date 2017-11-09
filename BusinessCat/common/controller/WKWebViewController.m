//
//  WKWebViewController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "WKWebViewController.h"
#import "CGCommonBiz.h"

@interface WKWebViewController ()

@end

@implementation WKWebViewController

+(void)setPath:(NSString *)path code:(id)code success:(void(^)(id response))success fail:(void (^)(void))fail{
//    UIView *view = [[ObjectShareTool sharedInstance].webview superview];
//    if(!view){
//        [[ObjectShareTool sharedInstance].webview addWebviewToWindow];
//    }
//    NSString *urlStr = [ObjectShareTool sharedInstance].webview.URL.absoluteString;
//    if([ObjectShareTool sharedInstance].webview && [CTStringUtil stringNotBlank:urlStr]){
//        [[ObjectShareTool sharedInstance].webview.bridge callHandler:path data:code responseCallback:^(id response) {
//            success(response);
//        }];
//    }else{
//        [[ObjectShareTool sharedInstance].webview loadRequest];
//        [[ObjectShareTool sharedInstance].webview.bridge callHandler:path data:code responseCallback:^(id response) {
//            success(response);
//        }];
//    }
}

//把webview添加到controller
-(void)addWebViewToView{
    [self.view addSubview:[ObjectShareTool sharedInstance].webview];
    [ObjectShareTool sharedInstance].webview.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self addWebViewToView];
}
-(void)viewDidAppear:(BOOL)animated{
    [self addWebViewToView];
}

//延时3秒，让controller3秒后再销毁，防止H5回调后找不到delegate调用函数
-(void)viewDidDisappear:(BOOL)animated{
    [[ObjectShareTool sharedInstance].webview addWebviewToWindow];
}


//为了不让controller销毁那么快
-(void)doNothing{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWebViewToView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:NotificationToApplicationDidBecomeActive object:nil];
}

//app从后台转回前台，检查H5是否还在，如果不在，回到原生，后台重新加载H5
-(void)applicationDidBecomeActive{
    NSString *url = [ObjectShareTool sharedInstance].webview.URL.absoluteString;
    if(![CTStringUtil stringNotBlank:url]){
        [[[CGCommonBiz alloc]init]uploadAppLog:@"APP回到前台，H5被回收了"];
        [[ObjectShareTool sharedInstance].webview addWebviewToWindow];
        [[ObjectShareTool sharedInstance].webview loadRequest];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [[[CGCommonBiz alloc]init]uploadAppLog:@"WKWebViewController收到内存警告"];
    [super didReceiveMemoryWarning];
}

- (BOOL)isSupportPanReturnBack{
    return [ObjectShareTool sharedInstance].webview.canSwipToNative;
}

-(void)dealloc{
    NSLog(@"H5的Controller被销毁了->%@->%@->%@", NSStringFromClass([self class]),  NSStringFromSelector(_cmd),self);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
