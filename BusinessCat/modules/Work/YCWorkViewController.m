//
//  YCWorkViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCWorkViewController.h"
#import "CGMeetingListViewController.h"

@interface YCWorkViewController ()

@end

@implementation YCWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideCustomBackBtn];
    [self createCustomNavi];
//    self.navigationItem.title = @"工作";
    
    CGMeetingListViewController *vc = [CGMeetingListViewController new];
    [self addChildViewController:vc];
    
    CGRect frame = vc.view.frame;
//    frame.size.height = self.view.frame.size.height - kCGBottomBarHeight - TOPBARHEIGHT;
    frame.size.height = self.view.frame.size.height - TOPBARHEIGHT;
    frame.origin.y = TOPBARHEIGHT;
    vc.view.frame = frame;
    [self.view addSubview:vc.view];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

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
    self.titleView.text = @"工作";

    [self.view addSubview:self.navi];
    
}

- (void)tokenCheckComplete:(BOOL)state {
    
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict {
    
}


@end
