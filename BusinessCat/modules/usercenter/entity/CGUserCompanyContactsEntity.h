//
//  CGUserCompanyContactsEntity.h
//  CGSays
//
//  Created by zhu on 16/10/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserCompanyContactsEntity : NSObject
@property(nonatomic,retain)NSString *letter;//首字母
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL companyManage;//普通管理员
@property (nonatomic, assign) BOOL companyAdmin;//超级管理员
//@property (nonatomic,strong) NSString *txyIdentifier; //腾讯云


@end
