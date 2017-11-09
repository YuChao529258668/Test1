//
//  CGUserCompanyAttestationEntity.h
//  CGSays
//
//  Created by zhu on 16/10/25.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  组织认证实体

#import <Foundation/Foundation.h>

@interface CGUserCompanyAttestationEntity : NSObject
@property (nonatomic, retain) NSString *companyid;//组织id
@property(nonatomic,assign)int type;//组织类型
@property (nonatomic, retain) NSString *classid;//班级id
@property (nonatomic, retain) NSString *name;//用户名
@property (nonatomic, retain) NSString *legalname;//法人
@property (nonatomic, retain) NSString *additional;//附加照片
@property (nonatomic, retain) NSString *verifycode;//验证码
@property (nonatomic, strong) UIImage *image;
@end
