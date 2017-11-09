//
//  LightExpDao.h
//  CGSays
//
//  Created by zhu on 2017/2/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseDao.h"
#import "CGLightExpEntity.h"

@interface LightExpDao : CTBaseDao
//保存体验到本地数据库
+(void)saveLightExpDataToDB:(NSMutableArray *)data;

//保存单个体验组到本地数据库
+(void)saveLightExpEntityToDB:(CGLightExpEntity *)entity;
//保存单个体验到本地数据库
+(void)saveLightExpAppToDB:(CGApps *)entity;

//查询本地体验
+(void)queryInfoDataFromDBSuccess:(void(^)(NSMutableArray *result,NSMutableArray *groupArray))success fail:(void (^)(NSError *error))fail;


//删除某几个体验
+(void)deleteLightExpWithUserID:(NSMutableArray *)data;
//删除所有体验
+(void)deleteAllLightExp;
//根据mid来更新体验
+(void)updateLightExpByMid:(NSString *)mid appsJsonStr:(NSString *)appsJsonStr;
@end
