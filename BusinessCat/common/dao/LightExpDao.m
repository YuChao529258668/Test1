//
//  LightExpDao.m
//  CGSays
//
//  Created by zhu on 2017/2/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "LightExpDao.h"
#import "CGUserDao.h"

@implementation LightExpDao
//保存体验到本地数据库
+(void)saveLightExpDataToDB:(NSMutableArray *)data{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!data || data.count <= 0){
            return;
        }
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *querySql = [NSString stringWithFormat:@"delete from %@", lightExpList_tableName];
            if([database executeUpdate:querySql]){
                for (NSInteger i=data.count-1; i>=0; i--) {
                    
                    if ([data[i] isKindOfClass:[CGLightExpEntity class]]) {
                        CGLightExpEntity *info = data[i];
                        NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%ld','%@')",lightExpList_tableName,lightExpList_mid,lightExpList_userID,lightExpList_pid,lightExpList_pName,lightExpList_desc,lightExpList_size,lightExpList_icon,lightExpList_isExp,lightExpList_update,lightExpList_type,lightExpList_apps,info.mid,[ObjectShareTool sharedInstance].currentUser.uuid,info.gid,info.gName,info.desc,info.size,nil,info.isExp,info.update,info.type,info.appsJsonStr];
                        [database executeUpdate:sql];
                    }else{
                        CGApps *info = data[i];
                        NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%@')",lightExpList_tableName,lightExpList_mid,lightExpList_userID,lightExpList_pid,lightExpList_pName,lightExpList_desc,lightExpList_size,lightExpList_icon,lightExpList_isExp,lightExpList_update,lightExpList_type,lightExpList_apps,info.mid,[ObjectShareTool sharedInstance].currentUser.uuid,info.pid,info.pName,info.desc,info.size,info.icon,info.isExp,info.update,info.type,nil];
                        [database executeUpdate:sql];
                    }
                }
            }
        }
        [database close];
    });
}

//保存单个体验组到本地数据库
+(void)saveLightExpEntityToDB:(CGLightExpEntity *)entity{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%ld','%@')",lightExpList_tableName,lightExpList_mid,lightExpList_userID,lightExpList_pid,lightExpList_pName,lightExpList_desc,lightExpList_size,lightExpList_icon,lightExpList_isExp,lightExpList_update,lightExpList_type,lightExpList_apps,entity.mid,[ObjectShareTool sharedInstance].currentUser.uuid,entity.gid,entity.gName,entity.desc,entity.size,nil,entity.isExp,entity.update,entity.type,entity.appsJsonStr];
            [database executeUpdate:sql];
        }
        [database close];
    });
}

//保存单个体验到本地数据库
+(void)saveLightExpAppToDB:(CGApps *)entity{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%@')",lightExpList_tableName,lightExpList_mid,lightExpList_userID,lightExpList_pid,lightExpList_pName,lightExpList_desc,lightExpList_size,lightExpList_icon,lightExpList_isExp,lightExpList_update,lightExpList_type,lightExpList_apps,entity.mid,[ObjectShareTool sharedInstance].currentUser.uuid,entity.pid,entity.pName,entity.desc,entity.size,entity.icon,entity.isExp,entity.update,entity.type,nil];
            [database executeUpdate:sql];
        }
        [database close];
    });
}

//查询本地体验
+(void)queryInfoDataFromDBSuccess:(void(^)(NSMutableArray *result,NSMutableArray *groupArray))success fail:(void (^)(NSError *error))fail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",lightExpList_tableName,lightExpList_userID,[ObjectShareTool sharedInstance].currentUser.uuid];
            FMResultSet *rs = [database executeQuery:sql];
            NSMutableArray *result = [NSMutableArray array];
            NSMutableArray *groupArray = [NSMutableArray array];
            while (rs.next) {
                NSDictionary *dict = [rs resultDictionary];
                NSNumber *type = [dict objectForKey:@"type"];
                if (type.integerValue == 2) {
                    CGLightExpEntity *comment = [CGLightExpEntity mj_objectWithKeyValues:dict];
                    comment.gid = dict[lightExpList_pid];
                    comment.gName = dict[lightExpList_pName];
                    comment.appsJsonStr = dict[lightExpList_apps];
                    [result insertObject:comment atIndex:0];
                    [groupArray insertObject:comment atIndex:0];
                    NSMutableArray *array = [NSMutableArray mj_objectArrayWithKeyValuesArray:comment.appsJsonStr];
                    if (array.count>0) {
                        NSMutableArray *apps = [NSMutableArray array];
                        for (NSDictionary *dic in array) {
                            CGApps *app = [CGApps mj_objectWithKeyValues:dic];
                            [apps addObject:app];
                        }
                        comment.apps = apps;
                    }else{
                        comment.apps = [NSMutableArray array];
                    }
                    
                }else{
                    CGApps *comment = [CGApps mj_objectWithKeyValues:dict];
                    [result insertObject:comment atIndex:0];
                }
            }
            [rs close];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(result,groupArray);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil);
            });
        }
        [database close];
    });
}

//删除某几个体验
+(void)deleteLightExpWithUserID:(NSMutableArray *)data{
    if (data.count<=0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            for (int i=0; i<data.count; i++) {
                if ([data[i] isKindOfClass:[CGLightExpEntity class]]) {
                    CGLightExpEntity *info = data[i];
                    NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",lightExpList_tableName,lightExpList_mid,info.mid];
                    [database executeUpdate:querySql];
                }else{
                    CGApps *info = data[i];
                    NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",lightExpList_tableName,lightExpList_mid,info.mid];
                    [database executeUpdate:querySql];
                }
            }
        }
        [database close];
    });
}

//删除所有体验
+(void)deleteAllLightExp{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",lightExpList_tableName,lightExpList_userID,[ObjectShareTool sharedInstance].currentUser.uuid];
            [database executeUpdate:querySql];
        }
        [database close];
    });
}

//根据mid来更新体验
+(void)updateLightExpByMid:(NSString *)mid appsJsonStr:(NSString *)appsJsonStr{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([CTStringUtil stringNotBlank:mid]){
            FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
            if ([database open]){
                NSString *sql = [NSString stringWithFormat:@"update %@ set %@=%@ where %@='%@'",lightExpList_tableName,lightExpList_mid,mid,lightExpList_apps,appsJsonStr];
                [database executeUpdate:sql];
            }
            [database close];
        }
    });
}
@end
