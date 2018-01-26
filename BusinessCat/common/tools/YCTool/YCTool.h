//
//  YCTool.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCTool : NSObject

// 灰度图
+ (UIImage *)grayImage:(UIImage *)image;

// x 小时 x 分钟 x 秒，倒计时
+ (NSString *)countDonwStringWithTargetDate:(NSTimeInterval)interval;
// x 小时 x 分钟 x 秒，倒计时
//+ (NSString *)countDonwStringWithSeconds:(int)seconds;
// x 小时 x 分钟 x 秒，倒计时
+ (void)HMSForSeconds:(NSInteger)seconds block:(void(^)(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string))block;

// 16进制颜色, 0xffaabb
+ (UIColor *)colorOfHex:(NSInteger)s;
+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

#pragma mark -

+ (BOOL)isBlankString:(NSString *)string;

+ (NSString *)stringOfDictionary:(NSDictionary *)dic;

+ (NSString *)stringOfArray:(NSArray *)array;

#pragma mark -

//获取对象的所有属性名
+ (NSArray<NSString *> *)getAllProperties:(NSObject *)obj;
+ (NSDictionary *)print:(NSObject *)obj;

#pragma mark - String 字符串

// 编码(加密)
+ (NSString *)base64String:(NSString *)decodeString;

// 解码(解密)
+ (NSString *)decodeBase64String:(NSString *)base64String;

@end
