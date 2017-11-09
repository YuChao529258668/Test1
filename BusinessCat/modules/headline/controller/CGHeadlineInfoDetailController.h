//
//  CGHeadlineInfoDetailController.h
//  CGSays
//
//  Created by mochenyang on 2016/9/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGInfoHeadEntity.h"
#import "CGDetailToolBar.h"
#import "HeadlineDetailLoadingView.h"
#import "CGCommonWebView.h"
typedef void (^CGHeadlineInfoDetailDeleteBlock)();
@interface CGHeadlineInfoDetailController : CTBaseViewController

@property (retain, nonatomic) WKWebView *webView;

@property(nonatomic,weak)IBOutlet CGDetailToolBar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *tuiBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, strong) CGInfoHeadEntity *info;

@property (nonatomic, assign) BOOL isH5;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) NSInteger detailType;//1我要评论 2打开文档 3支付费用 4访问工具网址 5下载文档
@property (nonatomic, strong) NSMutableArray *typeArray;//校正功能需要用到
@property(nonatomic,retain)NSString *infoId;
@property(nonatomic,assign)NSInteger type;
-(instancetype)initWithInfoId:(NSString *)infoId type:(NSInteger)type block:(CGHeadlineInfoDetailDeleteBlock)block;

@end
