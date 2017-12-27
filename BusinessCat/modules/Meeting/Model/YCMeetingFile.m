//
//  YCMeetingFile.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingFile.h"

@implementation YCMeetingFile

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _fileName = @"素材";
//        _pageCount = 1;
//    }
//    return self;
//}

//- (NSString *)fileName {
//    if (!_fileName) {
//
//    }
//}

- (void)setFileType:(int)fileType {
    _fileType = fileType;

    // 1 素材，页数肯定为1
    if (fileType == 1) {
        self.pageCount = 1;
        self.pageIn = 1;
        self.fileName = @"素材";
    }
}

//- (void)setPageCount:(int)pageCount {
//    _pageCount = pageCount;
//
//    // 1 素材，页数肯定为1
//    if (self.fileType == 1) {
//        _pageCount = 1;
//    }
//}

//- (NSString *)fileName {
//    if (self.toId) {
//        if (![self.toId isEqualToString:@"0"] && self.fileType == 1) {
//            return @"素材";
//        }
//    }
//    return _fileName;
//}

//- (int)pageCount {
//    if (self.toId) {
//        if (![self.toId isEqualToString:@"0"] && self.fileType == 1) {
//            return 1;
//        }
//    }
//    return _pageCount;
//}

//- (int)pageIn {
//    if (self.toId) {
//        if (![self.toId isEqualToString:@"0"] && self.fileType == 1) {
//            return 1;
//        }
//    }
//    return pageIn;
//}


//- (void)setToId:(NSString *)toId {
//    _toId = toId;
//
//    // 表示关闭文件
//    if ([toId isEqualToString:@"0"]) {
//        _pageCount = 0;
//    }
//}


// 所有图片地址用英文逗号连接
//- (void)setPicName:(NSString *)picName {
//    _picName = picName;
//
//    _imageNames = [_picName componentsSeparatedByString:@","];
//
//    if (_picName && _picPath) {
//        [self createImageUrls];
//    }
//}

// 第一张图片的地址
//- (void)setPicPath:(NSString *)picPath {
//    _picPath = picPath;
//
//    if (_picName && _picPath) {
//        [self createImageUrls];
//    }
//
//    if (!_picName) {
//        self.picName = picPath;
//    }
//}

- (NSArray *)createImageUrls {
    //    @"picPath" : @"http://pic.jp580.com/library/kengpo/cb587312-a47f-4504-a7a1-ccbb4fc3fcdb/cover/1502173359614-1"
    //    @"picName" : @"1502173359614-1,1502173359614-2,1502173359614-3,1502173359614-4,1502173359614-5,1502173359614-6,1502173359614-7,1502173359614-8,1502173359614-9,1502173359614-10,1502173359614-11,1502173359614-12,1502173359614-13,1502173359614-14,1502173359614-15,1502173359614-16,1502173359614-17,1502173359614-18,1502173359614-19,1502173359614-20,1502173359614-21,1502173359614-22,1502173359614-23,1502173359614-24,1502173359614-25,1502173359614-26,1502173359614-27,1502173359614-28"
    
    NSString *prefix = [self.picPath stringByReplacingOccurrencesOfString:self.imageNames.firstObject withString:@""];
    
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:self.imageNames.count];
    for (NSString *name in self.imageNames) {
        [imageUrls addObject: [NSString stringWithFormat:@"%@%@?imageMogr2/format/jpg/quality/100", prefix, name]];
    }
//    _imageUrls = imageUrls;
    return imageUrls;
}

//APP要注意非gif才执行转换，避免将GIF动画弄没了
//列表缩略图：?imageMogr2/format/jpg/quality/100/thumbnail/!50p
//标清：?imageMogr2/format/jpg
//高清：?imageMogr2/format/jpg/quality/100
//原图：不加参数

- (NSArray<NSString *> *)imageUrls {
    if (self.toId) {
        if (![self.toId isEqualToString:@"0"] && self.fileType == 1) {
            _imageUrls = @[self.picPath];
        }
        if (![self.toId isEqualToString:@"0"] && self.fileType == 0) {
            _imageUrls = [self createImageUrls];
        }
    }
    return _imageUrls;
}

- (NSArray<NSString *> *)imageNames {
    if (self.toId) {
        if (![self.toId isEqualToString:@"0"] && self.fileType == 1) {
            NSString *urlStr = [self.picPath componentsSeparatedByString:@"/"].lastObject;
            _imageNames = @[urlStr];
        }
        if (![self.toId isEqualToString:@"0"] && self.fileType == 0) {
            _imageNames = [self.picName componentsSeparatedByString:@","];
        }
    }
    return _imageNames;
}

- (void)setPageIn:(int)pageIn {
    _pageIn = pageIn - 1;
}

@end
