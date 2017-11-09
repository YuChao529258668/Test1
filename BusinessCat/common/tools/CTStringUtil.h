//
//  StringUtil.h
//  guoyou
//
//  Created by ym on 14-2-17.
//  Copyright (c) 2014年 guoyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTStringUtil : NSObject

//判断字符串是否不为空
+(BOOL) stringNotBlank:(NSString *)str;

+(NSString *)utf8ToUnicode:(NSString *)string;

//清除html的宽高
+(NSString *)clearHtmlImgWithAndHeight:(NSString *)html;

//动态计算高度
+(CGFloat)heightWithFont:(CGFloat)font width:(NSInteger)width str:(NSString *)string;

@end
