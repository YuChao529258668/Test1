//
//  TeamCircleDao.h
//  CGSays
//
//  Created by zhu on 2017/3/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseDao.h"
#import "CGSourceCircleEntity.h"

@interface TeamCircleDao : CTBaseDao
//保存或更新企业圈列表到本地数据库
+(void)saveTeamCircleToDB:(NSMutableArray *)data organizationID:(NSString *)organizationID;

//查询本地企业圈列表
+(void)queryMonitorinListFromDBWithOrganizationID:(NSString *)organizationID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//保存单个企业圈内容到本地数据库
+(void)saveOrganizationToDB:(CGSourceCircleEntity *)info organizationID:(NSString *)organizationID;

//删除某个企业圈内容
+(void)deleteTeamCircleToDBWithScoopID:(NSString *)scoopID;

//根据公司id删除某个企业圈内容
+(void)deleteTeamCircleToDBWithOrganizationID:(NSString *)organizationID;

//更改某个企业圈内容
+(void)updateTeamCircleWithScoopID:(NSString *)scoopID info:(CGSourceCircleEntity *)info;

@end
