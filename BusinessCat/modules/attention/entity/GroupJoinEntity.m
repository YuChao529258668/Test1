//
//  GroupJoinEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "GroupJoinEntity.h"

@implementation GroupJoinEntity

@end

@implementation JoinEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"groupID":@"id"};
}
@end
