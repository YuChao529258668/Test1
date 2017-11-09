//
//  CGProductInterfaceEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGProductInterfaceEntity.h"

@implementation CGProductInterfaceEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"interfaceID":@"id"};
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
