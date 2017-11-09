//
//  LightExpBiz.m
//  CGSays
//
//  Created by mochenyang on 2016/11/2.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "LightExpBiz.h"
#import "CGLightExpEntity.h"
#import "CGLatelyEntity.h"
#import "LightExpDao.h"

@implementation LightExpBiz

//查询banner
-(void)queryBanner:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_BANNER param:nil success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询快体验首页数据
-(void)queryExpMainPageData:(void(^)(NSDictionary *result))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MAIN_PAGE param:nil success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//体验库我的体验
-(void)discoverExpMyExperience:(void(^)(NSMutableArray *result, NSMutableArray *groupArray))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MY_EXPERIENCE param:nil success:^(id data) {
    [CGLightExpEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"apps" : @"CGApps"
               };
      
    }];
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *groupArray = [NSMutableArray array];
    for(NSDictionary *dict in array){
      NSNumber *type = [dict objectForKey:@"type"];
      if (type.integerValue == 2) {
        CGLightExpEntity *comment = [CGLightExpEntity mj_objectWithKeyValues:dict];
        if(comment.apps && ![comment.appsJsonStr isKindOfClass:[NSNull class]] && comment.apps.count > 0){
          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"apps"] options:NSJSONWritingPrettyPrinted error:nil];
          NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          comment.appsJsonStr = json;
        }
        [result addObject:comment];
        [groupArray addObject:comment];
      }else{
        CGApps *comment = [CGApps mj_objectWithKeyValues:dict];
        [result addObject:comment];
      }
    }
    [LightExpDao saveLightExpDataToDB:result];
    success(result,groupArray);
  } fail:^(NSError *error) {
    fail(error);
  }];
  
}

//我的体验创建组
-(void)discoverExpAddGroupWithName:(NSString *)name success:(void(^)(CGLightExpEntity *entity))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_ADD_GROUP param:param success:^(id data) {
    [CGLightExpEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"apps" : @"CGApps"
               };
      
    }];
    NSDictionary *dict = data;
    CGLightExpEntity *entity = [[CGLightExpEntity alloc]init];
    entity.gid = dict[@"gid"];
    entity.mid = dict[@"mid"];
    entity.type = 2;
    entity.gName = name;
    entity.apps = [NSMutableArray array];
    success(entity);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库关注产品
-(void)discoverExpAddProductWithProductID:(NSString *)productID success:(void(^)(CGApps *entity))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:productID,@"id", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_ADD_PRODUCT param:param success:^(id data) {
    NSMutableArray *dict = data;
    if (dict.count>0) {
      CGApps *comment = [CGApps mj_objectWithKeyValues:dict[0]];
      success(comment);
    }
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库我的体验删除
-(void)discoverExpMyDeleteWithID:(NSMutableArray *)ids success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if (ids.count>0) {
    [param setObject:ids forKey:@"ids"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_ADD_DELETE param:param success:^(id data) {
//    [CGLightExpEntity mj_setupObjectClassInArray:^NSDictionary *{
//      return @{
//               @"apps" : @"CGApps"
//               };
//      
//    }];
//    NSMutableArray *array = data;
//    NSMutableArray *result = [NSMutableArray array];
//    NSMutableArray *groupArray = [NSMutableArray array];
//    for(NSDictionary *dict in array){
//      NSNumber *type = [dict objectForKey:@"type"];
//      if (type.integerValue == 2) {
//        CGLightExpEntity *comment = [CGLightExpEntity mj_objectWithKeyValues:dict];
//        [result addObject:comment];
//        [groupArray addObject:comment];
//      }else{
//        CGApps *comment = [CGApps mj_objectWithKeyValues:dict];
//        [result addObject:comment];
//      }
//    }
    
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可，我喜欢用data
//    NSString *filePath = [path stringByAppendingPathComponent:LIGHTEXP_DATA];
//    // 归档
//    [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库最近体验
-(void)discoverExpMyLatelyWithSeccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MY_LATELY param:nil success:^(id data) {
    NSMutableArray *array = data;
    NSMutableArray *result = [NSMutableArray array];
    CGLatelyEntity *comment;
    for(NSDictionary *dict in array){
      comment = [CGLatelyEntity mj_objectWithKeyValues:dict];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库体验排序
-(void)discoverExpMySortWithApps:(NSMutableArray *)apps success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:apps,@"apps", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MY_SORT param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库产品加入组
-(void)discoverExpMyGroupAddWithids:(NSArray *)ids gid:(NSString *)gid op:(BOOL)op success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ids,@"ids",[NSNumber numberWithBool:op],@"op", nil];
  if ([CTStringUtil stringNotBlank:gid]) {
    [param setObject:gid forKey:@"gid"];
  }
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MY_GROUP_ADD param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//体验库产品重命名组
-(void)discoverExpMyGroupRenameWithGid:(NSString *)gid name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:gid,@"gid",name,@"name", nil];
  [self.component sendPostRequestWithURL:URL_DISCOVER_EXP_MY_GROUP_RENAME param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

@end
