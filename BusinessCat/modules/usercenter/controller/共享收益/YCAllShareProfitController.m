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
#import "YCPersonalProfitController.h"

// 代码复制：YCJoinShareController、CGInviteMembersViewController

@interface YCAllShareProfitController ()
@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property (nonatomic, strong) NSMutableArray<CGHorrolEntity *> *headViewEntitys;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (nonatomic, strong) ShareUtil *shareUtil;

@property (weak, nonatomic) IBOutlet UIImageView *choseIV;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (nonatomic, assign) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (nonatomic, strong) YCPersonalProfitController *profitVC;
@property (weak, nonatomic) IBOutlet UIView *profitContainerView;

@end

@implementation YCAllShareProfitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    如果当前组织未认领，就显示为“认领组织并加入”，然后打开认领组织功能，增加传加入共享参数（需接口增加）
//    如果当前组织已认领，并且我是管理员，就显示为“我要加入”，需提供加入组织共享接口
//    如果当前组织已认领，并且我不是管理员，两种判断：
//    1）已加入共享，您不是管理员无法查看！
//    2）未加入共享，您不是管理员无法操作！
//    如果已加入，并且是管理员直接显示收益清单：
    
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
        
        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
            
            for(int i=0;i<[ObjectShareTool sharedInstance].currentUser.companyList.count;i++) {
                CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                
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


//- (IBAction)shareAction:(UIButton *)sender {
//  CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[self.currentIndex];
//  NSString *url = local.inviteUrl;
//  NSString *desc = [NSString stringWithFormat:@"%@邀请你加入%@，很多成员已在里面，尽快加入哦。",[ObjectShareTool sharedInstance].currentUser.username,local.companyName];
//  self.shareUtil = [[ShareUtil alloc]init];
//  __weak typeof(self) weakSelf = self;
//  UIImage *image = [UIImage imageNamed:@"login_image"];
//  [self.shareUtil showShareMenuWithTitle:@"邀请你加入组织" desc:desc isqrcode:1 image:image url:url block:^(NSMutableArray *array) {
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
//    [weakSelf presentViewController:activityVC animated:YES completion:nil];
//  }];
//}

#pragma mark -

- (IBAction)clickAgreeBtn:(id)sender {
    self.isAgree = !self.isAgree;
    if (self.isAgree) {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_highlight"];
    } else {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_normal"];
    }
}

- (IBAction)clickJoinBtn:(id)sender {
    if (!self.isAgree) {
        [CTToast showWithText:@"请同意协议"];
    } else {
        __weak typeof(self) weakself = self;
        // 0:公司 1：用户
        [YCSpaceBiz joinShareWithType:self.type companyID:self.companyID doShare:1 Success:^{
            [CTToast showWithText:@"加入成功"];
//            [weakself.navigationController popViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            
        }];
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

- (void)selectItemWithIndex:(int)index data:(CGHorrolEntity *)data {
//    CGHorrolEntity *entity = self.headViewEntitys.firstObject;
//    _profitVC = [YCPersonalProfitController new];
//    _profitVC.shouldHideNavigationBar = YES;
//    _profitVC.type = 0;// 1 个人，0 公司
//    _profitVC.companyID = entity.rolId;
    [_profitVC reloadDataWithCompanyID:data.rolId];
}

@end
