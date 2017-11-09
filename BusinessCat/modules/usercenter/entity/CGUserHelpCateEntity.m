//
//  CGUserHelpCateEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserHelpCateEntity.h"

@implementation CGUserHelpCateEntity
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
