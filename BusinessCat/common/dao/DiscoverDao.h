//
//  DiscoverDao.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseDao.h"

@interface DiscoverDao : CTBaseDao
//保存或更新行业文库列表到本地数据库
+(void)saveProductInterfaceToDB:(NSMutableArray *)data type:(NSInteger)type action:(NSInteger)action;
//根据type和action查询本地行业文库列表
+(void)queryProductInterfaceFromDBWithType:(NSInteger)type action:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail;
//根据type和action删除本地行业文库列表
+(void)deleteProductInterfaceFromDBWithType:(NSInteger)type action:(NSInteger)action ID:(NSString *)ID;

//保存或更新全民推荐列表到本地数据库
+(void)saveRecommendListToDB:(NSMutableArray *)data type:(NSInteger)type action:(NSInteger)action;
//根据type和action查询本地全民推荐列表
+(void)queryRecommendListFromDBWithType:(NSInteger)type action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;


//保存或更新帮助二级列表到本地数据库
+(void)saveHelpCateListToDB:(NSMutableArray *)data cateID:(NSString *)cateID;
//根据cateID查询本地帮助二级列表
+(void)queryHelpCateListFromDBWithcateID:(NSString *)cateID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//保存或更新界面列表到本地数据库
+(void)saveInterfaceListToDB:(NSMutableArray *)data action:(NSInteger)action;
//根据action查询本地界面列表
+(void)queryInterfaceListFromDBWithAction:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail;
//根据ID修改本地界面列表 （收藏）
+(void)updateInterfaceListFromDBWithID:(NSString *)ID isFollow:(NSInteger)isFollow;

//保存或更新界面产品列表到本地数据库
+(void)saveInterfaceProductListToDB:(NSMutableArray *)data action:(NSInteger)action;
//根据action查询本地界面产品列表
+(void)queryInterfaceProductListFromDBWithAction:(NSInteger)action success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail;

//保存或更新岗位知识列表到本地数据库
+(void)saveJobKnowledgeToDB:(NSMutableArray *)data type:(NSInteger)type navTypeId:(NSString *)navTypeId;
//根据type和action删除岗位知识到本地数据库
+(void)deleteJobKnowledgeToDBWithType:(NSInteger)type navTypeId:(NSString *)navTypeId knowledgeID:(NSString *)knowledgeID;
//根据type和action查询本地岗位知识列表
+(void)queryJobKnowledgeFromDBWithType:(NSInteger)type navTypeId:(NSString *)navTypeId success:(void(^)(NSMutableArray *result,BOOL isRefresh))success fail:(void (^)(NSError *error))fail;
@end
