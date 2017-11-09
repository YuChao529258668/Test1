//
//  AttentionCompanyEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "AttentionCompanyEntity.h"

@implementation AttentionCompanyEntity
-(void)encodeWithCoder:(NSCoder *)aCoder{
  //encode properties/values
  [aCoder encodeObject:self.list      forKey:@"list"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.defaultUpdate]      forKey:@"defaultUpdate"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    //decode properties/values
    self.list       = [aDecoder decodeObjectForKey:@"list"];
    self.defaultUpdate          = [[aDecoder decodeObjectForKey:@"defaultUpdate"] integerValue];
  }
  
  return self;
}
@end

@implementation companyEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"companyID":@"id"};
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
  //encode properties/values
  [aCoder encodeObject:self.companyID      forKey:@"companyID"];
  [aCoder encodeObject:self.title  forKey:@"title"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.update]      forKey:@"update"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
  [aCoder encodeObject:self.depaName forKey:@"depaName"];
  [aCoder encodeObject:self.className forKey:@"className"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    //decode properties/values
    self.companyID       = [aDecoder decodeObjectForKey:@"companyID"];
    self.title           = [aDecoder decodeObjectForKey:@"title"];
    self.update          = [[aDecoder decodeObjectForKey:@"update"] integerValue];
    self.type            = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    self.depaName        = [aDecoder decodeObjectForKey:@"depaName"];
    self.className       = [aDecoder decodeObjectForKey:@"className"];
  }
  
  return self;
}
@end
