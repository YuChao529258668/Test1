//
//  PDFViewController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "PDFViewController.h"
#import "CGCommonWebView.h"

@interface PDFViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,retain)CGCommonWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *back;

@property(nonatomic,retain)NSString *url;

@end

@implementation PDFViewController

-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if(self){
        self.url = url;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavi];
    self.view.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#808080"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.processPool = [[WKProcessPool alloc]init];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.requiresUserActionForMediaPlayback = NO;
    self.webview = [CGCommonWebView sharedInstance];
    self.webview.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:self.webview];
    [self.view bringSubviewToFront:self.back];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)closeAction:(id)sender {
    [self baseBackAction];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self executeFontSize];
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
}

//改变字体
-(void)executeFontSize{
  NSInteger fontSize = 17;
  switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
    case 1:
      fontSize = 17;
      break;
    case 2:
      fontSize = 19;
      break;
    case 3:
      fontSize = 20;
      break;
    case 4:
      fontSize = 24;
      break;
      
    default:
      break;
  }
    NSString *fontSizeJS = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",fontSize];
    [self.webview evaluateJavaScript:fontSizeJS completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"改变字体完成");
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [GiFHUD dismiss];
}

-(void)dealloc{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
