//
//  CGUserMassageEntity.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserMassageEntity : NSObject
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *ranking;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *gradeName;
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userIntro;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyGender;
@property (nonatomic, strong) NSNumber *companyManage;
@property (nonatomic, strong) NSNumber *companyState;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *position;
@end
