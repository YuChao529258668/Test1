//
//  CGUserCreateDepartmentViewController.h
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserDepaEntity.h"
#import "CGUserSearchViewController.h"
#import "CGUserorganizaApplyEntity.h"

typedef void (^CGUserCreateDepartmentBlock)(CGUserDepaEntity *result);
typedef NS_ENUM(NSInteger, UserCreateType) {
  UserCreateTypeDepartment  = 0,  //部门
  UserCreateTypePosition    = 1,  //职位
  UserCreateTypeClasses     = 2,  //班级
  UserCreateTypeCollect     = 3   //院系
};

@interface CGUserCreateDepartmentViewController : CTBaseViewController{
  CGUserCreateDepartmentBlock resultBlock;
}
@property (nonatomic, assign) UserCreateType type;
@property (nonatomic, assign) UserChoseOrganizeType choseType;
@property (nonatomic, copy) NSString *depaID;
@property (nonatomic, copy) NSString *organizeID;
-(instancetype)initWithBlock:(CGUserCreateDepartmentBlock)block;
@property (nonatomic, strong) CGUserorganizaApplyEntity *info;
@property (nonatomic, assign) BOOL isChoseView;
@property (nonatomic, assign) BOOL isDiscover;
@end
