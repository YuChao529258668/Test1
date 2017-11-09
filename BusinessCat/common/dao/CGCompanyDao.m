//
//  CGCompanyDao.m
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGCompanyDao.h"
#import "AttentionStatisticsEntity.h"

#define MonitoringList @"MonitoringList"
#define MonitoringListPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],MonitoringList]

#define CompanyStatistics @"CompanyStatistics"
#define CompanyStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],CompanyStatistics]

#define ProductStatistics @"ProductStatistics"
#define ProductStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],ProductStatistics]

#define FigureStatistics @"FigureStatistics"
#define FigureStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],FigureStatistics]

#define GroupStatistics @"GroupStatistics"
#define GroupStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],GroupStatistics]

#define CompanyPrivilegeStatistics @"CompanyPrivilegeStatistics"
#define CompanyPrivilegeStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],CompanyPrivilegeStatistics]

#define UserPrivilegeStatistics @"UserPrivilegeStatistics"
#define UserPrivilegeStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],UserPrivilegeStatistics]

#define ProductInterfaceStatistics @"ProductInterfaceStatistics"
#define ProductInterfaceStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],ProductInterfaceStatistics]

#define JobKnowledgeStatistics @"JobKnowledgeStatistics"
#define JobKnowledgeStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],JobKnowledgeStatistics]

#define HelpListStatistics @"HelpList"
#define HelpListStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],HelpListStatistics]

#define ExpListStatistics @"ExpList"
#define ExpListStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],ExpListStatistics]

#define SettingStatistics @"Setting"
#define SettingStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],SettingStatistics]

#define InviteFriendStatistics @"InviteFriend"
#define InviteFriendStatisticsPath [NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],InviteFriendStatistics]

@implementation CGCompanyDao

/** 保存监控组列表到本地 */
+(BOOL)saveMonitoringGroupListInLocal:(AttentionCompanyEntity *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:MonitoringList];
  [archiver finishEncoding];
  return [data writeToFile:MonitoringListPath atomically:YES];
}

/** 从本地读取监控组列表 */
+(AttentionCompanyEntity *)getMonitoringGroupListFromLocal{
  AttentionCompanyEntity *companyList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:MonitoringListPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    companyList  = [unarchiver decodeObjectForKey:MonitoringList];
  }
  return companyList;
}

/** 清除监控组列表 */
+(BOOL)cleanMonitoringGroupList{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:nil forKey:MonitoringList];
  [archiver finishEncoding];
  if([data writeToFile:MonitoringListPath atomically:YES]){
    return YES;
  }
  return NO;
}

/**保存公司统计列表到本地 **/
+(BOOL)saveCompanyStatistics:(NSMutableArray *)list{
  for (AttentionStatisticsEntity *entity in list) {
    entity.count = 0;
  }
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:CompanyStatistics];
  [archiver finishEncoding];
  return [data writeToFile:CompanyStatisticsPath atomically:YES];
}

/** 从本地读取公司统计列表 */
+(NSMutableArray *)getCompanyStatisticsFromLocal{
  NSMutableArray *companyList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:CompanyStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    companyList  = [unarchiver decodeObjectForKey:CompanyStatistics];
  }
  return companyList;
}

/**保存产品统计列表到本地 **/
+(BOOL)saveProductStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:ProductStatistics];
  [archiver finishEncoding];
  return [data writeToFile:ProductStatisticsPath atomically:YES];
}

/** 从本地读取产品统计列表 */
+(NSMutableArray *)getProductStatisticsFromLocal{
  NSMutableArray *productList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:ProductStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    productList  = [unarchiver decodeObjectForKey:ProductStatistics];
  }
  return productList;
}

/**保存人物统计列表到本地 **/
+(BOOL)saveFigureStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:FigureStatistics];
  [archiver finishEncoding];
  return [data writeToFile:FigureStatisticsPath atomically:YES];
}

/** 从本地读取人物统计列表 */
+(NSMutableArray *)getFigureStatisticsFromLocal{
  NSMutableArray *figureList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:FigureStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    figureList  = [unarchiver decodeObjectForKey:FigureStatistics];
  }
  return figureList;
}

/**保存分组统计列表到本地 **/
+(BOOL)saveGroupStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:GroupStatistics];
  [archiver finishEncoding];
  return [data writeToFile:GroupStatisticsPath atomically:YES];
}

/** 从本地读取分组统计列表 */
+(NSMutableArray *)getGroupStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:GroupStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:GroupStatistics];
  }
  return groupList;
}

/**保存公司特权到本地 **/
+(BOOL)saveCompanyPrivilegeStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:CompanyPrivilegeStatistics];
  [archiver finishEncoding];
  return [data writeToFile:CompanyPrivilegeStatisticsPath atomically:YES];
}

/** 从本地读取公司特权 */
+(NSMutableArray *)getCompanyPrivilegeStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:CompanyPrivilegeStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:CompanyPrivilegeStatistics];
  }
  return groupList;
}

/**保存用户特权列表到本地 **/
+(BOOL)saveUserPrivilegeStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:UserPrivilegeStatistics];
  [archiver finishEncoding];
  return [data writeToFile:UserPrivilegeStatisticsPath atomically:YES];
}
/** 从本地读取用户特权 */
+(NSMutableArray *)getUserPrivilegeStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:UserPrivilegeStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:UserPrivilegeStatistics];
  }
  return groupList;
}

/**保存产品界面列表到本地 **/
+(BOOL)saveProductInterfaceStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:ProductInterfaceStatistics];
  [archiver finishEncoding];
  return [data writeToFile:ProductInterfaceStatisticsPath atomically:YES];
}
/** 从本地读产品界面 */
+(NSMutableArray *)getProductInterfaceStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:ProductInterfaceStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:ProductInterfaceStatistics];
  }
  return groupList;
}

/**保存岗位知识列表到本地 **/
+(BOOL)saveJobKnowledgeStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:JobKnowledgeStatistics];
  [archiver finishEncoding];
  return [data writeToFile:JobKnowledgeStatisticsPath atomically:YES];
}
/** 从本地读岗位知识 */
+(NSMutableArray *)getJobKnowledgeStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:JobKnowledgeStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:JobKnowledgeStatistics];
  }else{
      groupList = [NSMutableArray array];
  }
  return groupList;
}

/**保存帮助列表到本地 **/
+(BOOL)saveHelpListStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:HelpListStatistics];
  [archiver finishEncoding];
  return [data writeToFile:HelpListStatisticsPath atomically:YES];
}

/** 从本地读帮助列表 */
+(NSMutableArray *)getHelpListStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:HelpListStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:HelpListStatistics];
  }
  return groupList;
}

/**保存体验库列表到本地 **/
+(BOOL)saveExpListStatistics:(NSMutableArray *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:ExpListStatistics];
  [archiver finishEncoding];
  return [data writeToFile:ExpListStatisticsPath atomically:YES];
}

/** 从本地读体验库列表 */
+(NSMutableArray *)getExpListStatisticsFromLocal{
  NSMutableArray *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:ExpListStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:ExpListStatistics];
  }
  return groupList;
}

/**保存或更新设置 **/
+(BOOL)saveSettingStatistics:(CGSettingEntity *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:SettingStatistics];
  [archiver finishEncoding];
  return [data writeToFile:SettingStatisticsPath atomically:YES];
}
/** 查询设置数据 */
+(CGSettingEntity *)getSettingStatisticsFromLocal{
  CGSettingEntity *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:SettingStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:SettingStatistics];
  }
  return groupList;
};

/**保存或更新邀请好友数据 **/
+(BOOL)saveInviteFriendsStatistics:(CGInviteFriendEntity *)list{
  NSString *userPath = [CTFileUtil getDocumentsPath];
  [CTFileUtil createFolder:userPath error:nil];
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:list forKey:InviteFriendStatistics];
  [archiver finishEncoding];
  return [data writeToFile:InviteFriendStatisticsPath atomically:YES];
}

/** 查询邀请好友数据 */
+(CGInviteFriendEntity *)getInviteFriendsStatisticsFromLocal{
  CGInviteFriendEntity *groupList;
  NSMutableData *data = [NSMutableData dataWithContentsOfFile:InviteFriendStatisticsPath];
  if(data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    groupList  = [unarchiver decodeObjectForKey:InviteFriendStatistics];
  }
  return groupList;
}
@end
