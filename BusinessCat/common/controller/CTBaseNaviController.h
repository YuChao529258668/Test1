//
//  CTBaseNaviController.h
//  VieProd
//
//  Created by mochenyang on 16/3/23.
//  Copyright © 2016年 CGsays. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTViewControllerPanReturnBackDelegate <NSObject>

/**
 * 当前viewController实现该方法，返回是否支持手势返回
 * 该方法可选，默认支持手势返回
 */
- (BOOL)isSupportPanReturnBack;

@end

@interface CTBaseNaviController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/**
 * 不需要手势返回的页面使用类别重写这个方法判断并返回NO时该页面不支持手势返回
 * 最后需要判断是否是根视图，必须增加否则会存在手势和push动画冲突
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;


@end
