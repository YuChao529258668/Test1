//
//  MainPageBaseViewController.m
//  TestMain
//
//  Created by mochenyang on 2017/3/12.
//  Copyright © 2017年 mochenyang. All rights reserved.
//

#import "MainPageBaseViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CTRootViewController.h"
#import "HeadlineBigTypeEditController.h"
#import "SDCycleScrollView.h"
#import "CGDiscoverAppsEntity.h"
#import "CGDiscoverDataEntity.h"
#import "CGDiscoverBiz.h"
#import "ZbarController.h"
#import "commonViewModel.h"

@interface MainPageBaseViewController ()<CGMainPageHeaderDelegate,IFlyRecognizerViewDelegate>

@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;

@property(nonatomic,strong)UIPanGestureRecognizer *handleSwipe;
@property (nonatomic, strong) commonViewModel *viewModel;

@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词

@end

static float LogoBackgroupHeight = 0;

@implementation MainPageBaseViewController

-(void)viewWillDisappear:(BOOL)animated{
    self.isClick = YES;
  self.viewModel.isClick = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.isClick = YES;
  self.viewModel.isClick = YES;
}

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
    _viewModel.isClick = YES;
  }
  return _viewModel;
}

-(NSMutableString *)speekWord{
    if(!_speekWord){
        _speekWord = [NSMutableString string];
    }
    return _speekWord;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //装载UITableview的根view
    self.bottom.frame = CGRectMake(0, HeaderHeight, self.bottom.frame.size.width, self.bottom.frame.size.height);
    //弹簧图片高度
    LogoBackgroupHeight = CGRectGetMinY(self.menuView.hotSearchView.frame);
    self.logoBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LogoBackgroupHeight)];
    self.logoBackgroundImage.clipsToBounds = YES;
    self.logoBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    self.logoBackgroundImage.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:self.logoBackgroundImage];
    
    
    UIButton *changeSkinBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40-5, 15, 40, 40)];
    [changeSkinBtn setImage:[UIImage imageNamed:@"main_menu_changeskin"] forState:UIControlStateNormal];
    [self.view addSubview:changeSkinBtn];
    
    [self.view addSubview:self.menuView];
    
    [self hideCustomBackBtn];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 32, 20, 20)];
    leftImage.image = [UIImage imageNamed:@"headlines"];
    [self.navi addSubview:leftImage];
    
    UILabel *leftTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+5, 20, 100, 44)];
    leftTitle.text = @"今日知识";
    leftTitle.textColor = [UIColor whiteColor];
    leftTitle.font = [UIFont systemFontOfSize:15];
    [self.navi addSubview:leftTitle];
    
    self.navi.frame = CGRectMake(0,-self.navi.frame.size.height, self.navi.frame.size.width, self.navi.frame.size.height);
    self.navi.alpha = 0;
    [self.view bringSubviewToFront:self.navi];
    [self.view bringSubviewToFront:self.typeView];
    [self.view bringSubviewToFront:self.bottom];
    self.typeView.alpha = 0;
    self.typeView.backgroundColor = CTCommonViewControllerBg;
    self.handleSwipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:self.handleSwipe];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"common_search_white_icon"] forState:UIControlStateNormal];
    [self.navi addSubview:rightBtn];
    [self menuScrollToTop];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.frame = CGRectMake(SCREEN_WIDTH/2-self.indicator.frame.size.width/2, -self.indicator.frame.size.height, self.indicator.frame.size.width, self.indicator.frame.size.height);
  [self.view addSubview:self.indicator];
}

- (void)scrollViewDidScroll:(float)y{
    CGRect backgroupRect = self.logoBackgroundImage.frame;
    backgroupRect.size.height = LogoBackgroupHeight + y;
    backgroupRect.size.width = SCREEN_WIDTH + y;
    backgroupRect.origin.x = -y/2;
    if(backgroupRect.origin.x >= 0){
        backgroupRect.origin.x = 0;
    }
    self.logoBackgroundImage.frame = backgroupRect;
}



-(void)rightBtnAction{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 0;
    vc.action = @"library";
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGMainPageHeader *)menuView{
    if (!_menuView) {
        _menuView = [[CGMainPageHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
        _menuView.delegate = self;
    }
    return _menuView;
}

//重置位置
-(void)resetHeadlineLocationAction{
    [self menuScrollToBottom];
}

//批量设置tableview是否可以滚动
-(void)setTableViewScrollStatus:(BOOL)state{
    NSArray *subs = self.bottom.subviews;
    if(subs && subs.count > 0){
        for(int i=0;i<subs.count;i++){
            UIView *sub = subs[i];
            if([sub isKindOfClass:[UITableView class]]){
                UITableView *table = (UITableView *)sub;
                table.scrollEnabled = state;
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void)handleSwipe:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.fingerStartY = [gesture locationInView:gesture.view].y;
        self.tableviewStartY = self.bottom.frame.origin.y;
        self.naviStartY = self.navi.frame.origin.y;
    }else if (gesture.state == UIGestureRecognizerStateChanged){
//        if(((CTRootViewController *)self.parentViewController).headlineTabIsShow){//如果头条已经是置顶，则不能拖动手势
//            return;
//        }
//        CGPoint translation = [gesture translationInView:self.view];
//        float fingerCurrentY = [gesture locationInView:gesture.view].y;
//        float deltaY = self.fingerStartY - fingerCurrentY;//手指移动的距离，向下移动为负数，向上移动为正数
//        
//        //设置底部头条列表view的位置
//        float bottomY = 0;
//        float naviY = fabs((deltaY*64)/(HeaderHeight-104)) - 64;
//        //设置中间菜单view的位置
//        float menuY = -fabs((deltaY*CenterMenuOriginY)/(HeaderHeight-64));
//        //设置中间菜单view的alpha透明值
//        float menuAlpha = 1-fabs((deltaY*CenterMenuOriginY)/(HeaderHeight-CenterMenuOriginY))/CenterMenuOriginY;
//        float naviAlpha = ((64+naviY)/64)*4/5;//由于变成1的时候太快，所以取4/5
//        if(naviAlpha >= 1){
//            naviAlpha = 1;
//        }
//        //下拉刷新图标的位置
//        
//        float refreshImageY = -self.indicator.frame.size.height;
//        
//        if(translation.y > 0){//向下
//            bottomY = self.tableviewStartY - deltaY/5;
//            refreshImageY = -30+fabs(deltaY)/4;
//            naviY = -64;
//            menuY = fabs(deltaY)/5;
//            [self scrollViewDidScroll:menuY];
//            menuAlpha = 1;
//        }else{//向上
//            bottomY = self.tableviewStartY - deltaY;
//            if(bottomY <= CGRectGetMaxY(self.typeView.frame)){
//                bottomY = CGRectGetMaxY(self.typeView.frame);
//            }
//            if(naviY >= 0){
//                naviY = 0;
//            }
//            [self scrollViewDidScroll:0];
//            self.logoBackgroundImage.frame = CGRectMake(0, menuY, SCREEN_WIDTH, LogoBackgroupHeight);
//        }
//        CGRect naviRect = self.navi.frame;
//        naviRect.origin.y = naviY;
//        self.navi.frame = naviRect;//导航栏的滚动轨迹
//        self.menuView.frame = CGRectMake(0, menuY, self.menuView.frame.size.width, self.menuView.frame.size.height);//菜单滚动轨迹
//        CGRect bottomRect = self.bottom.frame;
//        bottomRect.origin.y = bottomY;
//        self.bottom.frame = bottomRect;//底部头条的滚动轨迹
//        
//        if(!self.isRefreshing){
//            CGRect refreshRect = self.indicator.frame;
//            refreshRect.origin.y = refreshImageY;
//            self.indicator.frame = refreshRect;
//        }
//        
//        self.navi.alpha = naviAlpha;//导航栏透明度
//        self.logoBackgroundImage.alpha = menuAlpha;//弹簧图片透明度
//        self.menuView.alpha = menuAlpha;//菜单透明度
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        float tableviewCurrentY = self.bottom.frame.origin.y;
        if(tableviewCurrentY <= (SCREEN_HEIGHT/2+50)){
            [self menuScrollToTop];
        }else{
            [self menuScrollToBottom];
        }
        //开启刷新
        if(self.indicator.frame.origin.y >= 25){
            self.isRefreshing = YES;
            [self startToRotateRefreshImage];
        }else{
            [self resetRefreshImage];
        }
    }
}

//开始旋转刷新的图标
-(void)startToRotateRefreshImage{
    CGRect rect = self.indicator.frame;
    rect.origin.y = 20;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.frame = rect;
    }];
    [self.indicator startAnimating];
//    
//    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.fromValue = [NSNumber numberWithFloat: M_PI *2];
//    animation.toValue =  [NSNumber numberWithFloat:0.f];
//    animation.duration  = 0.5;
//    animation.autoreverses = NO;
//    animation.fillMode =kCAFillModeForwards;
//    animation.repeatCount = kRequsetTimeOutSeconds/0.5;
//    [self.refreshImage.layer addAnimation:animation forKey:nil];
    [self.menuView refreshAllDataWithBlock:^{
        [self.indicator stopAnimating];
//        [self.refreshImage.layer removeAllAnimations];
        [self performSelector:@selector(resetRefreshImage) withObject:nil afterDelay:0.3];
    }];
    [self refreshTableASync:[self currentPage]];
}

-(void)resetRefreshImage{
    CGRect rect = self.indicator.frame;
    rect.origin.y = -self.indicator.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.frame = rect;
    }completion:^(BOOL finished) {
        self.isRefreshing = NO;
    }];
}

-(void)menuScrollToTop{
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              self.logoBackgroundImage.frame = CGRectMake(0, -CenterMenuOriginY, SCREEN_WIDTH, LogoBackgroupHeight);
              self.menuView.frame = CGRectMake(0, -CenterMenuOriginY, self.menuView.frame.size.width, self.menuView.frame.size.height);
              self.bottom.frame = CGRectMake(0, CGRectGetMaxY(self.typeView.frame), self.bottom.frame.size.width, self.bottom.frame.size.height);
              
              self.logoBackgroundImage.alpha = 0;
              self.menuView.alpha = 0;
              
              self.bottom.scrollEnabled = YES;
              [self setTableViewScrollStatus:YES];
            
              //显示头条的返回键
//              [((CTRootViewController *)self.parentViewController)showHeadlineBackTab];
          }completion:^(BOOL finished) {
              
          }];
    
    [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              self.navi.frame = CGRectMake(0, 0, self.navi.frame.size.width, self.navi.frame.size.height);
              self.navi.alpha = 1;
              self.typeView.alpha = 1;
          }completion:^(BOOL finished) {
              
          }];
}
-(void)menuScrollToBottom{
    [[self.bottom viewWithTag:1000] removeFromSuperview];//当返回首页初始状态时，把提示移除掉
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              self.navi.frame = CGRectMake(0, -self.navi.frame.size.height, self.navi.frame.size.width, self.navi.frame.size.height);
              self.logoBackgroundImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, LogoBackgroupHeight);

              self.menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
              self.bottom.frame = CGRectMake(0, HeaderHeight, self.bottom.frame.size.width, self.bottom.frame.size.height);
              
              self.navi.alpha = 0;
              self.typeView.alpha = 0;
              self.logoBackgroundImage.alpha = 1;
              self.menuView.alpha = 1;
              
              self.bottom.scrollEnabled = NO;
              
          }completion:^(BOOL finished) {
              [[self.bottom viewWithTag:1000] removeFromSuperview];//当返回首页初始状态时，把提示移除掉
          }];
}


#pragma CGMainPageHeaderDelegate

//执行H5命令函数
-(void)pageHeaderCallFunctionByPath:(NSString *)path{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.isClick) {
        weakSelf.isClick = NO;
        [WKWebViewController setPath:@"setCurrentPath" code:path success:^(id response) {
            
        } fail:^{
        }];
    }
}

//把资讯列表置顶函数
-(void)pageHeaderCallLookMoreInfo{
    [self menuScrollToTop];
    
}

//跳转到公共搜索函数
-(void)pageHeaderCallToCommonSearch{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.action = @"library";
    [self.navigationController pushViewController:vc animated:YES];
}

//点击热搜的关键词
-(void)pageHeaderCallToHotKeyword:(CGHotSearchEntity *)entity{
  [self.viewModel messageCommandWithcommand:entity.command type:entity.commondAction commpanyId:entity.commpanyId recordId:entity.recordId messageId:nil];
}

//打开相机扫二维码
-(void)pageHeaderCallToOpenCamera{
    ZbarController *controller = [[ZbarController alloc]initWithBlock:^(NSString *data) {
        NSLog(@"扫描结果：%@",data);
    } cancel:^{
        
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

//打开语音识别
-(void)pageHeaderCallToOpenVoice{
    //初始化语音识别控件
    self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    self.iflyRecognizerView.delegate = self;
    [self.iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [self.iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
    [self.iflyRecognizerView start];
}


/*科大讯飞语音识别回调
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast{
    for(NSString *key in [resultArray[0] allKeys]){
        NSData *wordData = [key dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *allWordDict = [NSJSONSerialization JSONObjectWithData:wordData options:kNilOptions error:nil];
        NSArray *wordArray = [allWordDict objectForKey:@"ws"];
        for(NSDictionary *wordDict in wordArray){
            for(NSDictionary *itemWord in [wordDict objectForKey:@"cw"]){
                NSString *end = [itemWord objectForKey:@"w"];
                if(![end containsString:@"。"] && ![end containsString:@"，"]&& ![end containsString:@"！"]){
                    [self.speekWord appendString:end];
                }
            }
        }
    }
    if(isLast){//最后一次
        NSString *word = self.speekWord;
        if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
            CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
            vc.keyWord = word;
          vc.action = @"library";
            [self.navigationController pushViewController:vc animated:YES];

        }
        self.speekWord = nil;
        self.iflyRecognizerView = nil;
    }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
