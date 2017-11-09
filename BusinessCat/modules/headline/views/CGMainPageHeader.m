//
//  CGMainPageHeader.m
//  CGSays
//
//  Created by mochenyang on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMainPageHeader.h"
#import "HeadlineBiz.h"
#import "HeadLineDao.h"
#import "HomePageAppsController.h"
#import "AppDelegate.h"

@interface CGMainPageHeader()
@property(nonatomic,retain)UIView *hotSearch;
@property(nonatomic,retain)UIView *menuRootView;//装载菜单的根view
@property(nonatomic,retain)UIView *searchRootView;

@property(nonatomic,retain)UIImageView *bannerEmptyImg;
@end

@implementation CGMainPageHeader

static int columnNum = 5;//列
static int orimargin = 20;//横向间隔
static int verMargin = 15;//竖向间隔
static float menuWidth = 0;//菜单宽度

#define LogoHeight (SCREEN_HEIGHT/16)//顶部logo的高度
#define LogoWidth (SCREEN_WIDTH/7)//顶部logo的宽度

#define menuIconLength (SCREEN_HEIGHT/27.5f)//菜单图标高度和宽度
#define menuTitleFontSize (SCREEN_HEIGHT/57)//菜单标题字体大小

#define hotSearchLine (SCREEN_HEIGHT/19)//热搜栏的高度

#define BannerHeight (SCREEN_HEIGHT/9)//banner高度

#define menuHeight (15+5+menuIconLength)//菜单高度

#define searchTitleFontSize (SCREEN_HEIGHT/53)//搜索框字体大小

static int hotSearchIndex = 0;


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        menuWidth = (SCREEN_WIDTH - orimargin*(columnNum+1))/columnNum;
        
        //查看更多
        UIButton *moreInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        [moreInfoBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [moreInfoBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        moreInfoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        moreInfoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [moreInfoBtn setTitle:@"    知识头条" forState:UIControlStateNormal];
        [moreInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:moreInfoBtn];
        [moreInfoBtn addTarget:self action:@selector(lookMoreInfoAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 15, moreInfoBtn.frame.size.height)];
        desc.textAlignment = NSTextAlignmentRight;
        desc.text = @"查看更多>";
        desc.font = [UIFont systemFontOfSize:13];
        desc.textColor = [UIColor grayColor];
        desc.userInteractionEnabled = NO;
        [moreInfoBtn addSubview:desc];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, moreInfoBtn.frame.size.height-1.0f,moreInfoBtn.frame.size.width , 0.5f)];
        line.backgroundColor = CTCommonLineBg;
        [moreInfoBtn addSubview:line];
        
        //底部banner栏
        self.banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMinY(moreInfoBtn.frame) - BannerHeight - 10, SCREEN_WIDTH, BannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"faxianmorentu"]];
        self.banner.autoScrollTimeInterval = 60;
        self.banner.backgroundColor = [UIColor clearColor];
        self.banner.contentMode = UIViewContentModeScaleAspectFill;
        self.banner.clipsToBounds = YES;
        self.banner.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [self.banner addSubview:self.bannerEmptyImg];
        [self addSubview:self.banner];
        
        //热搜栏
        self.hotSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.banner.frame) - 3 - hotSearchLine, SCREEN_WIDTH, hotSearchLine)];
        self.hotSearchView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.hotSearchView];
        
        UILabel *hotTag = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, hotSearchLine)];
        hotTag.text = @"热搜：";
        hotTag.textColor = [UIColor grayColor];
        hotTag.font = [UIFont systemFontOfSize:13];
        [self.hotSearchView addSubview:hotTag];
        
        UIButton *change = [[UIButton alloc]initWithFrame:CGRectMake(self.hotSearchView.frame.size.width - 56 - 10, 0, 56, hotSearchLine)];
        change.titleLabel.font = [UIFont systemFontOfSize:13];
        [change setImage:[UIImage imageNamed:@"forabatch"] forState:UIControlStateNormal];
        [change setTitle:@" 换一批" forState:UIControlStateNormal];
        [change setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.hotSearchView addSubview:change];
        [change addTarget:self action:@selector(changeOtherHotKeyword) forControlEvents:UIControlEventTouchUpInside];
        
        self.hotSearch = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotTag.frame), 0, self.hotSearchView.frame.size.width - CGRectGetMaxX(hotTag.frame) - change.frame.size.width - 10, hotSearchLine)];
        self.hotSearch.clipsToBounds = YES;
        self.hotSearch.backgroundColor = [UIColor whiteColor];
        [self.hotSearchView addSubview:self.hotSearch];
        
        
        //菜单根view
        self.menuRootView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.hotSearchView.frame)-(2*menuHeight+verMargin) - verMargin, frame.size.width, 2*menuHeight+verMargin)];
        [self addSubview:self.menuRootView];
        
        //搜索栏
        self.searchRootView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.menuRootView.frame) - SCREEN_HEIGHT/15 - verMargin, SCREEN_WIDTH - 20, SCREEN_HEIGHT/15)];
        self.searchRootView.backgroundColor = [UIColor whiteColor];
        self.searchRootView.alpha = 0.1;
        self.searchRootView.layer.cornerRadius = 2;
        self.searchRootView.layer.masksToBounds = YES;
        [self addSubview:self.searchRootView];
        
        self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.menuRootView.frame) - SCREEN_HEIGHT/15 - verMargin, SCREEN_WIDTH - 20, SCREEN_HEIGHT/15)];
        
        self.searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:searchTitleFontSize];
        [self.searchBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#919191"] forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.searchBtn setTitle:@"    请输入产品、公司、姓名、行业、报告等名称" forState:UIControlStateNormal];
        [self.searchBtn addTarget:self action:@selector(clickSearchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.searchBtn];
        
        UIButton *qrCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.searchBtn.frame.size.width - (self.searchBtn.frame.size.height-6), 0, self.searchBtn.frame.size.height-6, self.searchBtn.frame.size.height)];
        [qrCodeBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        [qrCodeBtn addTarget:self action:@selector(openCameraAction) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBtn addSubview:qrCodeBtn];
        
        UIButton *voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(qrCodeBtn.frame) - qrCodeBtn.frame.size.width, 0, qrCodeBtn.frame.size.width, qrCodeBtn.frame.size.height)];
        [voiceBtn setImage:[UIImage imageNamed:@"voiceinput"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(openVoiceAction) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBtn addSubview:voiceBtn];
        
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(qrCodeBtn.frame)-0.5, self.searchBtn.frame.size.height/2-16/2, 1, 16)];
        verLine.backgroundColor = [UIColor darkGrayColor];
        verLine.alpha = 0.8;
        [self.searchBtn addSubview:verLine];
        
        self.logoIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-LogoWidth/2, CGRectGetMinY(self.searchBtn.frame)/2-LogoHeight/2+25, LogoWidth, LogoHeight)];
        self.logoIconImage.contentMode = UIViewContentModeScaleAspectFill;
        self.logoIconImage.image = [UIImage imageNamed:@"mainpage_logo"];
        [self addSubview:self.logoIconImage];
        
        //生成九宫格菜单
        [self generatorMenu];
        
        //本地有热搜的缓存，先显示本地缓存
        if(self.hotTags.count > 0){
            [self generatorHotTag];
        }
        
        //获取banner本地数据
//        [self getLocalBannerData];//先加载本地，等token拿到再加载远程

    }
    return self;
}

-(UIImageView *)bannerEmptyImg{
    if(!_bannerEmptyImg){
        _bannerEmptyImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BannerHeight)];
        _bannerEmptyImg.contentMode = UIViewContentModeScaleAspectFill;
        _bannerEmptyImg.image = [UIImage imageNamed:@"homepage_banner_empty"];
    }
    return _bannerEmptyImg;
}

//生成热搜view
-(void)generatorHotTag{
    NSArray *subviews = self.hotSearch.subviews;
    if(subviews && subviews.count > 0){
        for(UIView *subview in subviews){
            CGRect rect = subview.frame;
            rect.origin.y = -50;
            [UIView animateWithDuration:0.5 animations:^{
                subview.frame = rect;
            }completion:^(BOOL finished) {
                [subview removeFromSuperview];
            }];
        }
    }
    [self performSelector:@selector(createHotSearchView) withObject:nil afterDelay:0.1];
}
-(void)createHotSearchView{
    UIButton *lastBtn = nil;
    if(self.hotTags && self.hotTags.count > 0){
        for(int i=0;i<self.hotTags.count;i++){
            CGHotSearchEntity *hot = self.hotTags[i];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, hotSearchLine)];
            button.tag = i;
            [button addTarget:self action:@selector(clickHotKeywordAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:hot.tagName forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button sizeToFit];
            if(lastBtn){
                button.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+6, self.hotSearch.frame.size.height, button.frame.size.width, hotSearchLine);
            }else{
                button.frame = CGRectMake(0, self.hotSearch.frame.size.height, button.frame.size.width, hotSearchLine);
            }
            if(CGRectGetMaxX(button.frame) <= self.hotSearch.frame.size.width){
                [self.hotSearch addSubview:button];
                lastBtn = button;
            }else{
                break;
            }
            CGRect buttonRect = button.frame;
            buttonRect.origin.y = 0;
            [UIView animateWithDuration:0.5 animations:^{
                button.frame = buttonRect;
            }];
            
        }
    }
}

//生成菜单
-(void)generatorMenu{
    [self.menuRootView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(self.menuArray && self.menuArray.count > 0){
        for(int i=0;i<self.menuArray.count;i++){
            if(i >= 10){//大于10个不显示
                break;
            }
            CGGropuAppsEntity *entity = self.menuArray[i];
            int currentColumn = i%columnNum;//列
            int currentLine = i/columnNum;//行
            UIButton *item = [[UIButton alloc]initWithFrame:CGRectMake((currentColumn+1)*orimargin+menuWidth*currentColumn,currentLine*verMargin+menuHeight*currentLine, menuWidth, menuHeight)];
            item.tag = i;
            [item addTarget:self action:@selector(clickMenuAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuRootView addSubview:item];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((menuWidth - menuIconLength)/2, 0, menuIconLength, menuIconLength)];
            [image sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:nil];
            [item addSubview:image];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), menuWidth, 15)];
            title.text = entity.name;
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [UIFont systemFontOfSize:menuTitleFontSize];
            title.textColor = [UIColor whiteColor];
            [item addSubview:title];
            [title sizeToFit];
            title.frame = CGRectMake(item.frame.size.width/2-title.frame.size.width/2, CGRectGetMaxY(image.frame)+5, title.frame.size.width, 15);
        }
    }
}

-(void)clickMenuAction:(UIButton *)button{
    int index = (int)button.tag;
    CGGropuAppsEntity *entity = self.menuArray[index];
    if(index == 9){//全部
        HomePageAppsController *controller = [[HomePageAppsController alloc]init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.rootController.navigationController pushViewController:controller animated:YES];
    }else if([CTStringUtil stringNotBlank:entity.code]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallFunctionByPath:)]){
            [self.delegate pageHeaderCallFunctionByPath:entity.code];
        }
    }
}

-(void)clickHotKeywordAction:(UIButton *)button{
    int index = (int)button.tag;
    if(self.hotTags.count - 1 >= button.tag){
        CGHotSearchEntity *hot = self.hotTags[index];
        if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallToHotKeyword:)]){
            [self.delegate pageHeaderCallToHotKeyword:hot];
        }
    }
}

-(void)lookMoreInfoAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallLookMoreInfo)]){
        [self.delegate pageHeaderCallLookMoreInfo];
    }
}
-(void)clickSearchAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallToCommonSearch)]){
        [self.delegate pageHeaderCallToCommonSearch];
    }
}

-(void)changeOtherHotKeyword{
    hotSearchIndex += 1;
    [self queryRemoteHotSearchData];
}

-(void)openCameraAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallToOpenCamera)]){
        [self.delegate pageHeaderCallToOpenCamera];
    }
}

-(void)openVoiceAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageHeaderCallToOpenVoice)]){
        [self.delegate pageHeaderCallToOpenVoice];
    }
}

//菜单
-(NSMutableArray *)menuArray{
    if(!_menuArray){
        _menuArray = [[[HeadLineDao alloc]init]queryHomePageMenuData];
    }
    return _menuArray;
}

//加载本地banner数据
- (void)getLocalBannerData{
//    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[[CTFileUtil getDocumentsPath] stringByAppendingPathComponent:DISCOVER_TOP_DATA]];
//    if(data){
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
//        self.dataEntity  = [unarchiver decodeObjectForKey:DISCOVER_TOP_DATA];
//    }
//    NSMutableArray *array = [NSMutableArray array];
//    for (BannerData *image in self.dataEntity.banner) {
//        NSString *src = image.src;
//        [array addObject:src];
//    }
//    
//    self.banner.imageURLStringsGroup = array;
//    if(array && array.count > 0){
//        [self.bannerEmptyImg removeFromSuperview];
//    }
}

//加载服务器的banner数据
-(void)loadRemoteBannerData{
//    __weak typeof(self) weakSelf = self;
//    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
//    [biz discoverDataSuccess:^(CGDiscoverDataEntity *entity) {
//        weakSelf.dataEntity = entity;
//        NSMutableArray *array = [NSMutableArray array];
//        for (BannerData *image in weakSelf.dataEntity.banner) {
//            NSString *src = image.src;
//            [array addObject:src];
//        }
//      
//        weakSelf.banner.imageURLStringsGroup = array;
//        if(array && array.count > 0){
//            [self.bannerEmptyImg removeFromSuperview];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
}

//重新绘制九宫格菜单
-(void)reloadMenuData{
    NSString *filePath = [[CTFileUtil getDocumentsPath] stringByAppendingPathComponent:HomePageMenuData];
    _menuArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [self generatorMenu];
}

//加载本地热搜数据
-(NSMutableArray *)hotTags{
    if(!_hotTags){
        _hotTags = [[[HeadLineDao alloc]init]queryHotSearchDataFromLocal];
    }
    return _hotTags;
}

//从服务器加载热搜
-(void)queryRemoteHotSearchData{
    __weak typeof(self) weakSelf = self;
  [[[HeadlineBiz alloc]init]headlinesHotsearchListWithPage:hotSearchIndex action:1 type:18 success:^(NSMutableArray *result) {
      if(result && result.count > 0){
          weakSelf.hotTags = result;
          [[[HeadLineDao alloc]init]saveHotSearchDataToLocal:result];
          [weakSelf generatorHotTag];
      }
    } fail:^(NSError *error) {
        
    }];
}

//刷新所有数据，供下拉刷新的调用
-(void)refreshAllDataWithBlock:(MainPageHeaderBlock)block{
    self.block = block;
    [self queryRemoteMenuData];
    [self queryRemoteHotSearchData];
//    [self loadRemoteBannerData];
}

//检查菜单数据
-(void)queryRemoteMenuData{
//    [[[CGDiscoverBiz alloc]init]loadHomePageAppsSuccess:^(NSMutableArray *result, BOOL hasChanged) {
//        if(hasChanged){//菜单已发生改变
//            [self reloadMenuData];
//        }
//        [self performSelector:@selector(callbackBlock) withObject:nil afterDelay:1];
//    } fail:^(NSError *error) {
//        [self performSelector:@selector(callbackBlock) withObject:nil afterDelay:1];
//    }];
}

-(void)callbackBlock{
    if(self.block){
        self.block();
    }
}
@end
