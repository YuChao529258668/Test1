//
//  LightExpBiz.h
//  CGSays
//
//  Created by mochenyang on 2016/11/2.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import "CGLightExpEntity.h"

@interface LightExpBiz : CGBaseBiz

//查询banner
-(void)queryBanner:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询快体验首页数据
-(void)queryExpMainPageData:(void(^)(NSDictionary *result))success fail:(void (^)(NSError *error))fail;

//体验库我的体验
-(void)discoverExpMyExperience:(void(^)(NSMutableArray *result, NSMutableArray *groupArray))success fail:(void (^)(NSError *error))fail;

//我的体验创建组
-(void)discoverExpAddGroupWithName:(NSString *)name success:(void(^)(CGLightExpEntity *entity))success fail:(void (^)(NSError *error))fail;

//体验库关注产品
-(void)discoverExpAddProductWithProductID:(NSString *)productID success:(void(^)(CGApps *entity))success fail:(void (^)(NSError *error))fail;

//体验库我的体验删除
-(void)discoverExpMyDeleteWithID:(NSMutableArray *)ids success:(void(^)())success fail:(void (^)(NSError *error))fail;

//体验库最近体验
-(void)discoverExpMyLatelyWithSeccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//体验库体验排序
-(void)discoverExpMySortWithApps:(NSMutableArray *)apps success:(void(^)())success fail:(void (^)(NSError *error))fail;

//体验库产品加入组
-(void)discoverExpMyGroupAddWithids:(NSArray *)ids gid:(NSString *)gid op:(BOOL)op success:(void(^)())success fail:(void (^)(NSError *error))fail;

//体验库产品重命名组
-(void)discoverExpMyGroupRenameWithGid:(NSString *)gid name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail;

//
@end
