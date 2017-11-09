//
//  CGUserDao.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserDao : NSObject

//保存用户token和uuid
-(BOOL)saveUserWithSecuCode:(NSString *)secuCode token:(NSString *)token;

/** 保存登录用户信息到本地 */
-(BOOL)saveLoginedInLocal:(CGUserEntity *)user;

/** 清除登录用户的信息 */
-(BOOL)cleanLoginedUser;

/** 获取用户json数据 */
-(NSString *)getUserWithJson;


@end
