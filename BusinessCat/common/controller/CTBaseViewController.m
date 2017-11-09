//
//  CTBaseViewController.m
//  VieProd
//
//  Created by Calon Mo on 16/3/23.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTBaseViewController.h"
#import "AppConstants.h"
#import "UMMobClick/MobClick.h"

@interface CTBaseViewController ()

@property(nonatomic,retain)NSString *titleStr;

@property(nonatomic,assign)BOOL showCustomNavi;//是否显示自定义的导航栏(默认隐藏)
@property(nonatomic,assign)BOOL showCustomBackBtn;//是否显示自定义导航栏的返回按钮(默认隐藏)

@end

@implementation CTBaseViewController

- (BOOL)shouldAutorotate{
  //是否允许转屏
  return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  //viewController所支持的全部旋转方向
  return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  //viewController初始显示的方向
  return UIInterfaceOrientationPortrait;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _showCustomNavi = YES;
        _showCustomBackBtn = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = CTCommonViewControllerBg;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = CTCommonViewControllerBg;
    [self.tableview setTableFooterView:view];
    [self.tableview setTableHeaderView:view];
    if ([self.tableview respondsToSelector:@selector(separatorInset)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    [self createCustomNavi];
    [self createCustomBackBtn];
}

-(void)setTitle:(NSString *)title{
    _titleStr = title;
    self.titleView.text = title;
}

-(void)baseBackAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createCustomNavi{
    if(_showCustomNavi){
        if(!self.navi){
            self.navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPBARHEIGHT)];
            self.navi.backgroundColor = CTThemeMainColor;
            self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(TOPBARCONTENTHEIGHT+5, CTMarginTop, SCREEN_WIDTH-2*(TOPBARCONTENTHEIGHT+5), TOPBARCONTENTHEIGHT)];
            self.titleView.backgroundColor = [UIColor clearColor];
            self.titleView.textColor = [UIColor whiteColor];
            self.titleView.textAlignment = NSTextAlignmentCenter;
            self.titleView.font = [UIFont systemFontOfSize:18];
            [self.navi addSubview:self.titleView];
        }
        self.titleView.text = _titleStr;
        [self.view addSubview:self.navi];
    }else{
        [self.navi removeFromSuperview];
        self.navi = nil;
    }
}

-(void)createCustomBackBtn{
    if(_showCustomBackBtn){
        if(!self.backBtn){
            self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, CTMarginTop, TOPBARCONTENTHEIGHT, TOPBARCONTENTHEIGHT)];
            [self.backBtn setImage:[UIImage imageNamed:@"topbar_goback_white_img"] forState:UIControlStateNormal];
            [self.backBtn addTarget:self action:@selector(baseBackAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.navi addSubview:self.backBtn];
    }else{
        [self.backBtn removeFromSuperview];
        self.backBtn = nil;
    }
}

-(void)showTopbarWithLogo:(NSString *)title desc:(NSString *)desc{
    [self hideCustomBackBtn];
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-32, 15, 20, 20)];
    logo.image = [UIImage imageNamed:@"common_top_logo"];
    logo.contentMode = UIViewContentModeCenter;
    [self.navi addSubview:logo];
    
    UILabel *module = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logo.frame), CGRectGetMinY(logo.frame), 50, 20)];
    module.textColor = [UIColor whiteColor];
    module.text = title;
    module.font = [UIFont systemFontOfSize:14];
    [self.navi addSubview:module];
    [module sizeToFit];
    
    float startX = (SCREEN_WIDTH - logo.frame.size.width - module.frame.size.width)/2;
    logo.frame = CGRectMake(startX, (44 - module.frame.size.height - 16)/2 + 20, logo.frame.size.width, logo.frame.size.height);
    module.frame = CGRectMake(CGRectGetMaxX(logo.frame),CGRectGetMinY(logo.frame)+2, module.frame.size.width,module.frame.size.height);
    
    UILabel *descL = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(module.frame), SCREEN_WIDTH, 16)];
    descL.font = [UIFont systemFontOfSize:12];
    descL.text = desc;
    descL.textAlignment = NSTextAlignmentCenter;
    descL.textColor = [UIColor whiteColor];
    [self.navi addSubview:descL];
}



//隐藏自定义导航栏
-(void)hideCustomNavi{
//    //NSLog(@"hideCustomNavi---------init");
    _showCustomNavi = NO;
    [self createCustomNavi];
}

-(void)showTheCustomNavi{
  _showCustomNavi = YES;
  [self createCustomNavi];
}
//隐藏自定义返回按钮
-(void)hideCustomBackBtn{
//    //NSLog(@"hideCustomBackBtn---------init");
    _showCustomBackBtn = NO;
    [self createCustomBackBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"Controller->%@->%@", NSStringFromClass([self class]),  NSStringFromSelector(_cmd));
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
