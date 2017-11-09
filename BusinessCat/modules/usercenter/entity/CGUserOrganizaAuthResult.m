//
//  CGUserOrganizaAuthResult.m
//  CGSays
//
//  Created by mochenyang on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserOrganizaAuthResult.h"

@implementation CGUserOrganizaAuthResult
//归档的实现
//MJCodingImplementation
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.organizaName      forKey:@"organizaName"];
  [aCoder encodeObject:self.name      forKey:@"name"];
  [aCoder encodeObject:self.legalPerson      forKey:@"legalPerson"];
  [aCoder encodeObject:self.additional      forKey:@"additional"];
  [aCoder encodeObject:self.authExplain      forKey:@"authExplain"];
  [aCoder encodeObject:self.image      forKey:@"image"];
  [aCoder encodeObject:self.verifyCode      forKey:@"verifyCode"];
  [aCoder encodeObject:self.reason      forKey:@"reason"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.organizaName       = [aDecoder decodeObjectForKey:@"organizaName"];
    self.name       = [aDecoder decodeObjectForKey:@"name"];
    self.legalPerson       = [aDecoder decodeObjectForKey:@"legalPerson"];
    self.additional       = [aDecoder decodeObjectForKey:@"additional"];
    self.authExplain       = [aDecoder decodeObjectForKey:@"authExplain"];
    self.image       = [aDecoder decodeObjectForKey:@"image"];
    self.verifyCode       = [aDecoder decodeObjectForKey:@"verifyCode"];
    self.reason       = [aDecoder decodeObjectForKey:@"reason"];
  }
  
  return self;
}
@end
