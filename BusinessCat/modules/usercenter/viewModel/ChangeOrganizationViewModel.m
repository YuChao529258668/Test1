//
//  ChangeOrganizationViewModel.m
//  CGSays
//
//  Created by zhu on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "ChangeOrganizationViewModel.h"

@implementation ChangeOrganizationViewModel
+(ChangeOrganizationType)getChangeOrganizationState{
    BOOL isSupperAdmin = NO;
    BOOL isHaveYetClaimed = NO;
    BOOL isHaveBasicPermissions = NO;
  if ([ObjectShareTool sharedInstance].currentUser.companyList.count<=0||[ObjectShareTool sharedInstance].currentUser.isLogin == NO) {
    return ChangeOrganizationTypeSuperAdminYetClaimed;
  }else{
    for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (entity.companyAdmin) {
        isSupperAdmin = YES;
        isHaveBasicPermissions = YES;
      }
      if (entity.companyState == 0) {
        //未认领，先认领
        isHaveYetClaimed = YES;
        isHaveBasicPermissions = YES;
        
      }else if (entity.companyState == 1){
        //已经认领
        if(entity.auditStete == 0){
          //待审核
        }else if(entity.auditStete == 1){
          //等级为真
          isHaveBasicPermissions = YES;
        }else if(entity.auditStete == 2){
          //审核不通过
        }
      }
    }
    if (isSupperAdmin&&isHaveYetClaimed&&isHaveBasicPermissions) {
      return ChangeOrganizationTypeSuperAdminYetClaimed;
    }else if (isSupperAdmin&&isHaveBasicPermissions){
      return ChangeOrganizationSuperAdmin;
    }else if (isHaveYetClaimed&&isHaveBasicPermissions){
      return ChangeOrganizationYetClaimed;
    }else if (isHaveBasicPermissions){
      return ChangeOrganizationBasicPermissions;
    }else{
      return ChangeOrganizationNone;
    }
  }
}

+(NSInteger)getOrganizationSuperAdminCount{
    int count = 0;
    for (CGUserOrganizaJoinEntity *entity in [ObjectShareTool sharedInstance].currentUser.companyList) {
        if (entity.companyAdmin) {
            count += 1;
        }
    }
    return count;
}

+(NSInteger)getOrganizationYetClaimedCount{
    int count = 0;
    for (CGUserOrganizaJoinEntity *entity in [ObjectShareTool sharedInstance].currentUser.companyList) {
        if (entity.companyState == 0&&entity.companyType !=4) {
            count += 1;
        }
    }
    return count;
}

+(NSInteger)getOrganizationPrivilegeCount{
  int count = 0;
  for (CGUserOrganizaJoinEntity *entity in [ObjectShareTool sharedInstance].currentUser.companyList) {
    if (entity.companyVip == 0) {
      count += 1;
    }
  }
  return count;
}

+(BOOL)isOrganizationPrivilege{
  BOOL count = 0;
  for (CGUserOrganizaJoinEntity *entity in [ObjectShareTool sharedInstance].currentUser.companyList) {
    if (entity.companyVip == 1) {
      count = 1;
      break;
    }
  }
  return count;
}

+(OrganizationType)getChangeOrganizationState:(CGUserOrganizaJoinEntity *)entity{
  if (entity.state == 4){
    //邀请中
    return  OrganizationTypeInvitationing;
  }else if (entity.companyState == 0) {
        //未认领，先认领
        return OrganizationTypeYetClaimed;
    }else if (entity.companyState == 1){
        //已经认领
        if(entity.auditStete == 0){
            //待审核
            return OrganizationTypeClaimedInReview;
        }else if(entity.auditStete == 1){
            //等级为真
            if ([CTStringUtil stringNotBlank:entity.companyLevel]) {
                return OrganizationTypeClaimedjoin;
            }else{
                return OrganizationTypeClaimedNoneVip;
            }
        }else if(entity.auditStete == 2){
            //审核不通过
            return OrganizationTypeClaimednotThroughReview;
        }
    }else if (entity.companyState == 2) {
        //认领中
        return OrganizationTypeClaimedIng;
    }else if(entity.companyState == 3){
        return OrganizationTypeClaimedFail;
    }
    return 0;
}
@end
