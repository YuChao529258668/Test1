//
//  DiscoverDao.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "DiscoverDao.h"
#import "CGInfoHeadEntity.h"
#import "CGUserHelpCateListEntity.h"
#import "CGProductInterfaceEntity.h"
#import "CGExpListEntity.h"
#import "CGRelevantInformationEntity.h"

@implementation DiscoverDao
+(void)saveProductInterfaceToDB:(NSMutableArray *)data type:(NSInteger)type action:(NSInteger)action{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSInteger time = [[NSDate date]timeIntervalSince1970];
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld and %@ = %ld", IndustryLibrary_tableName,IndustryLibrary_type,(long)type,IndustryLibrary_action,action];
    if ([database executeUpdate:querySql]){
      for(CGInfoHeadEntity *info in data){
        NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@',%d,%d,'%@',%ld,%ld,%d,%d,'%@',%d,'%@','%@','%@',%ld,%ld,%ld,'%@','%@','%@','%@','%@','%@','%@',%ld)",IndustryLibrary_tableName,HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,IndustryLibrary_type,IndustryLibrary_action,IndustryLibrary_time,HeadlineInfo_command,HeadlineInfo_commpanyId,HeadlineInfo_recordId,HeadlineInfo_messageId,HeadlineInfo_parameterId,IndustryLibrary_downloadUrl,IndustryLibrary_fileName,IndustryLibrary_fileSize,info.bigtype,info.infoId,info.title,info.tag,info.icon,info.desc,info.type,info.layout,info.label,info.source,info.address,info.discuss,info.subscribe,info.prompt,info.localtime,info.createtime,info.isSubscribe,info.isFollow,info.imglistJson,info.read,info.relevantJson,info.navtype,info.navColor,(long)type,action,time,info.command,info.commpanyId,info.recordId,info.messageId,info.parameterId,info.downloadUrl,info.fileName,info.fileSize];
        @try {
          [database executeUpdate:sql];
        } @catch (NSException *exception) {
          
        } @finally {
          
        }
        
      }
    }
      [database close];
    }
  });
}

//根据type和action查询本地行业文库列表
+(void)queryProductInterfaceFromDBWithType:(NSInteger)type action:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld and %@=%ld",IndustryLibrary_tableName,IndustryLibrary_type,type,IndustryLibrary_action,action];
      FMResultSet *rs = [database executeQuery:sql];
      CGInfoHeadEntity *info;
      BOOL isRefresh = NO;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
        info.infoId = [dict objectForKey:HeadlineInfo_id];
        info.imglistJson = [rs stringForColumn:HeadlineInfo_imglist];
        info.relevantJson = [rs stringForColumn:HeadlineInfo_relevant];
        
        NSString *time = [rs stringForColumn:IndustryLibrary_time];
        if ([CTDateUtils dateTimeDifferenceWithStartTime:time.integerValue endTime:[[NSDate date]timeIntervalSince1970]]>60*60*4) {
          isRefresh = YES;
        }
        
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
          success(result,isRefresh);
        }
      });
    }else{
      fail(nil);
    }
  });
}

//根据type和action删除本地行业文库列表
+(void)deleteProductInterfaceFromDBWithType:(NSInteger)type action:(NSInteger)action ID:(NSString *)ID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@=%ld and %@=%ld and %@='%@'",IndustryLibrary_tableName,IndustryLibrary_type,type,IndustryLibrary_action,action,HeadlineInfo_id,ID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//保存或更新全民推荐列表到本地数据库
+(void)saveRecommendListToDB:(NSMutableArray *)data type:(NSInteger)type action:(NSInteger)action{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld and %@ = %ld", RecommendList_tableName,RecommendList_type,type,RecommendList_action,action];
      if ([database executeUpdate:querySql]){
        for(CGInfoHeadEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@',%d,%d,'%@',%ld,%ld,%d,%d,'%@',%d,'%@','%@','%@',%ld,%ld)",RecommendList_tableName,HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,RecommendList_type,RecommendList_action,info.bigtype,info.infoId,info.title,info.tag,info.icon,info.desc,info.type,info.layout,info.label,info.source,info.address,info.discuss,info.subscribe,info.prompt,info.localtime,info.createtime,info.isSubscribe,info.isFollow,info.imglistJson,info.read,info.relevantJson,info.navtype,info.navColor,type,action];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
      }
      [database close];
    }
  });
}
//根据type和action查询本地全民推荐列表
+(void)queryRecommendListFromDBWithType:(NSInteger)type action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld and %@=%ld",RecommendList_tableName,RecommendList_type,type,RecommendList_action,action];
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

//保存或更新帮助二级列表到本地数据库
+(void)saveHelpCateListToDB:(NSMutableArray *)data cateID:(NSString *)cateID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", HelpCateList_tableName,HelpCateList_cateId,cateID];
      if ([database executeUpdate:querySql]){
        for(CGUserHelpCateListEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@) values('%@','%@','%@',%ld)",HelpCateList_tableName,HelpCateList_cateId,HelpCateList_pageId,HelpCateList_title,HelpCateList_createTime,cateID,info.pageId,info.title,info.createTime];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
      }
      [database close];
    }
  });
}
//根据cateID查询本地帮助二级列表
+(void)queryHelpCateListFromDBWithcateID:(NSString *)cateID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",HelpCateList_tableName,HelpCateList_cateId,cateID];
      FMResultSet *rs = [database executeQuery:sql];
      CGUserHelpCateListEntity *info;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGUserHelpCateListEntity mj_objectWithKeyValues:dict];
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

//保存或更新界面列表到本地数据库
+(void)saveInterfaceListToDB:(NSMutableArray *)data action:(NSInteger)action{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    if(!data || data.count <= 0){
//      return;
//    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", InterfaceList_tableName,InterfaceList_action,action];
      NSInteger time = [[NSDate date]timeIntervalSince1970];
      if ([database executeUpdate:querySql]){
        for(CGProductInterfaceEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@',%ld,'%@','%@',%ld,%ld,%ld,%ld,%ld,%ld,'%@')",InterfaceList_tableName,InterfaceList_id,InterfaceList_productId,InterfaceList_productName,InterfaceList_name,InterfaceList_isFollow,InterfaceList_cover,InterfaceList_media,InterfaceList_createtime,InterfaceList_action,InterfaceList_width,InterfaceList_height,InterfaceList_time,InterfaceList_original,InterfaceList_notice,info.interfaceID,info.productId,info.productName,info.name,info.isFollow,info.cover,info.media,info.createtime,action,info.width,info.height,time,info.original,info.notice];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
      }
      [database close];
    }
  });
}

//根据action查询本地界面列表
+(void)queryInterfaceListFromDBWithAction:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld",InterfaceList_tableName,InterfaceList_action,action];
      FMResultSet *rs = [database executeQuery:sql];
      CGProductInterfaceEntity *info;
      BOOL isRefresh = NO;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGProductInterfaceEntity mj_objectWithKeyValues:dict];
        NSString *time = [rs stringForColumn:InterfaceList_time];
        if ([CTDateUtils dateTimeDifferenceWithStartTime:time.integerValue endTime:[[NSDate date]timeIntervalSince1970]]>60*60*4) {
          isRefresh = YES;
        }
        [result addObject:info];
      }
      [rs close];
      [database close];
      dispatch_async(dispatch_get_main_queue(), ^{
        if(result.count <= 0){
          fail(nil);
        }else{
          success(result,isRefresh);
        }
      });
    }else{
      fail(nil);
    }
  });
}

//根据action和ID修改本地界面列表 （收藏）
//根据ID修改本地界面列表 （收藏）
+(void)updateInterfaceListFromDBWithID:(NSString *)ID isFollow:(NSInteger)isFollow{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if([CTStringUtil stringNotBlank:ID]){
      FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
      if ([database open]){
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@=%ld where %@='%@'",InterfaceList_tableName,InterfaceList_isFollow,isFollow,InterfaceList_id,ID];
        [database executeUpdate:sql];
        //NSLog(@"更新key---->%d:%@,%@,%@,%@",b,key,value,infoId,table);
        [database close];
      }
    }
  });
}

//保存或更新界面产品列表到本地数据库
+(void)saveInterfaceProductListToDB:(NSMutableArray *)data action:(NSInteger)action{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", InterfaceProductList_tableName,InterfaceProductList_action,action];
      NSInteger time = [[NSDate date]timeIntervalSince1970];
      if ([database executeUpdate:querySql]){
        for(CGExpListEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%ld,%ld,%ld,%ld,%ld,%ld)",InterfaceProductList_tableName,InterfaceProductList_id,InterfaceProductList_title,InterfaceProductList_icon,InterfaceProductList_desc,InterfaceProductList_source,InterfaceProductList_address,InterfaceProductList_subscribe,InterfaceProductList_createtime,InterfaceProductList_type,InterfaceProductList_isExpJoin,InterfaceProductList_action,InterfaceProductList_time,info.expID,info.title,info.icon,info.desc,info.source,info.address,info.subscribe,info.createtime,info.type,info.isExpJoin,action,time];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
      }
      [database close];
    }
  });
}

//根据action查询本地界面产品列表
+(void)queryInterfaceProductListFromDBWithAction:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld",InterfaceProductList_tableName,InterfaceProductList_action,action];
      FMResultSet *rs = [database executeQuery:sql];
      CGExpListEntity *info;
      BOOL isRefresh = NO;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGExpListEntity mj_objectWithKeyValues:dict];
        NSString *time = [rs stringForColumn:InterfaceProductList_time];
        if ([CTDateUtils dateTimeDifferenceWithStartTime:time.integerValue endTime:[[NSDate date]timeIntervalSince1970]]>60*60*4) {
          isRefresh = YES;
        }
        [result addObject:info];
      }
      [rs close];
      [database close];
      dispatch_async(dispatch_get_main_queue(), ^{
        if(result.count <= 0){
          fail(nil);
        }else{
          success(result,isRefresh);
        }
      });
    }else{
      fail(nil);
    }
  });
}

//保存或更新岗位知识列表到本地数据库
+(void)saveJobKnowledgeToDB:(NSMutableArray *)data type:(NSInteger)type navTypeId:(NSString *)navTypeId{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSInteger time = [[NSDate date]timeIntervalSince1970];
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld and %@ = '%@'", JobKnowledgeList_tableName,JobKnowledgeList_type,type,JobKnowledgeList_navTypeId,navTypeId];
      if ([database executeUpdate:querySql]){
        for(CGInfoHeadEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@',%d,%d,'%@',%ld,%ld,%d,%d,'%@',%d,'%@','%@','%@',%ld,'%@',%ld,'%@','%@','%@','%@','%@','%@')",JobKnowledgeList_tableName,HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,JobKnowledgeList_type,JobKnowledgeList_navTypeId,JobKnowledgeList_time,JobKnowledgeList_packageId,HeadlineInfo_command,HeadlineInfo_commpanyId,HeadlineInfo_recordId,HeadlineInfo_messageId,HeadlineInfo_parameterId,info.bigtype,info.infoId,info.title,info.tag,info.icon,info.desc,info.type,info.layout,info.label,info.source,info.address,info.discuss,info.subscribe,info.prompt,info.localtime,info.createtime,info.isSubscribe,info.isFollow,info.imglistJson,info.read,info.relevantJson,info.navtype,info.navColor,type,navTypeId,time,info.packageId,info.command,info.commpanyId,info.recordId,info.messageId,info.parameterId];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
      }
      [database close];
    }
  });
}

//根据type和action删除岗位知识到本地数据库
+(void)deleteJobKnowledgeToDBWithType:(NSInteger)type navTypeId:(NSString *)navTypeId knowledgeID:(NSString *)knowledgeID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@=%ld and %@='%@' and %@='%@'",JobKnowledgeList_tableName,JobKnowledgeList_type,type,JobKnowledgeList_navTypeId,navTypeId,HeadlineInfo_id,knowledgeID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//根据type和action查询本地岗位知识列表
+(void)queryJobKnowledgeFromDBWithType:(NSInteger)type navTypeId:(NSString *)navTypeId success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld and %@='%@'",JobKnowledgeList_tableName,JobKnowledgeList_type,type,JobKnowledgeList_navTypeId,navTypeId];
      FMResultSet *rs = [database executeQuery:sql];
      CGInfoHeadEntity *info;
      BOOL isRefresh = NO;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
        info.infoId = [dict objectForKey:HeadlineInfo_id];
        info.imglistJson = [rs stringForColumn:HeadlineInfo_imglist];
        info.relevantJson = [rs stringForColumn:HeadlineInfo_relevant];
        
        NSString *time = [rs stringForColumn:JobKnowledgeList_time];
        if ([CTDateUtils dateTimeDifferenceWithStartTime:time.integerValue endTime:[[NSDate date]timeIntervalSince1970]]>60*60*4) {
          isRefresh = YES;
        }
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
          success(result,isRefresh);
        }
      });
    }else{
      fail(nil);
    }
  });
}
@end
