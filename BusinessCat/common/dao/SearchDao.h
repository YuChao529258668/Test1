//
//  SearchDao.h
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTBaseDao.h"

@interface SearchDao : CTBaseDao
//保存搜索关键字到数据库
+(void)saveSearchToDB:(NSString *)key type:(NSInteger)type;

//根据type查询本地搜索关键字
+(void)querySearchFromDBWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//根据type删除本地搜索关键字
+(void)deleteSearchToDBWithType:(NSInteger)type;

//保存搜索关键字到数据库
+(void)saveHotSearchToDB:(NSMutableArray *)data type:(NSInteger)type;

//根据type查询本地热门搜索关键字
+(void)queryHotSearchFromDBWithType:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;
@end
