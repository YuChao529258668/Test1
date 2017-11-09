//
//  DateUtils.m
//  MangoCityCommerce
//
//  Created by Calon Mo on 15-1-27.
//  Copyright (c) 2015年 com.gdcattsoft. All rights reserved.
//

#import "CTDateUtils.h"

@implementation CTDateUtils

//今天，本地时间
+(NSDate *)today{
    NSDate *current = [NSDate date];
    return [current dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:current]];
}

//currentDate的明天
+(NSDate *) tomorrowWithDate:(NSDate *)currentDate{
    long current = [currentDate timeIntervalSince1970];
    current += 60*60*24;
    return [NSDate dateWithTimeIntervalSince1970:current];
}


//date的前beforeDater日期
+(NSDate *) beforeDayWithDate:(NSDate *)date beforeDate:(int)beforeDate{
    long current = [date timeIntervalSince1970];
    current -= 60*60*24*beforeDate;
    return [NSDate dateWithTimeIntervalSince1970:current];
}

//currentDate的昨天
+(NSDate *) yesterdayWithDate:(NSDate *)currentDate{
    long current = [currentDate timeIntervalSince1970];
    current -= 60*60*24;
    return [NSDate dateWithTimeIntervalSince1970:current];
}

//根据inputDate获取星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EE"];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [outputFormatter stringFromDate:inputDate];
}

//根据字符串日期获取周几
+(NSString *)weekdayShortStringFromString:(NSString *)dateString{
    if ([dateString length] < 1 || [dateString isEqualToString:@"null"])
        return @"";
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[format dateFromString:dateString]];
    return [weekdays objectAtIndex:theComponents.weekday];
}

//根据NSDate获取周几
+ (NSString*)weekdayShortStringFromDate:(NSDate*)inputDate{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+(NSDateComponents *)getNSDateComponentsWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}


+(NSString *)getTimeFormatFromDateString:(NSString *)dateString{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DateFormat1];
    return [self getTimeFormatText:[format dateFromString:dateString]];
}
/**
 * 返回文字描述的日期
 *
 * @param date
 * @return
 */
+(NSString *)getTimeFormatFromDate:(NSDate *)date{
    return [CTDateUtils getTimeFormatText:date];
}

+ (NSString *)getTimeFormatText:(NSDate *)date{
    return [CTDateUtils converFromLong:date.timeIntervalSince1970];
}

//传时间字符串，返回刚刚、几小时前、几天前等 精准时分
+(NSString *)getTimeDivisionFormatFromDateLong:(long)longTime{
  NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval time = currentTime - longTime/1000;
  if(time < 0){
    return @"未知";
  }
  NSInteger minute = time / 60;
  
  if(minute < 1){
    return @"刚刚";
  }
  if(minute < 60){
    return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
  }
  // 秒转小时
  NSInteger hours = time/3600;
  if (hours < 24) {
    return [NSString stringWithFormat:@"%ld小时前",(long)hours];
  }
  //秒转天数
  NSInteger day = time/3600;
  NSInteger days = day%24 >0?day/24+1:day/24;
  if(days <= 3){
    return [NSString stringWithFormat:@"%ld天前",(long)days];
  }
  if (days < 30) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月d日 mm:ss"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:longTime/1000]];
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"yyyy年M月d日 mm:ss"];
  return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:longTime/1000]];
}

//传时间字符串，返回刚刚、几小时前、几天前等
+(NSString *)getTimeFormatFromDateLong:(long)time{
    time = time/1000;
    return [CTDateUtils converFromLong:time];
}

+(NSString *)converFromLong:(long)longTime{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval time = currentTime - longTime;
    if(time < 0){
        return @"未知";
    }
    NSInteger minute = time / 60;
    
    if(minute < 1){
        return @"刚刚";
    }
    if(minute < 60){
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger day = time/3600;
  NSInteger days = day%24 >0?day/24+1:day/24;
    if(days <= 30){
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    if (days < 365) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"M月d日"];
        return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:longTime]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年M月d日"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:longTime]];
}



//比较指定时间在两个时间之间的前，中，后位置返回0:未开始，1：进行中，2：已结束
+(int)compareBetweenTwoDate:(NSDate *)compareDate start:(NSString *)start end:(NSString *)end{
    int result = 0;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DateFormat1];
    NSDate *startDate = [format dateFromString:start];
    NSDate *endDate = [format dateFromString:end];
    
    if([compareDate compare:startDate] == NSOrderedAscending){
        result = 0;
    }else if ([compareDate compare:startDate] == NSOrderedDescending && [compareDate compare:endDate] == NSOrderedAscending){
        result = 1;
    }else if([compareDate compare:endDate] == NSOrderedDescending){
        result = 2;
    }
    return result;
}
//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDateStr:(NSString *)first second:(NSString *)second{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DateFormat1];
    NSDate *firstDate = [format dateFromString:first];
    NSDate *secondDate = [format dateFromString:second];
    return [CTDateUtils compareTwoDate:firstDate second:secondDate];
}
//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDate:(NSDate *)first second:(NSDate *)second{
    BOOL returnValue = NO;
    if([first compare:second] == NSOrderedAscending){
        returnValue = YES;
    }else if ([first compare:second] == NSOrderedDescending){
        returnValue = NO;
    }
    return returnValue;
}

//first比second早，返回yes，否则返回no
+(BOOL)compareTwoDateInt:(NSInteger )first second:(NSInteger )second{
  NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:first/1000];
  NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:second/1000];
  return [CTDateUtils compareTwoDate:firstDate second:secondDate];
}

/*
 把秒数格式化成对应的MM:SS的格式
 */
+(NSString*)formatterSec:(int)sec{
    
    
    if (sec>60) {
        int min = sec/60;
        int secs = sec%60;
        return [NSString stringWithFormat:@"%02d:%02d",min,secs];
        
        
    }else{
        
        return [NSString stringWithFormat:@"00:%02d",sec];
    }
    
}

//时间差
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSInteger )startTime endTime:(NSInteger )endTime{
  NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:startTime];
  NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:endTime];
  NSCalendar *cal = [NSCalendar currentCalendar];
  
  unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  
  NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
  long sec = [d hour]*3600+[d minute]*60+[d second];
  return sec;
}


+(NSString *)formatDateToYYYYMMDD:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [format setDateFormat:@"yyyyMMdd"];
    return [format stringFromDate:date];
}

+(NSString *)formatDateToMMDDHHmm:(long )date{
    date = date/1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date];
  NSDateFormatter *format = [[NSDateFormatter alloc]init];
  [format setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
  [format setDateFormat:@"M月d日hh:mm"];
  return [format stringFromDate:confromTimesp];
}

+(NSString *)formatDateToYYMD:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [format setDateFormat:@"yy年M月d日"];
    return [format stringFromDate:date];
}

+(NSString *)formatDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

+(NSString *)formatDateFromLong:(long)date format:(NSString *)format{
    date = date/1000;
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:date];
    NSDate *nd = [d dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:d]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:nd];
}

+ (NSDate *)endOfDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDate *result = [endDate dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:endDate]];
    return result;
}

@end
