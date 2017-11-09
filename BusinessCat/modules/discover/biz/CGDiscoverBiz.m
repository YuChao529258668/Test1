//
//  CUDiscoverBiz.m
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverBiz.h"
#import "ObjectShareTool.h"
#import "CGSourceCircleEntity.h"
#import "CGPartSeeAddressEntity.h"
#import "TeamCircleDao.h"
#import "CGInfoHeadEntity.h"
#import "CGProductInterfaceEntity.h"
#import "InterfaceCatalogEntity.h"
#import "CGExpListEntity.h"
#import "CGProductDetailsVersionEntity.h"
#import "CGDetailsPlatformEnitity.h"
#import "CGVipListEntity.h"
#import "TeamCircleLastStateEntity.h"
#import "TeamCircleCompanyState.h"
#import "TeamCircleMessageModel.h"

@implementation CGDiscoverBiz
//爆料圈首页列表接口
- (void)discoverScoopListWithType:(NSInteger )type time:(NSInteger )time mode:(NSInteger )mode companyId:(NSString *)companyId companyType:(NSInteger )companyType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:mode],@"mode", nil];
  if ([CTStringUtil stringNotBlank:companyId]) {
    [param setObject:companyId forKey:@"companyId"];
    [param setObject:[NSNumber numberWithInteger:companyType] forKey:@"companyType"];
  }
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_LIST param:param success:^(id data) {
        [CGSourceCircleEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"imgList"  : @"SourceCircImgList",
                     @"praise"   : @"SourceCircPraise",
                     @"comments" : @"SourceCircComments",
                     @"reply"    : @"SourceCircReply",
                     @"payList" : @"SourcePay"
                     };
        }];
        NSMutableArray *array = data;
        CGSourceCircleEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGSourceCircleEntity mj_objectWithKeyValues:dict];
          if (comment.imgList && ![comment.imgList isKindOfClass:[NSNull class]] && comment.imgList.count > 0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"imgList"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            comment.imageListJsonStr = json;
          }
          if (comment.praise && ![comment.praise isKindOfClass:[NSNull class]] && comment.praise.count > 0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"praise"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            comment.praiseJsonStr = json;
          }
          if (comment.comments && ![comment.comments isKindOfClass:[NSNull class]] && comment.comments.count > 0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"comments"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            comment.commentJsonStr = json;
          }
          if (comment.payList && ![comment.payList isKindOfClass:[NSNull class]] && comment.payList.count > 0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"payList"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            comment.payJsonStr = json;
          }
            [result addObject:comment];
        }
      if (mode == 0) {
       [TeamCircleDao saveTeamCircleToDB:result organizationID:companyId]; 
      }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//爆料圈部分可见列表
- (void)discoverSscoopMemberWithCompanyID:(NSString *)companyId companyType:(NSInteger)companyType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:companyId,@"companyId",[NSNumber numberWithInteger:companyType],@"companyType", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_MEMBER param:param success:^(id data) {
        NSMutableArray *array = data;
        CGPartSeeAddressEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGPartSeeAddressEntity mj_objectWithKeyValues:dict];
            if (comment.userName.length<=0) {
                comment.userName = @"     ";
                comment.userId = @"100";
            }
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

////爆料圈搜索公司接口
//- (void)discoverSearchCompanyWithKeyword:(NSString *)keyword  page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
//  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:page],@"page", nil];
//  [self.component sendPostRequestWithURL:URL_DISCOVER_SEARCH_COMPANY param:param success:^(id data) {
//    NSMutableArray *array = data;
//    CGOtherCompanyEntity *comment;
//    NSMutableArray *result = [NSMutableArray array];
//    for(NSDictionary *dict in array){
//      comment = [CGOtherCompanyEntity mj_objectWithKeyValues:dict];
//      [result addObject:comment];
//    }
//    success(result);
//  } fail:^(NSError *error) {
//    fail(error);
//  }];
//}

//爆料圈发表接口
- (void)discoverScoopAddWithCompanyId:(NSString *)companyId companyType:(NSInteger)companyType content:(NSString *)content type:(NSInteger )type level:(NSInteger )level visibility:(NSInteger )visibility linkIcon:(NSString *)linkIcon linkId:(NSString *)linkId linkTitle:(NSString *)linkTitle linkType:(NSInteger )linkType imgList:(NSMutableArray *)imgList mediaId:(NSString *)mediaId visible:(NSMutableArray *)visible remind:(NSMutableArray *)remind success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:content forKey:@"content"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [param setObject:[NSNumber numberWithInteger:level] forKey:@"level"];
    
    if ([CTStringUtil stringNotBlank:linkIcon]) {
        [param setObject:linkIcon forKey:@"linkIcon"];
    }
    if ([CTStringUtil stringNotBlank:linkId]) {
        [param setObject:linkId forKey:@"linkId"];
        [param setObject:[NSNumber numberWithInteger:linkType] forKey:@"linkType"];
    }
    if ([CTStringUtil stringNotBlank:linkTitle]) {
        [param setObject:linkTitle forKey:@"linkTitle"];
    }
    if ([CTStringUtil stringNotBlank:companyId]) {
      [param setObject:companyId forKey:@"companyId"];
      [param setObject:[NSNumber numberWithInteger:companyType] forKey:@"companyType"];
    }
    if ([CTStringUtil stringNotBlank:mediaId]) {
      [param setObject:mediaId forKey:@"mediaId"];
    }  
    if (imgList.count>0) {
        [param setObject:imgList forKey:@"imgList"];
    }
    if (visible.count>0) {
        [param setObject:visible forKey:@"visible"];
        [param setObject:@(2) forKey:@"visibility"];
    }else{
        [param setObject:@(1) forKey:@"visibility"];
    }
    if (remind.count>0) {
        [param setObject:remind forKey:@"remind"];
    }
    
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_ADD param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//爆料圈点赞接口
- (void)authDiscoverScoopPraiseID:(NSString *)praiseID type:(NSInteger )type success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:praiseID,@"id",[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_PRAISE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//爆料圈首页数据
- (void)discoverScoopIndexSuccess:(void(^)(CGScoopIndexEntity *entity))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_INDEX param:nil success:^(id data) {
        NSDictionary *dict = data;
        CGScoopIndexEntity *entity = [CGScoopIndexEntity mj_objectWithKeyValues:dict];
        success(entity);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//爆料圈评论接口
- (void)discoverScoopCommentWithScoopID:(NSString *)scoopID content:(NSString *)content toUid:(NSString *)toUid success:(void(^)(NSString *commetID))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:scoopID,@"id",content,@"content",nil];
    if (toUid.length>0) {
        [param  setObject:toUid forKey:@"toUid"];
    }
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_COMMENT param:param success:^(id data) {
        NSDictionary *dict = data;
        success([dict objectForKey:@"id"]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//爆料圈删除接口
- (void)discoverScoopDeleteWithScoopID:(NSString *)scoopID success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:scoopID,@"id",nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_DELETE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//企业圈报料详情接口
-(void)authDiscoverScoopDetailsDataWithScoopId:(NSString *)scoopId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:scoopId,@"scoopId", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_DETAIL_DATA param:param success:^(id data) {
    [CGSourceCircleEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"imgList"  : @"SourceCircImgList",
               @"praise"   : @"SourceCircPraise",
               @"comments" : @"SourceCircComments",
               @"reply"    : @"SourceCircReply",
               @"payList" : @"SourcePay"
               };
    }];
    NSDictionary *dict = data;
      CGSourceCircleEntity *comment = [CGSourceCircleEntity mj_objectWithKeyValues:dict];
      if (comment.imgList && ![comment.imgList isKindOfClass:[NSNull class]] && comment.imgList.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"imgList"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        comment.imageListJsonStr = json;
      }
      if (comment.praise && ![comment.praise isKindOfClass:[NSNull class]] && comment.praise.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"praise"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        comment.praiseJsonStr = json;
      }
      if (comment.comments && ![comment.comments isKindOfClass:[NSNull class]] && comment.comments.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"comments"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        comment.commentJsonStr = json;
      }
      if (comment.payList && ![comment.payList isKindOfClass:[NSNull class]] && comment.payList.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"payList"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        comment.payJsonStr = json;
      }
    NSMutableArray *result = [NSMutableArray arrayWithObjects:comment, nil];
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

- (void)discoverDataAction:(NSInteger)action navType:(NSString *)navType time:(NSString *)time success:(void(^)(CGDiscoverDataEntity *entity))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:action],@"action", nil];
  if ([CTStringUtil stringNotBlank:navType]) {
    [param setObject:navType forKey:@"navType"];
  }
  
  if ([CTStringUtil stringNotBlank:time]) {
    [param setObject:time forKey:@"time"];
  }
    [self.component sendPostRequestWithURL:URL_DISCOVER_DATA param:param success:^(id data) {
        [CGDiscoverDataEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"scoop" : @"ScoopData",
                     @"banner" : @"BannerData"
                     };
        }];
        CGDiscoverDataEntity *entity = [CGDiscoverDataEntity mj_objectWithKeyValues:data];
        NSMutableData *dbdata = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:dbdata];
      if (action == 2) {
       [archiver encodeObject:entity forKey:DISCOVER_TOP_DATA];
        [archiver finishEncoding];
        [dbdata writeToFile:[NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],DISCOVER_TOP_DATA] atomically:YES];
      }else if (action == 3){
        [archiver encodeObject:entity forKey:TOOL_TOP_DATA];
        [archiver finishEncoding];
        [dbdata writeToFile:[NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],TOOL_TOP_DATA] atomically:YES];
      }
        
        success(entity);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//首页菜单数据接口
- (void)loadHomePageAppsSuccess:(void(^)(NSMutableArray *result,BOOL hasChanged))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"type", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_APPS param:param success:^(id data) {
        [CGDiscoverAppsEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"gropuApps" : @"CGGropuAppsEntity",
                     };
        }];
        NSMutableArray *array = data;
        if(array && array.count > 0){
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                CGDiscoverAppsEntity *big = [CGDiscoverAppsEntity mj_objectWithKeyValues:dict];
//                if(big && big.gropuApps && big.gropuApps.count > 0){
//                    NSArray *small = big.gropuApps;
//                    [result addObjectsFromArray:small];
//                }
              [result addObject:big];
            }
            BOOL hasChanged = NO;
//            if(result.count > 0){
//                [result sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                    CGGropuAppsEntity *item1 = obj1;
//                    CGGropuAppsEntity *item2 = obj2;
//                    return item1.indexSort > item2.indexSort;//升序
//                }];
//                
                NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//                NSString *filePath = [path stringByAppendingPathComponent:HomePageMenuData];
//                NSArray *oldMenuList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//                if(result.count != oldMenuList.count){//数量发生变化
//                    hasChanged = YES;
//                }else{
//                    for(int i=0;i<result.count;i++){
//                        CGGropuAppsEntity *last = result[i];
//                        CGGropuAppsEntity *old = oldMenuList[i];
//                        if(![last.code isEqualToString:old.code] || ![last.name isEqualToString:old.name] || last.indexSort != old.indexSort || ![last.icon isEqualToString:old.icon]){
//                            hasChanged = YES;
//                            break;
//                        }
//                    }
//                }
//                //数据已改变，更新到本地
//                if(hasChanged){
                    NSString *filePath = [path stringByAppendingPathComponent:DISCOVER_DATA];
                    [NSKeyedArchiver archiveRootObject:result toFile:filePath];
//                }
//            }
            success(result,hasChanged);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//竞品主题添加条件
- (void)discoverSubjectAddID:(NSString *)themeID type:(int)type subjectId:(NSString *)subjectId success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:themeID,@"id",[NSNumber numberWithInt:type],@"type",subjectId,@"subjectId", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_SUBJECT_ADD param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//全民推荐添加关联数据
- (void)discoverRecommendAddID:(NSString *)ID type:(int)type subjectId:(NSString *)subjectId success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInt:type],@"type",subjectId,@"subjectId", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_RECOMMEND_ADD param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//企业圈打赏功能
- (void)discoverScoopRewardWithToUserId:(NSString *)toUserId scoopId:(NSString *)scoopId body:(NSString *)body total_fee:(NSInteger)total_fee spbill_create_ip:(NSString *)spbill_create_ip trade_type:(NSString *)trade_type toType:(NSInteger)toType payType:(NSInteger)payType payMethod:(NSString *)payMethod success:(void(^)(CGRewardEntity * entity))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:toUserId,@"toUserId",scoopId,@"scoopId",body,@"body",[NSNumber numberWithInteger:total_fee],@"total_fee",spbill_create_ip,@"spbill_create_ip",trade_type,@"trade_type",[NSNumber numberWithInteger:toType],@"toType",[NSNumber numberWithInteger:payType],@"payType",payMethod,@"payMethod", nil];
    [self.component sendPostRequestWithURL:URL_DISCOVER_SCOOP_REWARD param:param success:^(id data) {
        NSDictionary *dict = data;
        CGRewardEntity *comment = [CGRewardEntity mj_objectWithKeyValues:dict];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//行业文库列表数据接口
-(void)discoverCompeteKengPoListWithTime:(NSInteger )time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page action:(NSInteger)action tagId:(NSString *)tagId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:mode],@"mode",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:action],@"action", nil];
  if ([CTStringUtil stringNotBlank:tagId]) {
    [param setObject:tagId forKey:@"tagId"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_KENGPO_LIST param:param success:^(id data) {
    [CGInfoHeadEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"relevantInfoList" : @"CGRelevantInformationEntity",
               };
    }];
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    long startTime = mode == 0 ? [[NSDate date] timeIntervalSince1970]*1000 : time;
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
      if(mode == 0){
        startTime -= 1;
      }else if (mode == 1){
        startTime += 1;
      }
      info.localtime = startTime;
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
      info.read = 0;
      
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//知识专辑列表接口
-(void)discoverPackageListWithType:(NSInteger)type page:(NSInteger)page tagid:(NSString *)tagid success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page", nil];
  if ([CTStringUtil stringNotBlank:tagid]) {
    [param setObject:tagid forKey:@"tagid"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_PACKAGE_LIST param:param success:^(id data) {
    [CGInfoHeadEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"relevantInfoList" : @"CGRelevantInformationEntity",
               };
    }];
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
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
      info.read = 0;
      
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//全民推荐列表数据
-(void)discoverRecommendListWithTime:(NSInteger)time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:mode],@"mode",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:action],@"action", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_RECOMMEND_LIST param:param success:^(id data) {
    [CGInfoHeadEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"relevantInfoList" : @"CGRelevantInformationEntity",
               };
    }];
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    long startTime = mode == 0 ? [[NSDate date] timeIntervalSince1970]*1000 : time;
    CGInfoHeadEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
      if(mode == 0){
        startTime -= 1;
      }else if (mode == 1){
        startTime += 1;
      }
      info.localtime = startTime;
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
      info.read = 0;
      
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//获取VIP等级列表
-(void)userVipListWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_VIP_LIST param:param success:^(id data) {
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGVipListEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGVipListEntity mj_objectWithKeyValues:dict];      
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//界面首页数据列表
-(void)discoverInterfaceListWithPage:(NSInteger)page tagId:(NSString *)tagId ID:(NSString *)ID verId:(NSString *)verId catalogId:(NSString *)catalogId action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:action],@"action", nil];
  if ([CTStringUtil stringNotBlank:tagId]) {
    [param setObject:tagId forKey:@"tagId"];
  }
  if ([CTStringUtil stringNotBlank:ID]) {
    [param setObject:ID forKey:@"id"];
  }
  if ([CTStringUtil stringNotBlank:verId]) {
    [param setObject:verId forKey:@"verId"];
  }
  if ([CTStringUtil stringNotBlank:catalogId]) {
    [param setObject:catalogId forKey:@"catalogId"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_INTERFACE_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    CGProductInterfaceEntity *comment;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *dict in array){
      comment = [CGProductInterfaceEntity mj_objectWithKeyValues:dict];
      if (comment.width<=0) {
        comment.width = SCREEN_WIDTH/2;
      }
      if (comment.height<=0) {
        comment.height = 300;
      }
      comment.cover = [comment.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [result addObject:comment];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//界面标签目录接口
-(void)discoverInterfaceCatalogTreeWithID:(NSString *)ID action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:action],@"action", nil];
  if ([CTStringUtil stringNotBlank:ID]) {
    [param setObject:ID forKey:@"id"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_INTERFACE_CATALOG_TREE param:param success:^(id data) {
    NSMutableArray *array = data;
    InterfaceCatalogEntity *comment;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *dict in array){
      comment = [InterfaceCatalogEntity mj_objectWithKeyValues:dict];
      [result addObject:comment];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库列表接口
-(void)discoverExpListTime:(NSInteger)time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page tags:(NSMutableArray *)tags action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:mode],@"mode",[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:action],@"action", nil];
  if (tags.count>0) {
    [param setObject:tags forKey:@"tags"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    CGExpListEntity *comment;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *dict in array){
      comment = [CGExpListEntity mj_objectWithKeyValues:dict];
      [result addObject:comment];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//产品版本记录列表
-(void)productDetailsVersionListWithID:(NSString *)ID platform:(NSString *)platform success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",platform,@"platform", nil];
  [self.component sendPostRequestWithURL:URL_product_details_version_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    CGProductDetailsVersionEntity *comment;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *dict in array){
      comment = [CGProductDetailsVersionEntity mj_objectWithKeyValues:dict];
      if (comment.isGallery) {
        [result addObject:comment];
      }
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//产品平台记录列表
-(void)productDetailsPlatformListWithID:(NSString *)ID success:(void(^)(NSMutableArray *result,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
  [self.component sendPostRequestWithURL:URL_PRODUCT_DETAILS_PLATFORM_version_LIST param:param success:^(id data) {
    CGPermissionsEntity *permission;
    NSMutableArray *result = [NSMutableArray array];
    if ([data isKindOfClass:[NSDictionary class]]) {
      permission = [CGPermissionsEntity mj_objectWithKeyValues:data];
    }else{
      NSMutableArray *array = data;
      CGDetailsPlatformEnitity *comment;
      for(NSDictionary *dict in array){
        comment = [CGDetailsPlatformEnitity mj_objectWithKeyValues:dict];
        [result addObject:comment];
      }
    }
    success(result,permission);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//查询企业圈是否有更新动态接口
-(void)queryDiscoverRemind:(void(^)(TeamCircleLastStateEntity *result))success hasSystemMsg:(void(^)(void))hasSystemMsg fail:(void (^)(NSError *error))fail{
    if([ObjectShareTool sharedInstance].currentUser.uuid){
        [self.component sendPostRequestWithURL:URL_DISCOVER_REMIND param:nil success:^(id data) {
            TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity mj_objectWithKeyValues:data];
            if(entity.systemMsgCount > 0){
                hasSystemMsg();
            }
            TeamCircleLastStateEntity *local = [TeamCircleLastStateEntity getFromLocal];
            
            if((entity.badge.recordId && ![entity.badge.recordId isEqualToString:local.badge.recordId])){//最新动态有更新
                [TeamCircleLastStateEntity saveToLocal:entity];
                success(entity);
                return;
            }else{
                //点击动态后不能更新消息红点数
                BOOL hasChange = NO;
                for(TeamCircleCompanyState *item in entity.list){
                    for(TeamCircleCompanyState *lo in local.list){
                        if(item.count != lo.count){
                            hasChange = YES;
                            local.count = entity.count;
                            local.list = entity.list;
                            [TeamCircleLastStateEntity saveToLocal:local];
                            success(local);
                            return;
                        }
                    }
                }
                if(local.count != entity.count){
                    local.count = entity.count;
                    [TeamCircleLastStateEntity saveToLocal:local];
                    success(local);
                }
            }
        } fail:^(NSError *error) {
            fail(error);
        }];
    }
}

//企业圈互动消息列表
-(void)queryDiscoverRemindListWithCompanyId:(NSString *)companyId companyType:(int)companyType mode:(int)mode time:(long)time success:(void(^)(NSMutableArray *list))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:companyId forKey:@"companyId"];
    [param setObject:@(companyType) forKey:@"companyType"];
    [param setObject:@(mode) forKey:@"mode"];
    [param setObject:@(time) forKey:@"time"];
    [self.component sendPostRequestWithURL:URL_DISCOVER_REMIND_LIST param:param success:^(id data) {
        NSMutableArray *list = [TeamCircleMessageModel mj_objectArrayWithKeyValuesArray:data];
        success(list);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

@end
