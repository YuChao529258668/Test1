//
//  CGInviteMembersViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCAllShareProfitController.h"
#import "CGHorrolView.h"
#import "CGUserOrganizaJoinEntity.h"
//#import"QRCodeGenerator.h"
//#import "ShareUtil.h"

#import "CGUserHelpCatePageViewController.h"
#import "YCSpaceBiz.h"
#import "CGUserCenterBiz.h"
#import "YCPersonalProfitController.h"
#import "CGAttestationController.h"

// 代码复制：YCJoinShareController、CGInviteMembersViewController

@interface YCAllShareProfitController ()
@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property (nonatomic, strong) NSMutableArray<CGHorrolEntity *> *headViewEntitys;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (nonatomic, strong) ShareUtil *shareUtil;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet UIImageView *choseIV;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (nonatomic, assign) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *agreeView;
@property (weak, nonatomic) IBOutlet UILabel *notManagerLabel;

@property (nonatomic, strong) YCPersonalProfitController *profitVC;
@property (weak, nonatomic) IBOutlet UIView *profitContainerView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, YCMeetingProfit *> *profitsDic;

@end

@implementation YCAllShareProfitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profitsDic = [NSMutableDictionary dictionary];
    
  self.title = @"共享收益";
  [self.topView addSubview:self.organizaHeaderView];
  [self.organizaHeaderView setSelectIndex:(int)self.currentIndex];
    
    // 下划线
    NSString *textStr = self.shareL.text;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    self.shareL.attributedText = attribtStr;

    CGHorrolEntity *entity = self.headViewEntitys.firstObject;
    _profitVC = [YCPersonalProfitController new];
    _profitVC.shouldHideNavigationBar = YES;
    _profitVC.type = 0;// 1 个人，0 公司
    _profitVC.companyID = entity.rolId;
    [self addChildViewController:_profitVC];
    [self.profitContainerView addSubview:_profitVC.view];
    [self selectItemWithIndex:self.currentIndex data:entity];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _profitVC.view.frame = self.profitContainerView.bounds;
}
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//
//
//}

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
  __weak typeof(self) weakSelf = self;
  if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
      
    _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      weakSelf.currentIndex = index;
        [weakSelf selectItemWithIndex:index data:data];
    }];
  }
  return _organizaHeaderView;
}

-(NSMutableArray<CGHorrolEntity *> *)headViewEntitys{
    if(!_headViewEntitys){
        _headViewEntitys = [NSMutableArray array];
        
        // 共享收益：已加入的公司+公司必须为已认领

        if([ObjectShareTool sharedInstance].currentUser.renZhengAndAuditCompanyList && [ObjectShareTool sharedInstance].currentUser.renZhengAndAuditCompanyList.count > 0){
            
            for(int i=0;i<[ObjectShareTool sharedInstance].currentUser.renZhengAndAuditCompanyList.count;i++) {
                CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.renZhengAndAuditCompanyList[i];
                
                if (local.companyType !=4) {
                    CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyName sort:i];
                    
                    if (i == 0) {
                        
                    }
                    if ([self.companyID isEqualToString:local.companyId]) {
                        self.currentIndex = i;
                        
                    }
                    [_headViewEntitys addObject:organiza];
                }
            }
        }
    }
    return _headViewEntitys;
}


#pragma mark -

- (IBAction)clickAgreeBtn:(id)sender {
    self.isAgree = !self.isAgree;
    if (self.isAgree) {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_highlight"];
    } else {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_normal"];
    }
}

// 未认证、已认证才能点
- (IBAction)clickJoinBtn:(id)sender {
    if (!self.isAgree) {
        [CTToast showWithText:@"请同意协议"];
        return;
    }
    
    BOOL isClaim;//认领
    CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[self.currentIndex];
    isClaim = (entity.companyState == 1);

    __weak typeof(self) weakself = self;
    if (isClaim) {
        // 加入共享
        // 0:公司 1：用户
        [YCSpaceBiz joinShareWithType:0 companyID:entity.companyId doShare:1 Success:^{
            [CTToast showWithText:@"加入成功"];
            
            YCMeetingProfit *profit = weakself.profitsDic[entity.companyId];
            profit.isShare = 1;
            
            // 更新界面
            CGHorrolEntity *entity = weakself.headViewEntitys[weakself.currentIndex];
            [weakself selectItemWithIndex:weakself.currentIndex data:entity];
            // 获取收益数据
        } fail:^(NSError *error) {
            
        }];
        
    } else {
        // 认领并加入
        CGAttestationController *vc = [[CGAttestationController alloc]initWithOrganiza:entity block:^(NSString *success) {
//            NSLog(@"%@",success);
            entity.companyState = 2;// 认证中
            // 更新界面
            CGHorrolEntity *data = weakself.headViewEntitys[weakself.currentIndex];
            [weakself selectItemWithIndex:weakself.currentIndex data:data];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)clickProtocolBtn:(id)sender {
    CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
    vc.title = @"共享会议协议";
    vc.pageId = @"f22d19f8-a664-47c9-d47e-11a13d17f120";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectItemWithIndex:(NSInteger)index data:(CGHorrolEntity *)entity {
    __weak typeof(self) weakself = self;
    weakself.whiteView.hidden = NO;

    [self getProfitWithCompanyID:entity.rolId success:^(YCMeetingProfit *profit, NSString *companyID) {
        
        CGHorrolEntity *currentEntity = weakself.headViewEntitys[weakself.currentIndex];
        // 如果不是当前界面
        if (![currentEntity.rolId isEqualToString:companyID]) {
            return ;
        }

        weakself.profitContainerView.hidden = YES;
        weakself.whiteView.hidden = YES;
        
        //    如果当前组织未认领，就显示为“认领组织并加入”，然后打开认领组织功能，增加传加入共享参数（需接口增加）
        //    如果当前组织已认领，并且我是管理员，就显示为“我要加入”，需提供加入组织共享接口
        //    如果当前组织已认领，并且我不是管理员，两种判断：
        //    1）已加入共享，您不是管理员无法查看！
        //    2）未加入共享，您不是管理员无法操作！
        //    如果已加入，并且是管理员直接显示收益清单：

//        BOOL isClaim;//认领
        BOOL isManager;//是否管理员
        BOOL isShare;// 是否加入共享
        
        // ??
        CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[index];
//        isClaim = (local.companyState == 1);
        isManager = (local.companyManage == 1 || local.companyAdmin == 1);
        isShare = (profit.isShare == 1);
        
        // 0-未认证，1-已认证 2-认证中 3-认证不通过
        switch (local.companyState) {
            case 0:
            {
                weakself.agreeView.hidden = NO;
                weakself.joinBtn.hidden = NO;
                weakself.notManagerLabel.hidden= YES;
                [weakself.joinBtn setTitle:@"认领组织并加入" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                if (isManager) {
                    if (isShare) {
                        weakself.profitContainerView.hidden = NO;
                        [weakself.profitVC updateWithProfit:profit];
                    } else {
                        weakself.agreeView.hidden = NO;
                        weakself.joinBtn.hidden = NO;
                        weakself.notManagerLabel.hidden= YES;
                        [weakself.joinBtn setTitle:@"我要加入" forState:UIControlStateNormal];
                    }
                } else { // 不是管理员
                    weakself.agreeView.hidden = YES;
                    weakself.joinBtn.hidden = YES;
                    weakself.notManagerLabel.hidden= NO;
                    
                    if (isShare) {
                        weakself.notManagerLabel.text = @"已加入共享，您不是管理员无法查看！";
                    } else {
                        weakself.notManagerLabel.text = @"未加入共享，您不是管理员无法操作！";
                    }
                }
            }
                break;
            case 2:
            {
                weakself.agreeView.hidden = YES;
                weakself.joinBtn.hidden = YES;
                weakself.notManagerLabel.hidden= NO;
                weakself.notManagerLabel.text = @"认领组织审核中";
            }
                break;
            case 3:
            {
                weakself.agreeView.hidden = YES;
                weakself.joinBtn.hidden = YES;
                weakself.notManagerLabel.hidden= NO;
                weakself.notManagerLabel.text = @"认领组织审核不通过";
            }
                break;
                
            default:
            {
                weakself.agreeView.hidden = YES;
                weakself.joinBtn.hidden = YES;
                weakself.notManagerLabel.hidden= NO;
                weakself.notManagerLabel.text = @"认领组织状态未知";
            }
                break;
        }
        
    }];
}


#pragma mark -

- (void)getProfitWithCompanyID:(NSString *)cid success:(void (^)(YCMeetingProfit *data, NSString *companyID))success{
    YCMeetingProfit *profit = self.profitsDic[cid];
    if (profit) {
        if (success) {
            success(profit, cid);
        }
        return ;
    }
    
    __weak typeof(self) weakself = self;
    [YCSpaceBiz getProfitWithType:0 companyID:cid Success:^(YCMeetingProfit *data){
        weakself.profitsDic[cid] = data;
        if (success) {
            success(data, cid);
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
