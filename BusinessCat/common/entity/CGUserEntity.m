//
//  CGUserEntity.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserEntity.h"
#import "CGUserOrganizaJoinEntity.h"


@implementation CGUserEntity
-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.uuid      forKey:@"uuid"];
  [aCoder encodeObject:self.secuCode      forKey:@"secuCode"];
  [aCoder encodeObject:self.token      forKey:@"token"];
  [aCoder encodeObject:self.openid      forKey:@"openid"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.bindWeixin]      forKey:@"bindWeixin"];
  [aCoder encodeObject:self.nickname      forKey:@"nickname"];
  [aCoder encodeObject:self.username      forKey:@"username"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.isVip]      forKey:@"isVip"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.vipDays]      forKey:@"vipDays"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.vipTime]      forKey:@"vipTime"];
  [aCoder encodeObject:self.portrait      forKey:@"portrait"];
  [aCoder encodeObject:self.grade      forKey:@"grade"];
  [aCoder encodeObject:self.gradeName      forKey:@"gradeName"];
  [aCoder encodeObject:self.qrcode      forKey:@"qrcode"];
  [aCoder encodeObject:self.gender      forKey:@"gender"];
  [aCoder encodeObject:self.phone      forKey:@"phone"];
  [aCoder encodeObject:self.userIntro      forKey:@"userIntro"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.messageNum]      forKey:@"messageNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.readMessageNum]      forKey:@"readMessageNum"];
//    [aCoder encodeObject:[NSNumber numberWithInt:self.integralNum]     forKey:@"integralNum"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.integralNum]     forKey:@"integralNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.followNum]      forKey:@"followNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.orderNum]      forKey:@"orderNum"];
  [aCoder encodeObject:[NSNumber numberWithFloat:self.totalAmount]      forKey:@"totalAmount"];
  [aCoder encodeObject:self.organization      forKey:@"organization"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.isLogin]      forKey:@"isLogin"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.auditNum]      forKey:@"auditNum"];
  [aCoder encodeObject:self.email      forKey:@"email"];
  [aCoder encodeObject:self.skills      forKey:@"skills"];
  [aCoder encodeObject:self.statistics      forKey:@"statistics"];
  [aCoder encodeObject:self.industry      forKey:@"industry"];
  [aCoder encodeObject:self.companyList forKey:@"companyList"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.updateName]      forKey:@"updateName"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.housekeeper]      forKey:@"housekeeper"];
    
    [aCoder encodeObject:self.txy forKey:@"txy"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.uuid       = [aDecoder decodeObjectForKey:@"uuid"];
    self.secuCode       = [aDecoder decodeObjectForKey:@"secuCode"];
    self.token       = [aDecoder decodeObjectForKey:@"token"];
    self.openid       = [aDecoder decodeObjectForKey:@"openid"];
    self.bindWeixin       = [[aDecoder decodeObjectForKey:@"bindWeixin"] intValue];
    self.nickname       = [aDecoder decodeObjectForKey:@"nickname"];
    self.username       = [aDecoder decodeObjectForKey:@"username"];
    self.isVip       = [[aDecoder decodeObjectForKey:@"isVip"] intValue];
    self.vipDays       = [[aDecoder decodeObjectForKey:@"vipDays"]intValue];
    self.vipTime       = [[aDecoder decodeObjectForKey:@"vipTime"]intValue];
    self.portrait       = [aDecoder decodeObjectForKey:@"portrait"];
    self.grade       = [aDecoder decodeObjectForKey:@"grade"];
    self.gradeName       = [aDecoder decodeObjectForKey:@"gradeName"];
    self.qrcode       = [aDecoder decodeObjectForKey:@"qrcode"];
    self.gender       = [aDecoder decodeObjectForKey:@"gender"];
    self.phone       = [aDecoder decodeObjectForKey:@"phone"];
    self.userIntro       = [aDecoder decodeObjectForKey:@"userIntro"];
    self.messageNum       = [[aDecoder decodeObjectForKey:@"messageNum"]intValue];
    self.readMessageNum       = [[aDecoder decodeObjectForKey:@"readMessageNum"]intValue];
//      self.integralNum       = [[aDecoder decodeObjectForKey:@"integralNum"]intValue];
      self.integralNum       = [[aDecoder decodeObjectForKey:@"integralNum"]doubleValue];
    self.followNum       = [[aDecoder decodeObjectForKey:@"followNum"]intValue];
    self.orderNum       = [[aDecoder decodeObjectForKey:@"orderNum"]intValue];
    self.totalAmount       = [[aDecoder decodeObjectForKey:@"totalAmount"]floatValue];
    self.organization       = [aDecoder decodeObjectForKey:@"organization"];
    self.isLogin       = [[aDecoder decodeObjectForKey:@"isLogin"]intValue];
    self.auditNum       = [[aDecoder decodeObjectForKey:@"auditNum"]intValue];
    self.email       = [aDecoder decodeObjectForKey:@"email"];
    self.skills       = [aDecoder decodeObjectForKey:@"skills"];
    self.statistics       = [aDecoder decodeObjectForKey:@"statistics"];
    self.industry       = [aDecoder decodeObjectForKey:@"industry"];
    self.companyList       = [aDecoder decodeObjectForKey:@"companyList"];
    self.updateName      = [[aDecoder decodeObjectForKey:@"updateName"]integerValue];
    self.housekeeper = [[aDecoder decodeObjectForKey:@"housekeeper"]integerValue];
      
      self.txy = [aDecoder decodeObjectForKey:@"txy"];
  }
  
  return self;
}

//归档的实现
//MJCodingImplementation

-(CGUserStatistics *)statistics{
    if(!_statistics){
        _statistics = [[CGUserStatistics alloc]init];
    }
    return _statistics;
}

- (void)setTxy:(NSDictionary *)txy {
    _txy = txy;
    self.txyIdentifier = txy[@"Identifier"];
    self.txyUsersig = txy[@"Usersig"];
}

- (NSString *)getCompanyID {
    return self.companyList.firstObject.companyId;
}

- (NSString *)defaultPosition {
    return self.companyList.firstObject.department;
}

@end
