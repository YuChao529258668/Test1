//
//  YCMeetingFile.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//


// 会议课件 ppt

#import <Foundation/Foundation.h>

@interface YCMeetingFile : NSObject

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,assign) int fileType;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,assign) int pageIn;
@property (nonatomic,strong) NSString *picName; // 所有图片地址用英文逗号连接
@property (nonatomic,strong) NSString *picPath; // 第一张图片的地址

@property (nonatomic,strong) NSArray<NSString *> *imageUrls;

@end
//
//{
//    fileName = "\U5f71\U8bf4-\U5f71\U89c6\U4eba\U670d\U52a1\U5e73\U53f0";
//    fileType = 7;
//    pageCount = 28;
//    pageIn = 1;
//    picName = "1502102242636-1,1502102242636-2,1502102242636-3,1502102242636-4";
//    picPath = "http://pic.jp580.com/library/kengpo/cb587312-a47f-4504-a7a1-ccbb4fc3fcdb/cover/1502173359614-1";
//}

