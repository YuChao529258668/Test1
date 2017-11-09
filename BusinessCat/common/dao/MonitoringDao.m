//
//  MonitoringDao.m
//  CGSays
//
//  Created by zhu on 2017/3/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "MonitoringDao.h"
#import "AttentionHead.h"
#import "CGUserDao.h"
#import "CGInfoHeadEntity.h"
#import "KnowledgeBaseEntity.h"
#import "CGRelevantInformationEntity.h"

@implementation MonitoringDao
+(void)savemonitoringToDB:(NSMutableArray *)data{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@", attentionMonitoringList_tableName];
      if([database executeUpdate:querySql]){
        CGUserEntity *userInfo = [ObjectShareTool sharedInstance].currentUser;
        for(AttentionHead *bigType in data){
          NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@',%d,%ld,%ld,'%@','%@','%@','%@',%d,%d,'%@','%@',%d,'%@',%d,%ld,%ld,%ld,%ld)",attentionMonitoringList_tableName,monitoringList_userID,monitoringList_address,monitoringList_countNum,monitoringList_createtime,monitoringList_attentionTime,monitoringList_desc,monitoringList_icon,monitoringList_infoId,monitoringList_label,monitoringList_layout,monitoringList_newNum,monitoringList_prompt,monitoringList_source,monitoringList_subscribeNum,monitoringList_title,monitoringList_type,monitoringList_updatetime,monitoringList_createType,monitoringList_isTop,monitoringList_dataLatestTime,userInfo.uuid,bigType.address,bigType.countNum,bigType.createtime,bigType.attentionTime,bigType.desc,bigType.icon,bigType.infoId,bigType.label,bigType.layout,bigType.newNum,bigType.prompt,bigType.source,bigType.subscribeNum,bigType.title,bigType.type,bigType.updatetime,bigType.createType,bigType.isTop,bigType.dataLatestTime];
          [database executeUpdate:insertSql];
        }
      }
      [database close];
    }
  });
}

//查询本地监控列表
+(void)queryMonitorinListFromDBSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",attentionMonitoringList_tableName,lightExpList_userID,[ObjectShareTool sharedInstance].currentUser.uuid];
      FMResultSet *rs = [database executeQuery:sql];
      NSMutableArray *result = [NSMutableArray array];
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
          AttentionHead *comment = [AttentionHead mj_objectWithKeyValues:dict];
          [result addObject:comment];
      }
      [rs close];
      [database close];
      dispatch_async(dispatch_get_main_queue(), ^{
        success(result);
      });
    }else{
      fail(nil);
    }
  });
}

//保存单个体验到本地数据库
+(void)saveMonitoringToDB:(AttentionHead *)entity{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      CGUserEntity *userInfo = [ObjectShareTool sharedInstance].currentUser;
      NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@',%d,%ld,%ld,'%@','%@','%@','%@',%d,%d,'%@','%@',%d,'%@',%d,%ld,%ld,%ld)",attentionMonitoringList_tableName,monitoringList_userID,monitoringList_address,monitoringList_countNum,monitoringList_createtime,monitoringList_attentionTime,monitoringList_desc,monitoringList_icon,monitoringList_infoId,monitoringList_label,monitoringList_layout,monitoringList_newNum,monitoringList_prompt,monitoringList_source,monitoringList_subscribeNum,monitoringList_title,monitoringList_type,monitoringList_updatetime,monitoringList_createType,monitoringList_isTop,userInfo.uuid,entity.address,entity.countNum,entity.createtime,entity.attentionTime,entity.desc,entity.icon,entity.infoId,entity.label,entity.layout,entity.newNum,entity.prompt,entity.source,entity.subscribeNum,entity.title,entity.type,entity.updatetime,entity.createType,entity.isTop];
      [database executeUpdate:insertSql];
      [database close];
    }
  });
}

//删除某个监控
+(void)deleteMonitoringToDB:(AttentionHead *)entity{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
          NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",attentionMonitoringList_tableName,monitoringList_infoId,entity.infoId];
          [database executeUpdate:querySql];
      }
      [database close];
  });
}

//根据mid来更新体验
+(void)updateMonitoring:(AttentionHead *)entity{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(entity){
      FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
      if ([database open]){
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%d",attentionMonitoringList_tableName,monitoringList_infoId,entity.infoId,monitoringList_newNum,entity.newNum];
        [database executeUpdate:sql];
        [database close];
      }
    }
  });
}

//保存动态
+(void)saveDynamicToDB:(NSMutableArray *)data dynamicID:(NSString *)dynamic{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", attentionDynamicList_tableName,dynamicList_dynamicID,dynamic];
      if([database executeUpdate:querySql]){
        for(CGInfoHeadEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@',%d,%d,'%@',%ld,%ld,%d,%d,'%@',%d,'%@','%@','%@','%@')",attentionDynamicList_tableName,HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,dynamicList_dynamicID,info.bigtype,info.infoId,info.title,info.tag,info.icon,info.desc,info.type,info.layout,info.label,info.source,info.address,info.discuss,info.subscribe,info.prompt,info.localtime,info.createtime,info.isSubscribe,info.isFollow,info.imglistJson,info.read,info.relevantJson,info.navtype,info.navColor,dynamic];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
        [database close];
      }
    }
  });
}

//根据动态id查询本地动态列表
+(void)queryMonitorinListFromDBWithdynamicID:(NSString *)dynamicID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!dynamicID || dynamicID.length <= 0){
      dispatch_async(dispatch_get_main_queue(), ^{
        fail(nil);
      });
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",attentionDynamicList_tableName,dynamicList_dynamicID,dynamicID];
      FMResultSet *rs = [database executeQuery:sql];
      CGInfoHeadEntity *info;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
        info.infoId = [dict objectForKey:HeadlineInfo_id];
        info.imglistJson = [rs stringForColumn:HeadlineInfo_imglist];
        info.relevantJson = [rs stringForColumn:HeadlineInfo_relevant];
        info.imglist = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.imglistJson];
        NSArray *array = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.relevantJson];
        NSMutableArray *relevantArray = [NSMutableArray array];
        for (NSDictionary *relevantDic in array) {
          CGRelevantInformationEntity *relevant = [CGRelevantInformationEntity mj_objectWithKeyValues:relevantDic];
          [relevantArray addObject:relevant];
        }
        info.relevant = relevantArray;
        [result addObject:info];
      }
      [rs close];
      [database close];
      dispatch_async(dispatch_get_main_queue(), ^{
        if(result.count <= 0){
          fail(nil);
        }else{
          success(result);
        }
      });
    }else{
      fail(nil);
    }
  });
}

//根据动态id删除本地动态
+(void)deleteDynamicWithDynamicID:(NSString *)dynamicID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",attentionDynamicList_tableName,dynamicList_dynamicID,dynamicID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//根据分组id保存或更新雷达分组列表到本地数据库
+(void)saveGroupListToDB:(NSMutableArray *)data groupID:(NSString *)groupID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", RadarGroupList_tableName,RadarGroupList_groupID,groupID];
      if([database executeUpdate:querySql]){
        CGUserEntity *userInfo = [ObjectShareTool sharedInstance].currentUser;
        for(AttentionMyGroupEntity *bigType in data){
          NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@',%ld,%ld,%ld,%ld)",RadarGroupList_tableName,RadarGroupList_groupID,RadarGroupList_ID,RadarGroupList_userID,RadarGroupList_title,RadarGroupList_countNum,RadarGroupList_newNum,RadarGroupList_conditionNum,RadarGroupList_isCanDel,groupID,bigType.groupID,userInfo.uuid,bigType.title,bigType.countNum,bigType.newNum,bigType.conditionNum,bigType.isCanDel];
          [database executeUpdate:insertSql];
        }
      }
      [database close];
    }
  });
}

//根据分组id查询本地动态列表
+(void)queryGroupListFromDBWithGroupID:(NSString *)groupID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!groupID || groupID.length <= 0){
      dispatch_async(dispatch_get_main_queue(), ^{
        fail(nil);
      });
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from (select * from %@ where %@ = '%@') where %@='%@'",RadarGroupList_tableName,RadarGroupList_userID,[ObjectShareTool sharedInstance].currentUser.uuid,RadarGroupList_groupID,groupID];
      FMResultSet *rs = [database executeQuery:sql];
      AttentionMyGroupEntity *info;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [AttentionMyGroupEntity mj_objectWithKeyValues:dict];
        [result addObject:info];
      }
      [rs close];
      [database close];
      dispatch_async(dispatch_get_main_queue(), ^{
        if(result.count <= 0){
          fail(nil);
        }else{
          success(result);
        }
      });
    }else{
      fail(nil);
    }
  });
}

//更改某个分组数据
+(void)updateGroupList:(AttentionMyGroupEntity *)entity{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(entity){
      FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
      if ([database open]){
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%ld",RadarGroupList_tableName,RadarGroupList_ID,entity.groupID,RadarGroupList_newNum,entity.newNum];
        [database executeUpdate:sql];
        [database close];
      }
    }
  });
}

+(void)deleteGroupList:(AttentionMyGroupEntity *)entity{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",RadarGroupList_tableName,RadarGroupList_ID,entity.groupID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}
@end
