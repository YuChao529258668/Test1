//
//  CGDiscoverOtherCompanyViewController.h
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserSearchCompanyEntity.h"

typedef void (^CGOtherCompanySureBlock)(CGUserSearchCompanyEntity *entity);
@interface CGDiscoverOtherCompanyViewController : CTBaseViewController{
  CGOtherCompanySureBlock success;
}
-(instancetype)initWithBlock:(CGOtherCompanySureBlock)sure;
@end
