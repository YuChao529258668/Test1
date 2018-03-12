//
//  YCTool.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCTool.h"
#import <objc/runtime.h>

@implementation YCTool

#pragma mark - Image

+ (UIImage *)grayImage:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), image.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


#pragma mark - Date

// x 小时 x 分钟 x 秒，倒计时
+ (NSString *)countDonwStringWithTargetDate:(NSTimeInterval)interval {
    NSInteger t = interval - [NSDate date].timeIntervalSince1970;
    NSInteger h = t /(60 * 60);
    NSInteger m = t %(60 * 60)/60;
    NSInteger s = t %(60);
    NSMutableString *title = [NSMutableString string];
    if (h) {
        [title appendFormat:@"%ld小时", (long)h];
    }
    if (m) {
        [title appendFormat:@"%ld分钟", (long)m];
    }
    if (s) {
        [title appendFormat:@"%ld秒", (long)s];
    }
    if (h + m + s == 0) {
        title = [NSMutableString stringWithString:@"0秒"];
    }
    return title;
}

// x 小时 x 分钟 x 秒，倒计时
//+ (void)HMSForSeconds:(NSInteger)seconds block:(void(^)(NSInteger h, NSInteger m, NSInteger s))block {
//    NSInteger t = seconds;
//    NSInteger h = t /(60 * 60);
//    NSInteger m = t %(60 * 60)/60;
//    NSInteger s = t %(60);
//
//    if (block) {
//        block(h, m, s);
//    }
//}

// x 小时 x 分钟 x 秒，倒计时
+ (void)HMSForSeconds:(NSInteger)seconds block:(void(^)(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string))block {
    NSInteger t = seconds;
    NSInteger h = t /(60 * 60);
    NSInteger m = t %(60 * 60)/60;
    NSInteger s = t %(60);
    
    NSMutableString *string = [NSMutableString string];

    if (block) {
        block(h, m, s, string);
    }
}

// xx小时xx分钟
+ (NSString *)HMStringForSeconds:(NSInteger)seconds {
    __block NSString *str;
    [self HMSForSeconds:seconds block:^(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string) {
        if (h) {
            [string appendFormat:@"%ld小时", (long)h];
        }
        if (m) {
            [string appendFormat:@"%ld分钟", (long)m];
        }
        if (h + m == 0) {
            [string appendString:@"0分钟"];
        }
        str = string;
    }];
    return str;
}

// 日期字符串，明天，后天，大后天。。。
+ (NSString *)dateStringWithDaHouTianOfDate:(NSDate *)date {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDate *tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSDate *houTian = [today dateByAddingTimeInterval:secondsPerDay * 2];
    NSDate *daHouTian = [today dateByAddingTimeInterval:secondsPerDay * 3];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";


    NSString * todayString = [formatter stringFromDate:today];
    NSString * yesterdayString = [formatter stringFromDate:yesterday];
    NSString * tomorrowString = [formatter stringFromDate:tomorrow];
    NSString * houTianString = [formatter stringFromDate:houTian];
    NSString * daHouTianString = [formatter stringFromDate:daHouTian];

    NSString * dateString = [formatter stringFromDate:date];

    NSString *prefixStr = @"";
    
    if ([dateString isEqualToString:todayString])
    {
        prefixStr = @"今天";
    } else if ([dateString isEqualToString:tomorrowString])
    {
        prefixStr = @"明天";
    } else if ([dateString isEqualToString:houTianString])
    {
        prefixStr = @"后天";
    } else if ([dateString isEqualToString:daHouTianString])
    {
        prefixStr = @"大后天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        prefixStr = @"昨天";
    }
    else
    {
        formatter.dateFormat = @"MM月dd日 EE HH:mm";
        return [formatter stringFromDate:date];
    }
    
    formatter.dateFormat = @"HH:mm";
    return [NSString stringWithFormat:@"%@ %@", prefixStr, [formatter stringFromDate:date]];
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        NSLog(@"the day is today");
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        NSLog(@"the day is yesterday");
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        NSLog(@"the day is tomorrowString");
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


#pragma mark - Color

// 16进制颜色
+ (UIColor *)colorOfHex:(NSInteger)s {
    return [UIColor colorWithRed:(((s & 0xFF0000) >> 16 )) / 255.0 green:(((s & 0xFF00) >> 8 )) / 255.0 blue:((s & 0xFF)) / 255.0 alpha:1.0];
}

+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return color;
}

#pragma mark -

+ (void)save:(NSData *)data {
    // Cache， library, temp, NSDocumentDirectory
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

- (void)test {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
//                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}


#pragma mark - Debug

//获取对象的所有属性名
+ (NSArray<NSString *> *)getAllProperties:(NSObject *)obj
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([obj class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

+ (NSDictionary *)print:(NSObject *)obj {
    if (!obj) {
        NSLog(@"%@", obj);
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray<NSString *> *propertys = [self getAllProperties:obj];
    
    [propertys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"key = %@", key);
        NSObject *value;
        @try{
             value = [obj valueForKey:key];
        }
        @catch(NSException *e){ // previewItemTitle valueForUndefinedKey
            value = @"null:   valueForUndefinedKey";
//            value = @"";
//            value = e.description;
        }
        if (!value) {
            value = @"";
        }
        [dic setObject:value forKey:key];
    }];
    
    NSLog(@"%@", [self stringOfDictionary:dic]);
    return dic;
}


#pragma mark - String

+ (BOOL)isBlankString:(NSString *)string {
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!string.length) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringOfDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"\t%@ = %@, \n", key, obj];
    }];
    
    [string appendString:@"}"];
    
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    return string;
}

+ (NSString *)stringOfArray:(NSArray *)array {
    if (!array) {
        return nil;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"[\n"];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"\t a[%lu] = %@, \n", (unsigned long)idx, obj];
    }];
    
    [string appendString:@"]"];
    
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    return string;
}

// 编码(加密)
+ (NSString *)base64String:(NSString *)decodeString {
    NSData *encodeData = [decodeString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
}

// 解码(解密)
+ (NSString *)decodeBase64String:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

// 保留两位有意义小数
+ (NSString *)numberStringOf:(double)number {
    long l = number * 100;
    number = l/100.0;
    NSString *str = [NSString stringWithFormat:@"%@", @(number)];
    return str;
}


#pragma mark - URL

+ (NSURL *)urlWithString:(NSString *)urlStr {
    NSString *str = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:str];
    return url;
}


#pragma mark - UIViewController

// 如果最上层的是 UIAlertController，viewControllerToPresent 的 modalPresentationStyle 会被修改为 UIModalPresentationOverFullScreen。不然 UIAlertController 的对话框会漂移到屏幕顶部。
- (void)PresentViewController:(UIViewController *)viewControllerToPresent {
    [self PresentViewController:viewControllerToPresent animated:YES completion:NULL];
}

// 如果最上层的是 UIAlertController，viewControllerToPresent 的 modalPresentationStyle 会被修改为 UIModalPresentationOverFullScreen。不然 UIAlertController 的对话框会漂移到屏幕顶部。
- (void)PresentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    UIViewController *topVC = [self topViewController];
    if ([topVC isKindOfClass:[UIAlertController class]]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    [topVC presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (UIViewController *)topViewController {
    UIViewController *topModalVC = [self topModalViewController];
    
    if ([topModalVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (UINavigationController *)topModalVC;
        return nc.topViewController;
    } else {
        return topModalVC;
    }
}

// default is [UIApplication sharedApplication].keyWindow.rootViewController
- (UIViewController *)topModalViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topModalVC = rootVC;
    
    while (topModalVC.presentedViewController) {
        topModalVC = topModalVC.presentedViewController;
    }
    return topModalVC;
}


#pragma mark - WKWebView

// 隐藏 PDF 左上角的页数
+ (void)hidePageNumberIndicatorOfWebView:(WKWebView *)webView {
    UIView *view = webView.subviews.lastObject;
    for (UIView *v in view.subviews) {
        if ([v.description containsString:@"WKPDFPageNumberIndicator"]) {
            v.hidden = YES;
        }
    }
}


@end
