//
//  DateUtils.h
//  MangoCityCommerce
//
//  Created by Calon Mo on 15-1-27.
//  Copyright (c) 2015年 com.gdcattsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DateFormat1 @"yyyy-MM-dd HH:mm:ss"

@interface CTDateUtils : NSObject

//今天，本地时间
+(NSDate *)today;

//currentDate的明天
+(NSDate *) tomorrowWithDate:(NSDate *)currentDate;

//date的前beforeDater日期
+(NSDate *) beforeDayWithDate:(NSDate *)date beforeDate:(int)beforeDate;

//currentDate的昨天
+(NSDate *) yesterdayWithDate:(NSDate *)currentDate;

//根据NSDate获取星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

//根据字符串日期获取周几
+(NSString *)weekdayShortStringFromString:(NSString *)dateString;

//根据NSDate获取周几
+ (NSString*)weekdayShortStringFromDate:(NSDate*)inputDate;

//获取NSDateComponents，可以从NSDateComponents获取年，月，日等
+(NSDateComponents *)getNSDateComponentsWithDate:(NSDate *)date;
//传时间字符串，返回刚刚、几小时前、几天前等
+(NSString *)getTimeFormatFromDateString:(NSString *)dateString;

//传时间字符串，返回刚刚、几小时前、几天前等 精准时分
+(NSString *)getTimeDivisionFormatFromDateLong:(long)time;
//传时间字符串，返回刚刚、几小时前、几天前等
+(NSString *)getTimeFormatFromDateLong:(long)time;

//传时间date，返回刚刚、几小时前、几天前等
+(NSString *)getTimeFormatFromDate:(NSDate *)date;

//比较指定时间在两个时间之间的前，中，后位置返回0:未开始，1：进行中，2：已结束
+(int)compareBetweenTwoDate:(NSDate *)compareDate start:(NSString *)start end:(NSString *)end;

//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDateStr:(NSString *)first second:(NSString *)second;
//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDate:(NSDate *)first second:(NSDate *)second;
//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDateInt:(NSInteger )first second:(NSInteger )second;

//把秒数格式化成对应的MM:SS的格式
+(NSString*)formatterSec:(int)sec;

//时间差
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSInteger )startTime endTime:(NSInteger )endTime;

+(NSString *)formatDateToYYYYMMDD:(NSDate *)date;

+(NSString *)formatDateToMMDDHHmm:(long )date;

+(NSString *)formatDateToYYMD:(NSDate *)date;

+(NSString *)formatDate:(NSDate *)date format:(NSString *)format;

+(NSString *)formatDateFromLong:(long)date format:(NSString *)format;

+ (NSDate *)endOfDate:(NSDate *)date;

@end
