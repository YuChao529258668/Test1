//
//  CTCommonUtil.m
//  CGSays
//
//  Created by mochenyang on 11-11-7.
//  Copyright 2011年 gdcattsoft.com. All rights reserved.
//

#import "CTCommonUtil.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "CTCommonTool.h"
//#import "iConsole.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation CTCommonUtil


//截取指定区域的图片  
+ (UIImage*)getSnapshotByView:(UIImage*)view toRect:(CGRect)rect
{  
    CGImageRef subImageRef = CGImageCreateWithImageInRect(view.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, NO, view.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];  
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return smallImage;  
}

/*
 *截取某个控件的图片
 */
+ (UIImage *)getSnapshotByView:(UIView *)view{
    NSData *pngImg;
    CGSize viewSize = [view bounds].size;
    if ([view isKindOfClass:[UIScrollView class]]) {
        viewSize = ((UIScrollView *)view).contentSize;
    }
    UIGraphicsBeginImageContext(viewSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    pngImg = UIImagePNGRepresentation( UIGraphicsGetImageFromCurrentImageContext());
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:pngImg];
}

+ (UIImage *)generateImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, CGRectMake(0, 0, size.width, size.height));
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return image;
}


//data转换为十六进制的。
+ (NSString *)hexStringFromData:(NSData *)data
{
    
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];++i)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}

#pragma mark - 转换操作

+ (NSString *)convertNilToEmptyStr:(NSString *)str
{
    if (str != nil && (NSNull *)str != [NSNull null])
    {
        return str;
    }
    return @"";
}

+ (UIColor *)convert16BinaryColor:(NSString *)sColor
{
    if (sColor != nil)
    {
        int iColorLength = [sColor length];
        if (iColorLength == 6 || iColorLength == 7)
        {
            unsigned int red = 0, green = 0, blue = 0;
            if (iColorLength == 7)
            {
                sColor = [sColor substringFromIndex:1];
            }
            [[NSScanner scannerWithString:[sColor substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
            [[NSScanner scannerWithString:[sColor substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
            [[NSScanner scannerWithString:[sColor substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
            
            return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
        }
    }
    return nil;
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
  NSArray *searchArray = preferIPv4 ?
  @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
  @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
  
  NSDictionary *addresses = [self getIPAddresses];
  NSLog(@"addresses: %@", addresses);
  
  __block NSString *address;
  [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
   {
     address = addresses[key];
     //筛选出IP地址格式
     if([self isValidatIP:address]) *stop = YES;
   } ];
  return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
  if (ipAddress.length == 0) {
    return NO;
  }
  NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
  
  if (regex != nil) {
    NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
    
    if (firstMatch) {
      NSRange resultRange = [firstMatch rangeAtIndex:0];
      NSString *result=[ipAddress substringWithRange:resultRange];
      //输出结果
      NSLog(@"%@",result);
      return YES;
    }
  }
  return NO;
}

+ (NSDictionary *)getIPAddresses
{
  NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
  
  // retrieve the current interfaces - returns 0 on success
  struct ifaddrs *interfaces;
  if(!getifaddrs(&interfaces)) {
    // Loop through linked list of interfaces
    struct ifaddrs *interface;
    for(interface=interfaces; interface; interface=interface->ifa_next) {
      if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
        continue; // deeply nested code harder to read
      }
      const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
      char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
      if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
        NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
        NSString *type;
        if(addr->sin_family == AF_INET) {
          if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
            type = IP_ADDR_IPv4;
          }
        } else {
          const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
          if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
            type = IP_ADDR_IPv6;
          }
        }
        if(type) {
          NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
          addresses[key] = [NSString stringWithUTF8String:addrBuf];
        }
      }
    }
    // Free memory
    freeifaddrs(interfaces);
  }
  return [addresses count] ? addresses : nil;
}

@end
