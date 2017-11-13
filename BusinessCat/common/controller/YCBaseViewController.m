//
//  YCBaseViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBaseViewController.h"
#import "UMMobClick/MobClick.h"

@interface YCBaseViewController ()

@end

@implementation YCBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldHideNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.shouldHideNavigationBar animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
@end
