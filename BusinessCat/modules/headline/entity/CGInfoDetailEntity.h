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

//@property (nonatomic,strong) NSMutableArray<NSString *> *yc_imageURLs;
//@property (nonatomic,strong) NSMutableArray *yc_imageURLs;
@property (nonatomic,strong) NSString *pageName;
- (NSMutableArray<NSString *> *)getYCImageURLs;

@end


@interface CGAppListEntity : NSObject
@property (nonatomic, copy) NSString *appIcon;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appUrl;
@end

//@"pageName" : @"fdc071fc-3b50-4edd-8147-7473fcbca42c-1,e2388031-00e4-4f32-8031-df35f28e5244-2,698741b8-f6d8-4f0d-a1b5-3fb13756a49b-3,e6bc5e2e-56f5-4e67-b2ea-e250a344298d-4,2efd20a0-af2d-4864-877c-93f64472a7f6-5,67744563-c90c-4d1b-9013-3d1afbe5f47a-6,caa13380-334b-43fa-9474-c1923d68e81d-7,af7a2cee-7a83-46fb-9142-2ff4d6ab0bef-8,fe225740-9682-4e03-ae92-3bc04aed47c0-9,644d5dc7-0ba8-4257-9652-ac8be4a20bfd-10,0ef7170a-dfc5-4870-b80c-39ad346dfa9a-11,e3e1b7bc-5934-49bc-a098-627e19ab081f-12,3309a95f-fb88-4599-8fa8-4c2e7855a9ab-13,641849e5-d859-404b-9c4e-2094068d0fdf-14,1ec5a616-a6ab-4fdf-9d52-f979454e8abe-15,30db4aa4-dc4d-400b-bf76-8818b7b14156-16,3455728c-7bc5-43cf-9a85-32d0d26d9fa1-17,7ba2387a-eb30-434f-9054-d737630ee9a1-18,f062349a-053d-4477-9480-44a7cf29e566-19,0749e024-4114-4551-9714-434a475e08f1-20,11d802cd-be2e-43d7-b392-64ffa19a8fd6-21,bd3dd5a6-691a-481e-805f-c36ee784a932-22,68fb42bc-9dc4-4be8-bc75-267e43770ca9-23,0d5dec71-ff66-4344-8455-df8d1b3dd205-24,cd36aad5-ddc3-44ab-961d-af39907ff702-25,ca9462d1-17c2-4a38-9931-4866ffe2"

//[22]    (null)    @"authorIcon" : @"http://pic.jp580.com/library/kengpo/cb587312-a47f-4504-a7a1-ccbb4fc3fcdb/cover/fdc071fc-3b50-4edd-8147-7473fcbca42c-1"
//
//[17]    (null)    @"infoPic" : @"http://pic.jp580.com/library/kengpo/cb587312-a47f-4504-a7a1-ccbb4fc3fcdb/cover/fdc071fc-3b50-4edd-8147-7473fcbca42c-1"

