//
//  KnowledgeBaseEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "KnowledgeBaseEntity.h"

@implementation KnowledgeBaseEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"categoryID":@"id"};
}
//归档的实现
- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super init]) {
    [self mj_decode:decoder];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [self mj_encode:encoder];
}
@end

@implementation ListEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"listID":@"id"};
}
//归档的实现
- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super init]) {
    [self mj_decode:decoder];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [self mj_encode:encoder];
}
@end

@implementation NavsEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"navsID":@"id"};
}
//归档的实现
- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super init]) {
    [self mj_decode:decoder];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [self mj_encode:encoder];
}
@end
