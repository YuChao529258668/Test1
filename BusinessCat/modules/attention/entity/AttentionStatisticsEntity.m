//
//  AttentionStatisticsEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionStatisticsEntity.h"

@implementation AttentionStatisticsEntity
-(void)encodeWithCoder:(NSCoder *)aCoder{
  //encode properties/values
  [aCoder encodeObject:self.typeName      forKey:@"typeName"];
  [aCoder encodeObject:self.typeId  forKey:@"typeId"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.time]      forKey:@"time"];
  [aCoder encodeObject:[NSNumber numberWithInteger:0] forKey:@"count"];
  [aCoder encodeObject:self.fonticon forKey:@"fonticon"];
  [aCoder encodeObject:self.icon forKey:@"icon"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    //decode properties/values
    self.typeName       = [aDecoder decodeObjectForKey:@"typeName"];
    self.typeId           = [aDecoder decodeObjectForKey:@"typeId"];
    self.time          = [[aDecoder decodeObjectForKey:@"time"] integerValue];
    self.count            = [[aDecoder decodeObjectForKey:@"count"] integerValue];
    self.fonticon        = [aDecoder decodeObjectForKey:@"fonticon"];
    self.icon       = [aDecoder decodeObjectForKey:@"icon"];
  }
  
  return self;
}
@end
