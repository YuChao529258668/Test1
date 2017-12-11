//
//  YCMeetingFileManager.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingFileManager.h"
#import "YCMeetingBiz.h"
#import "YCMeetingFile.h"

@interface YCMeetingFileManager()
@property (nonatomic,strong) NSMutableArray<NSString *> *downloading; // 正在下载的 url
@property (nonatomic,strong) NSString *rootPath; // 根目录
@property (nonatomic,strong) UIImage *downloadingImage; // 提示正在下载

@end


@implementation YCMeetingFileManager

static YCMeetingFileManager *manager;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YCMeetingFileManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloading = [NSMutableArray array];
        _downloadingImage = [UIImage imageNamed:@"meeting_download_ing"];
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _rootPath = [cachePath stringByAppendingPathComponent:@"meetingFiles"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:_rootPath]) {
            BOOL success = [fm createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (success) {
                NSLog(@"创建目录成功： %@", _rootPath);
            }
        }
    }
    return self;
}


#pragma mark -

// 获取图片。如果不存在，会返回一个提示正在下载的图片，并且下载图片
//- (UIImage *)getImageWithURLStr:(NSString *)urlStr {
////    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:urlStr];
//    NSString *imagePath = [self imagePathWithURLString:urlStr];
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//
//    if (data) {
//        return [UIImage imageWithData:data];
//    } else {
//        [self downloadImageWithURLStr:urlStr];
//        return self.downloadingImage;
//    }
//}

- (UIImage *)getImageWithURLStr:(NSString *)urlStr imageName:(NSString *)imageName fileName:(NSString *)fileName {
    //    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:urlStr];
//    NSString *imagePath = [self imagePathWithURLString:urlStr];
    NSString *imagePath = [self imagePathWithImageName:imageName fileName:fileName];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    
    if (data) {
        return [UIImage imageWithData:data];
    } else {
        [self downloadImageWithURLStr:urlStr imageName:imageName fileName:fileName];
        return self.downloadingImage;
    }
}


//- (void)saveImage:(UIImage *)image withURLStr:(NSString *)urlStr{
//    //    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:urlStr];
//    NSString *imagePath = [self imagePathWithURLString:urlStr];
//
////    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSData *data = UIImagePNGRepresentation(image);
//    [data writeToFile:imagePath atomically:YES];
//}

- (void)saveImage:(UIImage *)image withURLStr:(NSString *)urlStr imageName:(NSString *)imageName fileName:(NSString *)fileName {
    //    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:urlStr];
//    NSString *imagePath = [self imagePathWithURLString:urlStr];
    NSString *imagePath = [self imagePathWithImageName:imageName fileName:fileName];

    //    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSData *data = UIImagePNGRepresentation(image);
    BOOL success = [data writeToFile:imagePath atomically:YES];
    if (success) {
        NSLog(@"保存成功");
    }
}


//- (void)downloadImageWithURLStr:(NSString *)urlStr {
//    if ([self.downloading containsObject:urlStr]) {
//        return;
//    } else {
//        [self.downloading addObject:urlStr];
//    }
//
//    NSURL *url = [NSURL URLWithString:urlStr];
//
//    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        [self.downloading removeObject:urlStr]; // 移出下载队列
//
//        if (image) {
//            [self saveImage:image withURLStr:urlStr]; // 缓存到本地
//            [self.delegate meetingFileManager:self didDownloadImage:image imageUrlStr:urlStr];
//        }
//    }];
//}

- (void)downloadImageWithURLStr:(NSString *)urlStr imageName:(NSString *)imageName fileName:(NSString *)fileName  {
    if ([self.downloading containsObject:urlStr]) {
        return;
    } else {
        [self.downloading addObject:urlStr];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [self.downloading removeObject:urlStr]; // 移出下载队列
        
        if (image) {
            [self saveImage:image withURLStr:urlStr imageName:imageName fileName:fileName]; // 缓存到本地
            [self.delegate meetingFileManager:self didDownloadImage:image imageUrlStr:urlStr];
            NSLog(@"下载成功");
        }
    }];
}

//- (void)downloadImages:(NSArray<NSString *> *)urlStrs {
//    for (NSString *string in urlStrs) {
//        [self downloadImageWithURLStr:string];
//    }
//}

//- (NSArray *)getImagesWithURLStrings:(NSArray<NSString *> *)urlStrs {
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:urlStrs.count];
//
//    for (NSString *urlStr in urlStrs) {
//        [images addObject: [self getImageWithURLStr:urlStr]];
//    }
//    return images;
//}

- (NSArray *)getImagesWithURLStrings:(NSArray<NSString *> *)urlStrs imageNames:(NSArray *)imageNames fileName:(NSString *)fileName {
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:urlStrs.count];
    
    [urlStrs enumerateObjectsUsingBlock:^(NSString * _Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imageName = imageNames[idx];
        [images addObject: [self getImageWithURLStr:urlStr imageName:imageName fileName:fileName]];
    }];
    return images;
}


#pragma mark -

- (NSString *)imagePathWithURLString:(NSString *)urlStr {
    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:urlStr];
//    imagePath = [imagePath stringByAppendingString:@".jpg"];
    imagePath = [imagePath stringByAppendingString:@".png"];
    return imagePath;
}

- (NSString *)imagePathWithImageName:(NSString *)imageName fileName:(NSString *)fileName {
    NSString *imagePath = [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png", fileName, imageName]];
    //    imagePath = [imagePath stringByAppendingString:@".jpg"];
//    imagePath = [imagePath stringByAppendingString:@".png"];
    return imagePath;
}



@end
