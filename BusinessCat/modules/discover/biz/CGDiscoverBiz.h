//
//  CUDiscoverBiz.h
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGBaseBiz.h"
#import "CGScoopIndexEntity.h"
#import "CGDiscoverDataEntity.h"
#import "CGDiscoverAppsEntity.h"
#import "CGRewardEntity.h"
#import "TeamCircleLastStateEntity.h"
#import "CGPermissionsEntity.h"

@interface CGDiscoverBiz : CGBaseBiz
//爆料圈首页列表接口
- (void)discoverScoopListWithType:(NSInteger )type time:(NSInteger )time mode:(NSInteger )mode companyId:(NSString *)companyId companyType:(NSInteger )companyType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//爆料圈部分可见列表
- (void)discoverSscoopMemberWithCompanyID:(NSString *)companyId companyType:(NSInteger)companyType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

////爆料圈搜索公司接口
//- (void)discoverSearchCompanyWithKeyword:(NSString *)keyword  page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//爆料圈发表接口
- (void)discoverScoopAddWithCompanyId:(NSString *)companyId companyType:(NSInteger)companyType content:(NSString *)content type:(NSInteger )type level:(NSInteger )level visibility:(NSInteger )visibility linkIcon:(NSString *)linkIcon linkId:(NSString *)linkId linkTitle:(NSString *)linkTitle linkType:(NSInteger )linkType imgList:(NSMutableArray *)imgList mediaId:(NSString *)mediaId visible:(NSMutableArray *)visible remind:(NSMutableArray *)remind success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//爆料圈点赞接口
- (void)authDiscoverScoopPraiseID:(NSString *)praiseID type:(NSInteger )type success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//爆料圈首页数据
- (void)discoverScoopIndexSuccess:(void(^)(CGScoopIndexEntity *entity))success fail:(void (^)(NSError *error))fail;

//爆料圈评论接口
- (void)discoverScoopCommentWithScoopID:(NSString *)scoopID content:(NSString *)content toUid:(NSString *)toUid success:(void(^)(NSString *commetID))success fail:(void (^)(NSError *error))fail;

//爆料圈删除接口
- (void)discoverScoopDeleteWithScoopID:(NSString *)scoopID success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//企业圈报料详情接口
-(void)authDiscoverScoopDetailsDataWithScoopId:(NSString *)scoopId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//发现首页基础数据
- (void)discoverDataAction:(NSInteger)action navType:(NSString *)navType time:(NSString *)time success:(void(^)(CGDiscoverDataEntity *entity))success fail:(void (^)(NSError *error))fail;

//首页菜单数据接口
- (void)loadHomePageAppsSuccess:(void(^)(NSMutableArray *result,BOOL hasChanged))success fail:(void (^)(NSError *error))fail;

//竞品主题添加条件
- (void)discoverSubjectAddID:(NSString *)themeID type:(int)type subjectId:(NSString *)subjectId success:(void(^)())success fail:(void (^)(NSError *error))fail;

//全民推荐添加关联数据
- (void)discoverRecommendAddID:(NSString *)ID type:(int)type subjectId:(NSString *)subjectId success:(void(^)())success fail:(void (^)(NSError *error))fail;

//获取VIP等级列表
-(void)userVipListWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

/*
 toType ----支付对象类型  详情看接口文档（功能类型定义）
 payType-----支付类型( 1提现 2赞赏 3会员充值 4商城支付   )
 payMethod---支付方法（WECHATPAY-微信支付  JPPAY-竞品说钱包支付）
 token-验证token
 amount-----金额（int,单位分）
 client_ip------客户端ip
 */
//企业圈打赏功能
- (void)discoverScoopRewardWithToUserId:(NSString *)toUserId scoopId:(NSString *)scoopId body:(NSString *)body total_fee:(NSInteger)total_fee spbill_create_ip:(NSString *)spbill_create_ip trade_type:(NSString *)trade_type toType:(NSInteger)toType payType:(NSInteger)payType payMethod:(NSString *)payMethod success:(void(^)(CGRewardEntity * entity))success fail:(void (^)(NSError *error))fail;

//行业文库列表数据接口
-(void)discoverCompeteKengPoListWithTime:(NSInteger )time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page action:(NSInteger)action tagId:(NSString *)tagId success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//知识专辑列表接口
-(void)discoverPackageListWithType:(NSInteger)type page:(NSInteger)page tagid:(NSString *)tagid success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//全民推荐列表数据
-(void)discoverRecommendListWithTime:(NSInteger)time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
//界面首页数据列表
-(void)discoverInterfaceListWithPage:(NSInteger)page tagId:(NSString *)tagId ID:(NSString *)ID verId:(NSString *)verId catalogId:(NSString *)catalogId action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
//界面标签目录接口
-(void)discoverInterfaceCatalogTreeWithID:(NSString *)ID action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
//体验库列表接口
-(void)discoverExpListTime:(NSInteger)time mode:(NSInteger)mode type:(NSInteger)type page:(NSInteger)page tags:(NSMutableArray *)tags action:(NSInteger)action success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//产品版本记录列表
-(void)productDetailsVersionListWithID:(NSString *)ID platform:(NSString *)platform success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
//产品平台记录列表
-(void)productDetailsPlatformListWithID:(NSString *)ID success:(void(^)(NSMutableArray *result,CGPermissionsEntity *entity))success fail:(void (^)(NSError *error))fail;

//查询企业圈是否有更新动态接口
-(void)queryDiscoverRemind:(void(^)(TeamCircleLastStateEntity *result))success hasSystemMsg:(void(^)(void))hasSystemMsg fail:(void (^)(NSError *error))fail;

//企业圈互动消息列表
-(void)queryDiscoverRemindListWithCompanyId:(NSString *)companyId companyType:(int)companyType  mode:(int)mode time:(long)time success:(void(^)(NSMutableArray *list))success fail:(void (^)(NSError *error))fail;
@end
