//
//  AttentionBiz.m
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AttentionBiz.h"
#import "AttentionHead.h"
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
#import "AttentionSortList.h"
#import "CGUserDao.h"
#import "CGCompanyDao.h"
#import "AttentionMyGroupEntity.h"
#import "AttentionHead.h"
#import "AttentionStatisticsEntity.h"
#import "MonitoringDao.h"
#import "CGCompanyDao.h"

@implementation AttentionBiz

//获取关注页面一级列表
-(void)queryAttentionHeadListWithTime:(long)time mode:(int)mode url:(NSString *)url success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
//    if(time <= 0){
//        time = [[NSDate date]timeIntervalSince1970]*1000;
//    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:time],@"time",@(mode),@"mode",[NSNumber numberWithInt:20],@"count",nil];
    [self.component sendPostRequestWithURL:url param:param success:^(id data) {
        NSMutableArray *result = [AttentionHead mj_objectArrayWithKeyValuesArray:data];
      [MonitoringDao savemonitoringToDB:result];
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询关注详情
-(void)queryAttentionInfoWithId:(NSString *)dataId type:(int)type success:(void(^)(AttentionDetail *detail))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"type",dataId,@"id",nil];
    [self.component sendPostRequestWithURL:URL_ATTENTION_INFO param:param success:^(id data) {
        success([AttentionDetail mj_objectWithKeyValues:data]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询导航
-(void)queryNaviDataByType:(int)type toId:(NSString*)toId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"type",toId,@"toId",nil];
    [self.component sendPostRequestWithURL:URL_ATTENTION_NAV_LIST param:param success:^(id data) {
        NSArray *naviArray = data;
        NSMutableArray *result = [NSMutableArray array];
        AttentionSortList *entity;
        for(int i=0;i<naviArray.count;i++){
            NSDictionary *dict = naviArray[i];
            entity = [AttentionSortList mj_objectWithKeyValues:dict];
            [result addObject:entity];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询关注某记录的列表数据
-(void)queryAttentionDetailListWithType:(int)type label:(NSString *)label time:(long)time mode:(int)mode dataId:(NSString *)dataId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
//    if(!time){
//        time = [[NSDate date]timeIntervalSince1970]*1000;
//    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"type",label,@"label",[NSNumber numberWithLong:time],@"time",[NSNumber numberWithInt:mode],@"mode",dataId,@"id",nil];
    [self.component sendPostRequestWithURL:URL_ATTENTION_DATA_LIST param:param success:^(id data) {
        NSArray *headlineArray = data;
        NSMutableArray *result = [NSMutableArray array];
        CGInfoHeadEntity *info;
        for(NSDictionary *dict in headlineArray){
            info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
            if(info.imglist.count == 1){
                info.layout = ContentLayoutRightPic;
            }else if (info.imglist.count >= 3){
                info.layout = ContentLayoutMorePic;
            }else{
                info.layout = ContentLayoutOnlyTitle;
            }
          if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            info.imglistJson = json;
          }
            info.bigtype = label;
            [result addObject:info];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//关注页面关注操作
-(void)subscribeAddWithId:(NSString *)dataId type:(int)type success:(void(^)(NSInteger status))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"type",dataId,@"id",nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_SUBSCRIBE_ADD param:param success:^(id data) {
    NSString *status = data;
    success(status.integerValue);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达首页公司列表
-(void)radarCompanyListSuccess:(void(^)(AttentionCompanyEntity *result))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_COMPANY_LIST param:nil success:^(id data) {
    [AttentionCompanyEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"companyEntity",
               };
    }];
    NSDictionary *dic = data;
    AttentionCompanyEntity *result = [AttentionCompanyEntity mj_objectWithKeyValues:dic];
    [CGCompanyDao saveMonitoringGroupListInLocal:result];
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组列表接口
-(void)radarGroupListWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
//  AttentionMyGroupEntity
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if ([CTStringUtil stringNotBlank:ID]) {
    [param setObject:ID forKey:@"id"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
  }
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in array) {
     AttentionMyGroupEntity *entity = [AttentionMyGroupEntity mj_objectWithKeyValues:dic];
      [result addObject:entity];
    }
    if ([CTStringUtil stringNotBlank:ID]) {
    }
    [MonitoringDao saveGroupListToDB:result groupID:ID];
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组创建接口
-(void)authRadarGroupCreateWithID:(NSString *)ID type:(NSInteger)type title:(NSString *)title success:(void(^)(NSString *groupID))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:title,@"title", nil];
  if ([CTStringUtil stringNotBlank:ID]) {
     [param setObject:ID forKey:@"id"];
     [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
  }
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_CREATE param:param success:^(id data) {
    NSString *result = data;
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组删除接口
-(void)authRadarGroupDeleteWithID:(NSString *)ID success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_DELETE param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组修改接口
-(void)authRadarGroupUpdateWithID:(NSString *)ID title:(NSString *)title success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",title,@"title", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_UPDATE param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组名单列表接口
-(void)radarGroupConditionListWithID:(NSString *)ID page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:page],@"page", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_CONDITION_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in array) {
      AttentionHead *entity = [AttentionHead mj_objectWithKeyValues:dic];
      [result addObject:entity];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组名单编辑接口
-(void)authRadarGroupConditionAddWithID:(NSString *)ID type:(NSInteger)type subjectId:(NSString *)subjectId op:(NSInteger)op success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type",subjectId,@"subjectId",[NSNumber numberWithInteger:op],@"op", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_CONDITION_ADD param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组资讯列表详情
-(void)radarGroupDetailsListWithType:(NSInteger)type time:(NSInteger)time page:(NSInteger)page ID:(NSString *)ID navTypeId:(NSString *)navTypeId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:time],@"time", nil];
  if ([CTStringUtil stringNotBlank:navTypeId]) {
    [param setObject:navTypeId forKey:@"navTypeId"];
  }
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_DETAILS_LIST param:param success:^(id data) {
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
      if(info.imglist.count == 1){
        info.layout = ContentLayoutRightPic;
      }else if (info.imglist.count >= 3){
        info.layout = ContentLayoutMorePic;
      }else{
        info.layout = ContentLayoutOnlyTitle;
      }
      if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        info.imglistJson = json;
      }
      
      if (info.relevant && ![info.relevant isKindOfClass:[NSNull class]] && info.relevant.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"relevantInfoList"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        info.relevantJson = json;
      }
      [result addObject:info];
    }
    if (![CTStringUtil stringNotBlank:navTypeId]&&page == 1) {
      [MonitoringDao saveDynamicToDB:result dynamicID:ID];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达详情统计接口
-(void)radarGroupDetailsStatisticsWithType:(NSInteger)type ID:(NSString *)ID page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_DETAILS_STATISTICS param:param success:^(id data) {
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    AttentionStatisticsEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [AttentionStatisticsEntity mj_objectWithKeyValues:dict];
      [result addObject:info];
    }
    if (type == 8) {
      [CGCompanyDao saveProductStatistics:result];
    }else if (type == 3){
      [CGCompanyDao saveCompanyStatistics:result];
    }else if (type == 4){
      [CGCompanyDao saveFigureStatistics:result];
    }else if(type == 9){
      [CGCompanyDao saveGroupStatistics:result];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达订阅列表置顶接口
-(void)radarSubscribeTopWithID:(NSString *)ID type:(NSInteger)type op:(NSInteger)op success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:op],@"op", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_SUBSCRIBE_TOP param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//雷达分组加入列表接口
-(void)radarGroupJoinListID:(NSString *)ID type:(NSInteger)type success:(void(^)(GroupJoinEntity *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_JOIN_LIST param:param success:^(id data) {
    [GroupJoinEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"JoinEntity",
               };
    }];
    NSDictionary *dic = data;
    GroupJoinEntity *result = [GroupJoinEntity mj_objectWithKeyValues:dic];
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//技能导航分类接口（全部）
-(void)headlinesSkillNavListSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_SKILL_NAV_LIST_ALL param:nil success:^(id data) {
    [KnowledgeBaseEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"ListEntity",
               };
    }];
    [ListEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"NavsEntity",
               };
    }];
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in array) {
      KnowledgeBaseEntity *entity = [KnowledgeBaseEntity mj_objectWithKeyValues:dic];
      [result addObject:entity];
    }
      [ObjectShareTool sharedInstance].knowledgeBigTypeData = result;
      [CGCompanyDao saveJobKnowledgeStatistics:result];
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//技能导航分类接口
-(void)headlinesSkillNavListWithID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
  [self.component sendPostRequestWithURL:URL_SKILL_NAV_LIST param:param success:^(id data) {
    [KnowledgeBaseEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"ListEntity",
               };
    }];
    [ListEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"NavsEntity",
               };
    }];
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in array) {
      KnowledgeBaseEntity *entity = [KnowledgeBaseEntity mj_objectWithKeyValues:dic];
      [result addObject:entity];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//岗位知识列表接口
-(void)radarGroupDetailsListScoopWithPage:(NSInteger)page navTypeId:(NSString *)navTypeId type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:navTypeId,@"navTypeId",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithFloat:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_RADAR_GROUP_DETAILS_LIST_SCOOP param:param success:^(id data) {
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
      if(info.imglist.count == 1){
        info.layout = ContentLayoutRightPic;
      }else if (info.imglist.count >= 3){
        info.layout = ContentLayoutMorePic;
      }else{
        info.layout = ContentLayoutOnlyTitle;
      }
      if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        info.imglistJson = json;
      }
      
      if (info.relevant && ![info.relevant isKindOfClass:[NSNull class]] && info.relevant.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"relevantInfoList"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        info.relevantJson = json;
      }
      [result addObject:info];
    }
//    if (![CTStringUtil stringNotBlank:navTypeId]&&page == 1) {
//      [MonitoringDao saveDynamicToDB:result dynamicID:ID];
//    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//技能导航工具库
-(void)headlinesSkillNavToolListWithID:(NSString *)ID type:(NSInteger)type page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_ATTENTION_SKILL_NAV_TOOL_LIST param:param success:^(id data) {
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
//      if(info.imglist.count == 1){
//        info.layout = ContentLayoutRightPic;
//      }else if (info.imglist.count >= 3){
//        info.layout = ContentLayoutMorePic;
//      }else{
//        info.layout = ContentLayoutOnlyTitle;
//      }
      if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        info.imglistJson = json;
      }
      
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}
@end
