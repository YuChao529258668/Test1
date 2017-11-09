//
//  HomePageAppsController.m
//  CGSays
//
//  Created by mochenyang on 2017/3/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "HomePageAppsController.h"
#import "CGDiscoverAppsEntity.h"
#import "HeadLineDao.h"

@interface HomePageAppsController ()

@property(nonatomic,retain)NSMutableArray *menus;
@property(nonatomic,assign)BOOL isClick;

@end

@implementation HomePageAppsController

-(void)viewWillAppear:(BOOL)animated{
    self.isClick = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.isClick = YES;
}

- (void)viewDidLoad {
    self.title = @"应用";
    [super viewDidLoad];
    float horMargin = 35;
    int columnNum = 4;
    float width = (SCREEN_WIDTH-(columnNum+1)*horMargin)/columnNum;
    float iconWidth = width-10;
    float imgWidth = iconWidth - 15;
    
    self.menus = [[[HeadLineDao alloc]init]queryHomePageMenuData];
    CGGropuAppsEntity *all;
    for(CGGropuAppsEntity *menu in self.menus){
        if([menu.name isEqualToString:@"全部"]){
            all = menu;
            break;
        }
    }
    if(all){
        [self.menus removeObject:all];
    }
    float startY = CGRectGetMaxY(self.navi.frame);
    if(self.menus && self.menus.count > 0){
        for(int i=0;i<self.menus.count;i++){
            CGGropuAppsEntity *menu = self.menus[i];
            int currentColumn = i%columnNum;//列
            int currentLine = i/columnNum;//行
            CGRect rect = CGRectMake((currentColumn+1)*horMargin+width*currentColumn,startY +(currentLine+1)*horMargin+width*currentLine, width, width);
            UIButton *button = [[UIButton alloc]initWithFrame:rect];
            button.tag = i;
            [self.view addSubview:button];
            
            UIImageView *iconBg = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-iconWidth/2, 0, iconWidth, iconWidth)];
            iconBg.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#3c6799"];
            iconBg.layer.cornerRadius = 10;
            [button addSubview:iconBg];
            
            UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(iconWidth/2-imgWidth/2, iconWidth/2-imgWidth/2, imgWidth, imgWidth)];
            icon.contentMode = UIViewContentModeScaleAspectFill;
            [icon sd_setImageWithURL:[NSURL URLWithString:menu.icon]];
            [iconBg addSubview:icon];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(width/2-(width+40)/2, CGRectGetMaxY(iconBg.frame), width+40, 20)];
            title.text = menu.name;
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [UIFont systemFontOfSize:13];
            title.textColor = [UIColor darkGrayColor];
            [button addSubview:title];
            
            [button addTarget:self action:@selector(openH5Action:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)openH5Action:(UIButton *)button{
    CGGropuAppsEntity *menu = self.menus[button.tag];
    if (self.isClick) {
        self.isClick = NO;
        [WKWebViewController setPath:@"setCurrentPath" code:menu.code success:^(id response) {
            
        } fail:^{
        }];
    }
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
