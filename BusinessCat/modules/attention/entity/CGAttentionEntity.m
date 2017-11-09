//
//  CGAttentionEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionEntity.h"

@implementation CGAttentionEntity

-(instancetype)initWithRolId:(NSString *)rolId rolName:(NSString *)rolName type:(NSInteger)type{
  self = [super init];
  if(self){
    self.rolId = rolId;
    self.rolName = rolName;
    self.type = type;
  }
  return self;
}
@end
