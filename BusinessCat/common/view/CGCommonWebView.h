//
//  CGCommonWebView.h
//  CGSays
//
//  Created by mochenyang on 2017/2/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//  公用的网页浏览控件，单例模式

#import <WebKit/WebKit.h>

@interface CGCommonWebView : WKWebView

+(CGCommonWebView *)sharedInstance;

@end
