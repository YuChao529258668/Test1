//
//  CGTagsEntity.m
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTagsEntity.h"

@implementation CGTagsEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"tagID":@"id"};
}
@end

@implementation CGTags
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"tagID":@"id"};
}
@end
