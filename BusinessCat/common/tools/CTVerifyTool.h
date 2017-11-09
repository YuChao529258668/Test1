//
//  CTVerifyTool.h
//  CGSays
//
//  Created by mochenyang on 12-10-23.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTVerifyTool : NSObject

+ (BOOL)validateCard:(NSString *)inputValue;

+ (BOOL)isIP:(NSString *)inputValue;

+ (BOOL)isUrl:(NSString *)inputValue;

+ (BOOL)isCheckInput1:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen;

+ (BOOL)isCheckInput2:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen;

+ (BOOL)isHandset:(NSString *)inputValue;

+ (BOOL)isDecimal:(NSString *)inputValue;

+ (BOOL)isPostalcode:(NSString *)inputValue;

+ (BOOL)isDay:(NSString *)inputValue;

+ (BOOL)isDate:(NSString *)inputValue;

+ (BOOL)isTime:(NSString *)inputValue;

+ (BOOL)isIntNumber:(NSString *)inputValue;

+ (BOOL)isUpChar:(NSString *)inputValue;

+ (BOOL)isLowChar:(NSString *)inputValue;

+ (BOOL)isLetter:(NSString *)inputValue;

+ (BOOL)isLength:(NSString *)inputValue length:(int)length;

+ (BOOL)isChinese:(NSString *)inputValue;

+ (BOOL)isBeforeNow:(NSString *)inputValue;

/**
 * 验证输入的内容是否是数字
 */
+ (BOOL)isNumeric:(NSString *)input;

/**
 * 验证输入的内容是否是邮箱地址
 */
+ (BOOL)isEmail:(NSString *)input;

/**
 * 验证输入的内容是否是电话号码
 * 包括：11位手机码；区号-电话号码； 电话号码
 */
+ (BOOL)isTelePhone:(NSString *)input;

/**
 * 验证输入的内容是否是日期； format参数是日期校验格式如：yyyy-MM-dd
 */
+ (BOOL)isDate:(NSString *)input format:(NSString *)format;

/**
 * 验证字符串是否由字母＋数字组成
 */
+ (BOOL)checkAlphanumeric:(NSString *)input;

/**
 * 验证字符串是否只含有字母、数字或下划线
 */
+ (BOOL)checkGeneral:(NSString *)input;

/**
 * 公共验证方法；根据输入的字符串和匹配模式验证输入的内容
 */
+ (BOOL)commonCheck:(NSString *)input pattern:(NSString *)pattern;

/**
 * 验证身份证号码
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end
