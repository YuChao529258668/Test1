//
//  TeamCircleLastStateEntity.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircleLastStateEntity.h"

#define TeamCircleStateName @"TeamCircleLastState"

@implementation TeamCircleLastStateEntity

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : @"TeamCircleCompanyState"};
}

-(TeamCircleBadgeState *)badge{
    if(!_badge){
        _badge = [[TeamCircleBadgeState alloc]init];
    }
    return _badge;
}

-(NSMutableArray *)list{
    if(!_list){
        _list = [NSMutableArray array];
    }
    return _list;
}






+(BOOL)saveToLocal:(TeamCircleLastStateEntity *)entity{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:TeamCircleStateName];
    return [NSKeyedArchiver archiveRootObject:entity toFile:filePath];
}

+(TeamCircleLastStateEntity *)getFromLocal{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:TeamCircleStateName];
    TeamCircleLastStateEntity *entity = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if(!entity){
        entity = [[TeamCircleLastStateEntity alloc]init];
    }
    return entity;
}


-(TeamCircleCompanyState *)getCompanyStateById:(NSString *)companyId companyType:(int)companyType{
    for(TeamCircleCompanyState *item in self.list){
        if([item.companyId isEqualToString:companyId] && item.companyType == companyType){
            return item;
        }
    }
    return nil;
}

@end

