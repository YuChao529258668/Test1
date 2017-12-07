//
//  CGDiscoverMainController.m
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverMainController.h"
#import "WKWebViewController.h"
#import "CGUserDao.h"
#import "CGDiscoverSourceCircleViewController.h"
#import "CGMainLoginViewController.h"
#import "DiscoverIndexTableViewCell.h"
#import "DiscoverTeamTableViewCell.h"
#import "CGDiscoverAppsEntity.h"
#import "CGDiscoverBiz.h"
#import "CGDiscoverDataEntity.h"
#import "CGDiscoverAppsEntity.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "SDCycleScrollView.h"
#import "CGProductReviewViewController.h"
#import "CGProductInterfaceViewController.h"
#import "CGDiscoverTeamCircelViewController.h"
#import "commonViewModel.h"
#import "CGInterfaceViewController.h"
#import "CGToolViewController.h"
#import "CGTeamDocumentViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGUserOrganizaJoinEntity.h"

#import "CGUrlView.h"

@interface CGDiscoverMainController ()<SDCycleScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *topView;

@property (nonatomic, strong) CGDiscoverDataEntity *dataEntity;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) commonViewModel *viewModel;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger viewPermit;
@end

@implementation CGDiscoverMainController


-(SDCycleScrollView *)topView{
    if(!_topView){
        _topView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPIMAGEHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"faxianmorentu"]];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _topView.currentPageDotColor = [UIColor colorWithWhite:0.7 alpha:0.5]; // 自定义分页控件小圆标颜色
        _topView.pageDotColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        _topView.autoScrollTimeInterval = 30;
    }
    return _topView;
}


-(void)viewWillAppear:(BOOL)animated{
    self.isClick = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.isClick = YES;
}

-(void)tokenCheckComplete:(BOOL)state{
    if (state) {
        [self getLocalityData];
        [self getData];
        [CGDiscoverTeamCircelViewController sharedInstance];
    }
}

-(commonViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[commonViewModel alloc]init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百宝箱";//发现
    [self hideCustomBackBtn];
    self.tableview.separatorStyle = NO;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"station_magnifier"] forState:UIControlStateNormal];
  
    [self.navi addSubview:rightBtn];
    //重新拉取用户资料
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOuntSuccess) name:NOTIFICATION_LOGOUT object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCompanyState) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scoopLastTimer) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationReloadTable) name:NOTIFICATION_DISCOVER_MAINPAGE_RELOAD object:nil];
}

-(void)updateCompanyState{
  if ([ObjectShareTool sharedInstance].currentUser.companyList.count<=0) {
    TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
    entity.badge.userName = nil;
    entity.badge.portrait = nil;
    [TeamCircleLastStateEntity saveToLocal:entity];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:entity];
    [self.tableview reloadData];
  }
  [self getData];
}

//-(void)scoopLastTimer{
//    __weak typeof(self) weakSelf = self;
//    [[CGDiscoverBiz alloc]queryDiscoverRemind:^(TeamCircleLastStateEntity *result) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:result];
//        [weakSelf.tableview reloadData];
//    } hasSystemMsg:^{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@(1) forKey:NotificationSystemMessageRedHot];
//        [defaults synchronize];
//        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSystemMessageRedHot object:@(1)];//1代表有未读消息，标红
//    } fail:^(NSError *error) {
//    }];
//}

-(void)notificationReloadTable{
    [self.tableview reloadData];
}

-(void)loginSuccess{
    [self getData];
}

-(void)logOuntSuccess{
    [self getData];
}

- (void)rightBtnAction{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 0;
    vc.action = @"library";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getLocalityData{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:DISCOVER_DATA];
    // 解档
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [CGDiscoverAppsEntity mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"gropuApps" : @"CGGropuAppsEntity",
                 };
    }];
    
    NSMutableData *bannerData = [NSMutableData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CTFileUtil getDocumentsPath],DISCOVER_TOP_DATA]];
    if(data){
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:bannerData];
        self.dataEntity = [unarchiver decodeObjectForKey:DISCOVER_TOP_DATA];
    }
    
    self.listArray = [NSMutableArray array];
    if(data && data.count > 0){
        CGDiscoverAppsEntity *comment;
        for(NSDictionary *dict in data){
            comment = [CGDiscoverAppsEntity mj_objectWithKeyValues:dict];
            [self.listArray addObject:comment];
        }
    }
    if(self.listArray.count <= 0 || !self.dataEntity){
        [self getData];
    }
    [self.tableview reloadData];
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  [biz discoverDataAction:2 navType:nil time:nil success:^(CGDiscoverDataEntity *entity) {
      weakSelf.dataEntity = entity;
      [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
      [weakSelf.tableview reloadData];
    }];
    [biz loadHomePageAppsSuccess:^(NSMutableArray *result, BOOL hasChanged) {
        weakSelf.listArray = result;
        [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
        
    }];
}


//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{
    self.isClick = YES;
    [self getLocalityData];
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  if (self.dataEntity.banner.count>0) {
    BannerData *entity = self.dataEntity.banner[index];
    [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:nil typeArray:nil];
  }
}

-(BOOL)isHaveTeamCircel{
  BOOL ishave = NO;
  for (CGUserOrganizaJoinEntity *companyEntity in [ObjectShareTool sharedInstance].currentUser.companyList) {
    if (companyEntity.auditStete == 1) {
      ishave = YES;
      break;
    }
  }
  return ishave;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {          
            return TOPIMAGEHEIGHT;
        }
    }
//    else if (indexPath.section == 1){
//      if ([self isHaveTeamCircel]) {
//        return 50;
//      }
//        return 0;
//    }
    else{
        if (indexPath.row == 0) {
            return 35;
        }else if (indexPath.row == 1){
            CGDiscoverAppsEntity *entity = self.listArray[indexPath.section-1];
            return [DiscoverIndexTableViewCell heightWithArray:entity.gropuApps];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 28;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count+1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return nil;
//    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            
            [cell.contentView addSubview:self.topView];
            NSMutableArray *array = [NSMutableArray array];
            for (BannerData *image in self.dataEntity.banner) {
                NSString *src = image.src;
                [array addObject:src];
            }
          if (array.count<=0) {
            self.topView.localizationImageNamesGroup = @[[UIImage imageNamed:@"faxian_adspictures"]];
          }else{
           self.topView.imageURLStringsGroup = array;
          }
            return cell;
        }
    }
//    else if (indexPath.section == 1){
//        NSString*identifier = @"DiscoverTeamTableViewCell";
//        DiscoverTeamTableViewCell *cell = (DiscoverTeamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DiscoverTeamTableViewCell" owner:self options:nil];
//            cell = [array objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
//        [cell updateUserName:entity.badge.userName userIcon:entity.badge.portrait num:entity.count];
//        return cell;
//    }
    else{
        CGDiscoverAppsEntity *entity = self.listArray[indexPath.section-1];
        if (indexPath.row == 0) {
            NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = entity.groupName;
            
            return cell;
        }else{
            NSString*identifier = @"DiscoverIndexTableViewCell";
            DiscoverIndexTableViewCell *cell = (DiscoverIndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DiscoverIndexTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for(UIView *mylabelview in [cell.contentView subviews])
            {
                if ([mylabelview isKindOfClass:[UILabel class]]) {
                    [mylabelview removeFromSuperview];
                }
            }
            __weak typeof(self) weakSelf = self;
            [cell updateApplyWithapplyList:entity.gropuApps];
            [cell didSelectedButtonIndex:^(CGGropuAppsEntity *entity) {
                if (entity.permission == 1) {
                    //初始化AlertView
                    if ([ObjectShareTool sharedInstance].currentUser.isLogin==0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请登录后才能使用该功能"
                                                                       delegate:weakSelf
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"登录",nil];
                        alert.tag = 1000;
                        [alert show];
                        return ;
                    }
                }else if (entity.permission == 2&&entity.activation == 0){
                    NSString *str;
                    weakSelf.viewPermit = entity.viewPermit;
                    if (entity.viewPermit == 1) {
                        str = @"成为VIP会员";
                    }else if (entity.viewPermit == 2){
                        str = @"成为VIP企业";
                        if ([ObjectShareTool sharedInstance].currentUser.companyList.count<=0) {
                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                            [[CTToast makeText:@"请先加入企业"]show:window];
                            return;
                        }
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:entity.viewPrompt
                                                                   delegate:weakSelf
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:str,nil];
                    alert.tag = 1001;
                    [alert show];
                    return ;
                }
                if (entity.activation == 0) {
                    return ;
                }
                
                if ([entity.code isEqualToString:@"discover/galleryList"]) {//app界面
                    CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 1;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/webUiList"]){//网站界面
                    CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 2;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/publicityUiList"]){//产品宣传图
                    CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 3;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/posterUiList"]){//手机海报
                    CGInterfaceViewController *vc = [[CGInterfaceViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 4;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/planList"]){//行业方案
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 3;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/reportList"]){//行业报告
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 4;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/documentList"]){//办公文档
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 5;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/businessPlanList"]){//商业计划书
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 7;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/publicOfferingList"]){//上市企业
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 8;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/kengPoList"]){//产品报告
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 1;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/application"]){//企业报告
                    CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                    vc.titleStr = entity.name;
                    vc.type = 6;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/jobToolsList"]){//岗位工具
                    CGToolViewController *vc = [[CGToolViewController alloc]init];
                    vc.title = entity.name;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/vipUserExclusive"]){//VIP会员专享
                    CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
                    vc.title = entity.name;
                    vc.type = 0;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/vipCompanyExclusive"]){//VIP企业专享
                    CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
                    vc.title = entity.name;
                    vc.type = 1;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/teamFile"]){//团队文档
                    CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
                    vc.title = entity.name;
                    vc.type = 2;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if ([entity.code isEqualToString:@"discover/packageList"]){//知识专辑
                  CGProductReviewViewController *vc = [[CGProductReviewViewController alloc]init];
                  vc.titleStr = entity.name;
                  vc.type = 9;
                  [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        CGDiscoverTeamCircelViewController *vc = [CGDiscoverTeamCircelViewController sharedInstance];
//        [self.navigationController pushViewController:vc animated:YES];
//        TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
//        entity.badge.userName = nil;
//        entity.badge.portrait = nil;
//        [TeamCircleLastStateEntity saveToLocal:entity];
//        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:entity];
//        [self.tableview reloadData];
//    }
}

-(void)callbackAttentionToH5:(NSString *)path{
    if (self.isClick) {
        self.isClick = NO;
        __weak typeof(self) weakSelf = self;
        [WKWebViewController setPath:@"setCurrentPath" code:path success:^(id response) {
        } fail:^{
            weakSelf.isClick = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击登录
-(void)clickToLoginAction{
    __weak typeof(self) weakSelf = self;
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
        [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
        
    }];
    //  [self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self clickToLoginAction];
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
            if (self.viewPermit == 1) {//成为VIP会员
                vc.type = 0;
            }else if (self.viewPermit == 2){//成为VIP企业
                vc.type = 1;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
