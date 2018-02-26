//
//  CGKnowledgeBiz.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBiz.h"

@implementation CGKnowledgeBiz

//列表
-(void)queryKnowledgeListWithNavType:(NSString *)navType time:(NSString *)time success:(void(^)(NSMutableArray<KnowledgeAlbumEntity *> *list))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:navType,@"navType",time,@"time",nil];
    [self.component sendPostRequestWithURL:URL_KNOWLEDGE_LIST param:param success:^(id data) {
        success([KnowledgeAlbumEntity mj_objectArrayWithKeyValuesArray:data]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//目录
-(void)queryKnowledgePackageWithMainId:(NSString *)mainId packageId:(NSString *)packageId companyId:(NSString *)companyId cataId:(NSString *)cataId page:(NSInteger)page type:(NSInteger)type success:(void(^)(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(page) forKey:@"page"];
    if([CTStringUtil stringNotBlank:cataId]){
        [param setObject:cataId forKey:@"cataId"];
    }
  if ([CTStringUtil stringNotBlank:mainId]) {
    [param setObject:mainId forKey:@"mainId"];
  }
  if ([CTStringUtil stringNotBlank:packageId]) {
    [param setObject:packageId forKey:@"packageId"];
  }
  if ([CTStringUtil stringNotBlank:companyId]) {
    [param setObject:companyId forKey:@"companyId"];
  }
  if (type != 0) {
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
  }
    [self.component sendPostRequestWithURL:URL_KNOWLEDGE_PACKAGE param:param success:^(id data) {
      NSDictionary *dic = data;
      if ([dic[@"showType"]integerValue]) {
        [CGKnowledgePackageEntity mj_setupObjectClassInArray:^NSDictionary *{
          return @{
                   @"list" : @"CGKnowLedgeListEntity",
                   };
        }];
      }else{
        [CGKnowledgePackageEntity mj_setupObjectClassInArray:^NSDictionary *{
          return @{
                   @"list" : @"CGInfoHeadEntity",
                   };
        }];
      }
      [CGKnowLedgeListEntity mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list" : @"CGInfoHeadEntity",
                 };
      }];
        if (dic) {
          if ([[dic allKeys] containsObject:@"viewPermit"]) {
            if ([dic[@"viewPermit"]integerValue] == 8) {
              success([CGKnowledgePackageEntity mj_objectWithKeyValues:dic],nil);
            }else{
              CGPermissionsEntity *entity = [CGPermissionsEntity mj_objectWithKeyValues:dic];
              success(nil,entity);
            }
          }else{
            success([CGKnowledgePackageEntity mj_objectWithKeyValues:dic],nil);
          }
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//知识餐套餐目录列表
-(void)headlinesKnowledgePackageIndexWithTime:(NSString *)time navType:(NSString *)navType page:(NSInteger)page type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:time,@"time",[NSNumber numberWithInteger:page],@"page", nil];
  if (type != 0) {
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
  }
  if ([CTStringUtil stringNotBlank:navType]) {
    [param setObject:navType forKey:@"navType"];
  }
  [self.component sendPostRequestWithURL:URL_HEADLINE_KNOWLEDGE_PACKAGE_INDEX param:param success:^(id data) {
    [CGKnowLedgeListEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"list" : @"CGInfoHeadEntity",
               };
    }];
    NSArray *headlineArray = data;
    NSMutableArray *result = [NSMutableArray array];
    CGKnowLedgeListEntity *info;
    for(NSDictionary *dict in headlineArray){
      info = [CGKnowLedgeListEntity mj_objectWithKeyValues:dict];
      [result addObject:info];
    }
    success(result);
  } fail:^(NSError *error){
    fail(error);
  }];
}

// 我的文档 接口
- (void)getMyDocumentWithPage:(int)page success:(void(^)(CGKnowledgePackageEntity *result ,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail {
    NSDictionary *dic = @{@"page": @(page)};
    [self.component sendPostRequestWithURL:URL_DISCOVER_My_Document param:dic success:^(id data) {
        NSDictionary *dic = data;
        if ([dic[@"showType"]integerValue]) {
            [CGKnowledgePackageEntity mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"list" : @"CGKnowLedgeListEntity",
                         };
            }];
        }else{
            [CGKnowledgePackageEntity mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"list" : @"CGInfoHeadEntity",
                         };
            }];
        }
        [CGKnowLedgeListEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list" : @"CGInfoHeadEntity",
                     };
        }];
        if (dic) {
            if ([[dic allKeys] containsObject:@"viewPermit"]) {
                if ([dic[@"viewPermit"]integerValue] == 8) {
                    success([CGKnowledgePackageEntity mj_objectWithKeyValues:dic],nil);
                }else{
                    CGPermissionsEntity *entity = [CGPermissionsEntity mj_objectWithKeyValues:dic];
                    success(nil,entity);
                }
            }else{
                success([CGKnowledgePackageEntity mj_objectWithKeyValues:dic],nil);
            }
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

@end
