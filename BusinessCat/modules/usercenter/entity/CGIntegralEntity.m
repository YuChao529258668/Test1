//
//  CGIntegralEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGIntegralEntity.h"

@implementation CGIntegralEntity

@end

@implementation IntegralListEntity

@end

@implementation RelationInfoEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"infoID":@"id"};
}
@end
