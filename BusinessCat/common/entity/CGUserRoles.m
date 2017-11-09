//
//  CGUserRoles.m
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  用户的角色

#import "CGUserRoles.h"

@implementation CGUserRoles

//归档的实现
//MJCodingImplementation
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.skillId      forKey:@"skillId"];
  [aCoder encodeObject:self.skillName      forKey:@"skillName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.skillId       = [aDecoder decodeObjectForKey:@"skillId"];
    self.skillName       = [aDecoder decodeObjectForKey:@"skillName"];
  }
  
  return self;
}

@end
