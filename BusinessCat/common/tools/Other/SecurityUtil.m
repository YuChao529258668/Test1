//
//  SecurityUtil.m
//  CSALeaningSys
//
//  Created by Calon Mo on 15/7/17.
//
//

#import "SecurityUtil.h"

@implementation SecurityUtil

/**
 *md5对字符串加密，返回字符串
 */
+(NSString *)md5ByString:(NSString *)string{
    const char *strChar = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(strChar, strlen(strChar), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; ++count){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}
@end
