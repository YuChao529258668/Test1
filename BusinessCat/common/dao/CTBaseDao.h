//
//  CTBaseDao.h
//  Coyoo
//
//  Created by Calon Mo on 16/4/5.
//  Copyright © 2016年 Coyoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DBConstants.h"
#import "CTFileUtil.h"

#define LocalDatabaseName @"cgsays.sqlite"
#define DatabasePath [NSString stringWithFormat:@"%@/%@", [CTFileUtil getDocumentsPath], LocalDatabaseName]
#define LibraryPath [NSString stringWithFormat:@"%@", [CTFileUtil getLibarayCachePath]]
#define CookiesPath [NSString stringWithFormat:@"%@/", [CTFileUtil getLibarayCachePath]]

@interface CTBaseDao : NSObject

/**
 * 获取项目默认数据库local_app.db路径
 */
- (NSString *)getDataBasePath;


/**
 * 执行增，删，改操作；
 * @param strSql 执行语句
 */
- (BOOL)modifyDBWithStrSql:(NSString *)strSql error:(NSString **)error;

/**
 * 执行查询操作；
 * @param strSql 执行语句
 */
- (NSMutableArray *)queryDBWithStrSql:(NSString *)strSql error:(NSString **)error;

/**
 * 新增或更新内容
 * @param addKeyValues 更新或新增的键值对内容
 * @param condition: 判断是否存在和更新的条件，如：1=1 and 2=2
 * @return 操作失败返回0，更新成功返回1，新增成功返回2
 */
- (int)saveOrUpdateDataWithKeyValues:(NSDictionary *)keyValues condition:(NSString *)condition tableName:(NSString *)tableName error:(NSString **)error;

/**
 *  此函数不控制数据库的打开和关闭，由调用的地方控制
 */
-(BOOL)saveDataWithKeyValues:(NSDictionary *)keyValues condition:(NSString *)condition table:(NSString *)table database:(FMDatabase *)database error:(NSString **)error;

//根据表名查询本地数据版本
-(int)queryTableDataVersionByTableName:(NSString *)tableName;
//根据表名更新数据版本
-(BOOL)updateTableDataVersionByTableName:(NSString *)tableName newVersion:(int)newVersion;

@property (nonatomic, assign) CGFloat fontSize;
@end
