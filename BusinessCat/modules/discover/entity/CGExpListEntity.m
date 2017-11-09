//
//  CGExpListEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGExpListEntity.h"

@implementation CGExpListEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"expID":@"id"};
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
