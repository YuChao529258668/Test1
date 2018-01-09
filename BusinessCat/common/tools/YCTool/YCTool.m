//
//  YCTool.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCTool.h"

@implementation YCTool

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

// 16进制颜色
+ (UIColor *)colorOfHex:(NSInteger)s {
    return [UIColor colorWithRed:(((s & 0xFF0000) >> 16 )) / 255.0 green:(((s & 0xFF00) >> 8 )) / 255.0 blue:((s & 0xFF)) / 255.0 alpha:1.0];
}

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


#pragma mark -

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









@end
