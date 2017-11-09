//
//  CGChoseOrganizationViewController.h
//  CGSays
//
//  Created by zhu on 2017/4/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserOrganizaJoinEntity.h"

typedef void (^CGChoseOrganizationSureBlock)(CGUserOrganizaJoinEntity *entity,NSInteger selectIndex);
@interface CGChoseOrganizationViewController : CTBaseViewController{
  CGChoseOrganizationSureBlock success;
}
-(instancetype)initWithBlock:(CGChoseOrganizationSureBlock)sure;
@property (nonatomic, assign) NSInteger type;//0企业圈 1管家企业
@end
