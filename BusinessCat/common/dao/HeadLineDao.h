//
//  HeadLineDao.h
//  CGSays
//
//  Created by mochenyang on 2016/10/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块本地缓存操作类

#import <Foundation/Foundation.h>
#import "CTBaseDao.h"
#import "DBConstants.h"
#import "CGInfoDetailEntity.h"

@interface HeadLineDao : CTBaseDao

//保存或更新头条大类到本地数据库
-(void)saveOrUpdateHeadlineBigType:(NSMutableArray *)bigTypes success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询本地的头条大类
//-(void)queryHeadlineBigTypeFromDBSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询本地首页菜单数据
-(NSMutableArray *)queryHomePageMenuData;

//保存资讯到本地数据库
-(void)saveInfoDataToDB:(NSMutableArray *)data;

//查询本地资讯
-(void)queryInfoDataFromDB:(NSString *)bigtype success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//根据key来更新资讯
-(void)updateInfoDataByKey:(NSString *)key value:(id)value infoId:(NSString *)infoId table:(NSString *)table;

//删除咨询
-(void)deleteInfoDataByInfoID:(NSString *)InfoID;

//保存详情到本地
-(void)saveInfoDetailToDB:(CGInfoDetailEntity *)detail;
//从本地删除详情
-(void)deleteInfoDetailFromDB:(NSString *)infoId;
//从本地查询详情
-(void)queryInfoDetailFromDB:(NSString *)infoId success:(void(^)(CGInfoDetailEntity *detail))success fail:(void (^)(NSError *error))fail;

//清除数据库内容
+(void)deleteQuery;
//更新话题信息与收藏状态
//-(void)updateInfoDetail:(CGInfoDetailEntity *)detail;

-(BOOL)saveHotSearchDataToLocal:(NSMutableArray *)array;

-(NSMutableArray *)queryHotSearchDataFromLocal;
@end
