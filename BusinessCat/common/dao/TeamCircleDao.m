//
//  TeamCircleDao.m
//  CGSays
//
//  Created by zhu on 2017/3/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircleDao.h"
#import "CellLayout.h"

@implementation TeamCircleDao
//保存或更新企业圈列表到本地数据库
+(void)saveTeamCircleToDB:(NSMutableArray *)data organizationID:(NSString *)organizationID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!data || data.count <= 0){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", TeamCircleList_tableName,teamCircleList_organizationID,organizationID];
      if([database executeUpdate:querySql]){
        for(CGSourceCircleEntity *info in data){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@',%ld,%ld,%ld,'%@','%@','%@',%ld,%ld,'%@',%ld,%ld,%d,'%@','%@','%@','%@')",TeamCircleList_tableName,teamCircleList_organizationID,teamCircleList_scoopID,teamCircleList_portrait,teamCircleList_nickname,teamCircleList_content,teamCircleList_scoopType,teamCircleList_level,teamCircleList_visibility,teamCircleList_linkIcon,teamCircleList_linkId,teamCircleList_linkTitle,teamCircleList_linkType,teamCircleList_time,teamCircleList_userId,teamCircleList_isPraise,teamCircleList_isPay,teamCircleList_isSearch,teamCircleList_imageListJsonStr,teamCircleList_praiseJsonStr,teamCircleList_commentJsonStr,teamCircleList_payJsonStr,organizationID,info.scoopID,info.portrait,info.nickname,info.content,info.scoopType,info.level,info.visibility,info.linkIcon,info.linkId,info.linkTitle,info.linkType,info.time,info.userId,info.isPraise,info.isPay,info.isSearch,info.imageListJsonStr,info.praiseJsonStr,info.commentJsonStr,info.payJsonStr];
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

+(void)queryMonitorinListFromDBWithOrganizationID:(NSString *)organizationID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!organizationID || organizationID.length <= 0){
      dispatch_async(dispatch_get_main_queue(), ^{
        fail(nil);
      });
    }
    [SourceCircComments mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"reply"    : @"SourceCircReply",
               };
    }];
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSMutableArray *result = [NSMutableArray array];
      NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",TeamCircleList_tableName,teamCircleList_organizationID,organizationID];
      FMResultSet *rs = [database executeQuery:sql];
      CGSourceCircleEntity *info;
      while (rs.next) {
        NSDictionary *dict = [rs resultDictionary];
        info = [CGSourceCircleEntity mj_objectWithKeyValues:dict];
        NSArray *imageArray = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.imageListJsonStr];
        NSArray *praiseArray = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.praiseJsonStr];
        NSArray *commentArray = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.commentJsonStr];
        NSArray *payArray = [NSMutableArray mj_objectArrayWithKeyValuesArray:info.payJsonStr];
        NSMutableArray *newImageArray = [NSMutableArray array];
        for (NSDictionary *imageDic in imageArray) {
          SourceCircImgList *image = [SourceCircImgList mj_objectWithKeyValues:imageDic];
          [newImageArray addObject:image];
        }
        info.imgList = newImageArray;
        
        NSMutableArray *newPraiseArray = [NSMutableArray array];
        for (SourceCircPraise *praiseDic in praiseArray) {
          SourceCircPraise *praise = [SourceCircPraise mj_objectWithKeyValues:praiseDic];
          [newPraiseArray addObject:praise];
        }
        info.praise = newPraiseArray;
        
        NSMutableArray *newCommentArray = [NSMutableArray array];
        for (SourceCircComments *commentDic in commentArray) {
          SourceCircComments *comment = [SourceCircComments mj_objectWithKeyValues:commentDic];
          [newCommentArray addObject:comment];
        }
        info.comments = newCommentArray;
        
        NSMutableArray *newPayArray = [NSMutableArray array];
        for (SourcePay *payDic in payArray) {
          SourcePay *pay = [SourcePay mj_objectWithKeyValues:payDic];
          [newPayArray addObject:pay];
        }
        info.payList = newPayArray;
        static NSDateFormatter* dateFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
        });
        CellLayout* layout = [[CellLayout alloc] initWithStatusModel:info isUnfold:NO dateFormatter:dateFormatter];
        [result addObject:layout];
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

//保存单个企业圈内容到本地数据库
+(void)saveOrganizationToDB:(CGSourceCircleEntity *)info organizationID:(NSString *)organizationID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(!info){
      return;
    }
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    
    if ([database open]){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@',%ld,%ld,%ld,'%@','%@','%@',%ld,%ld,'%@',%ld,%ld,%d,'%@','%@','%@','%@')",TeamCircleList_tableName,teamCircleList_organizationID,teamCircleList_scoopID,teamCircleList_portrait,teamCircleList_nickname,teamCircleList_content,teamCircleList_scoopType,teamCircleList_level,teamCircleList_visibility,teamCircleList_linkIcon,teamCircleList_linkId,teamCircleList_linkTitle,teamCircleList_linkType,teamCircleList_time,teamCircleList_userId,teamCircleList_isPraise,teamCircleList_isPay,teamCircleList_isSearch,teamCircleList_imageListJsonStr,teamCircleList_praiseJsonStr,teamCircleList_commentJsonStr,teamCircleList_payJsonStr,organizationID,info.scoopID,info.portrait,info.nickname,info.content,info.scoopType,info.level,info.visibility,info.linkIcon,info.linkId,info.linkTitle,info.linkType,info.time,info.userId,info.isPraise,info.isPay,info.isSearch,info.imageListJsonStr,info.praiseJsonStr,info.commentJsonStr,info.payJsonStr];
          @try {
            [database executeUpdate:sql];
          } @catch (NSException *exception) {
            
          } @finally {
            
          }
          
        }
        [database close];
  });
}

//删除某个企业圈内容
+(void)deleteTeamCircleToDBWithScoopID:(NSString *)scoopID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",TeamCircleList_tableName,teamCircleList_scoopID,scoopID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//根据公司id删除某个企业圈内容
+(void)deleteTeamCircleToDBWithOrganizationID:(NSString *)organizationID{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",TeamCircleList_tableName,teamCircleList_organizationID,organizationID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//更改某个企业圈内容
+(void)updateTeamCircleWithScoopID:(NSString *)scoopID info:(CGSourceCircleEntity *)info{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(info){
      FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
      if ([database open]){
        NSMutableArray *imageListArray = [NSMutableArray array];
        for (SourceCircImgList *image in info.imgList) {
          [imageListArray addObject:[image mj_keyValues]];
        }
        NSData *imageListjsonData = [NSJSONSerialization dataWithJSONObject:imageListArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *imageListjson = [[NSString alloc] initWithData:imageListjsonData encoding:NSUTF8StringEncoding];
        NSString *sql1 = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",TeamCircleList_tableName,teamCircleList_scoopID,scoopID,teamCircleList_imageListJsonStr,imageListjson];
        NSMutableArray *praiseArray = [NSMutableArray array];
        for (SourceCircPraise *praise in info.praise) {
          [praiseArray addObject:[praise mj_keyValues]];
        }
        NSData *praisejsonData = [NSJSONSerialization dataWithJSONObject:praiseArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *praisejson = [[NSString alloc] initWithData:praisejsonData encoding:NSUTF8StringEncoding];
        NSString *sql2 = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",TeamCircleList_tableName,teamCircleList_scoopID,scoopID,teamCircleList_praiseJsonStr,praisejson];
        NSMutableArray *commentArray = [NSMutableArray array];
        for (SourceCircComments *comment in info.comments) {
          if (comment.reply) {
            NSMutableDictionary *dic = [comment.reply mj_keyValues];
            NSData *replyjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            comment.replyJsonStr = [[NSString alloc] initWithData:replyjsonData encoding:NSUTF8StringEncoding];
          }
          [imageListArray addObject:[comment mj_keyValues]];
        }
        NSData *commentjsonData = [NSJSONSerialization dataWithJSONObject:commentArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *commentjson = [[NSString alloc] initWithData:commentjsonData encoding:NSUTF8StringEncoding];
        NSString *sql3 = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",TeamCircleList_tableName,teamCircleList_scoopID,scoopID,teamCircleList_commentJsonStr,commentjson];
        NSMutableArray *payArray = [NSMutableArray array];
        for (SourcePay *pay in info.payList) {
          [payArray addObject:[pay mj_keyValues]];
        }
        NSData *payjsonData = [NSJSONSerialization dataWithJSONObject:payArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *payjson = [[NSString alloc] initWithData:payjsonData encoding:NSUTF8StringEncoding];
        NSString *sql4 = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",TeamCircleList_tableName,teamCircleList_scoopID,scoopID,teamCircleList_payJsonStr,payjson];
        [database executeUpdate:sql1];
        [database executeUpdate:sql2];
        [database executeUpdate:sql3];
        [database executeUpdate:sql4];
        [database close];
      }
    }
  });
}
@end
