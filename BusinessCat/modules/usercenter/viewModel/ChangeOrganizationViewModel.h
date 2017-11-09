//
//  ChangeOrganizationViewModel.h
//  CGSays
//
//  Created by zhu on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGUserOrganizaJoinEntity.h"
typedef NS_ENUM(NSInteger, ChangeOrganizationType) {
  ChangeOrganizationTypeSuperAdminYetClaimed = 0,  //企业管家、加入审核 、认领组织 通讯录、邀请成员、团队特权
  ChangeOrganizationSuperAdmin               = 1,  // 企业管家、加入审核、 通讯录、邀请成员、团队特权
  ChangeOrganizationYetClaimed               = 2,  //企业管家、认领组织 通讯录、邀请成员、团队特权
  ChangeOrganizationBasicPermissions         = 3,  //企业管家、通讯录、邀请成员、团队特权
  ChangeOrganizationNone                     = 4   //企业管家
};

typedef NS_ENUM(NSInteger, OrganizationType) {
  OrganizationTypeYetClaimed              = 0,  //组织未认证
  OrganizationTypeClaimedInReview         = 1,  //待审核中
  OrganizationTypeClaimedNoneVip          = 2,  //购买企业VIP
  OrganizationTypeClaimedjoin             = 3,  //已加入
  OrganizationTypeClaimednotThroughReview = 4,  //审核不通过
  OrganizationTypeClaimedIng              = 5,   //认领中
  OrganizationTypeClaimedFail             = 6,   //认领失败
  OrganizationTypeInvitationing           = 7,   //邀请中
  OrganizationTypeQuit                    = 1000   //退出组织操作，用于所属组织列表编辑模式的识别
};
@interface ChangeOrganizationViewModel : NSObject
+(ChangeOrganizationType)getChangeOrganizationState;
+(NSInteger)getOrganizationSuperAdminCount;
+(NSInteger)getOrganizationYetClaimedCount;
+(NSInteger)getOrganizationPrivilegeCount;
+(BOOL)isOrganizationPrivilege;
+(OrganizationType)getChangeOrganizationState:(CGUserOrganizaJoinEntity *)entity;

@end
