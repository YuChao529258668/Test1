//
//  CGUserIndustry.m
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserIndustry.h"

@implementation CGUserIndustry

//归档的实现
//MJCodingImplementation
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.industryId      forKey:@"industryId"];
  [aCoder encodeObject:self.industryName      forKey:@"industryName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.industryId       = [aDecoder decodeObjectForKey:@"industryId"];
    self.industryName       = [aDecoder decodeObjectForKey:@"industryName"];
  }
  
  return self;
}

@end
