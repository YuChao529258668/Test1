//
//  CGUserFireEntity.h
//  CGSays
//
//  Created by zhu on 16/10/25.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserFireEntity : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userIntro;
@property (nonatomic, strong) NSMutableArray *roles;
@property (nonatomic, strong) NSMutableArray *industrys;
@end
