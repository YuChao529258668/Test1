//
//  HeadlineBiz.h
//  CGSays
//
//  Created by mochenyang on 2016/9/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-业务网络请求类

#import "CGBaseBiz.h"
#import "CGInfoDetailEntity.h"
#import "CGCommentEntity.h"
#import "CGBigdataEntity.h"
#import "CGHotSearchEntity.h"

@interface HeadlineBiz : CGBaseBiz

//查询大类
//-(void)queryRemoteBigTypeDataWithType:(NSInteger)type success:(void(^)(NSMutableArray *bigTypeData))success fail:(void (^)(NSError *error))fail;

//查询头条列表
-(void)queryRemoteHeadlineDataByLabel:(NSString *)label time:(long)time mode:(int)mode success:(void(^)(NSMutableArray *bigTypeData))success fail:(void (^)(NSError *error))fail;

//查询资讯详情
-(void)queryRemoteInfoDetailById:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGInfoDetailEntity *infoDetail))success fail:(void (^)(NSError *error))fail;

//查询详情状态
-(void)queryInfoDetailStateById:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGTopicEntity *detailState))success fail:(void (^)(NSError *error))fail;

//关闭不感兴趣的内容
-(void)closeInfoWithId:(NSString *)infoId type:(int)type closeType:(int)closeType success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//发表话题评论接口
-(void)postTopicCommentWithContent:(NSString *)content infoId:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGCommentEntity *coment))success fail:(void (^)(NSError *error))fail;

//话题讨论回复接口
-(void)postCommentToCommentWithParentComment:(CGCommentEntity *)parentComment toComment:(CGCommentEntity *)toComment content:(NSString *)content type:(NSInteger)type success:(void(^)(CGCommentEntity *comment))success fail:(void (^)(NSError *error))fail;

//更新大类排序
-(void)updateHeadlineBigtypeSortWithArray:(NSMutableArray *)array success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//收藏/取消收藏接口
-(void)collectWithId:(NSString *)infoId type:(int)type collect:(int)collect success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//用户分享获取连接接口
-(void)userShareGetUrlWithUrl:(NSString *)url success:(void(^)(NSString *url))success fail:(void (^)(NSError *error))fail;

//获取资讯话题列表
-(void)queryHeadlineTopicListWithInfoId:(NSString *)infoId mode:(int)mode type:(NSInteger)type time:(long)time success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//获取话题回复列表
-(void)queryHeadlineTopicReplyListWithCommentId:(NSString *)commentId mode:(int)mode time:(long)time success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//话题讨论点赞接口
-(void)topicCommentPraiseWithInfoId:(NSString *)infoId commentId:(NSString *)commentId type:(NSInteger)type success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//根据话题id删除话题
-(void)delTopicById:(NSString *)topicId success:(void(^)(void))success fail:(void (^)(NSError *error))fail;


//全局搜索
- (void)commonSearchWithKeyword:(NSString *)keyword pageNo:(NSInteger)pageNo type:(NSInteger)type action:(NSString *)action ID:(NSString *)ID subType:(NSString *)subType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//头条知识搜索接口
- (void)commonSearchInfoWithKeyword:(NSString *)keyword pageNo:(NSInteger)pageNo level:(NSInteger)level action:(NSInteger)action ID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//竞品主题搜索关键字
- (void)discoverSubjectSearchKeyword:(NSString *)keyword ID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//查询百度关键字
- (void)jpSearchWithKeyword:(NSString *)keyword success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//分类校正接口
- (void)headlinesCorrectingNavTypeWithID:(NSString *)consultingID navType:(NSString *)navType success:(void(^)())success fail:(void (^)(NSError *error))fail;

//资讯类详情大数据
-(void)headlinesDetailsBigdataWithID:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGBigdataEntity *result))success fail:(void (^)(NSError *error))fail;

//头条首页热搜关键字接口
- (void)headlinesHotsearchListWithPage:(NSInteger)page action:(NSInteger)action type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//资讯详情状态接口
-(void)headlinesInfoDetailStateWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(NSInteger isFollow,NSInteger commentCount))success fail:(void (^)(NSError *error))fail;

//详情积分购买报告
-(void)headlinesInfoDetailsIntegralPurchaseWithType:(NSInteger)type ID:(NSString *)ID integral:(NSInteger)integral success:(void(^)())success fail:(void (^)(NSError *error))fail;

//评论删除接口
-(void)authHeadlinesTopicCommentDeleteWithCommentId:(NSString *)commentId success:(void(^)())success fail:(void (^)(NSError *error))fail;

//知识校正管理
-(void)headlinesManagerUpdateByAdminWithInfoId:(NSString *)infoId time:(NSInteger)time title:(NSString *)title navtype:(NSString *)navtype navtype2:(NSString *)navtype2 choice:(NSInteger )choice state:(NSInteger)state success:(void(^)())success fail:(void (^)(NSError *error))fail;

//素材校正
-(void)interfaceManagerUpdateByAdminWithID:(NSString *)ID title:(NSString *)title tagId:(NSString *)tagId state:(NSInteger)state success:(void(^)())success fail:(void (^)(NSError *error))fail;

//文库校正
-(void)kengpoManagerUpdateByAdminWithID:(NSString *)ID title:(NSString *)title tagId:(NSString *)tagId choice:(NSInteger)choice state:(NSInteger)state time:(NSInteger)time success:(void(^)())success fail:(void (^)(NSError *error))fail;

//采集接口
-(void)toutiaoSpiderWithurl:(NSString *)url channel:(NSInteger)channel navtype:(NSString *)navtype navtype2:(NSString *)navtype2 selected:(NSInteger)selected success:(void(^)())success fail:(void (^)(NSError *error))fail;
@end
