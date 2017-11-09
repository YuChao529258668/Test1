//
//  CGDiscoverAppsEntity.m
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverAppsEntity.h"

@implementation CGDiscoverAppsEntity
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.groupId      forKey:@"groupId"];
  [aCoder encodeObject:self.groupName      forKey:@"groupName"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.groupSort]      forKey:@"groupSort"];
  [aCoder encodeObject:self.gropuApps      forKey:@"gropuApps"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.groupId       = [aDecoder decodeObjectForKey:@"groupId"];
    self.groupName         = [aDecoder decodeObjectForKey:@"groupName"];
    self.groupSort         = [[aDecoder decodeObjectForKey:@"groupSort"]integerValue];
    self.gropuApps         = [aDecoder decodeObjectForKey:@"gropuApps"];
  }
  
  return self;
}
@end

@implementation CGGropuAppsEntity
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.appsID      forKey:@"appsID"];
  [aCoder encodeObject:self.name      forKey:@"name"];
  [aCoder encodeObject:self.code      forKey:@"code"];
  [aCoder encodeObject:self.icon      forKey:@"icon"];
  [aCoder encodeObject:self.color      forKey:@"color"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.webpage]      forKey:@"webpage"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.indexSort]      forKey:@"indexSort"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.permission]      forKey:@"permission"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.permissionShow]      forKey:@"permissionShow"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.activation]      forKey:@"activation"] ;
  [aCoder encodeObject:self.viewPrompt      forKey:@"viewPrompt"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.viewPermit]      forKey:@"viewPermit"];
}

//MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"appsID":@"id"};
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.appsID       = [aDecoder decodeObjectForKey:@"appsID"];
    self.name         = [aDecoder decodeObjectForKey:@"name"];
    self.webpage         = [[aDecoder decodeObjectForKey:@"webpage"]integerValue];
    self.indexSort         = [[aDecoder decodeObjectForKey:@"indexSort"]intValue];
    self.icon         = [aDecoder decodeObjectForKey:@"icon"];
    self.code         = [aDecoder decodeObjectForKey:@"code"];
    self.color = [aDecoder decodeObjectForKey:@"color"];
    self.permission = [[aDecoder decodeObjectForKey:@"permission"] integerValue];
    self.permissionShow = [[aDecoder decodeObjectForKey:@"permissionShow"] integerValue];
    self.activation = [[aDecoder decodeObjectForKey:@"activation"] integerValue];
    self.viewPrompt = [aDecoder decodeObjectForKey:@"viewPrompt"];
    self.viewPermit = [[aDecoder decodeObjectForKey:@"viewPermit"] integerValue];    
  }
  
  return self;
}
@end

