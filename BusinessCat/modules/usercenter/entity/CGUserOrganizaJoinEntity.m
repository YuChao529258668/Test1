//
//  CGUserOrganizaJoinEntity.m
//  CGSays
//
//  Created by zhu on 2016/12/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserOrganizaJoinEntity.h"

@implementation CGUserOrganizaJoinEntity
//归档的实现
//MJCodingImplementation

-(CGUserOrganizaAuthResult *)authInfo{
    if(!_authInfo){
        _authInfo = [[CGUserOrganizaAuthResult alloc]init];
    }
    return _authInfo;
}

-(CGAuditInfoEntity *)auditInfo{
  if (!_auditInfo) {
    _auditInfo = [[CGAuditInfoEntity alloc]init];
  }
  return _auditInfo;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:[NSNumber numberWithInt:self.isLoaded]      forKey:@"isLoaded"];
  [aCoder encodeObject:self.companyId      forKey:@"companyId"];
  [aCoder encodeObject:self.classId      forKey:@"classId"];
  [aCoder encodeObject:self.companyName      forKey:@"companyName"];
  [aCoder encodeObject:self.companyFullName      forKey:@"companyFullName"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.companyAdmin]      forKey:@"companyAdmin"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.companyManage]      forKey:@"companyManage"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.companyType]      forKey:@"companyType"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.auditStete]      forKey:@"auditStete"];
  [aCoder encodeObject:self.auditInfo      forKey:@"auditInfo"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.companyState]      forKey:@"companyState"];
  [aCoder encodeObject:self.department      forKey:@"department"];
  [aCoder encodeObject:self.className      forKey:@"className"];
  [aCoder encodeObject:self.departmentId      forKey:@"departmentId"];
  [aCoder encodeObject:self.position      forKey:@"position"];
  [aCoder encodeObject:self.companyLevel      forKey:@"companyLevel"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.isAudit]      forKey:@"isAudit"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.dataSort]      forKey:@"dataSort"];
  [aCoder encodeObject:self.authInfo      forKey:@"authInfo"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.companyVip]      forKey:@"companyVip"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.state]      forKey:@"state"];
  [aCoder encodeObject:self.inviteUrl      forKey:@"inviteUrl"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.isLoaded       = [[aDecoder decodeObjectForKey:@"isLoaded"]intValue];
    self.companyId       = [aDecoder decodeObjectForKey:@"companyId"];
    self.classId       = [aDecoder decodeObjectForKey:@"classId"];
    self.companyName       = [aDecoder decodeObjectForKey:@"companyName"];
    self.companyFullName       = [aDecoder decodeObjectForKey:@"companyFullName"];
    self.companyAdmin       = [[aDecoder decodeObjectForKey:@"companyAdmin"]intValue];
    self.companyManage       = [[aDecoder decodeObjectForKey:@"companyManage"]intValue];
    self.companyType       = [[aDecoder decodeObjectForKey:@"companyType"]intValue];
    self.auditStete       = [[aDecoder decodeObjectForKey:@"auditStete"]intValue];
    self.auditInfo       = [aDecoder decodeObjectForKey:@"auditInfo"];
    self.companyState       = [[aDecoder decodeObjectForKey:@"companyState"]intValue];
    self.department       = [aDecoder decodeObjectForKey:@"department"];
    self.className       = [aDecoder decodeObjectForKey:@"className"];
    self.departmentId       = [aDecoder decodeObjectForKey:@"departmentId"];
    self.position       = [aDecoder decodeObjectForKey:@"position"];
    self.companyLevel       = [aDecoder decodeObjectForKey:@"companyLevel"];
    self.isAudit       = [[aDecoder decodeObjectForKey:@"isAudit"]intValue];
    self.dataSort       = [[aDecoder decodeObjectForKey:@"dataSort"]intValue];
    self.authInfo       = [aDecoder decodeObjectForKey:@"authInfo"];
    self.companyVip       = [[aDecoder decodeObjectForKey:@"companyVip"]integerValue];
    self.state       = [[aDecoder decodeObjectForKey:@"state"]integerValue];
    self.inviteUrl = [aDecoder decodeObjectForKey:@"inviteUrl"];
  }
  
  return self;
}
@end

@implementation CGAuditInfoEntity
//归档的实现
//MJCodingImplementation

-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:[NSNumber numberWithInteger:self.frequency]      forKey:@"frequency"];
  [aCoder encodeObject:self.reason      forKey:@"reason"];
  [aCoder encodeObject:self.rejectUid      forKey:@"rejectUid"];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.time]      forKey:@"time"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.frequency       = [[aDecoder decodeObjectForKey:@"frequency"]integerValue];
    self.reason       = [aDecoder decodeObjectForKey:@"reason"];
    self.rejectUid       = [aDecoder decodeObjectForKey:@"rejectUid"];
    self.time       = [[aDecoder decodeObjectForKey:@"time"]integerValue];
  }
  
  return self;
}
@end
