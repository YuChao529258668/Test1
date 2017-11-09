//
//  CGDiscoverPartSeeViewController.h
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGHorrolEntity.h"
#import "CGUserSearchCompanyEntity.h"

typedef void (^CGPartSeeSureBlock)(CGUserSearchCompanyEntity *reslut,NSInteger visibility);
@interface CGDiscoverPartSeeViewController : CTBaseViewController{
  CGPartSeeSureBlock block;
}
-(instancetype)initWithBlock:(CGPartSeeSureBlock)release;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) CGUserSearchCompanyEntity *selectEntity;
@property (nonatomic, strong) CGHorrolEntity *currentEntity;
@property (nonatomic, assign) BOOL isHeadlineDetail;
@end
