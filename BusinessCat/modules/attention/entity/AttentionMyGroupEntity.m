//
//  AttentionMyGroupEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionMyGroupEntity.h"

@implementation AttentionMyGroupEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"groupID":@"id"};
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
  //encode properties/values
  [aCoder encodeObject:self.groupID      forKey:@"groupID"];
  [aCoder encodeObject:self.title  forKey:@"title"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.countNum]      forKey:@"countNum"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.newNum] forKey:@"newNum"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.conditionNum] forKey:@"conditionNum"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    //decode properties/values
    self.groupID       = [aDecoder decodeObjectForKey:@"groupID"];
    self.title   = [aDecoder decodeObjectForKey:@"title"];
    self.countNum   = [[aDecoder decodeObjectForKey:@"countNum"] integerValue];
    self.newNum      = [[aDecoder decodeObjectForKey:@"newNum"] integerValue];
    self.conditionNum      = [[aDecoder decodeObjectForKey:@"conditionNum"] integerValue];
  }
  
  return self;
}
@end
