//
//  CTDeviceTool.h
//  CGSays
//
//  Created by mochenyang on 12-11-9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTDeviceTool : NSObject

/**
 * 获取设备型号如：iPod4,1
 * 使用注意：获取的结果包含英文逗号；有些接口可能不支持这个特殊字符时请使用其它字符替换逗号
 */
+ (NSString *)getDeviceModel;

/**
 * 获取设备类型，3是iPhone或iPod；4是iPad
 */
+ (NSString *)getDeviceType;

/**
 * 判断输入的设备号是否跟当前用户使用的相同
 * 使用[UIDevice currentDevice].model
 * name: iPod iPhone iPad 不区分大小写
 */
+ (BOOL)checkDevice:(NSString *)name;

/**
 * 获取设备分辨率
 */
+ (CGSize)getDeviceScreen;

// 获取CPU频率；获取的单位是KHz
+ (NSUInteger) getCpuFrequency;

/**
 * 获取cpu使用比例，返回0.0~1.0的值
 */
+ (float)getCpuUsage;

// 获取总线频率, 单位Hz
+ (NSUInteger) getBusFrequency;

// 获取总的内存大小，单位是byte
+ (NSUInteger) getTotalMemory;

// 获取用户内存，单位是byte
+ (NSUInteger) getUserMemory;

// 获取socketBufferSize，单位是byte
+ (NSUInteger) maxSocketBufferSize;

/**
 * 获取可用的内存大小，单位是byte
 */
+ (NSUInteger)getAvailableMemory;

/**
 * 获取磁盘剩余空间大小，单位是byte
 */
+ (float)getFreeDisk;

/**
 * 获取磁盘总大小，单位是byte
 */
+ (float)getTotalDisk;

/**
 * 获取当前APP版本
 */
+ (NSString *)getAppVersion;

#pragma mark - 自定义唯一标识

/**
 * 获取设备的mac地址
 */
+ (NSString *)getMacAddress;

/**
 * 使用md5加密mac地址，生成唯一标识
 * NS_DEPRECATED_IOS(2_0,6_0)
 */
+ (NSString *)getMacUniqueIdentifier;

/**
 * 获取设备唯一标识id
 */
+ (NSString *)getUniqueDeviceIdentifier;

+(NSString *)getUniqueDeviceIdentifierAsString;

@end
