//
//  CGUserDao.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserDao.h"

@implementation CGUserDao

//保存用户token和uuid
-(BOOL)saveUserWithSecuCode:(NSString *)secuCode token:(NSString *)token{
    CGUserEntity *user = [ObjectShareTool sharedInstance].currentUser;
    if(!user){
        user = [[CGUserEntity alloc]init];
    }
    user.secuCode = secuCode;
    user.token = token;
    return [self saveLoginedInLocal:user];
}

-(BOOL)saveLoginedInLocal:(CGUserEntity *)user{
  NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *filePath = [path stringByAppendingPathComponent:USER_DATA];
  return [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

/** 清除登录用户的信息 */
-(BOOL)cleanLoginedUser{
//    NSString *userPath = [CTFileUtil getDocumentsPath];
//    [CTFileUtil createFolder:userPath error:nil];
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:nil forKey:CurrentLoginedUser];
//    [archiver finishEncoding];
//    
//    [data writeToFile:LoginUserInfoPath atomically:YES];
    [ObjectShareTool sharedInstance].currentUser = nil;
  NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *filePath = [path stringByAppendingPathComponent:USER_DATA];
  NSFileManager *defaultManager = [NSFileManager defaultManager];
  if ([defaultManager isDeletableFileAtPath:filePath]) {
  return  [defaultManager removeItemAtPath:filePath error:nil];
  }
    return NO;
}

/** 获取用户json数据 */
-(NSString *)getUserWithJson{
    return [CTJsonUtil objectToJson:[ObjectShareTool sharedInstance].currentUser];
}

@end
