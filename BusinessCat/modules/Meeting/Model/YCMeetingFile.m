//
//  YCMeetingFile.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingFile.h"

@implementation YCMeetingFile

- (void)setPicName:(NSString *)picName {
    _picName = picName;
    
    _imageNames = [_picName componentsSeparatedByString:@","];
    
    if (_picName && _picPath) {
        [self createImageUrls];
    }
}

- (void)setPicPath:(NSString *)picPath {
    _picPath = picPath;
    
    if (_picName && _picPath) {
        [self createImageUrls];
    }
}

- (void)createImageUrls {
    //    @"picPath" : @"http://pic.jp580.com/library/kengpo/cb587312-a47f-4504-a7a1-ccbb4fc3fcdb/cover/1502173359614-1"
    //    @"picName" : @"1502173359614-1,1502173359614-2,1502173359614-3,1502173359614-4,1502173359614-5,1502173359614-6,1502173359614-7,1502173359614-8,1502173359614-9,1502173359614-10,1502173359614-11,1502173359614-12,1502173359614-13,1502173359614-14,1502173359614-15,1502173359614-16,1502173359614-17,1502173359614-18,1502173359614-19,1502173359614-20,1502173359614-21,1502173359614-22,1502173359614-23,1502173359614-24,1502173359614-25,1502173359614-26,1502173359614-27,1502173359614-28"
    
    NSString *prefix = [_picPath stringByReplacingOccurrencesOfString:_imageNames.firstObject withString:@""];
    
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:_imageNames.count];
    for (NSString *name in _imageNames) {
        [imageUrls addObject: [NSString stringWithFormat:@"%@%@?imageMogr2/format/jpg/quality/100", prefix, name]];
    }
    _imageUrls = imageUrls;
}

//APP要注意非gif才执行转换，避免将GIF动画弄没了
//列表缩略图：?imageMogr2/format/jpg/quality/100/thumbnail/!50p
//标清：?imageMogr2/format/jpg
//高清：?imageMogr2/format/jpg/quality/100
//原图：不加参数


- (void)setPageIn:(int)pageIn {
    _pageIn = pageIn - 1;
}

@end
