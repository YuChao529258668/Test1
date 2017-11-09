//
//  CGUserTextViewController.h
//  CGSays
//
//  Created by zhu on 16/11/2.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserorganizaApplyEntity.h"

typedef NS_ENUM(NSInteger, UserTextType) {
  UserTextTypeNickName        = 0,
  UserTextTypeUserName        = 1,
  UserTextTypeDepartment      = 2, //部门
  UserTextTypePosition        = 3,  //职位
  UserTextTypeCompanyName     = 4, //公司名称
  UserTextTypeUserIntro       = 5, //一句话简介
  UserTextTypeidCardCode      = 6, //身份证
  UserTextTypeCreatClasses    = 7, //创建班级
  UserTextTypeCreatDepartment = 8, //创建部门
  UserTextTypeChosePosition   = 9,
  UserTextTypeAddGroup        = 10,
  UserTextTypeEditDepartment  = 11, //修改部门
  UserTextTypeEmail           = 12, //邮箱
  UserTextTypeAbbreviation    = 13, //企业简称
  UserTextTypeFullName        = 14, //企业全称
  UserTextTypeTelephone       = 15, //固定电话
  UserTextTypeOfficialWebsite = 16, //官方网站
  UserTextTypeOfficialMailbox = 17, //官方邮箱
  UserTextTypeAffiliation     = 18, //所属组织
  UserTextTypeNumberEmployees = 19, //员工人数
  UserTextTypeArea            = 20, //所在地区
  UserTextTypeDetailedAddress = 21, //详细地址
  UserTextTypeCorrectionTitle = 22, //校正标题
  UserTextTypeCorrectionTime  = 23, //修改创建时间
  UserTextTypeCorrectionUrl   = 24, //修改采集网址
};

typedef void (^CGUserTextBlock)(NSString*text,NSString *textID,UserTextType type);

@interface CGUserTextViewController : CTBaseViewController

@property (nonatomic, assign) UserTextType textType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *organizeID;
@property (nonatomic, copy) NSString *depaId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isChose;
@property (nonatomic, strong) CGUserorganizaApplyEntity *info;
-(instancetype)initWithBlock:(CGUserTextBlock)release;
@end
