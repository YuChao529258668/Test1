//
//  SearchDao.m
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "SearchDao.h"
#import "CGHotSearchEntity.h"

@implementation SearchDao
+(void)saveSearchToDB:(NSString *)key type:(NSInteger)type{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(![CTStringUtil stringNotBlank:key]){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSDate *datenow = [NSDate date];
      NSInteger time = [datenow timeIntervalSince1970];
          NSString *sql = [NSString stringWithFormat:@"insert into %@(%@,%@,%@) values(%ld,'%@',%ld)",SearchList_tableName,SearchList_type,SearchList_KeyWord,SearchList_time,type,key,time];
      if (![database executeUpdate:sql]) {
        NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",SearchList_tableName,SearchList_KeyWord,key];
        [database executeUpdate:querySql];
        [database executeUpdate:sql];
      }
        [database close];
      }
  });
}

//根据type查询本地搜索关键字
+(void)querySearchFromDBWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld order by %@ desc limit 10",SearchList_tableName,SearchList_type,type,SearchList_time];
      FMResultSet *rs = [database executeQuery:sql];
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        NSString *str = [dict objectForKey:SearchList_KeyWord];
        [result addObject:str];
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

//根据type删除本地搜索关键字
+(void)deleteSearchToDBWithType:(NSInteger)type{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",SearchList_tableName,SearchList_type,type];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//保存搜索关键字到数据库
+(void)saveHotSearchToDB:(NSMutableArray *)data type:(NSInteger)type{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", HotSearchList_tableName,HotSearchList_type,type];
      if([database executeUpdate:querySql]){
        for(CGHotSearchEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@) values(%ld,'%@','%@','%@','%@','%@',%ld)",HotSearchList_tableName,HotSearchList_type,HotSearchList_tagId,HotSearchList_tagName,HotSearchList_command,HotSearchList_commpanyId,HotSearchList_recordId,HotSearchList_recordType,type,info.tagId,info.tagName,info.command,info.commpanyId,info.recordId,info.recordType];
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

//根据type查询本地热门搜索关键字
+(void)queryHotSearchFromDBWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%ld",HotSearchList_tableName,HotSearchList_type,type];
      FMResultSet *rs = [database executeQuery:sql];
      CGHotSearchEntity *info;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGHotSearchEntity mj_objectWithKeyValues:dict];
        [result insertObject:info atIndex:0];
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
@end
