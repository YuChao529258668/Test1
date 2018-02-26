//
//  CGKnowledgeBiz.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import "KnowledgeHeaderEntity.h"
#import "CGInfoHeadEntity.h"
#import "KnowledgeAlbumEntity.h"
#import "CGPermissionsEntity.h"
#import "CGKnowledgePackageEntity.h"
#import "CGKnowLedgeListEntity.h"

@interface CGKnowledgeBiz : CGBaseBiz

-(void)queryKnowledgeListWithNavType:(NSString *)navType time:(NSString *)time success:(void(^)(NSMutableArray<KnowledgeAlbumEntity *> *list))success fail:(void (^)(NSError *error))fail;

-(void)queryKnowledgePackageWithMainId:(NSString *)mainId packageId:(NSString *)packageId companyId:(NSString *)companyId cataId:(NSString *)cataId page:(NSInteger)page type:(NSInteger)type success:(void(^)(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail;

//知识餐套餐目录列表
-(void)headlinesKnowledgePackageIndexWithTime:(NSString *)time navType:(NSString *)navType page:(NSInteger)page type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

// 我的文档
- (void)getMyDocumentWithPage:(int)page success:(void(^)(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail;

@end
