//
//  CTDeviceTool.m
//  CGSays
//
//  Created by mochenyang on 12-11-9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTDeviceTool.h"
#import "sys/utsname.h"
#import "sys/sysctl.h"
#import "mach/mach_host.h"
#import "mach/mach_init.h"
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <SAMKeychain/SAMKeychain.h>

@interface CTDeviceTool()

+ (NSString *) getSysInfoByName:(char *)typeSpecifier;

+ (NSUInteger) getSysInfo: (uint) typeSpecifier;

@end

@implementation CTDeviceTool

#pragma mark - Private methods

// 获取指定类型的系统信息
+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

// 根据枚举类型获取系统信息
+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

#pragma mark - Public methods

+ (NSString *)getDeviceModel
{
    // systemInfo.machine: iPod4,1
    // systemInfo.nodename: CattsoftDev-iPod
    // systemInfo.release: 11.0.0
    // systemInfo.sysname: Darwin
    // systemInfo.version: Darwin Kernel Version 11.0.0: Sun Apr  8 21:51:26 PDT 2012; root:xnu-1878.11.10~1/RELEASE_ARM_S5L8930X
        
    NSString *deviceString = [self getSysInfoByName:"hw.machine"];
    
//    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    // 3,2是verzion iphone4
//    if ([deviceString isEqualToString:@"iPhone3,1"] ||
//        [deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
//    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
//    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    // 直接返回硬件编码
    return deviceString;
}

+ (CGSize)getDeviceScreen
{
    UIScreen *screen = [UIScreen mainScreen];
    return [[screen currentMode] size];
}

+ (NSString *)getDeviceType
{
    return ([self checkDevice:@"ipad"] ? @"4" : @"3");
}

+ (BOOL)checkDevice:(NSString *)name
{
	NSString* deviceType = [UIDevice currentDevice].model;
	NSRange range = [deviceType rangeOfString:name options:NSCaseInsensitiveSearch];
	return range.location != NSNotFound;
}

+ (NSUInteger)getCpuFrequency
{
    NSUInteger cpuHz = [self getSysInfo:HW_CPU_FREQ];
    if (cpuHz < 1)
    {
        NSString *platform = [CTDeviceTool getDeviceModel];
        NSArray *platforms = [NSArray arrayWithObjects:@"iPhone1,1", @"iPhone1,2", @"iPhone2", @"iPhone3", @"iPhone4", @"iPhone5", @"iPod1", @"iPod2", @"iPod3", @"iPod4", @"iPod5", @"iPad1", @"iPad2", @"iPad3", @"iPad4", nil];
        NSArray *cpuHzs = [NSArray arrayWithObjects:@"412000000", @"412000000", @"600000000", @"1000000000", @"800000000", @"1300000000", @"412000000", @"532412000000", @"600000000", @"800000000", @"800000000", @"1000000000", @"1000000000", @"1400000000", @"1400000000", nil];
        for (int i = 0; i < [platforms count]; ++i)
        {
            NSString *pf = [platforms objectAtIndex:i];
            if ([platform hasPrefix:pf])
            {
                cpuHz = [[cpuHzs objectAtIndex:i] intValue];
            }
        }
    }
    
    return (cpuHz / 1000);
}

+ (float)getCpuUsage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

// 获取总线频率
+ (NSUInteger) getBusFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

// 获取总的内存大小
+ (NSUInteger) getTotalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

// 获取用户内存
+ (NSUInteger) getUserMemory
{
    return [self getSysInfo:HW_USERMEM];
}

// 获取socketBufferSize
+ (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

// iphone下获取可用的内存大小
+ (NSUInteger)getAvailableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS)
        return NSNotFound;
    return (vm_page_size * vmStats.free_count);
}

+ (float)getFreeDisk
{
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[dict objectForKey:NSFileSystemFreeSize] floatValue];
}

+ (float)getTotalDisk
{
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[dict objectForKey:NSFileSystemSize] floatValue];
}

+ (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 自定义唯一标识

// 获取设备的mac地址
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
+ (NSString *)getMacAddress
{   
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)getMacUniqueIdentifier
{
    NSString *macaddress = [CTDeviceTool getMacAddress];
    
    // MD5加密用户的mac地址
    if(self == nil || [macaddress length] == 0)
        return nil;
    
    const char *value = [macaddress UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; ++count)
    {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)getUniqueDeviceIdentifier
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [self getMacUniqueIdentifier];
}

static NSString *ApplicationUUID;
//使用钥匙串获取唯一id
+(NSString *)getUniqueDeviceIdentifierAsString{
    if (!ApplicationUUID) {
        NSString *appName = @"BusinessCat";
        NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:appName];
        if (strApplicationUUID == nil){
            strApplicationUUID  = [NSString stringWithFormat:@"CGKnowledgeIOS%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
//            NSLog(@"生成设备唯一标识：%@",strApplicationUUID);
//            NSError *error = nil;
//            SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
//            query.service = appName;
//            query.account = appName;
//            query.password = strApplicationUUID;
//            query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
//            [query save:&error];
//            if (error) {
//                NSLog(@"%@, 保存唯一标识失败 :   = %@", NSStringFromSelector(_cmd), error.description);
//                [CTToast showWithText:[NSString stringWithFormat:@"保存唯一标识失败 : %@", error.description]];
//            }
            
            NSError *error2 = nil;
            [SAMKeychain setPassword:strApplicationUUID forService:appName account:appName error:&error2];
            if (error2) {
                NSLog(@"%@, 保存唯一标识失败 :   = %@", NSStringFromSelector(_cmd), error2.description);
//                [CTToast showWithText:[NSString stringWithFormat:@"保存唯一标识失败 : %@", error2.description]];
            }
        }
        ApplicationUUID = strApplicationUUID;
    }
    return ApplicationUUID;

//    // 重装后改变？
//    NSString *strApplicationUUID  = [NSString stringWithFormat:@"CGKnowledgeIOS%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
////    NSLog(@"设备码 生成设备唯一标识：%@",strApplicationUUID);
//    return strApplicationUUID;
    
    
    /*
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appName = infoDictionary[@"CFBundleDisplayName"];
//    NSString *appName = infoDictionary[@"CFBundleName"];
//    NSString *appName = @"CGKnowledgeIOS";
    NSString *appName = @"BusinessCat";
    NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:appName];
    if (strApplicationUUID == nil){
        strApplicationUUID  = [NSString stringWithFormat:@"CGKnowledgeIOS%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        NSLog(@"生成设备唯一标识：%@",strApplicationUUID);
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = appName;
        query.password = strApplicationUUID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
        if (error) {
            NSLog(@"%@, 保存唯一标识失败 :   = %@", NSStringFromSelector(_cmd), error.description);
            [CTToast showWithText:[NSString stringWithFormat:@"保存唯一标识失败 : %@", error.description]];
        }

        NSError *error2 = nil;
        [SAMKeychain setPassword:strApplicationUUID forService:appName account:appName error:&error2];
        if (error2) {
            NSLog(@"%@, 保存唯一标识失败 :   = %@", NSStringFromSelector(_cmd), error.description);
            [CTToast showWithText:[NSString stringWithFormat:@"保存唯一标识失败 : %@", error.description]];
        }
    }
    return strApplicationUUID;
     */
}
@end
