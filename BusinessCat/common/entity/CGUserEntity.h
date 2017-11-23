//
//  CGUserEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGUserStatistics.h"
#import "CGUserRoles.h"
#import "CGUserIndustry.h"

@class CGUserOrganizaJoinEntity;

@interface CGUserEntity : NSObject

@property (nonatomic,retain) NSString *uuid;
@property (nonatomic,retain) NSString *secuCode;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,assign) int isLogin;
@property (nonatomic, copy) NSString *openid;
@property(nonatomic,assign)int bindWeixin;//是否已绑定微信
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *username;
@property(nonatomic,assign)int isVip;//1是vip 0非vip 2续费vip
@property(nonatomic,assign)int vipDays;//vip过期天数，正数为离过期还有多少天 负数为已过期多少天
@property(nonatomic,assign) NSInteger vipTime;//VIP到期时间
@property (nonatomic,retain) NSString *portrait; // 头像
@property (nonatomic,retain) NSString *grade;
@property (nonatomic,retain) NSString *gradeName;
@property (nonatomic,retain) NSString *qrcode;
@property (nonatomic,retain) NSString *gender;//男，女
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *userIntro;//一句话介绍
@property(nonatomic,assign)int messageNum;//消息数
@property(nonatomic,assign)int readMessageNum;//阅读过的消息数
@property(nonatomic,assign)int integralNum;//知识分
@property(nonatomic,assign)int followNum;//收藏数
@property(nonatomic,assign)int orderNum;//订单数
@property(nonatomic,assign)float totalAmount;//余额
@property(nonatomic,retain)NSString *organization;//加入的公司的简称，用逗号隔开
@property (nonatomic, assign) NSInteger auditNum; //待审核数量
@property (nonatomic, copy) NSString *email; //邮箱
@property (nonatomic, assign) NSInteger skillLevel;
@property (nonatomic, assign) NSInteger platformAdmin;
@property (nonatomic, assign) NSInteger updateName;
@property (nonatomic, copy) NSString *unionid;

@property (nonatomic, assign) NSInteger housekeeper;//是否管家会员
//用户相关的统计
@property (nonatomic,retain) CGUserStatistics *statistics;
//用户的角色
@property (nonatomic,retain) NSMutableArray *skills;
//用户行业
@property (nonatomic,retain) NSMutableArray *industry;
//用户加入的组织列表
@property(nonatomic,retain) NSMutableArray<CGUserOrganizaJoinEntity *> *companyList;

// 默认返回 companyList 的第一个公司的 companyId
- (NSString *)getCompanyID;
// 默认返回 companyList 的第一个公司的 department
- (NSString *)defaultPosition;

// 腾讯云
@property (nonatomic,strong) NSDictionary *txy;
@property (nonatomic,strong) NSString *txyIdentifier;
@property (nonatomic,strong) NSString *txyUsersig;



@end
