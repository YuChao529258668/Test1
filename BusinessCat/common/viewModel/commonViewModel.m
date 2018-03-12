
//
//  commonViewModel.m
//  CGSays
//
//  Created by zhu on 2017/4/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "commonViewModel.h"
#import "CTRootViewController.h"
#import "AppDelegate.h"
#import "CGUserCenterBiz.h"

#import "CGKnowledgeBaseDetailViewController.h"
#import "CGSortView.h"
#import "CGDiscoverTeamCircelViewController.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGKnowledgeCatalogController.h"
#import "CGProductReviewViewController.h"
#import "CGInterfaceViewController.h"
#import "CGToolViewController.h"
#import "CGTeamDocumentViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGUserFireViewController.h"
#import "CGOrderViewController.h"
#import "CGUserCollectController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGAttestationController.h"
#import "CommonWebViewController.h"
#import "CGMessageViewController.h"
#import "CGMainLoginViewController.h"
#import "CGUserSettingViewController.h"
#import "CGUserHelpViewController.h"
#import "CGUserHelpCatePageViewController.h"
#import "CGFeedbackViewController.h"
#import "CGMyReviewViewController.h"
#import "CGUserAuditViewController.h"
#import "CGUserContactsViewController.h"
#import "CGUserPhoneContactViewController.h"
#import "CGInviteMembersViewController.h"
#import "CGUserEditDepartmentViewController.h"
#import "CGIntegralMainController.h"
#import "CGBuyVIPViewController.h"
#import "CGMessageDetailViewController.h"
#import "CGEnterpriseArchivesViewController.h"
#import "CGTutorialViewController.h"

@interface commonViewModel ()
@property(nonatomic,retain)CTRootViewController *rootController;
@property (nonatomic, strong) CGPushEntity *entity;
@property (nonatomic, strong) NSMutableArray *directoryFristArray;
@end

@implementation commonViewModel

-(CTRootViewController *)rootController{
    if(!_rootController){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _rootController = app.rootController;
    }
    return _rootController;
}

-(void)messagePushAlertviewWithEnitty:(CGPushEntity *)entity{
    self.entity = entity;
    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:entity.aps.alert.body
                                                   delegate:self
                                          cancelButtonTitle:@"忽略"
                                          otherButtonTitles:@"查看",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self messageCommandWithCommand:self.entity.command parameterId:self.entity.parameterId commpanyId:self.entity.companyId recordId:self.entity.recordId messageId:self.entity.messageId detial:nil typeArray:nil];
    }else{
        if ([self.entity.command isEqualToString:@"TuanDuiQuanGongNeng"]||[self.entity.command isEqualToString:@"JiFenGongNeng"]||[self.entity.command isEqualToString:@"DingDanGongNeng"]||[self.entity.command isEqualToString:@"SuoShuZuZhi"]||[self.entity.command isEqualToString:@"RenLingZuZhiGongNeng"]||[self.entity.command isEqualToString:@"JiaRuShenHeGongNeng"]||[self.entity.command isEqualToString:@"TongXunLuGongNeng"]||[self.entity.command isEqualToString:@"WoDeDianPingGongNeng"]||[self.entity.command isEqualToString:@"WoDeHuiFuGongNeng"]||[self.entity.command isEqualToString:@"YiJianFanKuiGongNeng"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
        }
    }
}

-(void)messageCommandWithCommand:(NSString *)command parameterId:(NSString *)parameterId commpanyId:(NSString *)commpanyId recordId:(NSString *)recordId messageId:(NSString *)messageId detial:(CGInfoHeadEntity *)detail typeArray:(NSMutableArray *)typeArray{
    //是否刷新用户数据
    if ([self.entity.command isEqualToString:@"TuanDuiQuanGongNeng"]||[self.entity.command isEqualToString:@"JiFenGongNeng"]||[self.entity.command isEqualToString:@"DingDanGongNeng"]||[self.entity.command isEqualToString:@"SuoShuZuZhi"]||[self.entity.command isEqualToString:@"RenLingZuZhiGongNeng"]||[self.entity.command isEqualToString:@"JiaRuShenHeGongNeng"]||[self.entity.command isEqualToString:@"TongXunLuGongNeng"]||[self.entity.command isEqualToString:@"WoDeDianPingGongNeng"]||[self.entity.command isEqualToString:@"WoDeHuiFuGongNeng"]||[self.entity.command isEqualToString:@"YiJianFanKuiGongNeng"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
    }
    
    if ([command isEqualToString:@"JinRiZhiShiShouYe"]) {//今日知识首页(一级分类)
        [self.rootController  showTabIndex:0];
        [self.rootController.mealVC getPushDealWithRecordId:recordId parameterId:parameterId];
    }else if ([command isEqualToString:@"GangWeiZhiShiShouYe"]){//岗位知识首页(一级分类)
        [self.rootController  showTabIndex:1];
        [self.rootController.baseVC getPushDealWithRecordId:recordId];
    }else if ([command isEqualToString:@"GangWeiZhiShiLieBiao"]){//岗位知识列表(三级分类)
        CGKnowledgeBaseDetailViewController *vc = [[CGKnowledgeBaseDetailViewController alloc]init];
        vc.navTypeId = recordId;
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"GangWeiZhiShiPaiXu"]){//岗位知识排序
        CGSortView *sortView = [[CGSortView alloc]initWithArray:[ObjectShareTool sharedInstance].knowledgeBigTypeData];
    }else if ([command isEqualToString:@"FaXianShouYe"]){//发现首页
        [self.rootController  showTabIndex:2];
    }else if ([command isEqualToString:@"TuanDuiQuanGongNeng"]){//企业圈功能(公司)
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGDiscoverTeamCircelViewController class]]) {
            //      CGDiscoverTeamCircelViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            //TODO
        }else{
            CGDiscoverTeamCircelViewController *vc = [CGDiscoverTeamCircelViewController sharedInstance];
            for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
                CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                if (companyEntity.auditStete == 1) {
                    if ([companyEntity.companyId isEqualToString:commpanyId]) {
                        vc.selectIndex = i;
                        break;
                    }
                }
            }
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"TuanDuiQuanXiangQing"]){//企业圈详情(功能未有)
        
    }else if ([command isEqualToString:@"ZhiShiXiangQing"]){//知识详情
        CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:recordId type:parameterId.integerValue block:^{
            
        }];
        vc.info = detail;
        vc.typeArray = typeArray;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ZhuanJiXiangQing"]){//专辑详情
        CGKnowledgeCatalogController *vc = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:recordId companyId:nil cataId:nil];
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"WenKuXiangQing"]){//文库详情
        CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:recordId type:parameterId.integerValue block:^{
            
        }];
        vc.info = detail;
        vc.typeArray = typeArray;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ShangYeJiHuaShuGongNeng"]){//商业计划书功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 7;
        vc.titleStr = @"商业计划书";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ShangShiGongKaiShuGongNeng"]){//上市公开书功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 8;
        vc.titleStr = @"上市公开书";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"HangYeBaoGaoGongNeng"]){//行业报告功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 4;
        vc.titleStr = @"行业报告";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"HangYeFangAnGongNeng"]){//行业方案功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 3;
        vc.titleStr = @"行业方案";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ChanPinBaoGaoGongNeng"]){//产品报告功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 1;
        vc.titleStr = @"产品报告";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"BanGongWenDangGongNeng"]){//办公文档功能
        CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
        vc.type = 5;
        vc.titleStr = @"办公文档";
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"APPJieMianGongNeng"]){//APP界面功能
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 1;
        vc.titleStr = @"APP界面";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"WangZhanJieMianGongNeng"]){//网站界面功能
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 2;
        vc.titleStr = @"网站界面";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ChanPinXuanChuanTuGongNeng"]){//产品宣传图功能
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 3;
        vc.titleStr = @"产品宣传图";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ShouJiHaiBaoGongNeng"]){//手机海报功能
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 4;
        vc.titleStr = @"手机海报";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"APPJieMianChanPinBanBen"]){//APP界面产品版本
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 1;
        vc.titleStr = @"APP界面";
        vc.selectIndex = 1;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"WangZhanJieMianChanPinBanBen"]){//网站界面产品版本
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 2;
        vc.titleStr = @"网站界面";
        vc.selectIndex = 1;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ChanPinXuanChuanTuChanPinBanBen"]){//产品宣传图产品版本
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 3;
        vc.titleStr = @"产品宣传图";
        vc.selectIndex = 1;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"ShouJiHaiBaoLieBiaoChanPinBanBen"]){//手机海报列表产品版本
        CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
        vc.type = 4;
        vc.titleStr = @"手机海报";
        vc.selectIndex = 1;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"GangWeiGongJuGongNeng"]){//岗位工具功能
        CGToolViewController *vc = [[CGToolViewController alloc]init];
        vc.title = @"岗位工具";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"GangWeiGongJuFenLei"]){//岗位工具分类
        CGKnowledgeBaseDetailViewController *vc = [[CGKnowledgeBaseDetailViewController alloc]init];
        vc.navTypeId = recordId;
        vc.catePage = 1;
        vc.selectIndex = parameterId.integerValue;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"GangWeiGongJuXiangQing"]){//岗位工具详情
        //    CGKnowledgeBaseDetailViewController *vc = [[CGKnowledgeBaseDetailViewController alloc]init];
        //    vc.navTypeId = recordId;
        //    vc.catePage = 1;
        //    vc.selectIndex = parameterId.integerValue;
        //    [self.rootController.navigationController pushViewController:vc animated:YES];
        CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:recordId type:parameterId.integerValue block:^{
            
        }];
        vc.info = detail;
        vc.typeArray = typeArray;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"TuanDuiWenDangGongNeng"]){//团队文档功能(公司)
        CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
        vc.type = 2;
        vc.companyID = commpanyId;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"TuanDuiWenDangKongJianGouMaiGongNeng"]){//团队文档空间购买功能
        
    }else if ([command isEqualToString:@"VIPHuiYuanQuGongNeng"]){//VIP会员区功能(会员等区)
        CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
        vc.title = @"VIP会员";
        vc.type = 0;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"VIPQiYeQuGongNeng"]){//VIP企业区功能(企业等区)
        CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
        vc.title = @"VIP企业";
        vc.type = 1;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"VIPHuiYuanTeQuanGongNeng"]){//VIP会员特权功能
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        vc.type = 0;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"VIPQiYeTeQuanGongNeng"]){//VIP企业特权功能(公司)
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        vc.type = 1;
        vc.companyID = commpanyId;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"DangAnGongNeng"]){//档案功能
        CGUserFireViewController *controller = [[CGUserFireViewController alloc]init];
        [self.rootController.navigationController pushViewController:controller animated:YES];
    }else if ([command isEqualToString:@"XinBanBenTongZhi"]){//新版本通知
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
    }else if ([command isEqualToString:@"FaSongGongNeng"]){//发送功能
        
    }else if ([command isEqualToString:@"FaSongDuiHuanGongNeng"]){//发送兑换功能
        
    }else if ([command isEqualToString:@"JiFenGongNeng"]){//金币功能
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGIntegralMainController class]]) {
            CGIntegralMainController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGIntegralMainController *controller = [[CGIntegralMainController alloc]init];
            [self.rootController.navigationController pushViewController:controller animated:YES];
        }
    }else if ([command isEqualToString:@"JiFenGouMaiGongNeng"]){//金币购买功能
        CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
        vc.type = 4;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"DingDanGongNeng"]){//订单功能
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGOrderViewController class]]) {
            CGOrderViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGOrderViewController *vc = [[CGOrderViewController alloc]init];
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"DingDanXiangQing"]){//订单详情(功能未有)
        
    }else if ([command isEqualToString:@"ShouCangGongNeng"]){//收藏功能
        CGUserCollectController *vc = [[CGUserCollectController alloc]init];
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"SuoShuZuZhi"]){//所属组织
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGUserChangeOrganizationViewController class]]) {
            CGUserChangeOrganizationViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
            [self.rootController.navigationController pushViewController:controller animated:YES];
        }
    }else if ([command isEqualToString:@"RenLingZuZhiGongNeng"]){//认领组织功能(公司)
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGAttestationController class]]) {
            CGAttestationController *controller = [self.rootController.navigationController.viewControllers lastObject];
            for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
                CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                if (companyEntity.auditStete == 1) {
                    if ([companyEntity.companyId isEqualToString:commpanyId]) {
                        [controller refresh:companyEntity];
                        break;
                    }
                }
            }
        }else{
            for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
                CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                if (companyEntity.auditStete == 1) {
                    if ([companyEntity.companyId isEqualToString:commpanyId]) {
                        CGAttestationController *vc = [[CGAttestationController alloc]initWithOrganiza:companyEntity block:^(NSString *success) {
                            
                        }];
                        [self.rootController.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                }
            }
        }
    }else if ([command isEqualToString:@"JiaRuShenHeGongNeng"]){//加入审核功能(公司)
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGUserAuditViewController class]]) {
            CGUserAuditViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGUserAuditViewController *vc = [[CGUserAuditViewController alloc]init];
            vc.companyID = commpanyId;
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"TongXunLuGongNeng"]){//通讯录功能(公司)
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGUserContactsViewController class]]) {
            CGUserContactsViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
                CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                if (companyEntity.auditStete == 1) {
                    if ([companyEntity.companyId isEqualToString:commpanyId]) {
                        CGUserContactsViewController *vc = [[CGUserContactsViewController alloc]initWithOrganiza:companyEntity];
                        [self.rootController.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                }
            }
        }
    }else if ([command isEqualToString:@"ZuZhiJiaGouGongNeng"]){//组织架构功能(公司)
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
            if (companyEntity.auditStete == 1) {
                if ([companyEntity.companyId isEqualToString:commpanyId]) {
                    CGUserEditDepartmentViewController *controller = [[CGUserEditDepartmentViewController alloc]initWithOrganiza:companyEntity];
                    [self.rootController.navigationController pushViewController:controller animated:YES];
                    break;
                }
            }
        }
    }else if ([command isEqualToString:@"YaoQingChengYuanGongNeng"]){//邀请成员功能(公司)
        //    CGUserPhoneContactViewController *vc = [[CGUserPhoneContactViewController alloc]init];
        //    vc.companyID = commpanyId;
        //    [self.rootController.navigationController pushViewController:vc animated:YES];
        CGInviteMembersViewController *vc = [[CGInviteMembersViewController alloc]init];
        vc.companyID = commpanyId;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"WoDeDianPingGongNeng"]){//我的点评功能
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGMyReviewViewController class]]) {
            CGMyReviewViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGMyReviewViewController *vc = [[CGMyReviewViewController alloc]init];
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"WoDeHuiFuGongNeng"]){//我的回复功能
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGMyReviewViewController class]]) {
            CGMyReviewViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            CGMyReviewViewController *vc = [[CGMyReviewViewController alloc]init];
            vc.selectIndex = 1;
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"YiJianFanKuiGongNeng"]){//意见反馈功能
        if ([[self.rootController.navigationController.viewControllers lastObject] isKindOfClass:[CGFeedbackViewController class]]) {
            CGFeedbackViewController *controller = [self.rootController.navigationController.viewControllers lastObject];
            [controller refresh];
        }else{
            //反馈意见
            CGFeedbackViewController *vc = [[CGFeedbackViewController alloc]init];
            vc.type = parameterId.intValue;
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
    }else if ([command isEqualToString:@"BangZhuGongNeng"]){//帮助功能
        CGUserHelpViewController *vc = [[CGUserHelpViewController alloc]init];
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"BangZhuXiangQing"]){//帮助详情
        CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
        vc.pageId = recordId;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"SheZhiGongNeng"]){//设置功能
        CGUserSettingViewController *vc = [[CGUserSettingViewController alloc]init];
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"DengLuShouYe"]){//登录首页
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
        } fail:^(NSError *error) {
            
        }];
        [self.rootController.navigationController pushViewController:controller animated:YES];
    }else if ([command isEqualToString:@"XiaoXiGongNeng"]){//消息功能
        //    CGMessageViewController *controller = [[CGMessageViewController alloc]init];
        //    [self.rootController.navigationController pushViewController:controller animated:YES];
        CGMessageDetailViewController *vc = [[CGMessageDetailViewController alloc]init];
        vc.title = @"消息";
        vc.type = 1000;
        vc.ID = @"";
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"XiaoXiXiangQing"]){//消息详情(功能未有,类似帮助一样)
        
    }else if ([command isEqualToString:@"DaKaiWangZhi"]){//打开网址
        CommonWebViewController *vc = [[CommonWebViewController alloc]init];
        vc.url = recordId;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }else if ([command isEqualToString:@"QiYeDangAn"]){//企业档案
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
            if (companyEntity.auditStete == 1) {
                if ([companyEntity.companyId isEqualToString:commpanyId]) {
                    CGEnterpriseArchivesViewController *vc = [[CGEnterpriseArchivesViewController alloc]init];
                    vc.companyID = companyEntity.companyId;
                    vc.companytype = companyEntity.companyType;
                    [self.rootController.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
        }
    }else if ([command isEqualToString:@"kuaijiebangzhu"]){//快捷帮助
        __weak typeof(self) weakSelf = self;
        [[[CGUserCenterBiz alloc]init] authUserHelpCateListWithID:@"9f8209ca-827d-3a3a-da72-f51a1e4eddde" success:^(NSMutableArray *reslut) {
            weakSelf.directoryFristArray = reslut;
            [[[CGUserCenterBiz alloc]init] authUserHelpCateListWithID:@"ec3b8780-81f7-02a0-6df0-4793c6651e7c" success:^(NSMutableArray *reslut) {
                CGTutorialViewController *vc = [[CGTutorialViewController alloc]init];
                vc.modalPresentationStyle = UIModalPresentationCustom;
                vc.directoryFristArray = weakSelf.directoryFristArray;
                vc.directorySecondArray = reslut;
                [weakSelf.rootController presentViewController:vc animated:YES completion:nil];
            } fail:^(NSError *error) {
            }];
        } fail:^(NSError *error) {
        }];
    }else if ([command isEqualToString:@"XinZhuCeYongHuBaoGao"]){//新注册用户报告
        
    }else if ([command isEqualToString:@"JiaRuZuZhiBaoGao"]){//加入组织报告
        
    }else if ([command isEqualToString:@"RenLingZuZhiBaoGao"]){//认领组织报告
        
    }else if ([command isEqualToString:@"GouMaiVIPHuiYuanBaoGao"]){//购买VIP会员报告
        
    }else if ([command isEqualToString:@"GouMaiVIPQiYeBaoGao"]){//购买VIP企业报告
        
    }else if ([command isEqualToString:@"ChuangJianZuZhiBaoGao"]){//创建组织报告
        
    }else if ([command isEqualToString:@"FaSongBaoGao"]){//下载报告
        
    }else if ([command isEqualToString:@"FuFeiBaoGao"]){//付费报告
        
    }else if ([command isEqualToString:@"HangYeDaGuanChaGongNeng"]){//行业大观察功能(功能未有)
        
    }else if ([command isEqualToString:@"HangYeDaGuanChaXiangQing"]){//行业大观察详情(功能未有)
        
    }else if ([command isEqualToString:@"QiYeDaGuanChaGongNeng"]){//企业大观察功能(功能未有)
        
    }else if ([command isEqualToString:@"QiYeDaGuanChaXiangQing"]){//企业大观察详情(功能未有)
        
    }else if ([command isEqualToString:@"ChanPinDaGuanChaGongNeng"]){//产品大观察功能(功能未有)
        
    }else if ([command isEqualToString:@"ChanPinDaGuanChaXiangQing"]){//产品大观察详情(功能未有)
        
    }else if ([command isEqualToString:@"ChanPinGongNeng"]){//产品功能(功能未有)
        
    }else if ([command isEqualToString:@"ChanPinXiangQing"]){//产品详情(功能未有)
        
    }else if ([command isEqualToString:@"QiYeGongNeng"]){//企业功能(功能未有)
        
    }else if ([command isEqualToString:@"QiYeXiangQing"]){//企业详情(功能未有)
        
    }else if ([command isEqualToString:@"RenWuGongNeng"]){//人物功能(功能未有)
        
    }else if ([command isEqualToString:@"RenWuXiangQing"]){//人物详情(功能未有)
        
    }else if ([command isEqualToString:@"RongZiGongNeng"]){//融资功能(功能未有)
        
    }else if ([command isEqualToString:@"RongZiXiangQing"]){//融资详情(功能未有)
        
    }else if ([command isEqualToString:@"TouZiJiGouGongNeng"]){//投资机构功能(功能未有)
        
    }else if ([command isEqualToString:@"TouZiJiGouXiangQing"]){//投资机构详情(功能未有)
        
    }else if ([command isEqualToString:@"TiYanGongNeng"]){//体验功能(功能未有)
        
    }else if ([command isEqualToString:@"TiYanXiangQing"]){//体验详情(功能未有)
        
    }else if ([command isEqualToString:@"LeiDaGongNeng"]){//雷达功能(功能未有)
        
    }else if ([command isEqualToString:@"LeiDaWoDeFenZu"]){//雷达我的分组(功能未有)
        
    }else if ([command isEqualToString:@"LeiDaGongSiZuLieBiao"]){//雷达公司组列表(功能未有)
        
    }else if ([command isEqualToString:@"LeiDaXiangQing"]){//雷达详情(功能未有)
        
    }else if ([command isEqualToString:@"TuanDuiQuanBaoLiao"]){//企业圈爆料(功能未有)
        
    }
}
@end
