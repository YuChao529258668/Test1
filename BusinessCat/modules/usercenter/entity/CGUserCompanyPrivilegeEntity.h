//
//  CGUserCompanyPrivilegeEntity.h
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGUserCompanyInfoEntity.h"
#import "CGUserCompanyPrivilegeDataEntity.h"

@interface CGUserCompanyPrivilegeEntity : NSObject
@property (nonatomic, strong) CGUserCompanyInfoEntity *companyInfo;
@property (nonatomic, strong) CGUserCompanyPrivilegeDataEntity *companyPrivilege;
@end
