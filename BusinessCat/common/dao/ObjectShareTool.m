//
//  ObjectShareTool.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "ObjectShareTool.h"
#import "CGUserDao.h"
#import "WKWebViewController.h"
#import "CGUserCenterBiz.h"
#import "AppDelegate.h"
#import "CGCommonBiz.h"
#import "HeadLineDao.h"
#import "FMDatabase.h"
#import "CGHorrolEntity.h"
#import "CGCompanyDao.h"

#define TimerCount 60//倒计时总数

@interface ObjectShareTool()<WKNavigationDelegate,WKUIDelegate>


@end

@implementation ObjectShareTool

- (instancetype)init
{
  self = [super init];
  if (self) {
//    [self.webview loadRequest];
//    self.webviewTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(webviewTimerAction) userInfo:nil repeats:YES];
  }
  return self;
}

-(H5WebView *)webview{
//  if(!_webview){
//    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.processPool = [[WKProcessPool alloc]init];
//    configuration.allowsInlineMediaPlayback = YES;
//    configuration.mediaPlaybackRequiresUserAction = NO;
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
//      configuration.requiresUserActionForMediaPlayback = NO;
//    }
//    _webview = [[H5WebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
//    _webview.hidden = YES;
//    //ios8以下设置userAgent
//    [_webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//      NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",result,@"H5InAPP"], @"UserAgent", nil];
//      [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//    }];
//  }
  return _webview;
}

static ObjectShareTool *_sharedManager;

+ (ObjectShareTool *)sharedInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if(!_sharedManager){
      _sharedManager = [[ObjectShareTool alloc]init];
      _sharedManager.loginTimerCount = TimerCount;//初始默认数
    }
  });
  return _sharedManager;
}


-(CGUserEntity *)currentUser{
  if(!_currentUser){
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:USER_DATA];
    // 解档
    _currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
  }
  return _currentUser;
}

-(NSMutableDictionary *)knowledgeDict{
    if(!_knowledgeDict){
        _knowledgeDict = [NSMutableDictionary dictionary];
    }
    return _knowledgeDict;
}

-(NSMutableDictionary *)discoverDict{
  if (!_discoverDict) {
    _discoverDict = [NSMutableDictionary dictionary];
  }
  return _discoverDict;
}

-(NSMutableArray *)knowledgeBigTypeData{
    if(!_knowledgeBigTypeData){
        _knowledgeBigTypeData = [CGCompanyDao getJobKnowledgeStatisticsFromLocal];
    }
    return _knowledgeBigTypeData;
}

-(Reachability *)reachability{
  if(!_reachability){
    _reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
  }
  return _reachability;
}

//webview检查定时器
-(void)webviewTimerAction{
//    if(![[ObjectShareTool sharedInstance].webview superview]){
//        [[ObjectShareTool sharedInstance].webview addWebviewToWindow];
//    }
//    
//    NSString *url = [ObjectShareTool sharedInstance].webview.URL.absoluteString;
//    if(![CTStringUtil stringNotBlank:url]){
//        [[ObjectShareTool sharedInstance].webview loadRequest];
//        [[[CGCommonBiz alloc]init]uploadAppLog:@"APP定时器，H5被回收了"];
//    }
}


-(void)startLoginTimer{
  if(self.loginTimerCount == TimerCount){
    NSLog(@"启动定时器");
    self.loginVerifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loginVerifyTimerAction) userInfo:nil repeats:YES];
  }
}
-(void)stopLoginTimer{//关闭登录验证码倒计时函数
  NSLog(@"停止定时器");
  [self.loginVerifyTimer invalidate];
  self.loginVerifyTimer = nil;
  self.loginPhoneNum = nil;
  self.loginTimerCount = TimerCount;
}

-(void)loginVerifyTimerAction{
  NSLog(@"定时器执行中。。。");
  [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_TIMER object:@(self.loginTimerCount)];
  if(self.loginTimerCount <= 0){
    [self.loginVerifyTimer invalidate];
    self.loginVerifyTimer = nil;
    self.loginTimerCount = TimerCount;
  }else{
    self.loginTimerCount -= 1;
  }
}

+ (NSString *)currentUserID {
    return [ObjectShareTool sharedInstance].currentUser.uuid;
}

@end
