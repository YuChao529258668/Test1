//
//  CTFileUtil.m
//  CSALeaningSys
//
//  Created by Calon Mo on 15-5-7.
//
//

#import "CTFileUtil.h"

@implementation CTFileUtil

+(NSString *)getDocumentsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)getLibarayCachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
+ (BOOL)createFolder:(NSString *)folder error:(NSError **)error{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:error];
}

+(BOOL)deleteFolder:(NSString *)floder error:(NSError **)error{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:floder]){
        return [fileManager removeItemAtPath:floder error:error];
    }
    return NO;
}

//创建微课、练习。。。等文件存储路径
+ (void)initialize{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //创建微课存储文件夹
//        [CTFileUtil createFolder: CourseLocalPath error:nil];
//        
//        //创建微练习存储文件夹
//        [CTFileUtil createFolder:ExerciseLocalPath error:nil];
//        
//        //创建培训项目存储文件夹
//        [CTFileUtil createFolder:TrainLocalPath error:nil];
        
        //创建下载目录
//        [CTFileUtil createFolder:DownloadLocalPath error:nil];
    });
}

//为不同的用户创建以用户ID为名的文件夹

+(void)creatFolderForUser:(NSString *)loginUserId{
    
    NSString *path = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",loginUserId]];

    NSFileManager* fileManager =  [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    [self creatExerciseFolderForUser];
}



+(NSString *)getUserFolderPathForUserId:(NSString *)userId{
    
    return [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",userId]];
}



/** 获取url的后缀 */
+(NSString *)getFileNameType:(NSString *)url{
    NSArray *array = [url componentsSeparatedByString:@"."];
    return [@"." stringByAppendingString:array[array.count-1]];
}


/**计算文件夹大小*/
+(long)calculateFolderSize:(NSString *)path{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}


+ (long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
