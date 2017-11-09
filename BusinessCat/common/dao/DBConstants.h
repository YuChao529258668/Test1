//
//  DBConstants.h
//  CSALeaningSys
//
//  Created by Calon Mo on 15-5-7.
//  app的本地sqlite数据库表的声明都在此
//

#import <Foundation/Foundation.h>

@interface DBConstants : NSObject
///表名
- (NSString *)tableName;
//当前表的版本号；初始版本号为1
- (int)tableVersion;
//执行建表，更新表结构等
- (BOOL)createTableSQLV1;

@end


/******************************* 表结构与表数据的版本 TableVersion ****************************/
// 表名
#define tableVersion_tableName          @"table_version"
// 列名
#define tableVersion_name               @"name"
#define tableVersion_table_version      @"table_version"
#define tableVersion_data_version       @"data_version"

@interface TableVersion : DBConstants

@end



/******************* 头条大类表 HeadlineBigTypeTable ****************************/
// 表名
#define HeadlineBigType_tableName       @"headline_bigyype"
// 列名
#define HeadlineBigType_sort            @"sort"             //排序
#define HeadlineBigType_typeId          @"typeid"           //分类id
#define HeadlineBigType_typeName        @"typename"        //分类名字

@interface HeadlineBigTypeTable : DBConstants

@end




/******************* 头条表 HeadlineInfoTable ****************************/
//表名
#define HeadlineInfo_tableName      @"infoHead"
#define HeadlineInfo_bigtype        @"bigtype"
#define HeadlineInfo_id             @"infoId"
#define HeadlineInfo_title          @"title"
#define HeadlineInfo_tag            @"tag"
#define HeadlineInfo_icon           @"icon"
#define HeadlineInfo_desc           @"desc"
#define HeadlineInfo_type           @"type"
#define HeadlineInfo_layout         @"layout"
#define HeadlineInfo_label          @"label"
#define HeadlineInfo_source         @"source"
#define HeadlineInfo_address        @"address"
#define HeadlineInfo_discuss        @"discuss"
#define HeadlineInfo_subscribe      @"subscribe"
#define HeadlineInfo_prompt         @"prompt"
#define HeadlineInfo_localtime      @"localtime"
#define HeadlineInfo_createtime     @"createtime"
#define HeadlineInfo_isSubscribe    @"isSubscribe"
#define HeadlineInfo_isFollow       @"isFollow"
#define HeadlineInfo_imglist        @"imglist"
#define HeadlineInfo_read           @"read"
#define HeadlineInfo_relevant       @"relevant"
#define HeadlineInfo_navType        @"navType"
#define HeadlineInfo_navColor       @"navColor"

#define HeadlineInfo_command        @"command"
#define HeadlineInfo_commpanyId     @"commpanyId"
#define HeadlineInfo_recordId       @"recordId"
#define HeadlineInfo_messageId      @"messageId"
#define HeadlineInfo_parameterId    @"parameterId"


@interface HeadlineInfoTable : DBConstants

@end


/******************* 头条详情表 HeadlineInfoTable ****************************/

#define HeadlineInfoDetail_tableName    @"infoDetail"
#define HeadlineInfoDetail_id           @"infoId"
#define HeadlineInfoDetail_title        @"title"
#define HeadlineInfoDetail_html         @"html"
#define HeadlineInfoDetail_url          @"url"
#define HeadlineInfoDetail_infoPic      @"infoPic"
#define HeadlineInfoDetail_type         @"type"
#define HeadlineInfoDetail_baiduCode    @"baiduCode"
#define HeadlineInfoDetail_qiniuUrl     @"qiniuUrl"
#define HeadlineInfoDetail_format       @"format"
#define HeadlineInfoDetail_fileUrl      @"fileUrl"
#define HeadlineInfoDetail_isFollow     @"isFollow"
#define HeadlineInfoDetail_pageCout     @"pageCout"
#define HeadlineInfoDetail_commentCount @"commentCount"
#define HeadlineInfoDetail_authorIcon   @"authorIcon"
#define HeadlineInfoDetail_authorName   @"authorName"
#define HeadlineInfoDetail_navType      @"navType"
#define HeadlineInfoDetail_subType      @"subType"
#define HeadlineInfoDetail_viewPermit   @"viewPermit"
#define HeadlineInfoDetail_viewPrompt   @"viewPrompt"
#define HeadlineInfoDetail_infoOriginal @"infoOriginal"
#define HeadlineInfoDetail_source       @"source"
#define HeadlineInfoDetail_notice       @"notice"
#define HeadlineInfoDetail_integral     @"integral"
#define HeadlineInfoDetail_state        @"state"
#define HeadlineInfoDetail_shareUrl     @"shareUrl"
#define HeadlineInfoDetail_pageCount    @"pageCount"
#define HeadlineInfoDetail_width        @"width"
#define HeadlineInfoDetail_height       @"height"

@interface HeadlineInfoDetailTable : DBConstants

@end

/******************* 体验列表 ****************************/

#define lightExpList_tableName    @"lightExp_bigyype"

#define lightExpList_userID             @"userID"
#define lightExpList_mid                @"mid"
#define lightExpList_pid                @"pid"
#define lightExpList_pName              @"pName"
#define lightExpList_desc               @"desc"
#define lightExpList_size               @"size"
#define lightExpList_icon               @"icon"
#define lightExpList_isExp              @"isExp"
#define lightExpList_update             @"lightExpUpdate"
#define lightExpList_type               @"type"
#define lightExpList_apps               @"apps"


@interface LightExpListTable : DBConstants

@end

/******************* 雷达监控列表 ****************************/
#define attentionMonitoringList_tableName @"monitoringList_bigyype"

#define monitoringList_userID           @"userID"
#define monitoringList_address          @"address"
#define monitoringList_countNum         @"countNum"
#define monitoringList_createtime       @"createtime"
#define monitoringList_attentionTime    @"attentionTime"
#define monitoringList_desc             @"desc"
#define monitoringList_icon             @"icon"
#define monitoringList_infoId           @"id"
#define monitoringList_label            @"label"
#define monitoringList_layout           @"layout"
#define monitoringList_newNum           @"newNum"
#define monitoringList_prompt           @"prompt"
#define monitoringList_source           @"source"
#define monitoringList_subscribeNum     @"subscribeNum"
#define monitoringList_title            @"title"
#define monitoringList_type             @"type"
#define monitoringList_updatetime       @"updatetime"
#define monitoringList_createType       @"createType"
#define monitoringList_isTop            @"isTop"
#define monitoringList_dataLatestTime   @"dataLatestTime"

@interface AttentionMonitoringTable : DBConstants

@end


/******************* 雷达动态列表 ****************************/
#define attentionDynamicList_tableName @"dynamicList_bigyype"

#define dynamicList_dynamicID           @"dynamicID"



@interface DynamicListTable : DBConstants

@end

/******************* 企业圈列表 ****************************/

#define TeamCircleList_tableName @"TeamCircleList_bigyype"

#define teamCircleList_organizationID          @"organizationID"
#define teamCircleList_scoopID                 @"id"
#define teamCircleList_portrait                @"portrait"
#define teamCircleList_nickname                @"nickname"
#define teamCircleList_content                 @"content"
#define teamCircleList_scoopType               @"scoopType"
#define teamCircleList_level                   @"level"
#define teamCircleList_visibility              @"visibility"
#define teamCircleList_linkIcon                @"linkIcon"
#define teamCircleList_linkId                  @"linkId"
#define teamCircleList_linkTitle               @"linkTitle"
#define teamCircleList_linkType                @"linkType"
#define teamCircleList_time                    @"time"
#define teamCircleList_userId                  @"userId"
#define teamCircleList_isPraise                @"isPraise"
#define teamCircleList_isPay                   @"isPay"
#define teamCircleList_isSearch                @"isSearch"
#define teamCircleList_imageListJsonStr        @"imageListJsonStr"
#define teamCircleList_praiseJsonStr           @"praiseJsonStr"
#define teamCircleList_commentJsonStr          @"commentJsonStr"
#define teamCircleList_payJsonStr              @"payJsonStr"

@interface TeamCircleListTable : DBConstants

@end

/******************* 搜索列表 ****************************/

#define SearchList_tableName @"SearchList_bigyype"

#define SearchList_KeyWord          @"KeyWord"
#define SearchList_type             @"type"
#define SearchList_time             @"time"

@interface SearchListTable : DBConstants

@end

/******************* 热门搜索列表 ****************************/

#define HotSearchList_tableName @"HotSearchList_bigyype"

#define HotSearchList_type           @"type"
#define HotSearchList_tagId          @"tagId"
#define HotSearchList_tagName        @"tagName"
#define HotSearchList_command        @"command"
#define HotSearchList_commpanyId     @"commpanyId"
#define HotSearchList_recordId       @"recordId"
#define HotSearchList_recordType     @"recordType"

@interface HotSearchListTable : DBConstants

@end

/******************* 雷达分组列表 ****************************/

#define RadarGroupList_tableName @"RadarGroupList_bigyype"

#define RadarGroupList_groupID            @"groupID"
#define RadarGroupList_ID                 @"id"
#define RadarGroupList_userID             @"userID"
#define RadarGroupList_title              @"title"
#define RadarGroupList_countNum           @"countNum"
#define RadarGroupList_newNum             @"newNum"
#define RadarGroupList_conditionNum       @"conditionNum"
#define RadarGroupList_isCanDel           @"isCanDel"

@interface RadarGroupListTable : DBConstants

@end

/******************* 知识库第一分类 ****************************/

#define KnowledgeBaseFrist_tableName @"KnowledgeBaseFrist_bigyype"

#define KnowledgeBaseFrist_ID            @"id"
#define KnowledgeBaseFrist_icon          @"icon"
#define KnowledgeBaseFrist_fonticon      @"fonticon"
#define KnowledgeBaseFrist_name          @"name"
#define KnowledgeBaseFrist_color         @"color"

@interface KnowledgeBaseFristTable : DBConstants

@end

/******************* 知识库第二分类 ****************************/

#define KnowledgeBaseSecond_tableName @"KnowledgeBaseSecond_bigyype"

#define KnowledgeBaseSecond_navTypeId     @"navTypeId"
#define KnowledgeBaseSecond_ID            @"id"
#define KnowledgeBaseSecond_name          @"name"
#define KnowledgeBaseSecond_navs          @"navs"
#define KnowledgeBaseSecond_time          @"time"

@interface KnowledgeBaseSecondTable : DBConstants

@end

/******************* 行业文库列表 ****************************/

#define IndustryLibrary_tableName @"IndustryLibrary_bigyype"

@interface IndustryLibraryTable : DBConstants
#define IndustryLibrary_type         @"IndustryLibrary_type"
#define IndustryLibrary_action       @"IndustryLibrary_action"
#define IndustryLibrary_time         @"IndustryLibrary_time"
#define IndustryLibrary_downloadUrl  @"downloadUrl"
#define IndustryLibrary_fileName     @"fileName"
#define IndustryLibrary_fileSize     @"fileSize"
@end

/******************* 全民推荐列表 ****************************/

#define RecommendList_tableName @"RecommendList_bigyype"

@interface RecommendListTable : DBConstants
#define RecommendList_type     @"RecommendList_type"
#define RecommendList_action     @"RecommendList_action"
@end

/******************* 帮助二级列表 ****************************/

#define HelpCateList_tableName @"HelpCateList_bigyype"

@interface HelpCateListTable : DBConstants
#define HelpCateList_cateId     @"cateId"
#define HelpCateList_pageId     @"pageId"
#define HelpCateList_title      @"title"
#define HelpCateList_createTime @"createTime"
@end

/******************* 界面列表 ****************************/

#define InterfaceList_tableName @"InterfaceList_bigyype"

@interface InterfaceListTable : DBConstants
#define InterfaceList_id            @"id"
#define InterfaceList_productId     @"productId"
#define InterfaceList_productName   @"title"
#define InterfaceList_name          @"name"
#define InterfaceList_isFollow      @"isFollow"
#define InterfaceList_cover         @"cover"
#define InterfaceList_media         @"media"
#define InterfaceList_createtime    @"createtime"
#define InterfaceList_action        @"action"
#define InterfaceList_width         @"width"
#define InterfaceList_height        @"height"
#define InterfaceList_time          @"heiInterfaceList_time"
#define InterfaceList_original      @"original"
#define InterfaceList_notice          @"notice"

@end

/******************* 界面产品列表 ****************************/

#define InterfaceProductList_tableName @"InterfaceProductList_bigyype"

@interface InterfaceProductListTable : DBConstants
#define InterfaceProductList_id            @"id"
#define InterfaceProductList_title         @"title"
#define InterfaceProductList_icon          @"icon"
#define InterfaceProductList_desc          @"desc"
#define InterfaceProductList_source        @"source"
#define InterfaceProductList_address       @"address"
#define InterfaceProductList_subscribe     @"subscribe"
#define InterfaceProductList_createtime    @"createtime"
#define InterfaceProductList_type          @"type"
#define InterfaceProductList_isExpJoin     @"isExpJoin"
#define InterfaceProductList_action        @"action"
#define InterfaceProductList_time        @"InterfaceProductList_time"
@end

/******************* 岗位知识列表 ****************************/

#define JobKnowledgeList_tableName @"JobKnowledgeList_bigyype"

@interface JobKnowledgeListTable : DBConstants
#define JobKnowledgeList_navTypeId  @"JobKnowledgeList_navTypeId"
#define JobKnowledgeList_type       @"JobKnowledgeList_type"
#define JobKnowledgeList_time       @"JobKnowledgeList_time"
#define JobKnowledgeList_packageId  @"packageId"
@end
