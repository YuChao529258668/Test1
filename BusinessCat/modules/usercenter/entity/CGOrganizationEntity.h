//
//  CGOrganizationEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGOrganizationEntity : NSObject
@property (nonatomic, copy) NSString *companyicon;
@property (nonatomic, copy) NSString *companyname;
@property (nonatomic, copy) NSString *companyfullname;
@property (nonatomic, copy) NSString *companyphone;
@property (nonatomic, copy) NSString *companyhttp;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger employeesnum;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSMutableArray *knowledge;
@end

@interface CGknowledgeEntity : NSObject
@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *cateName;
@end
