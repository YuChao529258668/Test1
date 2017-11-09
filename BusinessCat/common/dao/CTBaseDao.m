//
//  CTBaseDao.m
//  Coyoo
//
//  Created by Calon Mo on 16/4/5.
//  Copyright © 2016年 Coyoo. All rights reserved.
//

#import "CTBaseDao.h"
#import <objc/runtime.h>

@implementation CTBaseDao

static BOOL _isInitTables = NO;

+ (void)initialize{
    if (_isInitTables)return;
    _isInitTables = YES;
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        // 需要创建数据库表实例对象
        NSMutableArray *tables = [NSMutableArray array];
        // 创建数组库表版本控制Table
        [self createsTables:tables];
        //遍历所有表
        for (DBConstants *instance in tables){
            int oldTableVersion = [self queryTableVersionWithDB:database tableName:[instance tableName]];
            // 判断表结构版本升级
            if ([instance tableVersion] > oldTableVersion){
                // 遍历所有版本
                for (int i = 1; i <= [instance tableVersion]; ++i){
                    if ([instance respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"createTableSQLV%d:", i])]){
                        BOOL result = [instance performSelector:NSSelectorFromString([NSString stringWithFormat:@"createTableSQLV%d:", i]) withObject:database];
                        if(result){
                            [self saveOrUpdateTableVersionToDB:database tableName:[instance tableName] version:i];
                            //NSLog(@"%@->create succes", [instance tableName]);
                        }else{
                            //NSLog(@"%@->create error", [instance tableName]);
                        }
                    }
                }
            }
        }
    }
    [database close];
}
+(void)createsTables:(NSMutableArray*)tables{
    [tables addObject:[[TableVersion alloc] init]];
    [tables addObject:[[HeadlineBigTypeTable alloc]init]];
    [tables addObject:[[HeadlineInfoTable alloc]init]];
    [tables addObject:[[HeadlineInfoDetailTable alloc]init]];
    [tables addObject:[[LightExpListTable alloc]init]];
    [tables addObject:[[AttentionMonitoringTable alloc]init]];
    [tables addObject:[[DynamicListTable alloc]init]];
    [tables addObject:[[TeamCircleListTable alloc]init]];
    [tables addObject:[[SearchListTable alloc]init]];
    [tables addObject:[[HotSearchListTable alloc]init]];
    [tables addObject:[[RadarGroupListTable alloc]init]];
    [tables addObject:[[KnowledgeBaseFristTable alloc]init]];
    [tables addObject:[[KnowledgeBaseSecondTable alloc]init]];
    [tables addObject:[[IndustryLibraryTable alloc]init]];
    [tables addObject:[[RecommendListTable alloc]init]];
    [tables addObject:[[InterfaceListTable alloc]init]];
    [tables addObject:[[HelpCateListTable alloc]init]];
    [tables addObject:[[InterfaceProductListTable alloc]init]];
    [tables addObject:[[JobKnowledgeListTable alloc]init]];
    //添加需创建的表
}
#pragma mark - Private methods
//查询指定表的结构版本
+ (int)queryTableVersionWithDB:(FMDatabase *)database tableName:(NSString *)tableName{
    int tableVersion = 0;
    NSString *conditionSql = [NSString stringWithFormat:@"select %@ from %@ where %@='%@'", tableVersion_table_version, tableVersion_tableName, tableVersion_name, tableName];
    FMResultSet *rs = [database executeQuery:conditionSql];
    if (rs.next){
        tableVersion = [rs intForColumnIndex:0];
    }
    [rs close];
    return tableVersion;
}
//插入指定表的版本号
+ (BOOL)saveOrUpdateTableVersionToDB:(FMDatabase *)database tableName:(NSString *)tableName version:(int)version{
    NSString *querySql = [NSString stringWithFormat:@"select count(0) from %@ where %@='%@'",tableVersion_tableName,tableVersion_name,tableName];
    FMResultSet *rs = [database executeQuery:querySql];
    int count = 0;
    if (rs.next){
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    
    if(count > 0){//更新
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@=%d where %@='%@'",tableVersion_tableName,tableVersion_table_version,version,tableVersion_name,tableName];
        return [database executeUpdate:updateSql];
    }else{//新增
        NSString *updateSql = [NSString stringWithFormat:@"insert or ignore into %@(%@,%@,%@) values('%@',%d,0)",tableVersion_tableName,tableVersion_name,tableVersion_table_version,tableVersion_data_version,tableName,version];
        return [database executeUpdate:updateSql];
    }
    return NO;
}

#pragma mark - Public methods

- (NSString *)getDataBasePath{
    return DatabasePath;
}

- (BOOL)modifyDBWithStrSql:(NSString *)strSql error:(NSString **)error{
    BOOL result = 0;
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        result = [database executeUpdate:strSql];
    }
    if ([database lastErrorCode] != 0){
        NSError *lastError = [database lastError];
        if (error){
            *error = [lastError.userInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    [database close];
    return result;
}

- (NSMutableArray *)queryDBWithStrSql:(NSString *)strSql error:(NSString **)error{
    NSMutableArray *result = [NSMutableArray array];
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        FMResultSet *rs = [database executeQuery:strSql];
        while (rs.next) {
            [result addObject:rs.resultDictionary];
        }
        [rs close];
    }
    if ([database lastErrorCode] != 0){
        NSError *lastError = [database lastError];
        if (error){
            *error = [lastError.userInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    [database close];
    return result;
}


- (int)saveOrUpdateDataWithKeyValues:(NSDictionary *)keyValues condition:(NSString *)condition tableName:(NSString *)tableName error:(NSString **)error{
    int result = 0;
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        int isExists = NO;
        if ([condition length] > 0){
            NSString *conditionSql = [NSString stringWithFormat:@"select count(0) from %@ where %@", tableName, condition];
            FMResultSet *rs = [database executeQuery:conditionSql];
            isExists = rs.columnCount > 0;
            [rs close];
        }
        if (isExists){ // 更新
            NSMutableString *updateSql = [NSMutableString stringWithFormat:@"update %@ set  ", tableName];
            NSArray *theKeys = [keyValues allKeys];
            for (NSString *keyName in theKeys){
                if ([keyValues objectForKey:keyName] != nil){
                    [updateSql appendFormat:@"%@=?,", keyName];
                }
            }
            [updateSql deleteCharactersInRange:NSMakeRange([updateSql length] - 1, 1)];
            [updateSql appendFormat:@" where %@", condition];
            result = [database executeUpdate:updateSql withArgumentsInArray:[keyValues allValues]] ? 1 : 0;
        }else{ // 新增
            NSMutableString *columns = [NSMutableString stringWithString:@" "];
            NSMutableString *values = [NSMutableString stringWithString:@" "];
            NSArray *theKeys = [keyValues allKeys];
            for (NSString *keyName in theKeys){
                if ([keyValues objectForKey:keyName] != nil){
                    [columns appendFormat:@"%@,", keyName];
                    [values appendString:@"?,"];
                }
            }
            [columns deleteCharactersInRange:NSMakeRange([columns length] - 1, 1)];
            [values deleteCharactersInRange:NSMakeRange([values length] - 1, 1)];
            
            NSString *insertSql = [NSMutableString stringWithFormat:@"insert or ignore into %@(%@) values(%@) ", tableName, columns, values];
            result = [database executeUpdate:insertSql withArgumentsInArray:[keyValues allValues]] ? 2 : 0;
        }
        [database close];
    }
    
    if ([database lastErrorCode] != 0){
        NSError *lastError = [database lastError];
        if (error){
            *error = [lastError.userInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    
    return result;
}

-(BOOL)saveDataWithKeyValues:(NSDictionary *)keyValues condition:(NSString *)condition table:(NSString *)table database:(FMDatabase *)database error:(NSString **)error{
    BOOL result = NO;
    
    NSMutableString *columns = [NSMutableString stringWithString:@" "];
    NSMutableString *values = [NSMutableString stringWithString:@" "];
    NSArray *theKeys = [keyValues allKeys];
    for (NSString *keyName in theKeys){
        if ([keyValues objectForKey:keyName] != nil){
            [columns appendFormat:@"%@,", keyName];
            [values appendString:@"?,"];
        }
    }
    [columns deleteCharactersInRange:NSMakeRange([columns length] - 1, 1)];
    [values deleteCharactersInRange:NSMakeRange([values length] - 1, 1)];
    
    NSString *insertSql = [NSMutableString stringWithFormat:@"insert or ignore into %@(%@) values(%@) ", table, columns, values];
    result = [database executeUpdate:insertSql withArgumentsInArray:[keyValues allValues]];
    
    if ([database lastErrorCode] != 0){
        NSError *lastError = [database lastError];
        if (error){
            *error = [lastError.userInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    return result;
}

//根据表名查询本地数据版本
-(int)queryTableDataVersionByTableName:(NSString *)tableName{
    int result = 0;
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@='%@'",tableVersion_data_version,tableVersion_tableName,tableVersion_name,tableName];
        FMResultSet *rs = [database executeQuery:querySql];
        if (rs.next){
            result = [rs intForColumn:tableVersion_data_version];
        }
        [rs close];
        [database close];
    }
    return result;
}

//根据表名更新数据版本
-(BOOL)updateTableDataVersionByTableName:(NSString *)tableName newVersion:(int)newVersion{
    BOOL result = NO;
    FMDatabase *database = [FMDatabase databaseWithPath:DatabasePath];
    if ([database open]){
        NSString *querySql = [NSString stringWithFormat:@"update %@ set %@=%d where %@='%@'",tableVersion_tableName,tableVersion_data_version,newVersion,tableVersion_name,tableName];
        FMResultSet *rs = [database executeQuery:querySql];
        if (rs.next){
            result = [rs intForColumn:tableVersion_data_version];
        }
        [rs close];
        [database close];
    }
    return result;
}

-(void)dealloc{
//    NSLog(@"Dao->%@->%@", NSStringFromClass([self class]),  NSStringFromSelector(_cmd));
}
@end
