//
//  AttentionBiz.h
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import "AttentionDetail.h"
#import "AttentionCompanyEntity.h"
#import "GroupJoinEntity.h"
#import "KnowledgeBaseEntity.h"

@interface AttentionBiz : CGBaseBiz

//获取关注页面一级列表
-(void)queryAttentionHeadListWithTime:(long)time mode:(int)mode url:(NSString *)url success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询关注详情
-(void)queryAttentionInfoWithId:(NSString *)dataId type:(int)type success:(void(^)(AttentionDetail *detail))success fail:(void (^)(NSError *error))fail;

//查询导航
-(void)queryNaviDataByType:(int)type toId:(NSString*)toId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询关注某记录的列表数据
-(void)queryAttentionDetailListWithType:(int)type label:(NSString *)label time:(long)time mode:(int)mode dataId:(NSString *)dataId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//关注页面关注操作
-(void)subscribeAddWithId:(NSString *)dataId type:(int)type success:(void(^)(NSInteger status))success fail:(void (^)(NSError *error))fail;

//雷达首页公司列表
-(void)radarCompanyListSuccess:(void(^)(AttentionCompanyEntity *result))success fail:(void (^)(NSError *error))fail;

//雷达分组列表接口
-(void)radarGroupListWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//雷达分组创建接口
-(void)authRadarGroupCreateWithID:(NSString *)ID type:(NSInteger)type title:(NSString *)title success:(void(^)(NSString *groupID))success fail:(void (^)(NSError *error))fail;

//雷达分组删除接口
-(void)authRadarGroupDeleteWithID:(NSString *)ID success:(void(^)())success fail:(void (^)(NSError *error))fail;

//雷达分组修改接口
-(void)authRadarGroupUpdateWithID:(NSString *)ID title:(NSString *)title success:(void(^)())success fail:(void (^)(NSError *error))fail;

//雷达分组名单列表接口
-(void)radarGroupConditionListWithID:(NSString *)ID page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//雷达分组名单编辑接口
-(void)authRadarGroupConditionAddWithID:(NSString *)ID type:(NSInteger)type subjectId:(NSString *)subjectId op:(NSInteger)op success:(void(^)())success fail:(void (^)(NSError *error))fail;

//雷达分组资讯列表详情
-(void)radarGroupDetailsListWithType:(NSInteger)type time:(NSInteger)time page:(NSInteger)page ID:(NSString *)ID navTypeId:(NSString *)navTypeId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//雷达详情统计接口
-(void)radarGroupDetailsStatisticsWithType:(NSInteger)type ID:(NSString *)ID page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//雷达订阅列表置顶接口
-(void)radarSubscribeTopWithID:(NSString *)ID type:(NSInteger)type op:(NSInteger)op success:(void(^)())success fail:(void (^)(NSError *error))fail;

//雷达分组加入列表接口
-(void)radarGroupJoinListID:(NSString *)ID type:(NSInteger)type success:(void(^)(GroupJoinEntity *result))success fail:(void (^)(NSError *error))fail;

//技能导航分类接口(全部)
-(void)headlinesSkillNavListSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//技能导航分类接口
-(void)headlinesSkillNavListWithID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//岗位知识列表接口
-(void)radarGroupDetailsListScoopWithPage:(NSInteger)page navTypeId:(NSString *)navTypeId type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//技能导航工具库
-(void)headlinesSkillNavToolListWithID:(NSString *)ID type:(NSInteger)type page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
@end
