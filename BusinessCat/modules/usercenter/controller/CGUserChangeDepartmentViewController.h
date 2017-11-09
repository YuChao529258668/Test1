//
//  CGUserChangeDepartmentViewController.h
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void(^CGUserChangeDepartmentSuccessBlock)(NSString *psition,NSString *departmentName,NSString *departmentID);
@interface CGUserChangeDepartmentViewController : CTBaseViewController
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *departmentID;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, assign) NSInteger companyType;
-(instancetype)initWithBlock:(CGUserChangeDepartmentSuccessBlock)block;
@end
