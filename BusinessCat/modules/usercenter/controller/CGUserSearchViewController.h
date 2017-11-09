//
//  CGUserSearchViewController.h
//  CGSays
//
//  Created by zhu on 16/10/21.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserSearchCompanyEntity.h"

typedef void (^CGUserSearchBlock)(CGUserSearchCompanyEntity *entity);
typedef NS_ENUM(NSInteger, UserChoseOrganizeType) {
  UserChoseOrganizeTypeCompany    = 1,  //公司
  UserChoseOrganizeTypeSchool     = 2,  //学校
  UserChoseOrganizeTypeGenSpace   = 3,  //众创空间
  UserChoseOrganizeTypeOther      = 4,  //其他组织
};

@interface CGUserSearchViewController : CTBaseViewController{
  CGUserSearchBlock resultBlock;
}
@property (nonatomic, assign) BOOL isDiscover;
-(instancetype)initWithBlock:(CGUserSearchBlock)block;
@end
