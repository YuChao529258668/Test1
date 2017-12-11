//
//  YCMeetingFileManager.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCMeetingFileManager;

@protocol YCMeetingFileManagerDelegate <NSObject>
- (void)meetingFileManager:(YCMeetingFileManager *)manager didDownloadImage:(UIImage *)image imageUrlStr:(NSString *)urlStr;
@end

@interface YCMeetingFileManager : NSObject
@property (nonatomic,weak) id<YCMeetingFileManagerDelegate> delegate;

+ (instancetype)shareManager;
//- (void)downloadImages:(NSArray<NSString *> *)urlStrs;
//// 从磁盘获取图片，没有的图片会自动下载，并返回一张图片提示正在下载
//- (UIImage *)getImageWithURLStr:(NSString *)urlStr;
//// 从磁盘获取图片，没有的图片会自动下载，并用一张提示正在下载的图片代替
//- (NSArray *)getImagesWithURLStrings:(NSArray<NSString *> *)urlStrs;

// 从磁盘获取图片，没有的图片会自动下载，并返回一张图片提示正在下载
- (UIImage *)getImageWithURLStr:(NSString *)urlStr imageName:(NSString *)imageName fileName:(NSString *)fileName;
// 从磁盘获取图片，没有的图片会自动下载，并返回一张图片提示正在下载
- (NSArray *)getImagesWithURLStrings:(NSArray<NSString *> *)urlStrs imageNames:(NSArray *)imageNames fileName:(NSString *)fileName;

@end
