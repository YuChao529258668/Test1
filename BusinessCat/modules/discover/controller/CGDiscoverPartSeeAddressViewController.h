//
//  CGDiscoverPartSeeAddressViewController.h
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGHorrolEntity.h"

typedef void (^CGPartSeeAddressSureBlock)(NSMutableArray *reslut,BOOL isCancel);
@interface CGDiscoverPartSeeAddressViewController : CTBaseViewController{
  CGPartSeeAddressSureBlock success;
}
@property (nonatomic, strong) NSMutableArray *selectArray;
-(instancetype)initWithBlock:(CGPartSeeAddressSureBlock)sure;
@property (nonatomic, strong) CGHorrolEntity *currentEntity;
@end
