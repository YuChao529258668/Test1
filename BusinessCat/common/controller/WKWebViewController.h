//
//  WKWebViewController.h
//  CGSays
//
//  Created by mochenyang on 2016/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  H5的Controller
//  用于打开app的H5，不能用来打开其他外部链接，外部链接使用CommonWebController

#import "CTBaseViewController.h"

@interface WKWebViewController : UIViewController

+(void)setPath:(NSString *)path code:(id)code success:(void(^)(id response))success fail:(void (^)(void))fail;

@end
