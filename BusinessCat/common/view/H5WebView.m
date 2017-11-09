//
//  H5WebView.m
//  CGSays
//
//  Created by mochenyang on 2017/2/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "H5WebView.h"
#import "ShareUtil.h"
#import "CGUserCenterBiz.h"
#import "CGUserDao.h"
#import "PDFViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CommonWebViewController.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGLightExpEntity.h"
#import "CGLaunchScreen.h"
#import "CGCommonBiz.h"
#import "WKWebViewController.h"
#import "CTRootViewController.h"
#import "AppDelegate.h"
#import "CGAttentionDynamicViewController.h"

@interface H5WebView()
@property(nonatomic,retain)CTRootViewController *rootController;
@property (nonatomic, strong) ShareUtil *share;
@property(nonatomic,retain)NSString *imageUrl;

@end

@implementation H5WebView

-(CTRootViewController *)rootController{
    if(!_rootController){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _rootController = app.rootController;
    }
    return _rootController;
}


- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    self = [super initWithFrame:frame configuration:configuration];
    if(self){
        __weak typeof(self) weakSelf = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.navigationDelegate = self;
        self.UIDelegate = self;
        self.scrollView.bounces = NO;
//        self.allowsBackForwardNavigationGestures = YES;
        
        //长按手势
        UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(webviewLongPressed:)];
        longPressed.delegate = self;
        [self addGestureRecognizer:longPressed];
        
        self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self];
        [self.bridge setWebViewDelegate:self];
        
        [self.bridge registerHandler:@"H5FinishedLoad" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"触发了H5加载完成的函数");
            CGLaunchScreen *screen = (CGLaunchScreen *)[[UIApplication sharedApplication].keyWindow viewWithTag:999];
            [screen close];
        }];
        //H5主动拉取用户信息
        [self.bridge registerHandler:@"updateUserData" handler:^(id data, WVJBResponseCallback responseCallback) {
            int state = [data intValue];
            if(state == 0){//不用更新token
                //NSLog(@"------H5主动拉取用户信息-不用更新token----------：%d",state);
                responseCallback([ObjectShareTool sharedInstance].currentUser.mj_JSONString);
            }else{
                //NSLog(@"------H5主动拉取用户信息-需要更新token----------：%d",state);
                [[[CGUserCenterBiz alloc]init]getToken:^(NSString *uuid, NSString *token) {
                    responseCallback([ObjectShareTool sharedInstance].currentUser.mj_JSONString);
                } fail:^(NSError *error) {
                    responseCallback(nil);
                }];
            }
        }];
        //H5主动推送用户信息到原生
        [self.bridge registerHandler:@"postUserDataToNative" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"H5推用户数据过来：%@",data);
          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:@"success"];
            responseCallback(@"success");
        }];
        
        //打开原生头条详情
        [self.bridge registerHandler:@"toNativeHeadlineDetailPage" handler:^(id data, WVJBResponseCallback responseCallback) {
            [weakSelf toNativeHeadlineDetailPage:data];
            responseCallback(@"success");
        }];
        
        //用原生打开url
        [self.bridge registerHandler:@"showPdfAtNative" handler:^(id data, WVJBResponseCallback responseCallback) {
            PDFViewController *controller = [[PDFViewController alloc]initWithUrl:data];
            [self.rootController presentViewController:controller animated:YES completion:nil];
            responseCallback(@"success");
        }];
        
        //返回原生界面
        [self.bridge registerHandler:@"toNative" handler:^(id data, WVJBResponseCallback responseCallback) {
            //NSLog(@"toNative----收到js调用原生函数的请求to原生-----参数---->%@",data);
            [weakSelf notificationToBackNative:data];
            responseCallback(@"success");
        }];
      
      //H5打开原生动态界面
      [self.bridge registerHandler:@"openDynamic" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"toNative----收到js调用原生函数的请求to原生-----参数---->%@",data);
        CGAttentionDynamicViewController *vc = [[CGAttentionDynamicViewController alloc]init];
        NSDictionary *dic = data;
        if ([[dic allKeys] containsObject:@"type"]) {
          NSString *type = dic[@"type"];
          vc.type = type.intValue;
        }
        if ([[dic allKeys] containsObject:@"dynamicID"]) {
          vc.dynamicID =dic[@"dynamicID"];;
        }
        if ([[dic allKeys] containsObject:@"navTypeId"]) {
          vc.navTypeId =dic[@"navTypeId"];;
        }
        [self.rootController.navigationController pushViewController:vc animated:YES];
        responseCallback(@"success");
      }];
      
        //跳转到搜索界面
        [self.bridge registerHandler:@"toSearch" handler:^(id data, WVJBResponseCallback responseCallback) {
            //NSLog(@"toNative----收到js调用原生函数的请求to原生-----参数---->%@",data);
            NSDictionary *dic = data;
            CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
            if ([[dic allKeys] containsObject:@"type"]) {
                NSString *type = dic[@"type"];
                vc.type = type.intValue;
            }
            if ([[dic allKeys] containsObject:@"action"]) {
                vc.action =dic[@"action"];;
            }
            if ([[dic allKeys] containsObject:@"id"]) {
                vc.typeID =dic[@"id"];;
            }
            if ([[dic allKeys] containsObject:@"groupId"]) {
                vc.groupId = dic[@"groupId"];
            }
            vc.isHtml5 = YES;
            [self.rootController.navigationController pushViewController:vc animated:YES];
            responseCallback(@"success");
        }];
        
        //是否显示状态栏
        [self.bridge registerHandler:@"toggleTime" handler:^(id data, WVJBResponseCallback responseCallback) {
            self.showStatusBar = [data boolValue];
            [[UIApplication sharedApplication] setStatusBarHidden:self.showStatusBar withAnimation:UIStatusBarAnimationNone];
            
            responseCallback(@"success");
        }];
        
        //打开webview
        [self.bridge registerHandler:@"openWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *code = data;
            if([code rangeOfString:@"itunes.apple.com"].location !=NSNotFound){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:code]];
            }else{
                CommonWebViewController *vc = [[CommonWebViewController alloc]init];
                vc.url = code;
                [self.rootController.navigationController pushViewController:vc animated:YES];
            }
            responseCallback(@"success");
        }];
        
        //刷新体验
        [self.bridge registerHandler:@"updateLightExp" handler:^(id data, WVJBResponseCallback responseCallback) {
          NSDictionary *dic = data;
          NSString *gid = dic[@"gid"];
          if (gid.length<=0) {
            NSDictionary *apps = dic[@"apps"];
            NSNumber *type = [apps objectForKey:@"type"];
            if (type.integerValue == 2) {
              CGLightExpEntity *comment = [CGLightExpEntity mj_objectWithKeyValues:apps];
              if(comment.apps && ![comment.appsJsonStr isKindOfClass:[NSNull class]] && comment.apps.count > 0){
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apps[@"apps"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                comment.appsJsonStr = json;
              }
              [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOINPRODUCT object:comment];
            }else{
              CGApps *comment = [CGApps mj_objectWithKeyValues:apps];
              [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOINPRODUCT object:comment];
            }
          }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOINPRODUCT object:dic];
          }
            responseCallback(@"success");
        }];
      
      //刷新关注
      [self.bridge registerHandler:@"updateAttention" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(@"success");
      }];
      
        //刷新关注
        [self.bridge registerHandler:@"updateAttention" handler:^(id data, WVJBResponseCallback responseCallback) {
//            NSDictionary *dic = data;
//            NSString *type = dic[@"type"];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:nil];
            responseCallback(@"success");
        }];
        
        //用原生打开分享
        [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSDictionary *dic = data;
            NSString *textToShare = dic[@"title"];
            //    UIImage *imageToShare = [UIImage imageNamed:@"cgsays_logo"];
            weakSelf.share =[[ShareUtil alloc]init];
            [weakSelf.share showShareMenuWithTitle:textToShare desc:textToShare isqrcode:1 image:dic[@"image"] url:dic[@"url"] block:^(NSMutableArray *array) {
                UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
                [self.rootController presentViewController:activityVC animated:YES completion:nil];
            }];
            responseCallback(@"success");
        }];
        
        //文库详情
        [self.bridge registerHandler:@"toLibraryDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSDictionary *dic = data;
            NSString *infoID = dic[@"id"];
            NSString *type = dic[@"type"];
            CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:infoID type:type.intValue block:^{
              
            }];
          vc.isH5 = YES;
            [self.rootController.navigationController pushViewController:vc animated:YES];
            responseCallback(@"success");
        }];
      
      //打开webview
      [self.bridge registerHandler:@"gotoHtml5" handler:^(id data, WVJBResponseCallback responseCallback) {
          UIView *superview = self.superview;
//          NSString *s = NSStringFromClass([superview class]);
          if([superview isKindOfClass:[UIWindow class]]){
              WKWebViewController *webview = [[WKWebViewController alloc]init];
              [self.rootController.navigationController pushViewController:webview animated:YES];
          }
          
        responseCallback(@"success");
      }];
        //监听开启/关闭webview的内部滑动后退手势
        [self.bridge registerHandler:@"setGesture" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"打印：%@",data);
            if([data isEqualToString:@"web"]){//关闭滑动返回原生界面
                self.canSwipToNative = NO;
//                [ObjectShareTool sharedInstance].webview.allowsBackForwardNavigationGestures = YES;
            }else if([data isEqualToString:@"page"]){//开启滑动返回原生界面
//                [ObjectShareTool sharedInstance].webview.allowsBackForwardNavigationGestures = NO;
                self.canSwipToNative = YES;
            }
            responseCallback(@"success");
        }];
        
        
    //h5数据监控
        [self.bridge registerHandler:@"shujutext" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSDictionary *dic = data;
            NSDictionary *param = dic[@"param"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic[@"strtime"],@"strtime",dic[@"endtime"],@"endtime",dic[@"url"],@"url",jsonString,@"param",dic[@"type"],@"type",dic[@"errCode"],@"errCode",dic[@"message"],@"message", nil];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [path stringByAppendingPathComponent:@"shujudata"];
            NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            if (dataArray.count<=0) {
                dataArray = [NSMutableArray array];
            }
            [dataArray insertObject:dic1 atIndex:0];
            if (dataArray.count>100) {
                [dataArray removeObjectsInRange:NSMakeRange(100, (dataArray.count-100))];
            }
            [NSKeyedArchiver archiveRootObject:dataArray toFile:filePath];
            responseCallback(@"success");
        }];
        
        //ios9以上设置userAgent，ios8的在ObjectShareTool里init函数设置
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
            [self evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                self.customUserAgent = [NSString stringWithFormat:@"%@ %@",result,@"H5InAPP"];
            }];
            
        }
    }
    return self;
}


-(void)notificationToBackNative:(NSString *)data{
    if([@"Headlines" isEqualToString:data] || [@"Skill" isEqualToString:data] || [@"Discover" isEqualToString:data] || [@"Reports" isEqualToString:data] ||[@"Mine" isEqualToString:data] || [@"Search" isEqualToString:data]||[@"Content" isEqualToString:data]){
        [self backToNativ];
    }
}

//返回原生
-(void)backToNativ{
    [self.rootController.navigationController popViewControllerAnimated:YES];
}


-(void)toNativeHeadlineDetailPage:(NSDictionary *)param{
    CGHeadlineInfoDetailController *controller = [[CGHeadlineInfoDetailController alloc]initWithInfoId:[param objectForKey:@"infoId"] type:[[param objectForKey:@"type"]intValue] block:^{
      
    }];
  controller.isH5 = YES;
    [self.rootController.navigationController pushViewController:controller animated:YES];
}

- (void)webviewLongPressed:(UITapGestureRecognizer*)recognizer{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    [self evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        self.imageUrl = result;
        if (self.imageUrl.length == 0) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存储图像",@"拷贝", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){//存储图像
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        UIImage* image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else if (buttonIndex == 1){//拷贝
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.imageUrl;
        self.imageUrl = nil;
    }
}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error){
        [[CTToast makeText:@"保存失败"]show:[UIApplication sharedApplication].keyWindow];
    }else {
        [[CTToast makeText:@"保存成功"]show:[UIApplication sharedApplication].keyWindow];
    }
    self.imageUrl = nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"Client Not handler");
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    self.finishLoadH5 = YES;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential* cred = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

-(void)loadRequest{
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data/index.0694ff.html"];
    NSString *filePath1 = [[documentArray lastObject] stringByAppendingPathComponent:@"/html5Data"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index.0694ff" ofType:@"html" inDirectory:@"html5"];
    if (result) {
        NSURL* url = [NSURL fileURLWithPath:filePath];
        NSURL* url1 = [NSURL fileURLWithPath:filePath1];
        [self loadFileURL:url allowingReadAccessToURL:url1];
    }else if (path){
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }else{
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_H5]]];
    }
}

-(void)addWebviewToWindow{
    [[UIApplication sharedApplication].keyWindow insertSubview:[ObjectShareTool sharedInstance].webview atIndex:0];
    [ObjectShareTool sharedInstance].webview.hidden = YES;
}

-(void)dealloc{
    [[[CGCommonBiz alloc]init]uploadAppLog:@"WebView被怼掉了，Webview被回收了"];
}



@end
