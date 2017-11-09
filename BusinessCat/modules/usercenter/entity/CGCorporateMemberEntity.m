//
//  CGCorporateMemberEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGCorporateMemberEntity.h"

@implementation CGCorporateMemberEntity

//归档的实现
MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"privilegeTitle" : @"CGPrivilegeTitle",@"privilegeList":@"CGPrivilegeList"};
}
@end


@implementation CGPrivilegeTitle

//归档的实现
MJCodingImplementation

@end

@implementation CGPrivilegeList

//归档的实现
MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : @"CGListEntity"};
}

@end

@implementation CGListEntity
//归档的实现
MJCodingImplementation

@end
