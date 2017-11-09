//
//  CGUserOrganizaJoinEntity.h
//  CGSays
//
//  Created by zhu on 2016/12/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  用户加入组织实体

#import <Foundation/Foundation.h>
#import "CGUserOrganizaAuthResult.h"

@class CGAuditInfoEntity;

@interface CGUserOrganizaJoinEntity : NSObject
@property(nonatomic,assign)BOOL isLoaded;//判断是否已经请求过，用于控制空显示，无其他作用

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyFullName;
@property(nonatomic,assign)int companyAdmin;//是否为超级管理员
@property (nonatomic, assign) int companyManage;//当前用户是否是公司管理
@property (nonatomic, assign) int companyType;//1企业，2学校 3创客 4其他
@property (nonatomic, assign) int auditStete;//用户申请状态 0待审核，1审核通过，2审核不通过
@property(nonatomic,assign)int companyState;//0-未认证，1-已认证 2-认证中 3-认证不通过
@property(nonatomic,retain)NSString *department;
@property(nonatomic,retain)NSString *className;
@property(nonatomic,retain)NSString *departmentId;
@property(nonatomic,retain)NSString *position;
@property(nonatomic,retain)NSString *companyLevel;
@property(nonatomic,assign)int isAudit;//是否需要审核
@property(nonatomic,assign)int dataSort;
@property (nonatomic, assign) NSInteger companyVip;
@property (nonatomic, assign) NSInteger state;
@property(nonatomic,retain)NSString *scoopCover;//企业圈封面
@property (nonatomic, copy) NSString *inviteUrl;//邀请链接

@property(nonatomic,retain)CGUserOrganizaAuthResult *authInfo;//认证结果信息
@property(nonatomic,retain)NSMutableArray *auditInfo;//用户加入组织审核信息，比如被拒绝时会有
@end

@interface CGAuditInfoEntity : NSObject
@property (nonatomic, assign) NSInteger frequency;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *rejectUid;
@property (nonatomic, assign) NSInteger time;
@end















