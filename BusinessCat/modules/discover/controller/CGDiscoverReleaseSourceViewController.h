//
//  CGDiscoverReleaseSourceViewController.h
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGDiscoverLink.h"
#import "CGHorrolEntity.h"

typedef NS_ENUM(NSInteger, DiscoverReleaseType) {
  DiscoverReleaseTypeNoCompany    = 0,  //企业圈未加入公司
  DiscoverReleaseTypeCompany      = 1,  //企业圈加入公司
  HeadlineReleaseTypeNoCompany    = 2,  //头条爆料未加入公司
  HeadlineReleaseTypeCompany      = 3   //头条爆料已加入公司
};

typedef void (^CGDiscoverReleaseSuccessBlock)(BOOL isCurrent, NSInteger reloadIndex,BOOL isOutside);
@interface CGDiscoverReleaseSourceViewController : CTBaseViewController
-(instancetype)initWithBlock:(CGDiscoverReleaseSuccessBlock)success;
@property (nonatomic, retain) CGDiscoverLink *link;
@property (nonatomic, assign) DiscoverReleaseType releaseType;
@property (nonatomic, strong) CGHorrolEntity *currentEntity;
@property (nonatomic, assign) NSInteger type;//0企业圈 1企业管家
@property (nonatomic, assign) NSInteger selectIndex;
@end
