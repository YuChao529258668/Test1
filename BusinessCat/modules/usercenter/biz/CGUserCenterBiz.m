//  CGUserCenterBiz.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCenterBiz.h"
#import "ObjectShareTool.h"
#import "CGUserDao.h"
#import "CGUserIndustryListEntity.h"
#import "CGUserCompanyAuditListEntity.h"
#import "CGUserCompanyContactsEntity.h"
#import "CGInfoHeadEntity.h"
#import "CGUserDepaEntity.h"
#import "CGTagsEntity.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserPhoneContactEntity.h"
#import "CGUserWalletListEntity.h"
#import "CGCompanyDao.h"
#import "CGUserDao.h"
#import "CGSourceCircleEntity.h"
#import "CGIntegralEntity.h"
#import "CGOrderProgressEntity.h"
#import "CGSearchSourceCircleEntity.h"
#import "CGMessageEntity.h"
#import "CGMessageDetailEntity.h"
#import "CGUserHelpCateEntity.h"
#import "CGUserHelpCateListEntity.h"
#import "CGGradesPackageEntity.h"
#import "UMessage.h"
#import "KnowledgeAlbumEntity.h"
#import "TeamCircleLastStateEntity.h"

@implementation CGUserCenterBiz


-(void)getToken:(void(^)(NSString * uuid,NSString *token))complete fail:(void (^)(NSError *error))fail{
    NSLog(@"调用获取token接口进行token的检查。。。。。。");
    NSNumber *timestamp = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]*1000];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:timestamp forKey:@"timestamp"];
    if([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.secuCode]){
        NSString *secuCode = [ObjectShareTool sharedInstance].currentUser.secuCode;
        [param setObject:secuCode forKey:@"secuCode"];
    }else{
//      UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没传secucode" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//      [al show];
        NSLog(@"没传secucode %@", NSStringFromSelector(_cmd));
    }
    [self.component sendPostRequestWithURL:URL_USER_TOKEN param:param success:^(id data) {
        NSLog(@"获取token接口回调：%@",data);
        NSString *secuCode = [data objectForKey:@"secuCode"];
        NSString *token = [data objectForKey:@"token"];
        if (token) {
            if([[[CGUserDao alloc]init] saveUserWithSecuCode:secuCode token:token]){
                complete(secuCode,token);
            }else{
                fail(nil);
            }
        }
    } fail:^(NSError *error){
        NSLog(@"获取token接口失败回调：%@",error);
        fail(error);
    }];
}

//获取登录验证码
-(void)getLoginVerifyCodeByPhone:(NSString *)phone success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    [self.component sendPostRequestWithURL:URL_USER_GET_VERIFYCODE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//登录
-(void)loginWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode success:(void(^)(CGUserEntity *user))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",verifyCode,@"verifyCode", nil];
    [self.component sendPostRequestWithURL:URL_USER_LOGIN param:param success:^(id data) {
        NSString *uuid = [data objectForKey:@"uuid"];
        NSString *token = [data objectForKey:@"token"];
        if([[[CGUserDao alloc]init] saveUserWithSecuCode:uuid token:token]){
            success([ObjectShareTool sharedInstance].currentUser);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//重新绑定手机
-(void)authUserChangephoneWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",verifyCode,@"verifyCode", nil];
  [self.component sendPostRequestWithURL:URL_USER_CHANGEPHONE param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//获取用户信息
-(void)queryUserDetailInfoWithCode:(NSString *)code success:(void(^)(CGUserEntity *user))success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if ([CTStringUtil stringNotBlank:code]) {
    [param setObject:code forKey:@"code"];
  }
    [self.component sendPostRequestWithURL:URL_USER_DETAIL param:param success:^(id data) {
        [CGUserEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"skills" : @"CGUserRoles",
                     @"industry" : @"CGUserIndustry",
                     @"companyList":@"CGUserOrganizaJoinEntity"
                     };
        }];
      [CGUserOrganizaJoinEntity mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"auditInfo" : @"CGAuditInfoEntity",
                 };
      }];
        
        CGUserEntity *user = [CGUserEntity mj_objectWithKeyValues:data];
      [UMessage addAlias:user.uuid type:UMessagePush_Alias response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        
      }];
        [ObjectShareTool sharedInstance].currentUser = user;
      if (user.isLogin == YES) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:[TeamCircleLastStateEntity getFromLocal]];
      }else{
        TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
        entity.badge.userName = nil;
        entity.badge.portrait = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:entity];
      }
      if ([ObjectShareTool sharedInstance].isloginState == 1) {
        [ObjectShareTool sharedInstance].isloginState = 0;
        NSString *message = [NSString stringWithFormat:@"准备清除用户信息但我没清--uuid:%@,identity:%@,token:%@,isLogin:%d",[ObjectShareTool sharedInstance].currentUser.uuid,[CTDeviceTool getUniqueDeviceIdentifierAsString],[ObjectShareTool sharedInstance].currentUser.token,0];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
      }
      if (user.isLogin == 0) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [[CTToast makeText:@"用户信息返回没有登录"]show:window];
          NSLog(@"尝试获取用户信息：用户没有登录 %@", NSStringFromSelector(_cmd));
      }
        if(user.isLogin == 0 && [CTStringUtil stringNotBlank:user.phone]){
            [[[CGUserDao alloc]init]cleanLoginedUser];
            [self getToken:^(NSString *uuid, NSString *token) {
                success([ObjectShareTool sharedInstance].currentUser);
            } fail:^(NSError *error) {
                success([ObjectShareTool sharedInstance].currentUser);
            }];
        }else{
            [[[CGUserDao alloc]init]saveLoginedInLocal:user];
            success(user);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户消息标签接口
-(void)userMessageTagsWithSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_USER_MESSAGE_TAGS param:nil success:^(id data) {
    NSDictionary *dic = data;
    NSArray *array = dic[@"basics"];
    success(array.mutableCopy);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//修改用户信息
-(void)updateUserInfoWithUsername:(NSString *)username nickname:(NSString *)nickname gender:(NSString *)gender portrait:(NSString *)portrait email:(NSString *)email addSkillIds:(NSMutableArray *)addSkillIds delSkillIds:(NSMutableArray *)delSkillIds skillLevel:(NSInteger)skillLevel success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (username.length>0) {
        [param setObject:username forKey:@"username"];
    }
    if (nickname.length>0) {
        [param setObject:nickname forKey:@"nickname"];
    }
    if (gender.length>0){
        [param setObject:gender forKey:@"gender"];
    }
    if (portrait.length>0) {
        [param setObject:portrait forKey:@"portrait"];
    }
    if (email.length>0) {
        [param setObject:email forKey:@"email"];
    }
    if (addSkillIds.count>0) {
        [param setObject:addSkillIds forKey:@"addSkillIds"];
    }
    if (delSkillIds.count>0) {
        [param setObject:delSkillIds forKey:@"delSkillIds"];
    }
  
  if (skillLevel>0) {
    [param setObject:[NSNumber numberWithInteger:skillLevel] forKey:@"skillLevel"];
  }
  
    [self.component sendPostRequestWithURL:URL_USER_UPDATE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织信息编辑接口
-(void)authUserOrganizaEditWithCompanyid:(NSString *)companyid companytype:(NSInteger)companytype companyicon:(NSString *)companyicon companyname:(NSString *)companyname companyphone:(NSString *)companyphone companyhttp:(NSString *)companyhttp email:(NSString *)email employeesnum:(NSInteger)employeesnum city:(NSString *)city area:(NSString *)area province:(NSString *)province addKnowledge:(NSMutableArray *)addKnowledge delKnowledge:(NSMutableArray *)delKnowledge address:(NSString *)address success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:companyid,@"companyid",[NSNumber numberWithInteger:companytype],@"companytype", nil];
  if ([CTStringUtil stringNotBlank:companyicon]) {
    [param setObject:companyicon forKey:@"companyicon"];
  }
  if ([CTStringUtil stringNotBlank:companyname]) {
    [param setObject:companyname forKey:@"companyname"];
  }
  if ([CTStringUtil stringNotBlank:companyphone]) {
    [param setObject:companyphone forKey:@"companyphone"];
  }
  if ([CTStringUtil stringNotBlank:companyhttp]) {
    [param setObject:companyhttp forKey:@"companyhttp"];
  }
  if ([CTStringUtil stringNotBlank:email]) {
    [param setObject:email forKey:@"email"];
  }
  if (employeesnum>0) {
    [param setObject:[NSNumber numberWithInteger:employeesnum] forKey:@"employeesnum"];
  }
  if ([CTStringUtil stringNotBlank:city]) {
    [param setObject:city forKey:@"city"];
  }
  if ([CTStringUtil stringNotBlank:area]) {
    [param setObject:area forKey:@"area"];
  }
  if ([CTStringUtil stringNotBlank:province]) {
    [param setObject:province forKey:@"province"];
  }
  if ([CTStringUtil stringNotBlank:address]) {
    [param setObject:address forKey:@"address"];
  }
  
  if (addKnowledge.count>0) {
    [param setObject:addKnowledge forKey:@"addKnowledge"];
  }
  
  if (delKnowledge.count>0) {
    [param setObject:delKnowledge forKey:@"delKnowledge"];
  }
  
  [self.component sendPostRequestWithURL:URL_USER_ORGANIZEA_EDIT param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//组织信息获取接口
-(void)authUserOrganizaInfoWithCompanyidWith:(NSString *)companyid companytype:(NSInteger)companytype success:(void(^)(CGOrganizationEntity *result))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:companyid,@"companyid",[NSNumber numberWithInteger:companytype],@"companytype", nil];
  [self.component sendPostRequestWithURL:URL_USER_ORGANIZEA_INFO param:param success:^(id data) {
    [CGOrganizationEntity mj_setupObjectClassInArray:^NSDictionary *{
      return @{
               @"knowledge" : @"CGknowledgeEntity"
               };
    }];
    CGOrganizationEntity *user = [CGOrganizationEntity mj_objectWithKeyValues:data];
    success(user);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//公司组织搜索接口
-(void)userCompanySearchWithkeyword:(NSString *)keyword type:(NSNumber *)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInt:1],@"page", nil];
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    
    [self.component sendPostRequestWithURL:URL_USER_COMPANYSEARCH param:param success:^(id data) {
        success([CGUserSearchCompanyEntity mj_objectArrayWithKeyValuesArray:data]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司组织申请加入
-(void)userCompanyJoinWithCompangyID:(NSString *)companyID depaId:(NSString *)depaId type:(NSInteger )type classId:(NSString *)classId position:(NSString *)position startTime:(NSString *)startTime success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:companyID forKey:@"id"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (depaId) {
        [param setObject:depaId forKey:@"depaId"];
    }
    if (classId) {
        [param setObject:classId forKey:@"classId"];
    }
    if (position) {
        [param setObject:position forKey:@"position"];
    }
    if (startTime) {
        [param setObject:startTime forKey:@"startTime"];
    }
    [self.component sendPostRequestWithURL:URL_USER_COMPANYJOIN param:param success:^(id data) {
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//行业列表
-(void)IndustrySsuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_INDUSTRYLIST param:nil success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserIndustryListEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserIndustryListEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司组织创建接口
-(void)companyCreateWithCompanyName:(NSString *)companyName companyType:(int )companyType industryId:(NSString *)industryId scaleLevel:(int )scaleLevel success:(void(^)(NSString *companyID,NSNumber *companyType))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:companyName,@"name",[NSNumber numberWithInt:companyType],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_COMPANYCREAT param:param success:^(id data) {
        NSDictionary *dic = data;
        NSNumber *type = dic[@"type"];
        NSString *companyID = dic[@"id"];
        success(companyID,type);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司加入审核列表
-(void)userCompanyAuditListWithOrganizaId:(NSString *)organizaId type:(int)type Page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    if(organizaId){
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page", nil];
        [self.component sendPostRequestWithURL:URL_USER_COMPANYAUDITLIST param:param success:^(id data) {
            NSMutableArray *array = data;
            CGUserCompanyAuditListEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserCompanyAuditListEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        } fail:^(NSError *error) {
            fail(error);
        }];
    }else{
        fail(nil);
    }
}

//公司审核员工操作
-(void)userCompanyAuditWithUserID:(NSString *)userID organizaId:(NSString *)organizaId organizaType:(int)organizaType action:(int )action reason:(NSString *)reason success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"userId",organizaId,@"organizeId",[NSNumber numberWithInt:organizaType],@"organizeType",[NSNumber numberWithInt:action],@"action", nil];
    if ([CTStringUtil stringNotBlank:reason]) {
        [param setObject:reason forKey:@"reason"];
    }
    [self.component sendPostRequestWithURL:URL_USER_COMPANYAUDIT param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司特权数据接口
-(void)userCompanyPrivilegeSuccess:(void(^)(CGUserCompanyPrivilegeEntity *result))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_COMPANYPRIVILEGE param:nil success:^(id data) {
        CGUserCompanyPrivilegeEntity *detail = [CGUserCompanyPrivilegeEntity mj_objectWithKeyValues:data];
        success(detail);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司&管理员认证
-(void)userCompanyAttestation:(CGUserOrganizaJoinEntity *)authEntity success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:authEntity.authInfo.additional,@"additional",[NSNumber numberWithInteger:authEntity.companyType],@"type",authEntity.authInfo.name,@"name", nil];
    if(authEntity.companyType != 2){
        [param setObject:authEntity.authInfo.legalPerson forKey:@"legalPerson"];
        [param setObject:authEntity.authInfo.organizaName forKey:@"organizaName"];
        [param setObject:authEntity.companyId forKey:@"id"];
    }else{
        [param setObject:authEntity.classId forKey:@"id"];
    }
    
    if([CTStringUtil stringNotBlank:authEntity.authInfo.verifyCode]){
        [param setObject:authEntity.authInfo.verifyCode forKey:@"verifyCode"];
    }
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_AUTH param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//通讯录接口
-(void)userCompanyContactsWithKeyword:(NSString *)keyword organizaId:(NSString *)organizaId type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",organizaId,@"id", nil];
    if(keyword){
        [param setObject:keyword forKey:@"keyword"];
    }
    [self.component sendPostRequestWithURL:URL_USER_COMPANYCONTACT param:param success:^(id data) {
        NSMutableArray *array = data;
        NSMutableArray *result = [NSMutableArray array];
        if(array && array.count > 0){
            CGUserCompanyContactsEntity *comment;
            for(NSDictionary *dict in array){
                comment = [CGUserCompanyContactsEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//退出登录
-(void)userLogoutSuccess:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_LOGOUT param:nil success:^(id data) {
      [UMessage removeAlias:[ObjectShareTool sharedInstance].currentUser.uuid type:UMessagePush_Alias response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        
      }];
        [[[CGUserDao alloc]init]cleanLoginedUser];
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询用户收藏数据
-(void)getUserCollectionDataWithLabel:(int)label page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:label],@"label",[NSNumber numberWithInteger:page],@"page", nil];
    [self.component sendPostRequestWithURL:URL_USER_COLLECTION param:param success:^(id data) {
      NSArray *array = data;
//      if(array && array.count > 0){
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
          NSNumber *type = dict[@"type"];
          if (type.integerValue == 26) {
            [result addObject:[KnowledgeHeaderEntity mj_objectWithKeyValues:dict]];
          }else{
            CGInfoHeadEntity *comment = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
           comment.cover = [comment.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             [result addObject:comment];
          }
        }
        success(result);
//      }else{
//        fail(nil);
//      }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织获取部门列表
-(void)authUserOrganizaDepaListWithOrganizaID:(NSString *)OrganizaID type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:OrganizaID,@"id",[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_DEPA_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserDepaEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserDepaEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织获取角色列表
-(void)organizaRoleListWithType:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_ROLE_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserDepaEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserDepaEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织创建部门
-(void)organizaCreateDepaWithDepaID:(NSString *)depaID type:(NSInteger )type name:(NSString *)name success:(void(^)(NSString *depaID))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",depaID,@"id",name,@"name", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_CREATE_DEPA param:param success:^(id data) {
        NSDictionary *dic = data;
        success(dic[@"id"]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//学校创建班级
-(void)organizaCreateClassWithClassID:(NSString *)classID depaId:(NSString *)depaId name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:classID,@"id",depaId,@"depaId",name,@"name", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_CREATE_CLASS param:param success:^(id data) {
        
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//学校获取班级接口
-(void)organizaClassListWithSchoolID:(NSString *)schoolID depaId:(NSString *)depaId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:schoolID,@"id",depaId,@"depaId", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_CLASS_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserDepaEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserDepaEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//标签分类列表接口
-(void)commonTagsListWith:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_COMMON_TAGS_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            [CGTagsEntity mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"tags" : @"CGTags",
                         };
            }];
            CGTagsEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGTagsEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//标签行业分类列表接口
-(void)commonIndustryListWithSuccess:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_COMMON_INDUSTRY_LIST param:nil success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGTags *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGTags mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织部门重命名接口
-(void)userOrganizaDepaUpdateWithOrganizaId:(NSString *)organizaId depaId:(NSString *)depaId type:(NSInteger)type name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"organizaId",depaId,@"depaId",[NSNumber numberWithInteger:type],@"type",name,@"name", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_DEPA_UPDATE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织部门删除接口
-(void)userOrganizaDepaDeleteWithOrganizaId:(NSString *)organizaId depaId:(NSString *)depaId type:(NSInteger)type success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",depaId,@"depaId",[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_DEPA_DELETE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户切换组织接口
-(void)userOrganizaSwitchWithID:(NSString *)companyID success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:companyID,@"id",nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZA_SWITCH param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//通讯录上传匹配接口
-(void)authCommonPhonebookWithPhones:(NSMutableArray *)phones companyId:(NSString *)companyId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:companyId forKey:@"companyId"];
    if (phones.count>0) {
        [param setObject:phones forKey:@"phones"];
    }
    [self.component sendPostRequestWithURL:URL_COMMON_PHONEBOOK param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserPhoneContactEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserPhoneContactEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//邀请同事短信接口
-(void)authUserInvitationWithPhone:(NSString *)phone organizaId:(NSString *)organizaId organizaType:(int)organizaType success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",organizaId,@"id",[NSNumber numberWithInt:organizaType],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_INVITATION param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//登录获取语音验证码接口
-(void)userVoiceVerifycodeWithPhone:(NSString *)phone success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObject:phone forKey:@"phone"];
    [self.component sendPostRequestWithURL:URL_USER_VOICE_VERIFYCODE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户退出组织接口
-(void)userOrganizaExitWithID:(NSString *)organizationID type:(int)type success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizationID,@"id",[NSNumber numberWithInt:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZE_EXIT param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户微信信息绑定接口
-(void)wechatInfoUpdateWithNickname:(NSString *)nickname gender:(int)gender openid:(NSString *)openid portrait:(NSString *)portrait unionid:(NSString *)unionid op:(BOOL)op success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:nickname,@"nickname",[NSNumber numberWithInt:gender],@"gender",openid,@"openid",unionid,@"unionid",[NSNumber numberWithBool:op],@"op", nil];
    if ([CTStringUtil stringNotBlank:portrait]) {
        [param setObject:portrait forKey:@"portrait"];
    }
    [self.component sendPostRequestWithURL:URL_USER_WECHAT_INFO_UPDATE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//钱包基础信息接口
-(void)authUserWalletInfoSuccess:(void(^)(CGUserWalletInfoEntity *reslut))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_WALLET_INFO param:nil success:^(id data) {
        NSDictionary *dic = data;
        CGUserWalletInfoEntity *entity = [CGUserWalletInfoEntity mj_objectWithKeyValues:dic];
        success(entity);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//钱包变化记录接口
-(void)authUserWalletListWithType:(NSInteger)type mode:(NSInteger)mode page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:mode],@"mode",[NSNumber numberWithInteger:page],@"page", nil];
    [self.component sendPostRequestWithURL:URL_USER_WALLET_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGUserWalletListEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGUserWalletListEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//钱包提现
-(void)authRedpackWithdrawWithAmount:(NSInteger)amount client_ip:(NSString *)client_ip success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:amount],@"amount",client_ip,@"client_ip", nil];
    [self.component sendPostRequestWithURL:URL_REDPACK_WITHDRAW param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织信息修改接口
-(void)authUserOrganizingUpdateWithID:(NSString *)ID type:(NSInteger)type departmentId:(NSString *)departmentId position:(NSString *)position success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",[NSNumber numberWithInteger:type],@"type", nil];
    if ([CTStringUtil stringNotBlank:departmentId]) {
        [param setObject:departmentId forKey:@"departmentId"];
    }
    if ([CTStringUtil stringNotBlank:position]) {
        [param setObject:position forKey:@"position"];
    }
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZING_UPDATE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//认证组织发生短信
-(void)organizaAuthSendSMS:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_ORGANIZASMS param:nil success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//设置普通管理员
-(void)organizaManagerOperatorWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId action:(int)action success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",[NSNumber numberWithInt:organizaType],@"type",userId,@"userId",[NSNumber numberWithInt:action],@"action", nil];
    [self.component sendPostRequestWithURL:URL_ORGANIZING_MANAGE_OPERATOR param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//超级管理员转让
-(void)organizaSuperManagerOperatorWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",[NSNumber numberWithInt:organizaType],@"type",userId,@"userId", nil];
    [self.component sendPostRequestWithURL:URL_ORGANIZING_SUPER_ADMIN param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//组织强制移除用户
-(void)organizaExitUserWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId reason:(NSString *)reason success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",[NSNumber numberWithInt:organizaType],@"type",userId,@"userId",reason,@"reason", nil];
    [self.component sendPostRequestWithURL:URL_ORGANIZING_EXIT_USER param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//所属组织排序
-(void)sortOrganizas:(NSMutableArray *)organizas success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableArray *ids = [NSMutableArray array];
    for(CGUserOrganizaJoinEntity *entity in organizas){
        NSString *organizaId = nil;
        if(entity.companyType == 2){
            organizaId = entity.classId;
        }else{
            organizaId = entity.companyId;
        }
        [ids addObject:[NSDictionary dictionaryWithObjectsAndKeys:organizaId,@"id",[NSNumber numberWithInt:entity.companyType],@"type", nil]];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"organizas", nil];
    [self.component sendPostRequestWithURL:URL_ORGANIZING_SORT param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//意见反馈发表接口
-(void)userFeedbackAddWithContent:(NSString *)content type:(NSInteger)type level:(NSInteger)level linkIcon:(NSString *)linkIcon linkId:(NSString *)linkId linkTitle:(NSString *)linkTitle linkType:(NSInteger)linkType imgList:(NSMutableArray *)imgList success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:content,@"content",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:level],@"level", nil];
    if ([CTStringUtil stringNotBlank:linkId]) {
        [param setObject:linkId forKey:@"linkId"];
        [param setObject:linkTitle forKey:@"linkTitle"];
        [param setObject:[NSNumber numberWithInteger:linkType] forKey:@"linkType"];
        [param setObject:linkIcon forKey:@"linkIcon"];
    }
    if (imgList.count>0) {
        [param setObject:imgList forKey:@"imgList"];
    }
    [self.component sendPostRequestWithURL:URL_USER_FEEDBACK_ADD param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//意见反馈列表接口
-(void)userFeedbackListWithTime:(NSInteger)time mode:(NSInteger)mode success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:mode],@"mode", nil];
    [self.component sendPostRequestWithURL:URL_USER_FEEDBACK_LIST param:param success:^(id data) {
        [CGSourceCircleEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"imgList"  : @"SourceCircImgList",
                     @"praise"   : @"SourceCircPraise",
                     @"comments" : @"SourceCircComments",
                     @"reply"    : @"SourceCircReply",
                     @"payList" : @"SourcePay"
                     };
        }];
        NSMutableArray *array = data;
        CGSourceCircleEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGSourceCircleEntity mj_objectWithKeyValues:dict];
            comment.isFeedback = YES;
            comment.visibility = 1;
            comment.time = [dict[@"createtime"]integerValue];
            if (comment.imgList && ![comment.imgList isKindOfClass:[NSNull class]] && comment.imgList.count > 0) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"imgList"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                comment.imageListJsonStr = json;
            }
            if (comment.praise && ![comment.praise isKindOfClass:[NSNull class]] && comment.praise.count > 0) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"praise"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                comment.praiseJsonStr = json;
            }
            if (comment.comments && ![comment.comments isKindOfClass:[NSNull class]] && comment.comments.count > 0) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"comments"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                comment.commentJsonStr = json;
            }
            if (comment.payList && ![comment.payList isKindOfClass:[NSNull class]] && comment.payList.count > 0) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"payList"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                comment.payJsonStr = json;
            }
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//意见反馈头部信息
-(void)userFeedbackGetInfoWithType:(NSInteger)type success:(void(^)(FeedbackInfoEntity *reslut))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_USER_FEEDBACK_GETINFO param:param success:^(id data) {
    NSDictionary *dic = data;
    success([FeedbackInfoEntity mj_objectWithKeyValues:dic]);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//意见反馈删除接口
-(void)userFeedbackDeleteWithID:(NSString *)ID success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
    [self.component sendPostRequestWithURL:URL_USER_FEEDBACK_DELETE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//意见反馈评论接口
-(void)userFeedbackCommentWithID:(NSString *)ID content:(NSString *)content toUid:(NSString *)toUid success:(void(^)(NSString *commentID))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",content,@"content", nil];
    if ([CTStringUtil stringNotBlank:toUid]) {
        [param setObject:toUid forKey:@"toUid"];
    }
    [self.component sendPostRequestWithURL:URL_USER_FEEDBACK_COMMENT param:param success:^(id data) {
        NSDictionary *dic = data;
        success(dic[@"id"]);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户订单列表接口
-(void)authUserOrderListWithOrderStatus:(NSInteger)orderStatus page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:orderStatus],@"orderStatus",[NSNumber numberWithInteger:page],@"page", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORDER_LIST param:param success:^(id data) {
        [CGOrderEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"relationList"  : @"RelationEntity",
                     @"payResult" : @"CGRewardEntity"
                     };
        }];
        NSMutableArray *array = data;
        NSMutableArray *result = [NSMutableArray array];
        CGOrderEntity *comment;
        for (NSDictionary *dic in array) {
            comment = [CGOrderEntity mj_objectWithKeyValues:dic];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户知识分历史接口
-(void)authUserIntegralHistoryWithTime:(NSInteger)time type:(NSInteger)type success:(void(^)(CGIntegralEntity *reslut))success fail:(void (^)(NSError *error))fail{
    [CGIntegralEntity mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list"  : @"IntegralListEntity",
                 @"relationInfo"      : @"RelationInfoEntity"
                 };
    }];
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_USER_INTEGRAL_HISTORY param:param success:^(id data) {
        CGIntegralEntity *comment = [CGIntegralEntity mj_objectWithKeyValues:data];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户订单进度接口
-(void)authUserOrderScheduleListWIthOrderId:(NSString *)orderId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:orderId,@"orderId", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORDER_SCHEDULE_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        NSMutableArray *result = [NSMutableArray array];
        CGOrderProgressEntity *comment;
        for (NSDictionary *dic in array) {
            comment = [CGOrderProgressEntity mj_objectWithKeyValues:dic];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//获取VIP信息接口
-(void)userPrivilegeWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(CGCorporateMemberEntity *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if ([CTStringUtil stringNotBlank:ID]) {
    [param setObject:ID forKey:@"id"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
  }
    [self.component sendPostRequestWithURL:URL_USER_PRIVILEGE param:param success:^(id data) {
//        [CGCorporateMemberEntity mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"privilegeTitle"  : @"CGPrivilegeTitle",
//                     @"privilegeList"  : @"CGPrivilegeList",
//                     };
//        }];
//      [CGPrivilegeList mj_setupObjectClassInArray:^NSDictionary *{
//        return @{
//                 @"list"  : @"CGListEntity",
//                 };
//      }];
        CGCorporateMemberEntity *comment = [CGCorporateMemberEntity mj_objectWithKeyValues:data];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//我点评的列表接口
-(void)authUserCommentListWithType:(NSInteger)type page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:page],@"page", nil];
    [self.component sendPostRequestWithURL:URL_USER_COMMENT_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        CGSearchSourceCircleEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGSearchSourceCircleEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//消息推送列表接口
-(void)authUserMessageListWithPage:(NSInteger )page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page", nil];
    [self.component sendPostRequestWithURL:URL_USER_MESSAGE_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        CGMessageEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGMessageEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//系统消息列表接口
-(void)authUserMessageSystemListWithID:(NSString *)ID page:(NSInteger)page type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    [CGMessageDetailEntity mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list"  : @"CGMessageDetailListEntity",
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:type],@"type",ID,@"id", nil];
    [self.component sendPostRequestWithURL:URL_USER_MESSAGE_SYSTEM_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        CGMessageDetailEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGMessageDetailEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//帮助栏目接口
-(void)authUserHelpCateSuccess:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_HELP_LIST param:nil success:^(id data) {
        NSMutableArray *array = data;
        CGUserHelpCateEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGUserHelpCateEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//帮助信息列表接口
-(void)authUserHelpCateListWithID:(NSString *)ID success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
    [self.component sendPostRequestWithURL:URL_USER_HELP_CATE_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        CGUserHelpCateListEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGUserHelpCateListEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//帮助信息页面接口
-(void)authUserHelpCatePageWithID:(NSString *)ID success:(void(^)(CGUserHelpCatePageEntity *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id", nil];
    [self.component sendPostRequestWithURL:URL_USER_HELP_CATE_PAGE param:param success:^(id data) {
        NSDictionary *dict = data;
        CGUserHelpCatePageEntity *comment = [CGUserHelpCatePageEntity mj_objectWithKeyValues:dict];;
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户等级套餐接口
-(void)authUserGradesPackageWithGradesId:(NSString *)gradesId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:gradesId,@"gradesId", nil];
    [self.component sendPostRequestWithURL:URL_USER_GRADES_PACKAGE param:param success:^(id data) {
        NSMutableArray *array = data;
        CGGradesPackageEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGGradesPackageEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户套餐列表接口
-(void)authUserPackageListWithType:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type", nil];
  [self.component sendPostRequestWithURL:URL_USER_USER_PACKAGE_LIST param:param success:^(id data) {
    NSMutableArray *array = data;
    CGGradesPackageEntity *comment;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *dict in array){
      comment = [CGGradesPackageEntity mj_objectWithKeyValues:dict];
      [result addObject:comment];
    }
    success(result);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//用户订单取消接口
-(void)authUserOrderCancelWithOrderId:(NSString *)orderId success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:orderId,@"orderId", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORDER_CANCEL param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户订单详情接口
-(void)authUserOrderDetailsWithOrderId:(NSString *)orderId success:(void(^)(CGOrderEntity *reslut))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:orderId,@"orderId", nil];
    [self.component sendPostRequestWithURL:URL_USER_ORDER_DETAILS param:param success:^(id data) {
        NSDictionary *dic = data;
        CGOrderEntity *comment = [CGOrderEntity mj_objectWithKeyValues:dic];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户设置信息获取接口
-(void)userSettingSuccess:(void(^)(CGSettingEntity *reslut))success fail:(void (^)(NSError *error))fail{
    [self.component sendPostRequestWithURL:URL_USER_SETTING param:nil success:^(id data) {
        NSDictionary *dic = data;
        CGSettingEntity *comment = [CGSettingEntity mj_objectWithKeyValues:dic];
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户设置信息更新接口
-(void)userSettingUpdateWithDisturb:(NSInteger)disturb fontSize:(NSInteger)fontSize nightMode:(NSInteger)nightMode noPic:(NSInteger)noPic vibration:(NSInteger)vibration voice:(NSInteger)voice message:(NSInteger)message knowledgeMsg:(NSInteger)knowledgeMsg everydayMsg:(NSInteger)everydayMsg rewardMsg:(NSInteger)rewardMsg auditMsg:(NSInteger)auditMsg exitMsg:(NSInteger)exitMsg success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if (disturb == 0) {
    [param setObject:[NSNumber numberWithInteger:disturb] forKey:@"disturb"];
  }
  if (fontSize == 0) {
    [param setObject:[NSNumber numberWithInteger:fontSize] forKey:@"fontSize"];
  }
  if (nightMode == 0) {
    [param setObject:[NSNumber numberWithInteger:nightMode] forKey:@"nightMode"];
  }
  if (noPic == 0) {
    [param setObject:[NSNumber numberWithInteger:noPic] forKey:@"noPic"];
  }
  if (vibration == 0) {
    [param setObject:[NSNumber numberWithInteger:vibration] forKey:@"vibration"];
  }
  if (voice == 0) {
    [param setObject:[NSNumber numberWithInteger:voice] forKey:@"voice"];
  }
  if (message == 0) {
    [param setObject:[NSNumber numberWithInteger:message] forKey:@"message"];
  }
  if (knowledgeMsg == 0) {
    [param setObject:[NSNumber numberWithInteger:knowledgeMsg] forKey:@"knowledgeMsg"];
  }
  if (everydayMsg == 0) {
    [param setObject:[NSNumber numberWithInteger:everydayMsg] forKey:@"everydayMsg"];
  }
  if (rewardMsg == 0) {
    [param setObject:[NSNumber numberWithInteger:rewardMsg] forKey:@"rewardMsg"];
  }
  if (auditMsg == 0) {
    [param setObject:[NSNumber numberWithInteger:auditMsg] forKey:@"auditMsg"];
  }
  if (exitMsg == 0) {
    [param setObject:[NSNumber numberWithInteger:exitMsg] forKey:@"exitMsg"];
  }
  [self.component sendPostRequestWithURL:URL_USER_SETTING_UPDATE param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//用户邀请好友数据接口
-(void)authUserInviteFriendsSuccess:(void(^)(CGInviteFriendEntity *reslut))success fail:(void (^)(NSError *error))fail{
  [self.component sendPostRequestWithURL:URL_USER_INVITE_FRIEND param:nil success:^(id data) {
    NSDictionary *dic = data;
    CGInviteFriendEntity *comment = [CGInviteFriendEntity mj_objectWithKeyValues:dic];
    success(comment);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//修改技能接口
-(void)userInfoUpdateSkillLevel:(NSInteger)skillLevel success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:skillLevel],@"skillLevel", nil];
  [self.component sendPostRequestWithURL:URL_USER_INFO_UPDATE_SKILLLEVEL param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}
@end
