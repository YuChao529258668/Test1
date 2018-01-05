//
//  CGMyMainViewController.m
//  CGSays
//
//  Created by mochenyang on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//  "我的"首页

#import "CGMyMainViewController.h"
#import "CGUserLevelView.h"
#import "CGUserSettingViewController.h"
#import "CGUserHelpViewController.h"
#import "CGMainLoginViewController.h"
#import "CGUserDao.h"
#import "CTRootViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGUserPhoneContactViewController.h"
#import "CGInviteMembersViewController.h"
#import "CGUserContactsViewController.h"
#import "CGUserCompanyPrivilegeViewController.h"
#import "CGUserCollectController.h"
#import "CGRedPacketViewController.h"
#import "CGIntegralMainController.h"
#import "CGAttestationController.h"
#import "CGUserCompanyTowTableViewCell.h"
#import "CGCompanyDao.h"
#import "ChangeOrganizationViewModel.h"
#import "CGUserAuditViewController.h"
#import "CGUserEditDepartmentViewController.h"
#import "CGFeedbackViewController.h"
#import "CGOrderViewController.h"
#import "CGMyReviewViewController.h"
#import "CGInviteFriendsViewController.h"
#import "CGMessageViewController.h"
#import "CGUserFireViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "ShareUtil.h"
#import "CGMessageDetailViewController.h"
#import "TeamCircleLastStateEntity.h"
#import "CGParameterViewController.h"
#import "CGTeamDocumentViewController.h"
#import "CGDiscoverBiz.h"

@interface CGMyMainViewController ()<UIActionSheetDelegate>

@property(nonatomic,retain)UIImageView *userIcon;//用户头像
@property(nonatomic,retain)UILabel *userNameLabel;//用户名
@property(nonatomic,retain)UIImageView *bindAccountImage;//绑定账号的标识
@property(nonatomic,retain)CGUserLevelView *userLevel;//用户级别图标
@property(nonatomic,retain)UIButton *clickToLoginBtn;//点击登录
@property(nonatomic,retain)UIButton *toBeVIPBtn;//成为VIP按钮
@property(nonatomic,retain)UIButton *editUserInfoBtn;//右上角编辑用户信息按钮
@property(nonatomic,retain)UIButton *toSeeVIPDetailBtn;//了解VIP特权按钮

@property(nonatomic,retain)UILabel *message;//消息
@property(nonatomic,retain)UILabel *collect;//收藏
@property(nonatomic,retain)UILabel *order;//订单
@property(nonatomic,retain)UILabel *wallet;//钱包
@property(nonatomic,retain)UILabel *integral;//知识分
@property (nonatomic, strong) UILabel *privilege;//特权

@property(nonatomic,retain)UILabel *companys;
@property (nonatomic, strong) ShareUtil *shareUtil;

@property(nonatomic,retain)UILabel *systemRedHot;//消息红点
@property (nonatomic, strong) UIActionSheet *inviteFriendsSheet;
@property (nonatomic, strong) UIButton *leftBtn;
@property(nonatomic,strong)NSTimer *timer;
@end

#define UserHeaderHeight (SCREEN_HEIGHT/6)//头部高度

#define NormalCellHeight 50//普通cell的高度

#define OrganizeOperateHeight 70//组织相关操作的cell的高度

@implementation CGMyMainViewController

-(UILabel *)systemRedHot{
    if(!_systemRedHot){
        _systemRedHot = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16, 24, 8, 8)];
        _systemRedHot.backgroundColor = [UIColor redColor];
        _systemRedHot.layer.masksToBounds = YES;
        _systemRedHot.layer.cornerRadius = 4;
    }
    return _systemRedHot;
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableview reloadData];
  [self updateLeftButtonState];
}

- (void)viewDidLoad {
    self.title = @"我的";
    [super viewDidLoad];
    [self hideCustomBackBtn];
    
    //重新拉取用户资料
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryRemoteUserDetailInfo) name:NOTIFICATION_TOQUERYUSERINFO object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:NotificationToApplicationDidBecomeActive object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground) name:NotificationToApplicationDidEnterBackground object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRemoteUserDetailInfo) name:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [rightBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_news"] forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSystemMessageRedHot:) name:NotificationSystemMessageRedHot object:nil];
    
    //检查本地是否有保存系统消息未读标识
    [self setSystemRedHotState:[[[NSUserDefaults standardUserDefaults] objectForKey:NotificationSystemMessageRedHot]intValue]];
  
  self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 34, 24)];
  self.leftBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.leftBtn addTarget:self action:@selector(dataAction) forControlEvents:UIControlEventTouchUpInside];
  [self.leftBtn setTitle:@"参数" forState:UIControlStateNormal];
  self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  self.leftBtn.hidden = NO;
  [self.navi addSubview:self.leftBtn];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scoopLastTimer) userInfo:nil repeats:YES];
}

-(void)scoopLastTimer{
  __weak typeof(self) weakSelf = self;
  [[CGDiscoverBiz alloc]queryDiscoverRemind:^(TeamCircleLastStateEntity *result) {
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:result];
    [weakSelf.tableview reloadData];
  } hasSystemMsg:^{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(1) forKey:NotificationSystemMessageRedHot];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSystemMessageRedHot object:@(1)];//1代表有未读消息，标红
  } fail:^(NSError *error) {
  }];
}

-(void)updateLeftButtonState{
  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
    self.leftBtn.hidden = NO;
  }else{
    self.leftBtn.hidden = NO;
  }
}

-(void)notificationSystemMessageRedHot:(NSNotification *)notification{
    int state = [notification.object intValue];
    [self setSystemRedHotState:state];
}
-(void)setSystemRedHotState:(int)state{
    if(state == 1){
        [self.navi addSubview:self.systemRedHot];
    }else{
        [self.systemRedHot removeFromSuperview];
    }
}

-(void)dataAction{
  CGParameterViewController *vc = [[CGParameterViewController alloc]init];
  [self.navigationController pushViewController:vc animated:YES];
}

//app重新回到前台，计算app退出了多久
-(void)applicationDidBecomeActive{
    int current = [[NSDate date]timeIntervalSince1970];
    int diff = current - [ObjectShareTool sharedInstance].appEnterBackgroupTime;
    [ObjectShareTool sharedInstance].loginTimerCount = [ObjectShareTool sharedInstance].appEnterBackgroupSecond - diff;
    if([ObjectShareTool sharedInstance].loginTimerCount <= 0){
        [[ObjectShareTool sharedInstance] stopLoginTimer];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_TIMER object:@(0)];
    }
}

//记录app退出时的时间戳
-(void)applicationDidEnterBackground{
    [ObjectShareTool sharedInstance].appEnterBackgroupTime = [[NSDate date]timeIntervalSince1970];
    [ObjectShareTool sharedInstance].appEnterBackgroupSecond = [ObjectShareTool sharedInstance].loginTimerCount;
}

//获取token回调 state:YES-成功 NO-失败
-(void)tokenCheckComplete:(BOOL)state{
    
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{
    [self.tableview reloadData];
  __weak typeof(self) weakSelf = self;
  [[[CGUserCenterBiz alloc]init] queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
    [weakSelf updateLeftButtonState];
  } fail:^(NSError *error) {
    
  }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
      if ([ChangeOrganizationViewModel getChangeOrganizationState] == ChangeOrganizationNone) {
        return 3;
      }
      return 4;
//        if([ObjectShareTool sharedInstance].currentUser.isLogin == 0){//未登录
//            return 3;
//        }else if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){//已登录
//            if([ChangeOrganizationViewModel getChangeOrganizationState] !=ChangeOrganizationNone){
//                return 4;
//            }else{
//                return 3;
//            }
//        }
    }else if (section == 1){
        return 0;
    }else if(section == 2){
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return UserHeaderHeight;
        }else if(indexPath.row == 1){
            return 55;
        }else if(indexPath.row == 2){
            return NormalCellHeight;
        }else if(indexPath.row == 3){
          if ([ChangeOrganizationViewModel getChangeOrganizationState] != ChangeOrganizationNone) {
            return OrganizeOperateHeight*2;
          }
          return OrganizeOperateHeight;
        }
    }else if(indexPath.section == 1){
        return NormalCellHeight;
    }else if(indexPath.section == 2){
        //根据登录状态控制高度是否显示，不控制cell的数量，这样方便在didselect里处理
        if(indexPath.row == 0){
//            if([ObjectShareTool sharedInstance].currentUser.isLogin == 0){//未登录
//                return 0;
//            }else if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){//已登录
//                return NormalCellHeight;
//            }
          return 0;
        }
    }
    return NormalCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section != 2 ? 0 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = CTCommonViewControllerBg;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.clipsToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        if(indexPath.section == 0 && indexPath.row == 1){
            [self generateFunctionMenuWithContentView:cell.contentView];
        }
        if(indexPath.section == 0){
            if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(indexPath.row == 2){
                cell.imageView.image = [UIImage imageNamed:@"subordinateorg"];
                cell.textLabel.text = @"所属组织";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.contentView addSubview:self.companys];
            }else if(indexPath.row == 3){
              static NSString*towIdentifier = @"CGUserCompanyTowTableViewCell";
              CGUserCompanyTowTableViewCell *cell = (CGUserCompanyTowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:towIdentifier];
              if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanyTowTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
              }
              
              __weak typeof(self) weakSelf = self;
              [cell info:[ObjectShareTool sharedInstance].currentUser.companyList];
              [cell didSelectedButtonIndex:^(NSInteger type) {
                switch (type) {
                  case OrganisationSelectTypeClaim:{//认领组织
                      CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
                      [weakSelf.navigationController pushViewController:controller animated:YES];
                  }
                    break;
                    case OrganisationSelectTypeJoinAudit:{//加入审核
                        CGUserAuditViewController *controller = [[CGUserAuditViewController alloc]init];
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    }
                    
                    break;
                    case OrganisationSelectTypeAddressbook:{//通讯录
                        CGUserContactsViewController *vc = [[CGUserContactsViewController alloc]init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                    case OrganisationSelectTypeNviteMembers:{////邀请成员
                      CGInviteMembersViewController *vc = [[CGInviteMembersViewController alloc]init];
                      [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    
                    break;
                  case OrganisationSelectTypePrivilege:
                    //团队特权
                  {
                    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
                    vc.type = 1;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                  }
                    break;
                  case OrganisationSelectTypeEnterpriseCircle:
                    //企业圈
                  {
                    CGDiscoverTeamCircelViewController *vc = [CGDiscoverTeamCircelViewController sharedInstance];
                    [self.navigationController pushViewController:vc animated:YES];
                    TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
                    entity.badge.userName = nil;
                    entity.badge.portrait = nil;
                    [TeamCircleLastStateEntity saveToLocal:entity];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:entity];
                    [self.tableview reloadData];
                  }
                    break;
                  case OrganisationSelectTypeEnterpriseFire:
                    //企业文档
                  {
                    CGTeamDocumentViewController *vc = [[CGTeamDocumentViewController alloc]init];
                    vc.title = @"企业文库";
                    vc.type = 2;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                  }
                    break;
                  case OrganisationSelectTypeHousekeeper:
                    //企业管家
                  {
                    CGFeedbackViewController *vc = [[CGFeedbackViewController alloc]init];
                    vc.type = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                  }
                    break;
                  case OrganisationSelectTypeToSearch:
                    //没有加入组织跳搜索
                  {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先加入所属组织" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
                    [alertView show];
                  }
                    break;
                  case OrganisationSelectTypeIsLogOut:
                    //没有加入组织跳搜索
                  {
                    [weakSelf clickToLoginAction];
                  }
                    break;
                  default:
                    break;
                }
              }];
              return cell;
            }
        }else if(indexPath.section == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            if(indexPath.row == 0){
//                cell.imageView.image = [UIImage imageNamed:@"jpsrole"];
//                cell.textLabel.text = @"任务大厅";
//                [cell.contentView addSubview:[self createCellDetail:@"用知识获取回报" color:[CTCommonUtil convert16BinaryColor:@"#FB5B5E"]]];
//            }else
              if(indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"dianping"];
                cell.textLabel.text = @"我的点评";
//                [cell.contentView addSubview:[self createCellDetail:@"点评送大礼" color:[CTCommonUtil convert16BinaryColor:@"#FB5B5E"]]];
            }else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"feedback"];
                cell.textLabel.text = @"意见反馈";
            }
        }else if(indexPath.section == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if(indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"customer"];
                cell.textLabel.text = @"专属客服";
                [cell.contentView addSubview:[self createCellDetail:@"静静" color:[UIColor grayColor]]];
            }else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"invitefriends"];
                cell.textLabel.text = @"邀请好友";
//              [cell.contentView addSubview:[self createCellDetail:@"邀请送大礼" color:[CTCommonUtil convert16BinaryColor:@"#FB5B5E"]]];
            }else if(indexPath.row == 2){
                cell.imageView.image = [UIImage imageNamed:@"helpp"];
                cell.textLabel.text = @"帮助";
            }else if(indexPath.row == 3){
                cell.imageView.image = [UIImage imageNamed:@"user_set"];
                cell.textLabel.text = @"设置";
            }
        }
    }
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){//用户信息
            [cell.contentView addSubview:self.userIcon];
            [cell.contentView addSubview:self.toBeVIPBtn];
            [cell.contentView addSubview:self.toSeeVIPDetailBtn];
            
            if([ObjectShareTool sharedInstance].currentUser.isLogin == 0){//未登录
                self.userIcon.image = [UIImage imageNamed:@"Default_login"];
                [cell.contentView addSubview:self.clickToLoginBtn];
                [self.userNameLabel removeFromSuperview];
                [self.bindAccountImage removeFromSuperview];
                [self.userLevel removeFromSuperview];
                [self.editUserInfoBtn removeFromSuperview];
                
//                [self.toBeVIPBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.toBeVIPBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.toBeVIPBtn setTitle:@"成为VIP" forState:UIControlStateNormal];
                [self.toBeVIPBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                
                
            }else if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){//已登录
                [self.clickToLoginBtn removeFromSuperview];
                [cell.contentView addSubview:self.userNameLabel];
                [cell.contentView addSubview:self.userLevel];
                [cell.contentView addSubview:self.editUserInfoBtn];
                
                CGRect userNameRect = self.userNameLabel.frame;
                self.userNameLabel.text = [ObjectShareTool sharedInstance].currentUser.username;
                [self.userNameLabel sizeToFit];
                userNameRect.size.width = self.userNameLabel.frame.size.width;
                self.userNameLabel.frame = userNameRect;
                
                if([ObjectShareTool sharedInstance].currentUser.bindWeixin == 0){//未绑定微信
                    [self.bindAccountImage removeFromSuperview];
                }else if ([ObjectShareTool sharedInstance].currentUser.bindWeixin == 1){//已绑定微信
                    [cell.contentView addSubview:self.bindAccountImage];
                    CGRect bindAccountImageRect = self.bindAccountImage.frame;
                    bindAccountImageRect.origin.x = CGRectGetMaxX(self.userNameLabel.frame)+5;
                    self.bindAccountImage.frame = bindAccountImageRect;
                }
                //设置头像
                if([[ObjectShareTool sharedInstance].currentUser.portrait containsString:@"http://pic.jp580.com"]){
                    NSString *iconUrl = [[ObjectShareTool sharedInstance].currentUser.portrait stringByAppendingString:@"?imageView2/2/w/200/h/200/interlace/1/format/jpg"];
                    
                    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"Default_login"]];
                }else{
                    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[ObjectShareTool sharedInstance].currentUser.portrait] placeholderImage:[UIImage imageNamed:@"Default_login"]];
                }
                
                //设置用户级别
                [self.userLevel setLevelName];
//                if([ObjectShareTool sharedInstance].currentUser.isVip == 1){
//                    [self.toBeVIPBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
                  [self.toBeVIPBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.toBeVIPBtn setTitle:@"我的特权" forState:UIControlStateNormal];
//                    [self.toBeVIPBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                  [self.toBeVIPBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                  [self.toSeeVIPDetailBtn removeFromSuperview];
//                }else if ([ObjectShareTool sharedInstance].currentUser.isVip == 2) {
//                  [self.toBeVIPBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                  [self.toBeVIPBtn setTitle:@"续费VIP" forState:UIControlStateNormal];
//                  [self.toBeVIPBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//                }else{
//                    [self.toBeVIPBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    [self.toBeVIPBtn setTitle:@"成为VIP" forState:UIControlStateNormal];
//                    [self.toBeVIPBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//                }
            }
        }else if(indexPath.row == 1){//菜单
            self.message.text = [NSString stringWithFormat:@"%d",[ObjectShareTool sharedInstance].currentUser.messageNum];
            self.collect.text = [NSString stringWithFormat:@"%d",[ObjectShareTool sharedInstance].currentUser.followNum];
            self.order.text = [NSString stringWithFormat:@"%d",[ObjectShareTool sharedInstance].currentUser.orderNum];
            self.wallet.text = [NSString stringWithFormat:@"%.2f",[ObjectShareTool sharedInstance].currentUser.totalAmount/100];
            self.integral.text = [NSString stringWithFormat:@"%d",[ObjectShareTool sharedInstance].currentUser.integralNum];
//          self.privilege.text = [NSString stringWithFormat:@""]
        }else if(indexPath.row == 2){//所属组织
            if([ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
                NSMutableString *organizaName = [NSMutableString string];
                for(CGUserOrganizaJoinEntity *organiza in [ObjectShareTool sharedInstance].currentUser.companyList){
                    [organizaName appendString:organiza.companyName];
                    [organizaName appendString:@","];
                }
                NSString *name;
                if(organizaName.length > 16){
                    name = [organizaName substringToIndex:15];
                }else{
                    name = [organizaName substringToIndex:organizaName.length-1];
                }
                self.companys.text = [NSString stringWithFormat:@"%lu家(%@)",(unsigned long)[ObjectShareTool sharedInstance].currentUser.companyList.count,name];
              self.companys.numberOfLines = 2;
              self.companys.lineBreakMode = NSLineBreakByCharWrapping;
              self.companys.frame = CGRectMake(120, 15, SCREEN_WIDTH-120-35, 20);
            }else{
                self.companys.text = @"";
            }
            
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    if(indexPath.section == 0){
        if(indexPath.row == 2){
              CGUserChangeOrganizationViewController *controller =[[CGUserChangeOrganizationViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(indexPath.section == 1){
      if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        if (indexPath.row == 1) {
          //反馈意见
          CGFeedbackViewController *vc = [[CGFeedbackViewController alloc]init];
          [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 0){
          CGMyReviewViewController *vc = [[CGMyReviewViewController alloc]init];
          [self.navigationController pushViewController:vc animated:YES];
        }
      }else{
        [self clickToLoginAction];
      }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
//          //邀请好友
//          CGInviteFriendsViewController *vc = [[CGInviteFriendsViewController alloc]init];
//          [self.navigationController pushViewController:vc animated:YES];
          
          [self callInviteFriendsSheetFunc];
        }else if(indexPath.row == 2){
            CGUserHelpViewController *controller = [[CGUserHelpViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(indexPath.row == 3){
            CGUserSettingViewController *vc = [[CGUserSettingViewController alloc] initWithBlock:^{
              [weakSelf updateLeftButtonState];
                [weakSelf.tableview reloadData];
            } fail:^(NSError *error) {
                
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

//用户头像
-(UIImageView *)userIcon{
    if(!_userIcon){
        float iconLength = UserHeaderHeight - 55;
        _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, (UserHeaderHeight)/2-iconLength/2,iconLength,iconLength)];
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
        _userIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserIconAction)];
        [_userIcon addGestureRecognizer:tapGesture];
        _userIcon.image = [UIImage imageNamed:@"Default_login"];
        _userIcon.backgroundColor = CTCommonViewControllerBg;
        _userIcon.layer.cornerRadius = (iconLength)/2;
        _userIcon.layer.masksToBounds = YES;
      _userIcon.layer.borderWidth = 0.5;
      _userIcon.layer.borderColor = CTCommonLineBg.CGColor;
    }
    return _userIcon;
}

//用户名字
-(UILabel *)userNameLabel{
    if(!_userNameLabel){
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userIcon.frame)+15, CGRectGetMidY(self.userIcon.frame)-25, 100, 25)];
        _userNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _userNameLabel;
}

//编辑档案按钮
-(UIButton *)editUserInfoBtn{
    if(!_editUserInfoBtn){
        _editUserInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 55, 35)];
        [_editUserInfoBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editUserInfoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editUserInfoBtn addTarget:self action:@selector(editUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
        [_editUserInfoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _editUserInfoBtn;
}

//绑定第三方账号的图标
-(UIImageView *)bindAccountImage{
    if(!_bindAccountImage){
        _bindAccountImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+5, CGRectGetMinY(self.userNameLabel.frame)+self.userNameLabel.frame.size.height/2-18/2,18,18)];
        _bindAccountImage.image = [UIImage imageNamed:@"my_bindweixin"];
        _bindAccountImage.layer.cornerRadius = 18/2;
        _bindAccountImage.layer.masksToBounds = YES;
    }
    return _bindAccountImage;
}

//用户级别view
-(CGUserLevelView *)userLevel{
    if(!_userLevel){
        _userLevel = [[CGUserLevelView alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+2, 150, 20)];
    }
    return _userLevel;
}

-(UIButton *)clickToLoginBtn{
    if(!_clickToLoginBtn){
        _clickToLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userIcon.frame)+15, self.userIcon.frame.origin.y, 100, self.userIcon.frame.size.height)];
        _clickToLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_clickToLoginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        _clickToLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_clickToLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_clickToLoginBtn addTarget:self action:@selector(clickToLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickToLoginBtn;
}
-(UIButton *)toBeVIPBtn{
    if(!_toBeVIPBtn){
        _toBeVIPBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, CGRectGetMinY(self.userIcon.frame) + self.userIcon.frame.size.height/2-30/2, 70, 30)];
      [_toBeVIPBtn addTarget:self action:@selector(clickTOBeVIP) forControlEvents:UIControlEventTouchUpInside];
        _toBeVIPBtn.layer.borderColor = CTThemeMainColor.CGColor;
        _toBeVIPBtn.layer.borderWidth = 0.7f;
        _toBeVIPBtn.layer.cornerRadius = 3;
        _toBeVIPBtn.layer.masksToBounds = YES;
        _toBeVIPBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _toBeVIPBtn;
}

-(UIButton *)toSeeVIPDetailBtn{
  if (!_toSeeVIPDetailBtn) {
    _toSeeVIPDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95, self.toBeVIPBtn.frame.size.height+self.toBeVIPBtn.frame.origin.y, 90, 30)];
    [_toSeeVIPDetailBtn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [_toSeeVIPDetailBtn setTitle:@"了解VIP特权" forState:UIControlStateNormal];
    [_toSeeVIPDetailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _toSeeVIPDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_toSeeVIPDetailBtn addTarget:self action:@selector(clickToSeeVIPDetail) forControlEvents:UIControlEventTouchUpInside];
  }
  return _toSeeVIPDetailBtn;
}

//加入的公司控件
-(UILabel *)companys{
    if(!_companys){
        _companys = [self createCellDetail:@"" color:[UIColor grayColor]];
    }
    return _companys;
}

//创建header的菜单
-(void)generateFunctionMenuWithContentView:(UIView *)contentView{
    int menuNum = 4;
    float itemWidth = SCREEN_WIDTH/menuNum;
    float itemHeight = 55;
  [contentView addSubview:[self createFunctionMenuWith:CGRectMake(0, 0, itemWidth, itemHeight) titleStr:@"收藏" showVerLine:YES method:@selector(collectAction) index:1 image:[UIImage imageNamed:@"minecollection"]]]; // "管家"
    [contentView addSubview:[self createFunctionMenuWith:CGRectMake(itemWidth, 0, itemWidth, itemHeight) titleStr:@"知识币" showVerLine:YES method:@selector(integralAction) index:4 image:[UIImage imageNamed:@"knowledgegold"]]];
  [contentView addSubview:[self createFunctionMenuWith:CGRectMake(itemWidth*2, 0, itemWidth, itemHeight) titleStr:@"点评" showVerLine:YES method:@selector(reviewAction) index:5 image:[UIImage imageNamed:@"dianping"]]];
  [contentView addSubview:[self createFunctionMenuWith:CGRectMake(itemWidth*3, 0, itemWidth, itemHeight) titleStr:@"订单" showVerLine:NO method:@selector(orderAction) index:2 image:[UIImage imageNamed:@"mineorder"]]];
}

-(UIView *)createFunctionMenuWith:(CGRect)frame titleStr:(NSString *)titleStr showVerLine:(BOOL)showVerLine method:(SEL)method index:(int)index image:(UIImage *)image{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:method];
    [view addGestureRecognizer:tapGesture];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2-20, frame.size.width, 20)];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor darkGrayColor];
//    title.font = [UIFont systemFontOfSize:14];
//    title.text = @"0";
  UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-22)/2, 7, 22, 22)];
  iv.image = image;
  [view addSubview:iv];
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), frame.size.width, 20)];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.font = [UIFont systemFontOfSize:13];
//    if(index == 0){
//        self.message = title;
//    }else if (index == 1){
//        self.collect = title;
//    }else if (index == 2){
//        self.order = title;
//    }else if (index == 3){
//        self.wallet = title;
//    }else if (index == 4){
//        self.integral = title;
//    }else if (index == 5){
//      self.privilege = title;
//    }
    desc.text = titleStr;
//    [view addSubview:title];
    [view addSubview:desc];
    
    if(showVerLine){
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-0.5, frame.size.height/2-frame.size.height/2/2, 0.5, frame.size.height/2)];
        verLine.backgroundColor = CTCommonLineBg;
        [view addSubview:verLine];
    }
    return view;
}


-(UILabel *)createCellDetail:(NSString *)str color:(UIColor *)color{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH-120-35, NormalCellHeight)];
    label.text = str;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = color;
    label.clipsToBounds = YES;
    return label;
}


#pragma Action

//点击头像
-(void)clickUserIconAction{
    if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){//已登录
        [self editUserInfoAction];
    }else{
        [self clickToLoginAction];
    }
}

//点击点评
-(void)reviewAction{
  if([ObjectShareTool sharedInstance].currentUser.isLogin == 1){//已登录
    CGMyReviewViewController *vc = [[CGMyReviewViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
  }else{
    [self clickToLoginAction];
  }
}


//点击消息
-(void)messageAction{
    NSLog(@"消息");
//    CGMessageViewController *controller = [[CGMessageViewController alloc]init];
//    [self.navigationController pushViewController:controller animated:YES];
  CGMessageDetailViewController *vc = [[CGMessageDetailViewController alloc]init];
  vc.title = @"消息";
  vc.type = 1000;
  vc.ID = @"";
  [self.navigationController pushViewController:vc animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(0) forKey:NotificationSystemMessageRedHot];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSystemMessageRedHot object:@(0)];
}

//点击收藏
-(void)collectAction{
    NSLog(@"收藏");
    CGUserCollectController *controller = [[CGUserCollectController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

//点击特权
-(void)downLoadAction{
  
}

//点击订单
-(void)orderAction{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
    NSLog(@"订单");
    CGOrderViewController *vc = [[CGOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
  }else{
    [self clickToLoginAction];
  }
}

//点击钱包
-(void)walletAction{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
    NSLog(@"钱包");
    CGRedPacketViewController *controller = [[CGRedPacketViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
  }else{
    [self clickToLoginAction];
  }
}

//点击知识分
-(void)integralAction{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
    CGIntegralMainController *controller = [[CGIntegralMainController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
  }else{
    [self clickToLoginAction];
  }
}

//认领组织
-(void)claimOrganize{

}

//编辑档案
-(void)editUserInfoAction{
//  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
//    __weak typeof(self) weakSelf = self;
      CGUserFireViewController *controller = [[CGUserFireViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
//    CGUserFireViewController *vc = [[CGUserFireViewController alloc]init];
//    [vc didSelectedButtonIndex:^(NSString *success) {
//      [weakSelf.tableview reloadData];
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
//  }else{
//    [self clickToLoginAction];
//  }
}

//通讯录
-(void)teamAddressBook{
    NSLog(@"通讯录");
    CGUserContactsViewController *vc = [[CGUserContactsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
////邀请成员
//-(void)inviteMember{
//    NSLog(@"邀请成员");
//    CGUserPhoneContactViewController *vc = [[CGUserPhoneContactViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//团队特权
-(void)teamPrivilege{
    NSLog(@"团队特权");
    //团队特权
    CGUserCompanyPrivilegeViewController *vc = [[CGUserCompanyPrivilegeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

//成为VIP
-(void)clickTOBeVIP{
//  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
      CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
      [self.navigationController pushViewController:vc animated:YES];
//
//  }else{
//    [self clickToLoginAction];
//  }
}

-(void)clickToSeeVIPDetail{
  CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
  [self.navigationController pushViewController:vc animated:YES];
}

//点击登录
-(void)clickToLoginAction{
    __weak typeof(self) weakSelf = self;
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
      [weakSelf.tableview reloadData];
      [weakSelf updateLeftButtonState];
    } fail:^(NSError *error) {
      
    }];
//    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

//查询服务器的用户详细信息
-(void)queryRemoteUserDetailInfo{
    __weak typeof(self) weakSelf = self;
    [[[CGUserCenterBiz alloc]init] queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
      [weakSelf.tableview reloadData];
      [weakSelf updateLeftButtonState];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
    } fail:^(NSError *error) {
      
    }];
}


//邀请好友
- (void)callInviteFriendsSheetFunc{
  self.inviteFriendsSheet = [[UIActionSheet alloc] initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信版邀请",@"App下载邀请", nil];
  self.inviteFriendsSheet.tag = 1003;
  [self.inviteFriendsSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
  NSString *url;
  if (actionSheet.tag == 1003){
    switch (buttonIndex) {
      case 0:
        //微信版邀请
        if (![CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].inviteFriend.invitationUrl]) {
          __weak typeof(self) weakSelf = self;
          [[[CGUserCenterBiz alloc] init] authUserInviteFriendsSuccess:^(CGInviteFriendEntity *reslut) {
            [CGCompanyDao saveInviteFriendsStatistics:reslut];
            [ObjectShareTool sharedInstance].inviteFriend = reslut;
            NSString *name = [CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]?[ObjectShareTool sharedInstance].currentUser.username:@"";
            NSString *title = [NSString stringWithFormat:@"%@邀请你加入广州创将。马上点击链接%@ ,下载app后通过微信或手机号登录，团队成员都在等你了，点击链接快快加入哦！",name,reslut.invitationUrl];
            weakSelf.shareUtil = [[ShareUtil alloc]init];
            UIImage *image = [UIImage imageNamed:@"login_image"];
            [weakSelf.shareUtil showShareMenuWithTitle:@"" desc:title isqrcode:1 image:image url:reslut.invitationUrl block:^(NSMutableArray *array) {
              UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
              [weakSelf presentViewController:activityVC animated:YES completion:nil];
            }];
          } fail:^(NSError *error) {
            [ObjectShareTool sharedInstance].inviteFriend = [CGCompanyDao getInviteFriendsStatisticsFromLocal];
          }];
          return;
        }else{
         url = [ObjectShareTool sharedInstance].inviteFriend.invitationUrl;
        }
        break;
      case 1:
        //App下载邀请
        url = APP_STORE_URL;
        break;
      case 2:
        return;
        break;
    }
  }
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  UIImage *image = [UIImage imageNamed:@"login_image"];
  [self.shareUtil showShareMenuWithTitle:@"好友邀请你使用会议猫" desc:@"我正在使用会议猫，它是非常棒的智能知识管家，现在也推荐给你" isqrcode:1 image:image url:url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
