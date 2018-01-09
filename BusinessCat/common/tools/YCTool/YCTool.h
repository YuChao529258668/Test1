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

// 16进制颜色
+ (UIColor *)colorOfHex:(NSInteger)s;

#pragma mark -

+ (NSString *)stringOfDictionary:(NSDictionary *)dic;

+ (NSString *)stringOfArray:(NSArray *)array;

#pragma mark -

//获取对象的所有属性名
+ (NSArray<NSString *> *)getAllProperties:(NSObject *)obj;
+ (NSDictionary *)print:(NSObject *)obj;

@end
