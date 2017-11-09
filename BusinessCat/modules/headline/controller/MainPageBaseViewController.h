//
//  MainPageBaseViewController.h
//  TestMain
//
//  Created by mochenyang on 2017/3/12.
//  Copyright © 2017年 mochenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMainPageHeader.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>

//菜单向上滑动的距离
#define CenterMenuOriginY 104

//顶部滑动菜单的高度(根据屏幕大小做不同的适应)
#define HeaderHeight iPhone4Inch?(SCREEN_HEIGHT*10.2f/15):iPhone47Inch?(SCREEN_HEIGHT*9.6f/15):(SCREEN_HEIGHT*9.2f/15)

//手指滑动到此距离自动置顶
#define WillScrollMargin (HeaderHeight - 200)

@interface MainPageBaseViewController : CTBaseViewController
//手指开始的位置
@property(nonatomic,assign)float fingerStartY;
//tableview开始的位置
@property(nonatomic,assign)float tableviewStartY;
//navi开始的位置
@property(nonatomic,assign)float naviStartY;
//装载tableview
@property(nonatomic,weak) IBOutlet UIScrollView *bottom;
//底部弹簧图片
@property(nonatomic,retain)UIImageView *logoBackgroundImage;
//中间菜单的view
@property(nonatomic,retain)CGMainPageHeader *menuView;

@property(nonatomic,retain)UIActivityIndicatorView *indicator;

@property(nonatomic,assign)BOOL isRefreshing;

//分类的view
@property(nonatomic,weak)IBOutlet UIView *typeView;

@property (nonatomic, assign) BOOL isClick;

-(void)resetHeadlineLocationAction;

//批量设置tableview是否可以滚动
-(void)setTableViewScrollStatus:(BOOL)state;
//菜单滑动到顶部
-(void)menuScrollToTop;
//菜单滑动到底部
-(void)menuScrollToBottom;


//获取当前在哪页
-(int)currentPage;

//下拉刷新
-(void)refreshTableASync:(int)index;

@end
