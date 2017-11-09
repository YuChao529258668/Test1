//
//  CTVerifyTool.m
//  CGSays
//
//  Created by mochenyang on 12-10-23.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTVerifyTool.h"
#import "CTCommonUtil.h"

@implementation CTVerifyTool

+ (BOOL)isNumeric:(NSString *)input
{
    return [CTVerifyTool commonCheck:input pattern:@"^\\d+$"];
}

+ (BOOL)isEmail:(NSString *)input
{
    return [CTVerifyTool commonCheck:input pattern:@"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"];
}

+ (BOOL)isTelePhone:(NSString *)input{
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    return [CTVerifyTool commonCheck:input pattern:MOBILE];
}

+ (BOOL)isDate:(NSString *)input format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:format];
    
    return ([formatter dateFromString:input] != nil);
}

+ (BOOL)checkAlphanumeric:(NSString *)input
{
    return [CTVerifyTool commonCheck:input pattern:@"^(([0-9]+[a-zA-Z]+[0-9a-zA-Z]*)|([a-zA-Z]+[0-9]+[0-9a-zA-Z]*))$"];
}

+ (BOOL)checkGeneral:(NSString *)input
{
    return [CTVerifyTool commonCheck:input pattern:@"^([_0-9a-zA-Z]+)$"];
}

+ (BOOL)commonCheck:(NSString *)input pattern:(NSString *)pattern
{
    if ([input isKindOfClass:[NSString class]] && [pattern isKindOfClass:[NSString class]])
    {
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        return [regular numberOfMatchesInString:input options:0 range:NSMakeRange(0, input.length)];
    }
    
    return NO;
}

+ (BOOL)validateCard:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"];
}

+ (BOOL)isIP:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$"];
}

+ (BOOL)isUrl:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^(https|http|www|ftp|)?(://)?(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*((:\\d+)?)(/(\\w+(-\\w+)*))*(\\.?(\\w)*)(\\?)?(((\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*(\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*)*(\\w*)*)$"];
}

+ (BOOL)isCheckInput1:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen
{
    if ([inputValue length] >= minLen && [inputValue length] <= maxLen)
    {
        if ([CTVerifyTool commonCheck:inputValue pattern:@"[0-9]"] && [CTVerifyTool commonCheck:inputValue pattern:@"[a-zA-Z]"] && [CTVerifyTool commonCheck:inputValue pattern:@"[_~-.!@#$%^&*()+?><]"])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isCheckInput2:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen
{
    if ([inputValue length] >= minLen && [inputValue length] <= maxLen)
    {
        return [CTVerifyTool checkAlphanumeric:inputValue];
    }
    return NO;
}

+ (BOOL)isHandset:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];
}

+ (BOOL)isDecimal:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"\\d+\\.\\d{2}?"];
}

+ (BOOL)isPostalcode:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"\\d{6}(-\\d{4})?"];
}

+ (BOOL)isDay:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^((0?[1-9])|((1|2)[0-9])|30|31)$"];
}

+ (BOOL)isDate:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^\\d{4}-(0?[1-9]{1}|1[0-2])-(0?[1-9]{1}|[1-2][0-9]|3[0-1])(\\s([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9])?$"];
}

+ (BOOL)isTime:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"([0-1]?[0-9]|2[0-3]):[0-5]?[0-9]:[0-5]?[0-9]"];
}

+ (BOOL)isIntNumber:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^[0-9]*[1-9][0-9]*$"];
}

+ (BOOL)isUpChar:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^[A-Z]+$"];
}

+ (BOOL)isLowChar:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^[a-z]+$"];
}

+ (BOOL)isLetter:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^[A-Za-z]+$"];
}

+ (BOOL)isLength:(NSString *)inputValue length:(int)length
{
    return [inputValue length] > length ? NO : YES;
}

+ (BOOL)isChinese:(NSString *)inputValue
{
    return [CTVerifyTool commonCheck:inputValue pattern:@"^[\u4E00-\u9FA5]+$"];
}

+ (BOOL)isBeforeNow:(NSString *)inputValue
{
//    NSDate *date = [CTCommonUtil formatDateWithYMD:inputValue];
//    if (date != nil && [date compare:[NSDate date]] > 0)
//    {
//        return YES;
//    }
    
    return NO;
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
@end
