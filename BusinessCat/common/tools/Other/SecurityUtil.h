//
//  SecurityUtil.h
//  CSALeaningSys
//
//  Created by Calon Mo on 15/7/17.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface SecurityUtil : NSObject

/**
 *md5对字符串加密，返回字符串
 */
+(NSString *)md5ByString:(NSString *)string;

@end
