//
//  YCMultiCallHelper.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMultiCallHelper.h"
#import "CGSelectContactsViewController.h" // 选择通讯录

@interface YCMultiCallHelper()

// 多人语音通话控制器
//@property (nonatomic,strong,readwrite) UIViewController *multiCallViewController; // strong 需要不用时设置为 nil
@property (nonatomic,weak,readwrite) UIViewController *multiCallViewController;

// 发起语音通话的控制器，废弃
@property (nonatomic,strong) UIViewController *sourceVC; // 废弃

@end


@implementation YCMultiCallHelper

#pragma mark - 单例

static YCMultiCallHelper *helper;

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [YCMultiCallHelper new];
    });
    return helper;
}

#pragma mark - 有效

- (UIButton *)createAddContactBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 高于底部 view 就行，底部 view 高度 112
    float width = 60;
    float x = [UIScreen mainScreen].bounds.size.width / 2;
    float y = [UIScreen mainScreen].bounds.size.height - 112 - width /2 - 6;
    CGRect frame = CGRectMake(0, 0, width, width);
    btn.frame = frame;
    btn.center = CGPointMake(x, y);
    [btn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addContactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)addContactBtnClick {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    CGSelectContactsViewController *vc = [[CGSelectContactsViewController alloc]init];
    vc.titleForBar = @"选择联系人";
    
    vc.completeBtnClickBlock = ^(NSMutableArray<CGUserCompanyContactsEntity *> *contacts) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
        for (CGUserCompanyContactsEntity *contact in contacts) {
            [array addObject:contact.userId];
        }
        [YCJCSDKHelper multiCall:array displayName:nil];
    };
    
//    [self.navigationController pushViewController:vc animated:YES]; // 不弹出新界面
//    [self.presentedViewController.navigationController pushViewController:vc animated:YES]; // 不弹出新界面
    // 通话界面不显示时，发生通话事件会崩溃，比如拨打新用户，通话结束
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen; // 让显示选择联系人界面时，通话界面不消失
//    [self.sourceVC.presentedViewController presentViewController:vc animated:YES completion:nil]; // 通话界面跳出联系人界面
    [self.multiCallViewController presentViewController:vc animated:YES completion:nil]; // 通话界面跳出联系人界面
}

+ (void)setMultiCallViewController:(UIViewController *)multiCallVC {
    YCMultiCallHelper *helper = [YCMultiCallHelper shareHelper];
    helper.multiCallViewController = multiCallVC;
    [multiCallVC.view addSubview:[helper createAddContactBtn]];
}









#pragma mark - 交换方法 无效
// 成功交换执行的代码，但是 self 指代的对象也跟着变了。所以交换两个类的方法是不可行的，用到 self 必然报错。

//- (void)setSourceVC:(UIViewController *)sourceVC {
//    _sourceVC = sourceVC;
//
//    //    [self exchangeMethod];
//    //    [self addKVO];
//}

- (void)exchangeMethod {
//    Class class = NSClassFromString(@"CallingViewController");
    Method m1 = class_getInstanceMethod(self.sourceVC.class, @selector(viewWillDisappear:));
    Method m2 = class_getInstanceMethod(self.class, @selector(yc_viewWillDisappear:));
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod(self.sourceVC.class, @selector(viewWillAppear:));
    Method m4 = class_getInstanceMethod(self.class, @selector(yc_viewWillAppear:));
    method_exchangeImplementations(m3, m4);
}

// yc_viewWillDisappear 删除 btn， sourceVC = nil
- (void)yc_viewWillDisappear:(BOOL)animated {
    
    [[YCMultiCallHelper shareHelper] performSelector:@selector(yc_viewWillDisappear:) withObject:@(animated)]; // [YCMultiCallHelper presentedViewController]: unrecognized selector
    
//    [[YCMultiCallHelper shareHelper].sourceVC performSelector:@selector(viewWillDisappear:) withObject:@(animated)];
    
    
//    [self yc_viewWillDisappear:animated]; // self 此时是 CGChatListViewController，会崩溃，找不到方法。
//    [self.sourceVC yc_viewWillDisappear:animated]; // 编译报错，找不到方法

    // 被添加 btn 的控制器
//    UIViewController *targetVC = self.sourceVC.presentedViewController;
    UIViewController *targetVC = [YCMultiCallHelper shareHelper].sourceVC.presentedViewController;
    [targetVC.view addSubview:[self createAddContactBtn]];
}

// 获取
- (void)yc_viewWillAppear:(BOOL)animated {
//    [self yc_viewWillAppear:animated];
//    [self.sourceVC yc_viewWillAppear:animated];

//    self.sourceVC = nil; // self 是单例，释放内存
    
    [[YCMultiCallHelper shareHelper] performSelector:@selector(yc_viewWillAppear:) withObject:@(animated)];
    [YCMultiCallHelper shareHelper].sourceVC = nil;
}


#pragma mark - kvo观察presentedViewController 无效

- (void)addKVO {
//    [self.sourceVC addObserver:self forKeyPath:@"presentedViewController" options:NSKeyValueObservingOptionNew context:nil];
    [self.sourceVC addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"presentedViewController"]) {
        UIViewController *targetVC = self.sourceVC.presentedViewController;
        [targetVC.view addSubview:[self createAddContactBtn]];

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
