//
//  CGMainPageHeader.h
//  CGSays
//
//  Created by mochenyang on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "CGDiscoverDataEntity.h"
#import "CGDiscoverBiz.h"
#import "CGHotSearchEntity.h"


typedef void (^MainPageHeaderBlock)(void);

@protocol CGMainPageHeaderDelegate <NSObject>

//执行H5命令函数
-(void)pageHeaderCallFunctionByPath:(NSString *)path;

//把资讯列表置顶函数
-(void)pageHeaderCallLookMoreInfo;

//跳转到公共搜索函数
-(void)pageHeaderCallToCommonSearch;

//点击热搜的关键词
-(void)pageHeaderCallToHotKeyword:(CGHotSearchEntity *)entity;

//打开相机扫二维码
-(void)pageHeaderCallToOpenCamera;

//打开语音识别
-(void)pageHeaderCallToOpenVoice;

@end

@interface CGMainPageHeader : UIView<SDCycleScrollViewDelegate>

@property (nonatomic, strong) CGDiscoverDataEntity *dataEntity;
@property(nonatomic,retain)NSMutableArray *menuArray;
@property(nonatomic,retain)NSMutableArray *hotTags;
@property(nonatomic,retain)UIView *hotSearchView;
@property(nonatomic,retain)UIButton *searchBtn;
@property (nonatomic, strong) SDCycleScrollView *banner;
@property(nonatomic,retain)UIImageView *logoIconImage;

@property(nonatomic,weak)id<CGMainPageHeaderDelegate> delegate;

@property(nonatomic,copy)MainPageHeaderBlock block;

-(instancetype)initWithFrame:(CGRect)frame;

//刷新所有数据，供下拉刷新的调用
-(void)refreshAllDataWithBlock:(MainPageHeaderBlock)block;


@end
