//
//  CGUserCenterBiz.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import "CGUserSearchCompanyEntity.h"
#import "CGUserCompanyPrivilegeEntity.h"
#import "CGUserWalletInfoEntity.h"
#import "CGUserCompanyAttestationEntity.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserHelpCatePageEntity.h"
#import "CGOrderEntity.h"
#import "CGSettingEntity.h"
#import "CGCorporateMemberEntity.h"
#import "CGIntegralEntity.h"
#import "CGInviteFriendEntity.h"
#import "CGOrganizationEntity.h"
#import "FeedbackInfoEntity.h"
#import "CGMessageDetailEntity.h"
@interface CGUserCenterBiz : CGBaseBiz

//获取token
-(void)getToken:(void(^)(NSString * uuid,NSString *token))complete fail:(void (^)(NSError *error))fail;

//获取登录验证码
-(void)getLoginVerifyCodeByPhone:(NSString *)phone success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//登录
-(void)loginWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode success:(void(^)(CGUserEntity *user))success fail:(void (^)(NSError *error))fail;

//重新绑定手机
-(void)authUserChangephoneWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode success:(void(^)())success fail:(void (^)(NSError *error))fail;

//获取用户信息
-(void)queryUserDetailInfoWithCode:(NSString *)code success:(void(^)(CGUserEntity *user))success fail:(void (^)(NSError *error))fail;

//用户消息标签接口
-(void)userMessageTagsWithSuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//修改用户信息
-(void)updateUserInfoWithUsername:(NSString *)username nickname:(NSString *)nickname gender:(NSString *)gender portrait:(NSString *)portrait email:(NSString *)email addSkillIds:(NSMutableArray *)addSkillIds delSkillIds:(NSMutableArray *)delSkillIds skillLevel:(NSInteger)skillLevel success:(void(^)())success fail:(void (^)(NSError *error))fail;

//组织信息编辑接口
-(void)authUserOrganizaEditWithCompanyid:(NSString *)companyid companytype:(NSInteger)companytype companyicon:(NSString *)companyicon companyname:(NSString *)companyname companyphone:(NSString *)companyphone companyhttp:(NSString *)companyhttp email:(NSString *)email employeesnum:(NSInteger)employeesnum city:(NSString *)city area:(NSString *)area province:(NSString *)province addKnowledge:(NSMutableArray *)addKnowledge delKnowledge:(NSMutableArray *)delKnowledge address:(NSString *)address success:(void(^)())success fail:(void (^)(NSError *error))fail;

//组织信息获取接口
-(void)authUserOrganizaInfoWithCompanyidWith:(NSString *)companyid companytype:(NSInteger)companytype success:(void(^)(CGOrganizationEntity *result))success fail:(void (^)(NSError *error))fail;

//公司组织搜索接口
-(void)userCompanySearchWithkeyword:(NSString *)keyword type:(NSNumber *)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//公司组织申请加入
-(void)userCompanyJoinWithCompangyID:(NSString *)companyID depaId:(NSString *)depaId type:(NSInteger )type classId:(NSString *)classId position:(NSString *)position startTime:(NSString *)startTime success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//行业列表
-(void)IndustrySsuccess:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//公司组织创建接口
-(void)companyCreateWithCompanyName:(NSString *)companyName companyType:(int )companyType industryId:(NSString *)industryId scaleLevel:(int )scaleLevel success:(void(^)(NSString *companyID,NSNumber *companyType))success fail:(void (^)(NSError *error))fail;

//公司加入审核列表
-(void)userCompanyAuditListWithOrganizaId:(NSString *)organizaId type:(int)type Page:(NSInteger)page success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail;

//公司审核员工操作
-(void)userCompanyAuditWithUserID:(NSString *)userID organizaId:(NSString *)organizaId organizaType:(int)organizaType action:(int )action reason:(NSString *)reason success:(void(^)())success fail:(void (^)(NSError *error))fail;

//公司特权数据接口
-(void)userCompanyPrivilegeSuccess:(void(^)(CGUserCompanyPrivilegeEntity *result))success fail:(void (^)(NSError *error))fail;

//公司&管理员认证
-(void)userCompanyAttestation:(CGUserOrganizaJoinEntity *)authEntity isShare:(int)isShare success:(void(^)())success fail:(void (^)(NSError *error))fail;

//通讯录接口
-(void)userCompanyContactsWithKeyword:(NSString *)keyword organizaId:(NSString *)organizaId type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//退出登录
-(void)userLogoutSuccess:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//查询用户收藏数据
-(void)getUserCollectionDataWithLabel:(int)label page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//组织获取部门列表
-(void)authUserOrganizaDepaListWithOrganizaID:(NSString *)OrganizaID type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//组织获取角色列表
-(void)organizaRoleListWithType:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//认证组织发生短信
-(void)organizaAuthSendSMS:(void(^)(void))success fail:(void (^)(NSError *error))fail;

//组织创建部门
-(void)organizaCreateDepaWithDepaID:(NSString *)depaID type:(NSInteger )type name:(NSString *)name success:(void(^)(NSString *depaID))success fail:(void (^)(NSError *error))fail;

//学校创建班级
-(void)organizaCreateClassWithClassID:(NSString *)classID depaId:(NSString *)depaId name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail;

//学校获取班级接口
-(void)organizaClassListWithSchoolID:(NSString *)schoolID depaId:(NSString *)depaId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//标签分类列表接口
-(void)commonTagsListWith:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//标签行业分类列表接口
-(void)commonIndustryListWithSuccess:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//组织部门重命名接口
-(void)userOrganizaDepaUpdateWithOrganizaId:(NSString *)organizaId depaId:(NSString *)depaId type:(NSInteger)type name:(NSString *)name success:(void(^)())success fail:(void (^)(NSError *error))fail;

//组织部门删除接口
-(void)userOrganizaDepaDeleteWithOrganizaId:(NSString *)organizaId depaId:(NSString *)depaId type:(NSInteger)type success:(void(^)())success fail:(void (^)(NSError *error))fail;

//用户切换组织接口
-(void)userOrganizaSwitchWithID:(NSString *)companyID success:(void(^)())success fail:(void (^)(NSError *error))fail;

//通讯录上传匹配接口
-(void)authCommonPhonebookWithPhones:(NSMutableArray *)phones companyId:(NSString *)companyId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//邀请同事短信接口
-(void)authUserInvitationWithPhone:(NSString *)phone organizaId:(NSString *)organizaId organizaType:(int)organizaType success:(void(^)())success fail:(void (^)(NSError *error))fail;
//登录获取语音验证码接口
-(void)userVoiceVerifycodeWithPhone:(NSString *)phone success:(void(^)())success fail:(void (^)(NSError *error))fail;
//用户退出组织接口
-(void)userOrganizaExitWithID:(NSString *)organizationID type:(int)type success:(void(^)())success fail:(void (^)(NSError *error))fail;
//用户微信信息绑定接口
-(void)wechatInfoUpdateWithNickname:(NSString *)nickname gender:(int)gender openid:(NSString *)openid portrait:(NSString *)portrait unionid:(NSString *)unionid op:(BOOL)op success:(void(^)())success fail:(void (^)(NSError *error))fail;

//钱包基础信息接口
-(void)authUserWalletInfoSuccess:(void(^)(CGUserWalletInfoEntity *reslut))success fail:(void (^)(NSError *error))fail;
//钱包变化记录接口
-(void)authUserWalletListWithType:(NSInteger)type mode:(NSInteger)mode page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//钱包提现
-(void)authRedpackWithdrawWithAmount:(NSInteger)amount client_ip:(NSString *)client_ip success:(void(^)())success fail:(void (^)(NSError *error))fail;

//组织信息修改接口
-(void)authUserOrganizingUpdateWithID:(NSString *)ID type:(NSInteger)type departmentId:(NSString *)departmentId position:(NSString *)position success:(void(^)())success fail:(void (^)(NSError *error))fail;

//设置普通管理员
-(void)organizaManagerOperatorWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId action:(int)action success:(void(^)())success fail:(void (^)(NSError *error))fail;

//超级管理员转让
-(void)organizaSuperManagerOperatorWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId success:(void(^)())success fail:(void (^)(NSError *error))fail;

//组织强制移除用户
-(void)organizaExitUserWithOrganizaId:(NSString *)organizaId organizaType:(int)organizaType userId:(NSString *)userId reason:(NSString *)reason success:(void(^)())success fail:(void (^)(NSError *error))fail;

//所属组织排序
-(void)sortOrganizas:(NSMutableArray *)organizas success:(void(^)())success fail:(void (^)(NSError *error))fail;

//意见反馈发表接口
-(void)userFeedbackAddWithContent:(NSString *)content type:(NSInteger)type level:(NSInteger)level linkIcon:(NSString *)linkIcon linkId:(NSString *)linkId linkTitle:(NSString *)linkTitle linkType:(NSInteger)linkType imgList:(NSMutableArray *)imgList success:(void(^)())success fail:(void (^)(NSError *error))fail;

//意见反馈列表接口
-(void)userFeedbackListWithTime:(NSInteger)time mode:(NSInteger)mode success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;

//意见反馈头部信息
-(void)userFeedbackGetInfoWithType:(NSInteger)type success:(void(^)(FeedbackInfoEntity *reslut))success fail:(void (^)(NSError *error))fail;

//意见反馈删除接口
-(void)userFeedbackDeleteWithID:(NSString *)ID success:(void(^)())success fail:(void (^)(NSError *error))fail;

//意见反馈评论接口
-(void)userFeedbackCommentWithID:(NSString *)ID content:(NSString *)content toUid:(NSString *)toUid success:(void(^)(NSString *commentID))success fail:(void (^)(NSError *error))fail;

//用户订单列表接口
-(void)authUserOrderListWithOrderStatus:(NSInteger)orderStatus page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//用户知识分历史接口
-(void)authUserIntegralHistoryWithTime:(NSInteger)time type:(NSInteger)type success:(void(^)(CGIntegralEntity *reslut))success fail:(void (^)(NSError *error))fail;
//用户订单进度接口
-(void)authUserOrderScheduleListWIthOrderId:(NSString *)orderId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//获取VIP信息接口
-(void)userPrivilegeWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(CGCorporateMemberEntity *reslut))success fail:(void (^)(NSError *error))fail;
//我点评的列表接口
-(void)authUserCommentListWithType:(NSInteger)type page:(NSInteger)page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//消息推送列表接口
-(void)authUserMessageListWithPage:(NSInteger )page success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//系统消息列表接口
-(void)authUserMessageSystemListWithID:(NSString *)ID page:(NSInteger)page type:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//帮助栏目接口
-(void)authUserHelpCateSuccess:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//帮助信息列表接口
-(void)authUserHelpCateListWithID:(NSString *)ID success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//帮助信息页面接口
-(void)authUserHelpCatePageWithID:(NSString *)ID success:(void(^)(CGUserHelpCatePageEntity *reslut))success fail:(void (^)(NSError *error))fail;
//用户等级套餐接口
-(void)authUserGradesPackageWithGradesId:(NSString *)gradesId success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//用户套餐列表接口
-(void)authUserPackageListWithType:(NSInteger)type success:(void(^)(NSMutableArray *reslut))success fail:(void (^)(NSError *error))fail;
//用户订单取消接口
-(void)authUserOrderCancelWithOrderId:(NSString *)orderId success:(void(^)())success fail:(void (^)(NSError *error))fail;
//用户订单详情接口
-(void)authUserOrderDetailsWithOrderId:(NSString *)orderId success:(void(^)(CGOrderEntity *reslut))success fail:(void (^)(NSError *error))fail;
//用户设置信息获取接口
-(void)userSettingSuccess:(void(^)(CGSettingEntity *reslut))success fail:(void (^)(NSError *error))fail;
//用户设置信息更新接口
-(void)userSettingUpdateWithDisturb:(NSInteger)disturb fontSize:(NSInteger)fontSize nightMode:(NSInteger)nightMode noPic:(NSInteger)noPic vibration:(NSInteger)vibration voice:(NSInteger)voice message:(NSInteger)message knowledgeMsg:(NSInteger)knowledgeMsg everydayMsg:(NSInteger)everydayMsg rewardMsg:(NSInteger)rewardMsg auditMsg:(NSInteger)auditMsg exitMsg:(NSInteger)exitMsg success:(void(^)())success fail:(void (^)(NSError *error))fail;
//用户邀请好友数据接口
-(void)authUserInviteFriendsSuccess:(void(^)(CGInviteFriendEntity *reslut))success fail:(void (^)(NSError *error))fail;

//修改技能接口
-(void)userInfoUpdateSkillLevel:(NSInteger)skillLevel success:(void(^)())success fail:(void (^)(NSError *error))fail;


// 二维码登录
- (void)loginWithQRCode:(NSString *)code success:(void(^)())success fail:(void (^)(NSError *error))fail;
@end
