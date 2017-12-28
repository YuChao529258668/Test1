//
//  CTFileUtil.h
//  CSALeaningSys
//
//  Created by Calon Mo on 15-5-7.
//
//

#import <Foundation/Foundation.h>

@interface CTFileUtil : NSObject

+(NSString *)getDocumentsPath;

+ (NSString *)getLibarayCachePath;

+ (BOOL)createFolder:(NSString *)folder error:(NSError **)error;

+(BOOL)deleteFolder:(NSString *)floder error:(NSError **)error;


/**
 为每个登录的用户创建一个文件夹，可存放该用户的内容，文件夹以用户ID命名
 
 */

+(void)creatFolderForUser:(NSString *)loginUserId;

/**
 获取用户的文件夹
 
 */

+(NSString*)getUserFolderPathForUserId:(NSString*)userId;


/**
 创建一个存放练习的文件夹
 
 */
+(void)creatExerciseFolderForUser;

/** 获取url的后缀 */
+(NSString *)getFileNameType:(NSString *)url;

/**计算文件夹大小*/
+(long)calculateFolderSize:(NSString *)path;


@end
