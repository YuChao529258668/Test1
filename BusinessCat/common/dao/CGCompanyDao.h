//
//  CGCompanyDao.h
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGUserOrganizaJoinEntity.h"
#import "AttentionCompanyEntity.h"
#import "CGSettingEntity.h"
#import "CGInviteFriendEntity.h"

@interface CGCompanyDao : NSObject

/** 保存监控组列表到本地 */
+(BOOL)saveMonitoringGroupListInLocal:(AttentionCompanyEntity *)list;

/** 从本地读取监控组列表 */
+(AttentionCompanyEntity *)getMonitoringGroupListFromLocal;

/** 清除监控组列表 */
+(BOOL)cleanMonitoringGroupList;


/**保存公司统计列表到本地 **/
+(BOOL)saveCompanyStatistics:(NSMutableArray *)list;
/** 从本地读取公司统计列表 */
+(NSMutableArray *)getCompanyStatisticsFromLocal;

/**保存产品统计列表到本地 **/
+(BOOL)saveProductStatistics:(NSMutableArray *)list;
/** 从本地读取产品统计列表 */
+(NSMutableArray *)getProductStatisticsFromLocal;

/**保存人物统计列表到本地 **/
+(BOOL)saveFigureStatistics:(NSMutableArray *)list;
/** 从本地读取人物统计列表 */
+(NSMutableArray *)getFigureStatisticsFromLocal;

/**保存分组统计列表到本地 **/
+(BOOL)saveGroupStatistics:(NSMutableArray *)list;
/** 从本地读取分组统计列表 */
+(NSMutableArray *)getGroupStatisticsFromLocal;

/**保存公司特权到本地 **/
+(BOOL)saveCompanyPrivilegeStatistics:(NSMutableArray *)list;
/** 从本地读取公司特权 */
+(NSMutableArray *)getCompanyPrivilegeStatisticsFromLocal;

/**保存用户特权列表到本地 **/
+(BOOL)saveUserPrivilegeStatistics:(NSMutableArray *)list;
/** 从本地读取用户特权 */
+(NSMutableArray *)getUserPrivilegeStatisticsFromLocal;

/**保存产品界面列表到本地 **/
+(BOOL)saveProductInterfaceStatistics:(NSMutableArray *)list;
/** 从本地读产品界面 */
+(NSMutableArray *)getProductInterfaceStatisticsFromLocal;

/**保存岗位知识列表到本地 **/
+(BOOL)saveJobKnowledgeStatistics:(NSMutableArray *)list;
/** 从本地读岗位知识 */
+(NSMutableArray *)getJobKnowledgeStatisticsFromLocal;

/**保存帮助列表到本地 **/
+(BOOL)saveHelpListStatistics:(NSMutableArray *)list;
/** 从本地读帮助列表 */
+(NSMutableArray *)getHelpListStatisticsFromLocal;

/**保存体验库列表到本地 **/
+(BOOL)saveExpListStatistics:(NSMutableArray *)list;
/** 从本地读体验库列表 */
+(NSMutableArray *)getExpListStatisticsFromLocal;

/**保存或更新设置 **/
+(BOOL)saveSettingStatistics:(CGSettingEntity *)list;
/** 查询设置数据 */
+(CGSettingEntity *)getSettingStatisticsFromLocal;

/**保存或更新邀请好友数据 **/
+(BOOL)saveInviteFriendsStatistics:(CGInviteFriendEntity *)list;
/** 查询邀请好友数据 */
+(CGInviteFriendEntity *)getInviteFriendsStatisticsFromLocal;
@end
