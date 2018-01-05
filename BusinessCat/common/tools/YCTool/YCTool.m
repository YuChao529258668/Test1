//
//  YCTool.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCTool.h"

@implementation YCTool

+ (UIImage *)grayImage:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), image.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

// x 小时 x 分钟 x 秒，倒计时
+ (NSString *)countDonwStringWithTargetDate:(NSTimeInterval)interval {
    NSInteger t = interval - [NSDate date].timeIntervalSince1970;
    NSInteger h = t /(60 * 60);
    NSInteger m = t %(60 * 60)/60;
    NSInteger s = t %(60);
    NSMutableString *title = [NSMutableString string];
    if (h) {
        [title appendFormat:@"%ld小时", (long)h];
    }
    if (m) {
        [title appendFormat:@"%ld分钟", (long)m];
    }
    if (s) {
        [title appendFormat:@"%ld秒", (long)s];
    }
    if (h + m + s == 0) {
        title = [NSMutableString stringWithString:@"0秒"];
    }
    return title;
}

// 16进制颜色
+ (UIColor *)colorOfHex:(NSInteger)s {
    return [UIColor colorWithRed:(((s & 0xFF0000) >> 16 )) / 255.0 green:(((s & 0xFF00) >> 8 )) / 255.0 blue:((s & 0xFF)) / 255.0 alpha:1.0];
}

+ (void)save:(NSData *)data {
    // Cache， library, temp, NSDocumentDirectory
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

@end
