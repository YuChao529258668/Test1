//
//  MonitoringDao.h
//  CGSays
//
//  Created by zhu on 2017/3/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTBaseDao.h"
#import "AttentionHead.h"
#import "AttentionMyGroupEntity.h"

@interface MonitoringDao : CTBaseDao
//保存或更新雷达监控列表到本地数据库
+(void)savemonitoringToDB:(NSMutableArray *)data;

//查询本地监控列表
+(void)queryMonitorinListFromDBSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//保存单个监控到本地数据库
+(void)saveMonitoringToDB:(AttentionHead *)entity;
//删除某个监控
+(void)deleteMonitoringToDB:(AttentionHead *)entity;

//更改某个监控
+(void)updateMonitoring:(AttentionHead *)entity;

//保存动态
+(void)saveDynamicToDB:(NSMutableArray *)data dynamicID:(NSString *)dynamic;

//根据动态id查询本地动态列表
+(void)queryMonitorinListFromDBWithdynamicID:(NSString *)dynamicID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//根据动态id删除本地动态
+(void)deleteDynamicWithDynamicID:(NSString *)dynamicID;

//根据分组id保存或更新雷达分组列表到本地数据库
+(void)saveGroupListToDB:(NSMutableArray *)data groupID:(NSString *)groupID;
//根据分组id查询本地动态列表
+(void)queryGroupListFromDBWithGroupID:(NSString *)groupID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//更改某个分组数据
+(void)updateGroupList:(AttentionMyGroupEntity *)entity;
//删除某个分组数据
+(void)deleteGroupList:(AttentionMyGroupEntity *)entity;

@end
