//
//  H5WebView.h
//  CGSays
//
//  Created by mochenyang on 2017/2/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface H5WebView : WKWebView<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property(nonatomic,assign)BOOL canSwipToNative;//是否可以滑动返回原生界面

@property(nonatomic,assign)BOOL showStatusBar;//yes隐藏，no显示

@property(nonatomic,strong)WKWebViewJavascriptBridge *bridge;

@property(nonatomic,assign)BOOL finishLoadH5;//未加载完成，app可以先提示请稍后

-(void)addWebviewToWindow;

-(void)loadRequest;
@end
