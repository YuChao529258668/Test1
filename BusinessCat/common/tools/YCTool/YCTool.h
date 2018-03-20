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
// xx小时xx分钟
+ (NSString *)HMStringForSeconds:(NSInteger)seconds;

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

// 保留两位有意义小数
+ (NSString *)numberStringOf:(double)number;

// 日期字符串，明天，后天，大后天。。。
+ (NSString *)dateStringWithDaHouTianOfDate:(NSDate *)date;

#pragma mark - WKWebView

// 隐藏 PDF 左上角的页数
+ (void)hidePageNumberIndicatorOfWebView:(WKWebView *)webView;

// 隐藏底部栏(第1页 共3页， +100%-)，类型是 WKCompositingView，高度 30
+ (void)hideBottomBarOfWebView:(WKWebView *)webView;

#pragma mark - URL

+ (NSURL *)urlWithString:(NSString *)urlStr;

@end
