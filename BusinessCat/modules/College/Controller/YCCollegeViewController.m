//
//  YCCollegeViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCCollegeViewController.h"

@interface YCCollegeViewController ()

@end

@implementation YCCollegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self hideCustomBackBtn];
    [self createCustomNavi];

}


#pragma mark - 适配旧代码

//- (void)layoutTableView {
//    float y = TOPBARHEIGHT;
//    //    float bottomBarH = [((AppDelegate *)[UIApplication sharedApplication].delegate) bottomBarHeight];
//    //    float height = self.tableView.frame.size.height - y;
//    //    float height = SCREEN_HEIGHT - y - bottomBarH;
//    float height = self.view.frame.size.height - y; // 自己 view 的高度由 tab controller 决定
//    CGRect rect = self.tableView.frame;
//    rect.size.height = height;
//    rect.origin.y = y;
//    self.tableView.frame = rect;
//}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self layoutTableView];
//}
//
//
-(void)createCustomNavi{
    
    if(!self.navi){
        self.navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPBARHEIGHT)];
        self.navi.backgroundColor = CTThemeMainColor;
        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(TOPBARCONTENTHEIGHT+5, CTMarginTop, SCREEN_WIDTH-2*(TOPBARCONTENTHEIGHT+5), TOPBARCONTENTHEIGHT)];
        self.titleView.backgroundColor = [UIColor clearColor];
        self.titleView.textColor = [UIColor blackColor];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        self.titleView.font = [UIFont systemFontOfSize:18];
        [self.navi addSubview:self.titleView];
    }
    self.titleView.text = @"学院";
    
    [self.view addSubview:self.navi];
    
}

- (void)tokenCheckComplete:(BOOL)state {
    
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict {
    
}

@end
