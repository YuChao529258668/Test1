//
//  DBConstants.m
//  CSALeaningSys
//
//  Created by Calon Mo on 15-5-7.
//
//

#import "DBConstants.h"
#import "FMDB.h"

/*
 数据库常量类
      作用：在此类声明表名和表结构
 表升级说明：后续需要升级表结构需创建新表，在原表名基础增加V2,V3...例如TableNameV2,TableNameV3等，再把旧表数据插入新表，删除旧表，完成表升级
 */

@implementation DBConstants

///表名
- (NSString *)tableName{
    return nil;
}
//当前表的版本号；初始版本号为1
- (int)tableVersion{
    return 1;
}
//建表sql语句
- (BOOL)createTableSQLV1{
    return NO;
}

@end




#pragma mark - TableVersion

@implementation TableVersion
- (NSString *)tableName{
    return tableVersion_tableName;
}
- (int)tableVersion{
    return 1;
}
- (BOOL)createTableSQLV1:(FMDatabase *)database{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key, %@ int,%@ int)",[self tableName], tableVersion_name, tableVersion_table_version,tableVersion_data_version];
    return [database executeStatements:sql];
}
@end




#pragma mark - HeadlineBigTypeTable

@implementation HeadlineBigTypeTable
- (NSString *)tableName{
    return HeadlineBigType_tableName;
}
- (int)tableVersion{
    return 1;
}
- (BOOL)createTableSQLV1:(FMDatabase *)database{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER, %@  TEXT,%@ TEXT)",[self tableName], HeadlineBigType_sort, HeadlineBigType_typeId,HeadlineBigType_typeName];
    return [database executeStatements:sql];
}
@end



#pragma mark - HeadlineInfoTable

@implementation HeadlineInfoTable
- (NSString *)tableName{
    return HeadlineInfo_tableName;
}
- (int)tableVersion{
    return 1;
}
- (BOOL)createTableSQLV1:(FMDatabase *)database{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT primary key, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName], HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor];
    return [database executeStatements:sql];
}

@end



#pragma mark - HeadlineInfoDetailTable

@implementation HeadlineInfoDetailTable
- (NSString *)tableName{
    return HeadlineInfoDetail_tableName;
}
- (int)tableVersion{
    return 3;
}
- (BOOL)createTableSQLV1:(FMDatabase *)database{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT)",[self tableName], HeadlineInfoDetail_id,HeadlineInfoDetail_title,HeadlineInfoDetail_html,HeadlineInfoDetail_url,HeadlineInfoDetail_infoPic,HeadlineInfoDetail_type,HeadlineInfoDetail_baiduCode,HeadlineInfoDetail_qiniuUrl,HeadlineInfoDetail_format,HeadlineInfoDetail_fileUrl,HeadlineInfoDetail_isFollow,HeadlineInfoDetail_pageCout,HeadlineInfoDetail_commentCount,HeadlineInfoDetail_authorIcon,HeadlineInfoDetail_authorName,HeadlineInfoDetail_navType,HeadlineInfoDetail_subType,HeadlineInfoDetail_viewPrompt,HeadlineInfoDetail_viewPermit,HeadlineInfoDetail_infoOriginal,HeadlineInfoDetail_source,HeadlineInfoDetail_notice,HeadlineInfoDetail_integral,HeadlineInfoDetail_state,HeadlineInfoDetail_shareUrl];
    return [database executeStatements:sql];
}
- (BOOL)createTableSQLV2:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",[self tableName],HeadlineInfoDetail_pageCount];
  return [database executeStatements:sql];
}

- (BOOL)createTableSQLV3:(FMDatabase *)database{
  NSString *sql1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",[self tableName],HeadlineInfoDetail_width];
  NSString *sql2 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",[self tableName],HeadlineInfoDetail_height];
  return [database executeStatements:sql1]&&[database executeStatements:sql2];
}

@end

/******************* 体验列表 AttentionDetailSortListTable ****************************/

#pragma mark - LightExpListTable

@implementation LightExpListTable

- (NSString *)tableName{
  return lightExpList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT)",[self tableName], lightExpList_mid,lightExpList_userID,lightExpList_pid,lightExpList_pName,lightExpList_desc,lightExpList_size,lightExpList_icon,lightExpList_isExp,lightExpList_update,lightExpList_type,lightExpList_apps];
  return [database executeStatements:sql];
}

@end

/******************* 雷达监控列表 ****************************/
#pragma mark - AttentionMonitoringTable

@implementation AttentionMonitoringTable

- (NSString *)tableName{
  return attentionMonitoringList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER)",[self tableName], monitoringList_infoId,monitoringList_userID,monitoringList_address,monitoringList_countNum,monitoringList_createtime,monitoringList_attentionTime,monitoringList_desc,monitoringList_icon,monitoringList_label,monitoringList_layout,monitoringList_newNum,monitoringList_prompt,monitoringList_source,monitoringList_subscribeNum,monitoringList_title,monitoringList_type,monitoringList_updatetime,monitoringList_createType,monitoringList_isTop,monitoringList_dataLatestTime];
  return [database executeStatements:sql];
}

@end

/******************* 雷达动态列表 ****************************/
#pragma mark - DynamicListTable

@implementation DynamicListTable

- (NSString *)tableName{
  return attentionDynamicList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT primary key, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName], HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,dynamicList_dynamicID];
  return [database executeStatements:sql];
}
@end

/******************* 企业圈列表 ****************************/
#pragma mark - TeamCircleListTable

@implementation TeamCircleListTable

- (NSString *)tableName{
  return TeamCircleList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT primary key, %@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName],teamCircleList_organizationID,teamCircleList_scoopID,teamCircleList_portrait,teamCircleList_nickname,teamCircleList_content,teamCircleList_scoopType,teamCircleList_level,teamCircleList_visibility,teamCircleList_linkIcon,teamCircleList_linkId,teamCircleList_linkTitle,teamCircleList_linkType,teamCircleList_time,teamCircleList_userId,teamCircleList_isPraise,teamCircleList_isPay,teamCircleList_isSearch,teamCircleList_imageListJsonStr,teamCircleList_praiseJsonStr,teamCircleList_commentJsonStr,teamCircleList_payJsonStr];
  return [database executeStatements:sql];
}

@end


/******************* 搜索列表 ****************************/
@implementation SearchListTable

- (NSString *)tableName{
  return SearchList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER,%@ TEXT primary key,%@ INTEGER)",[self tableName],SearchList_type,SearchList_KeyWord,SearchList_time];
  return [database executeStatements:sql];
}

@end

/******************* 热门搜索列表 ****************************/
@implementation HotSearchListTable

- (NSString *)tableName{
  return HotSearchList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER,%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER)",[self tableName],HotSearchList_type,HotSearchList_tagId,HotSearchList_tagName,HotSearchList_command,HotSearchList_commpanyId,HotSearchList_recordId,HotSearchList_recordType];
  return [database executeStatements:sql];
}
@end


/******************* 雷达分组列表 ****************************/
@implementation RadarGroupListTable

- (NSString *)tableName{
  return RadarGroupList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER)",[self tableName],RadarGroupList_ID,RadarGroupList_groupID,RadarGroupList_userID,RadarGroupList_title,RadarGroupList_countNum,RadarGroupList_newNum,RadarGroupList_conditionNum,RadarGroupList_isCanDel];
  return [database executeStatements:sql];
}
@end

/******************* 知识库第一分类 ****************************/
@implementation KnowledgeBaseFristTable

- (NSString *)tableName{
  return KnowledgeBaseFrist_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName],KnowledgeBaseFrist_ID,KnowledgeBaseFrist_icon,KnowledgeBaseFrist_fonticon,KnowledgeBaseFrist_name,KnowledgeBaseFrist_color];
  return [database executeStatements:sql];
}
@end

/******************* 知识库第二分类 ****************************/
@implementation KnowledgeBaseSecondTable

- (NSString *)tableName{
  return KnowledgeBaseSecond_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT primary key,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER)",[self tableName],KnowledgeBaseSecond_ID,KnowledgeBaseSecond_navTypeId,KnowledgeBaseSecond_name,KnowledgeBaseSecond_navs,KnowledgeBaseSecond_time];
  return [database executeStatements:sql];
}


@end

/******************* 行业文库列表 ****************************/

@implementation IndustryLibraryTable

- (NSString *)tableName{
  return IndustryLibrary_tableName;
}
- (int)tableVersion{
  return 3;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName], HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,IndustryLibrary_type,IndustryLibrary_action,IndustryLibrary_time,IndustryLibrary_downloadUrl,IndustryLibrary_fileName,IndustryLibrary_fileSize];
  return [database executeStatements:sql];
}

- (BOOL)createTableSQLV2:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_command];
  NSString *sql1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_commpanyId];
  NSString *sql2 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_recordId];
  NSString *sql3 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_messageId];
  NSString *sql4 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_parameterId];
  return [database executeStatements:sql]&&[database executeStatements:sql1]&&[database executeStatements:sql2]&&[database executeStatements:sql3]&&[database executeStatements:sql4];
}

- (BOOL)createTableSQLV3:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],IndustryLibrary_downloadUrl];
  NSString *sql1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],IndustryLibrary_fileName];
  NSString *sql2 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",[self tableName],IndustryLibrary_fileSize];
  return [database executeStatements:sql]&&[database executeStatements:sql1]&&[database executeStatements:sql2];
}


@end

/******************* 全民推荐列表 ****************************/
@implementation RecommendListTable

- (NSString *)tableName{
  return RecommendList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER)",[self tableName], HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,RecommendList_type,RecommendList_action];
  return [database executeStatements:sql];
}
@end

/******************* 帮助二级列表 ****************************/

@implementation HelpCateListTable

- (NSString *)tableName{
  return HelpCateList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT primary key, %@ TEXT,%@ INTEGER)",[self tableName],HelpCateList_cateId,HelpCateList_pageId,HelpCateList_title,HelpCateList_createTime ];
  return [database executeStatements:sql];
}
@end

/******************* 界面列表 ****************************/
#define InterfaceList_original      @"original"
#define InterfaceList_notice          @"notice"
@implementation InterfaceListTable

- (NSString *)tableName{
  return InterfaceList_tableName;
}
- (int)tableVersion{
  return 2;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT, %@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER)",[self tableName],InterfaceList_id,InterfaceList_productId,InterfaceList_productName,InterfaceList_name,InterfaceList_isFollow,InterfaceList_cover,InterfaceList_media,InterfaceList_createtime,InterfaceList_action,InterfaceList_width,InterfaceList_height,InterfaceList_time];
  return [database executeStatements:sql];
}

- (BOOL)createTableSQLV2:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",[self tableName],InterfaceList_original];
  NSString *sql1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],InterfaceList_notice];
  return [database executeStatements:sql]&&[database executeStatements:sql1];
}
@end

/******************* 界面产品列表 ****************************/

@implementation InterfaceProductListTable

- (NSString *)tableName{
  return InterfaceProductList_tableName;
}
- (int)tableVersion{
  return 1;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER)",[self tableName],InterfaceProductList_id,InterfaceProductList_title,InterfaceProductList_icon,InterfaceProductList_desc,InterfaceProductList_source,InterfaceProductList_address,InterfaceProductList_subscribe,InterfaceProductList_createtime,InterfaceProductList_type,InterfaceProductList_isExpJoin,InterfaceProductList_action,InterfaceProductList_time];
  return [database executeStatements:sql];
}
@end

/******************* 岗位知识列表 ****************************/

@implementation JobKnowledgeListTable

- (NSString *)tableName{
  return JobKnowledgeList_tableName;
}
- (int)tableVersion{
  return 2;
}

- (BOOL)createTableSQLV1:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ TEXT,%@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT)",[self tableName], HeadlineInfo_bigtype,HeadlineInfo_id,HeadlineInfo_title,HeadlineInfo_tag,HeadlineInfo_icon,HeadlineInfo_desc,HeadlineInfo_type,HeadlineInfo_layout,HeadlineInfo_label,HeadlineInfo_source,HeadlineInfo_address,HeadlineInfo_discuss,HeadlineInfo_subscribe,HeadlineInfo_prompt,HeadlineInfo_localtime,HeadlineInfo_createtime,HeadlineInfo_isSubscribe,HeadlineInfo_isFollow,HeadlineInfo_imglist,HeadlineInfo_read,HeadlineInfo_relevant,HeadlineInfo_navType,HeadlineInfo_navColor,JobKnowledgeList_navTypeId,JobKnowledgeList_type,JobKnowledgeList_time,JobKnowledgeList_packageId];
  return [database executeStatements:sql];
}

- (BOOL)createTableSQLV2:(FMDatabase *)database{
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_command];
  NSString *sql1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_commpanyId];
  NSString *sql2 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_recordId];
  NSString *sql3 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_messageId];
  NSString *sql4 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",[self tableName],HeadlineInfo_parameterId];
  return [database executeStatements:sql]&&[database executeStatements:sql1]&&[database executeStatements:sql2]&&[database executeStatements:sql3]&&[database executeStatements:sql4];
}
@end
