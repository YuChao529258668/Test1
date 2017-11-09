//
//  CGInfoHeadEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/10/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条列表model

#import <Foundation/Foundation.h>
#import "CGRelevantInformationEntity.h"

typedef enum  {
    ContentLayoutUnknown = 0,//未知
    ContentLayoutLeftPic = 1,//左图标
    ContentLayoutMorePic = 2,//多图文
    ContentLayoutRightPic = 3,//右图片
    ContentLayoutOnlyTitle = 4,//单标题
    ContentLayoutCatalog = 5 //目录
}HeadlineContentLayout;

//tableview布局宏定义
#define identifierOnlyTitle @"onlyTitle"//纯标题
#define identifierLeftPic @"leftPic"//左图片
#define identifierLeftPicCompany @"leftPicCompany"//左图片公司
#define identifierLeftPicProduct @"leftPicProduct"//左图片产品
#define identifierMorePic @"morePic"//多图片
#define identifierRightPic @"rightPic"//右图片
#define identifierCatalog @"catalog" //目录
#define identifierTool @"tool"//工具

@interface CGInfoHeadEntity : NSObject

@property (nonatomic, strong) NSString * infoId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) int type;//1资讯 2频道 3公司 4人物 5投资机构 6竟报 7方案 8产品 9主题 10体验
@property (nonatomic, assign) HeadlineContentLayout layout;//布局
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * label2;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) int discuss;
@property (nonatomic, assign) int subscribe;
@property (nonatomic, strong) NSString * prompt;
@property (nonatomic, assign) long createtime;
@property (nonatomic, copy) NSString *navtype; //导航分类
@property (nonatomic, copy) NSString *navtype2; //导航分类2
@property (nonatomic, copy) NSString *navColor; //导航分类颜色
@property (nonatomic, assign) int isSubscribe; //是否关注
@property (nonatomic, assign) int isFollow; //是否收藏

@property (nonatomic, strong) NSArray * imglist;
@property (nonatomic, strong) NSMutableArray<CGRelevantInformationEntity *> *relevant;

@property (nonatomic, strong) NSString *packageId;
@property (nonatomic, strong) NSString *cataId;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) int isJoin;//是否加入主题 需要根据主题 是否全民推荐
@property (nonatomic, assign) int isExp; //是否是体验库
@property (nonatomic, assign) int isExpJoin;//是否加入我的体验
@property (nonatomic, copy) NSString *cover;   //
@property (nonatomic, assign) NSInteger viewPermit;
@property (nonatomic, copy) NSString *viewPrompt;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) NSInteger isIcon;

@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, copy) NSString *notice;

//跳转规则
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *commpanyId;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *parameterId;

//以下参数非接口返回
@property(nonatomic,retain)NSString *bigtype;//大类
@property(nonatomic,retain)NSString *imglistJson;//图片地址json格式
@property(nonatomic,retain)NSString *relevantJson;//
@property(nonatomic,assign)int read;//是否阅读过
@property(nonatomic,assign)long localtime;//本地时间

@end
