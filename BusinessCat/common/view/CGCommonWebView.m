//
//  CGCommonWebView.m
//  CGSays
//
//  Created by mochenyang on 2017/2/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGCommonWebView.h"

@implementation CGCommonWebView


static CGCommonWebView *_sharedManager;

+(CGCommonWebView *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_sharedManager){
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            configuration.processPool = [[WKProcessPool alloc]init];
            configuration.allowsInlineMediaPlayback = YES;
            configuration.mediaPlaybackRequiresUserAction = NO;
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
                configuration.requiresUserActionForMediaPlayback = NO;
            }
            _sharedManager = [[CGCommonWebView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds configuration:configuration];
            _sharedManager.backgroundColor = CTCommonViewControllerBg;
            _sharedManager.scrollView.backgroundColor = CTCommonViewControllerBg;
        }
    });
    [_sharedManager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    return _sharedManager;
}
@end
