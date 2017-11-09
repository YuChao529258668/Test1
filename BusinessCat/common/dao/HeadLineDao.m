//
//  HeadLineDao.m
//  CGSays
//
//  Created by mochenyang on 2016/10/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadLineDao.h"
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
#import "CGRelevantInformationEntity.h"

//首页热搜数据
#define HomePageHotSearchData @"HomePageHotSearchData"
#define HomePageHotSearchDataPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],HomePageHotSearchData]



@implementation HeadLineDao

//缓存大类到本地数据库
-(void)saveOrUpdateHeadlineBigType:(NSMutableArray *)bigTypes success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *querySql = [NSString stringWithFormat:@"delete from %@", HeadlineBigType_tableName];
            if([database executeUpdate:querySql]){
                for(CGHorrolEntity *bigType in bigTypes){
                    NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@) values(%d,'%@','%@')",HeadlineBigType_tableName,HeadlineBigType_sort,HeadlineBigType_typeId,HeadlineBigType_typeName,bigType.sort,bigType.rolId,bigType.rolName];
                    [database executeUpdate:insertSql];
                }
            }
            
            [database close];
//            [ObjectShareTool sharedInstance].bigTypeData = bigTypes;
            dispatch_async(dispatch_get_main_queue(), ^{
                success(bigTypes);
            });
        }
    });
}

//查询本地的头条大类
//-(void)queryHeadlineBigTypeFromDBSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *result = [ObjectShareTool sharedInstance].bigTypeData;
//        if(result && result.count > 0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                success(result);
//            });
//        }else{
//            FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
//            if ([database open]){
//                NSString *sql = [NSString stringWithFormat:@"select * from %@ order by %@ asc",HeadlineBigType_tableName,HeadlineBigType_sort];
//                FMResultSet *rs = [database executeQuery:sql];
//                while (rs.next) {
//                    CGHorrolEntity *bigtype = [[CGHorrolEntity alloc]initWithRolId:[rs stringForColumn:HeadlineBigType_typeId] rolName:[rs stringForColumn:HeadlineBigType_typeName] sort:[rs intForColumn:HeadlineBigType_sort]];
//                    [result addObject:bigtype];
//                }
//                [rs close];
//                [database close];
//            }
//            [ObjectShareTool sharedInstance].bigTypeData = result;
//            if(result){
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                success(result);
//            });
//        }
//    });
//}

//保存资讯到本地数据库
-(void)saveInfoDataToDB:(NSMutableArray *)data{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!data || data.count <= 0){
            return;
        }
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        
        if ([database open]){
            for(CGInfoHeadEntity *info in data){
                NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@',%d,%d,'%@',%ld,%ld,%d,%d,'%@',%d,'%@','%@','%@')",HeadlineInfo_tableName,HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,info.bigtype,info.infoId,info.title,info.tag,info.icon,info.desc,info.type,info.layout,info.label,info.source,info.address,info.discuss,info.subscribe,info.prompt,info.localtime,info.createtime,info.isSubscribe,info.isFollow,info.imglistJson,info.read,info.relevantJson,info.navtype,info.navColor];
                @try {
                    [database executeUpdate:sql];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
            }
            [database close];
        }
    });
}

//删除关注大类
-(void)deleteInfoDataByInfoID:(NSString *)InfoID{
  if (InfoID.length<=0) {
    return;
  }
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",HeadlineInfo_tableName,HeadlineInfo_id,InfoID];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//查询本地资讯
-(void)queryInfoDataFromDB:(NSString *)bigtype success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!bigtype || bigtype.length <= 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil);
            });
        }
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSMutableArray *result = [NSMutableArray array];
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@' order by %@ desc limit 20",HeadlineInfo_tableName,HeadlineInfo_bigtype,bigtype,HeadlineInfo_localtime];
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

//根据key来更新资讯
-(void)updateInfoDataByKey:(NSString *)key value:(id)value infoId:(NSString *)infoId table:(NSString *)table{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([CTStringUtil stringNotBlank:infoId]){
            FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
            if ([database open]){
                NSString *sql = [NSString stringWithFormat:@"update %@ set %@=%@ where %@='%@'",table,key,value,HeadlineInfo_id,infoId];
                [database executeUpdate:sql];
                //NSLog(@"更新key---->%d:%@,%@,%@,%@",b,key,value,infoId,table);
                [database close];
            }
        }
    });
}

//保存详情到本地
-(void)saveInfoDetailToDB:(CGInfoDetailEntity *)detail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
          NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@',%ld,%d,%ld,'%@','%@','%@','%@',%ld,'%@',%ld,'%@','%@',%ld,%ld,'%@',%ld,%ld,%ld)",HeadlineInfoDetail_tableName,HeadlineInfoDetail_id,HeadlineInfoDetail_title,HeadlineInfoDetail_html,HeadlineInfoDetail_url,HeadlineInfoDetail_infoPic,HeadlineInfoDetail_type,HeadlineInfoDetail_baiduCode,HeadlineInfoDetail_qiniuUrl,HeadlineInfoDetail_format,HeadlineInfoDetail_fileUrl,HeadlineInfoDetail_isFollow,HeadlineInfoDetail_pageCout,HeadlineInfoDetail_commentCount,HeadlineInfoDetail_authorIcon,HeadlineInfoDetail_authorName,HeadlineInfoDetail_navType,HeadlineInfoDetail_subType,HeadlineInfoDetail_viewPermit,HeadlineInfoDetail_viewPrompt,HeadlineInfoDetail_infoOriginal,HeadlineInfoDetail_source,HeadlineInfoDetail_notice,HeadlineInfoDetail_integral,HeadlineInfoDetail_state,HeadlineInfoDetail_shareUrl,HeadlineInfoDetail_pageCount,HeadlineInfoDetail_width,HeadlineInfoDetail_height,detail.infoId,detail.title,detail.html,detail.url,detail.infoPic,detail.type,detail.baiduCode,detail.qiniuUrl,detail.format,detail.fileUrl,detail.isFollow,detail.pageCout,detail.commentCount,detail.authorIcon,detail.authorName,detail.navType,detail.subType,detail.viewPermit,detail.viewPrompt,detail.infoOriginal,detail.source,detail.notice,detail.integral,detail.state,detail.shareUrl,detail.pageCount,detail.width,detail.height];
            [database executeUpdate:sql];
            [database close];
        }
    });
}

//从本地删除详情
-(void)deleteInfoDetailFromDB:(NSString *)infoId{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *querySql = [NSString stringWithFormat:@"delete from %@ where %@='%@'",HeadlineInfoDetail_tableName,HeadlineInfoDetail_id,infoId];
      [database executeUpdate:querySql];
    }
    [database close];
  });
}

//从本地查询详情
-(void)queryInfoDetailFromDB:(NSString *)infoId success:(void(^)(CGInfoDetailEntity *detail))success fail:(void (^)(NSError *error))fail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
        if ([database open]){
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",HeadlineInfoDetail_tableName,HeadlineInfoDetail_id,infoId];
            FMResultSet *rs = [database executeQuery:sql];
            if(rs.next){
                NSDictionary *dict = [rs resultDictionary];
                CGInfoDetailEntity *detail = [CGInfoDetailEntity mj_objectWithKeyValues:dict];
                detail.infoId = [dict objectForKey:HeadlineInfoDetail_id];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(detail);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(nil);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil);
            });
        }
    });
}

//清除数据库内容
+(void)deleteQuery{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
      NSString *headlineInfoQuerySql = [NSString stringWithFormat:@"delete from %@",HeadlineInfo_tableName];
      [database executeUpdate:headlineInfoQuerySql];
      NSString *headlineInfoDetailQuerySql = [NSString stringWithFormat:@"delete from %@",HeadlineInfoDetail_tableName];
      [database executeUpdate:headlineInfoDetailQuerySql];
      NSString *lightExpQuerySql = [NSString stringWithFormat:@"delete from %@",lightExpList_tableName];
      [database executeUpdate:lightExpQuerySql];
      
      NSString *attentionMonitoringQuerySql = [NSString stringWithFormat:@"delete from %@",attentionMonitoringList_tableName];
      [database executeUpdate:attentionMonitoringQuerySql];
      
      NSString *ttentionDynamicQuerySql = [NSString stringWithFormat:@"delete from %@",attentionDynamicList_tableName];
      [database executeUpdate:ttentionDynamicQuerySql];
      
      NSString *teamCircleQuerySql = [NSString stringWithFormat:@"delete from %@",TeamCircleList_tableName];
      [database executeUpdate:teamCircleQuerySql];
      
      NSString *searchQuerySql = [NSString stringWithFormat:@"delete from %@",SearchList_tableName];
      [database executeUpdate:searchQuerySql];
      
      NSString *hotSearchQuerySql = [NSString stringWithFormat:@"delete from %@",HotSearchList_tableName];
      [database executeUpdate:hotSearchQuerySql];
      
      NSString *radarGroupListQuerySql = [NSString stringWithFormat:@"delete from %@",RadarGroupList_tableName];
      [database executeUpdate:radarGroupListQuerySql];
      
      NSString *helpCateListQuerySql = [NSString stringWithFormat:@"delete from %@",HelpCateList_tableName];
      [database executeUpdate:helpCateListQuerySql];
      
      NSString *interfaceProductListQuerySql = [NSString stringWithFormat:@"delete from %@",InterfaceProductList_tableName];
      [database executeUpdate:interfaceProductListQuerySql];
      
      NSString *jobKnowledgeListQuerySql = [NSString stringWithFormat:@"delete from %@",JobKnowledgeList_tableName];
      [database executeUpdate:jobKnowledgeListQuerySql];
      NSString *industryLibraryQuerySql = [NSString stringWithFormat:@"delete from %@",IndustryLibrary_tableName];
      [database executeUpdate:industryLibraryQuerySql];
    }
    [database close];
  });
}

-(BOOL)saveHotSearchDataToLocal:(NSMutableArray *)array{
    [CTFileUtil createFolder:[CTFileUtil getDocumentsPath] error:nil];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:HomePageHotSearchData];
    [archiver finishEncoding];
    return [data writeToFile:HomePageHotSearchDataPath atomically:YES];
}

-(NSMutableArray *)queryHotSearchDataFromLocal{
    NSMutableArray *result;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:HomePageHotSearchDataPath];
    if(data){
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        result  = [unarchiver decodeObjectForKey:HomePageHotSearchData];
    }
    return result;
}

//查询本地首页菜单数据
-(NSMutableArray *)queryHomePageMenuData{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:HomePageMenuData];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}
@end
