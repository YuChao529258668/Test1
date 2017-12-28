//
//  StringUtil.m
//  guoyou
//
//  Created by ym on 14-2-17.
//  Copyright (c) 2014年 guoyou. All rights reserved.
//

#import "CTStringUtil.h"

@implementation CTStringUtil

//判断字符串是否不为空
+(BOOL) stringNotBlank:(NSString *) str{
    if(!str || str == nil || str == NULL){
        return NO;
    }
  if ([str isEqualToString:@"(null)"]||[str isEqualToString:@"<null>"]) {
    return NO;
  }
    if ([str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if([str isKindOfClass:[NSString class]]){
        if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
            return NO;
        }
    }
    
    return YES;
}

+(NSString *) utf8ToUnicode:(NSString *)string{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
    }
    return s;
}

//清除html的宽高
+(NSString *)clearHtmlImgWithAndHeight:(NSString *)html{
    NSString *regexStr = @"width=\\\"[\\d]+\"|height=\\\"[\\d]+\"|img_width=\\\"[\\d]+\"|img_height=\\\"[\\d]+\"";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:html options:0 range:NSMakeRange(0, [html length])];
    if([matches count] > 0){
        NSMutableArray *array = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            for (int i = 0; i < [match numberOfRanges]; i++) {
                //以正则中的(),划分成不同的匹配部分
                NSString *component = [html substringWithRange:[match rangeAtIndex:i]];
                [array addObject:component];
            }
        }
        for(NSString *str in array){
            html = [html stringByReplacingOccurrencesOfString:str withString:@""];
        }

    }
    return html;
}

//动态计算高度
+(CGFloat)heightWithFont:(CGFloat)font width:(NSInteger)width str:(NSString *)string{
  UIFont * fonts = [UIFont systemFontOfSize:font];
  CGSize size  =CGSizeMake(width, MAXFLOAT);
  NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
  size = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  return size.height;
}
@end
