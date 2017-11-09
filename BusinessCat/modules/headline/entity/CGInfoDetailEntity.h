//
//  CGInfoDetailEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/10/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条详情model

#import <Foundation/Foundation.h>
#import "CGTopicEntity.h"

@interface CGInfoDetailEntity : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * infoId;
@property (nonatomic, strong) NSString * html;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * infoPic;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, copy) NSString *baiduCode;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *qiniuUrl;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, assign) int pageCout;
@property (nonatomic, copy) NSString *navType;
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, copy) NSString *authorIcon;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, assign) NSInteger viewPermit;
@property (nonatomic, copy) NSString *viewPrompt;
@property (nonatomic, assign) NSInteger infoOriginal;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, strong) NSMutableArray *appList;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) NSInteger createTimeNew;

@property (nonatomic, assign) NSInteger pageCount;
//@property(nonatomic,retain)CGTopicEntity *topicInfo;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end

@interface CGAppListEntity : NSObject
@property (nonatomic, copy) NSString *appIcon;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appUrl;
@end
