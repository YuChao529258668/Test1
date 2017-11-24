//
//  CTBaseNaviController.m
//  VieProd
//
//  Created by Calon Mo on 16/3/23.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTBaseNaviController.h"
#import "AppConstants.h"
#import "AppDelegate.h"
#import "WKWebViewController.h"

@interface CTBaseNaviController ()

@property(nonatomic,retain)NSArray *blackStatusControllers;
@property(nonatomic,retain)NSArray *hideStatusControllers;

@end

@implementation CTBaseNaviController

//凡是需要黑色状态栏的，把该controller的名字放到下面这个数组，在这里进行统一管理
-(NSArray *)blackStatusControllers{
    if(!_blackStatusControllers){
        _blackStatusControllers = [NSArray arrayWithObjects:@"CGHeadlineInfoDetailController",@"CGTopicMainViewController",@"CGTopicCommentController",@"CommonWebViewController", nil];
    }
    return _blackStatusControllers;
}

//凡是需要隐藏状态栏的，把该controller的名字放到下面这个数组，在这里进行统一管理
-(NSArray *)hideStatusControllers{
    if(!_hideStatusControllers){
        _hideStatusControllers = [NSArray arrayWithObjects:@"WKWebViewController", nil];
    }
    return _hideStatusControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;//默认隐藏navi的自带导航栏
    self.view.backgroundColor = CTThemeMainColor;
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationBar.barTintColor = CTThemeMainColor;//导航栏背景颜色
    self.navigationBar.tintColor = [UIColor whiteColor];//返回箭头和文字的颜色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    self.delegate = self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    if(self = [super initWithRootViewController:rootViewController]){
        [self openInteractivePopGestureRecognizer];
    }
    return self;
}

/**
 * Custom initialization
 * 在naviVC中统一处理栈中各个vc是否支持滑动返回的情况
 * 当前仅最底层的vc关闭滑动返回
 */
- (void)openInteractivePopGestureRecognizer{
    UIGestureRecognizer *interactivePopGestureRecognizer = [self performSelector:@selector(interactivePopGestureRecognizer)];
    interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 解决手势会跟tableview和scrollview冲突问题 begin
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return [gestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self setState:NSStringFromClass([viewController class])];
}

-(void)setState:(NSString *)controllerName{
    
    BOOL isBlack = NO;
    for(NSString *controler in self.blackStatusControllers){
        if([controler isEqualToString:controllerName]){
            isBlack = YES;
            break;
        }
    }
    
    // 修改状态栏颜色
    isBlack = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:isBlack?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:NO];
    
    BOOL ishide = NO;
    for(NSString *controller in self.hideStatusControllers){
        if([controller isEqualToString:controller]){
            if([controller isEqualToString:NSStringFromClass([WKWebViewController class])]){
                if([ObjectShareTool sharedInstance].webview.showStatusBar == 1){
                    ishide = YES;
                }
            }else{
                ishide = YES;
            }
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:ishide withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIViewController<CTViewControllerPanReturnBackDelegate> *viewController = [self.viewControllers lastObject];
    if ([viewController respondsToSelector:@selector(isSupportPanReturnBack)]){
        return [viewController isSupportPanReturnBack];
    }else if (self.viewControllers.count == 1){//关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)shouldAutorotate{
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}
@end
