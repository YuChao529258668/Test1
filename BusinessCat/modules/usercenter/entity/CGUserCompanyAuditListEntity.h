//
//  CGUserCompanyAuditListEntity.h
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserCompanyAuditListEntity : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *applyTime;
@property(nonatomic,assign) int auditState;//0待审核 1已同意 2已拒绝
@end
