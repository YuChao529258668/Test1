//
//  CTCommonUtil.h
//  CGSays
//
//  Created by mochenyang on 11-11-7.
//  Copyright 2011年 gdcattsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>


@interface CTCommonUtil : NSObject
{    
}


/*
 *截取某个控件指定区域的图片
 */
+ (UIImage*)getSnapshotByView:(UIView *)view toRect:(CGRect)rect;
/*
 *截取某个控件的图片
 */
+ (UIImage *)getSnapshotByView:(UIView *)view;

/*
 *根据color生成图片
 */
+ (UIImage *)generateImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * 把NSData转换成Hex字符串
 */
+ (NSString *)hexStringFromData:(NSData *)data;

/**
 * str为nil或NSNull时返回空字符串，否则返回本身
 */
+ (NSString *)convertNilToEmptyStr:(NSString *)str;

/**
 * 把16进制颜色值转为UIColor；转换失败返回nil
 *  sColor可以是：111111或#111111
 */
+ (UIColor *)convert16BinaryColor:(NSString *)sColor;

/**
 * 获取设备当前网络IP地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
