//
//  CGCompeteMainController.m
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGCompeteMainController.h"

@interface CGCompeteMainController ()

@end

@implementation CGCompeteMainController

- (void)viewDidLoad {
    self.title = @"竞报";
    [super viewDidLoad];
    self.view.backgroundColor = CTThemeMainColor;
    [self hideCustomNavi];
    [self hideCustomBackBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationToLoadH5) name:NSStringFromClass([self class]) object:nil];
}

//点击tab收到的通知
-(void)notificationToLoadH5{
    [self.view addSubview:[ObjectShareTool sharedInstance].webview];
    [[ObjectShareTool sharedInstance].bridge callHandler:@"setCurrentPath" data:@"discover/experience" responseCallback:^(id response) {
        NSLog(@"竞报---->调用js方法后接收到的参数: %@", response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
