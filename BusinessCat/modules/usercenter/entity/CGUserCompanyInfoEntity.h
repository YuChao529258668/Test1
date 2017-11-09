//
//  CGUserCompanyInfoEntity.h
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserCompanyInfoEntity : NSObject
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *gradeName;
@property (nonatomic, assign) NSInteger companyManage;
@property (nonatomic, assign) NSInteger companyState;
@property (nonatomic, assign) NSInteger integralNum;
@end
