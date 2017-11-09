////
////  CGCorporateMemberViewController.m
////  CGKnowledge
////
////  Created by zhu on 2017/5/8.
////  Copyright © 2017年 cgsyas. All rights reserved.
////
//
#import "CGCorporateMemberViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserMemberTableViewCell.h"
#import "CGUserMemberHeaderTableViewCell.h"
#import "CGCorporateMemberEntity.h"
#import "CGInviteFriendsViewController.h"
#import "CGBuyVIPViewController.h"
#import "CGCompanyDao.h"

@interface CGCorporateMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CGCorporateMemberEntity *entity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGCorporateMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"VIP会员介绍";
  self.biz = [[CGUserCenterBiz alloc]init];
//  __weak typeof(self) weakSelf = self;
  self.bgView.backgroundColor = CTThemeMainColor;
//  self.dataArray = [CGCompanyDao getUserPrivilegeStatisticsFromLocal];
  [self.tableview reloadData];
//  [self.biz userPrivilegeWithType:0 success:^(NSMutableArray *reslut) {
//    weakSelf.dataArray = reslut;
//    [weakSelf.tableView reloadData];
//    [CGCompanyDao saveUserPrivilegeStatistics:reslut];
//  } fail:^(NSError *error) {
//    
//  }];
    // Do any additional setup after loading the view from its nib.
}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.section == 0) {
//    return 195;
////    return 83;
//  }
//  return 50;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//  return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//  if (section==0) {
//    return 1;
//  }
//  return self.entity.privilegeList.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//  if (section==1) {
//    return 50;
//  }
//  return 0;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//  if (section==1) {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    view.backgroundColor = CTCommonViewControllerBg;
//    UILabel *FirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50)];
//    FirstLabel.text = @"服务";
//    FirstLabel.textAlignment = NSTextAlignmentCenter;
//    FirstLabel.textColor = CTThemeMainColor;
//    FirstLabel.font = [UIFont systemFontOfSize:16];
//    UILabel *SecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50)];
//    [view addSubview:FirstLabel];
//    SecondLabel.text = @"普通会员";
//    SecondLabel.textAlignment = NSTextAlignmentCenter;
//    SecondLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#777777"];
//    SecondLabel.font = [UIFont systemFontOfSize:16];
//    UILabel *ThreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50)];
//    [view addSubview:SecondLabel];
//    ThreeLabel.text = @"VIP会员";
//    ThreeLabel.textAlignment = NSTextAlignmentCenter;
//    ThreeLabel.textColor = CTThemeMainColor;
//    ThreeLabel.font = [UIFont systemFontOfSize:16];
//    [view addSubview:ThreeLabel];
//    return view;
//  }
//  return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  [tableView deselectRowAtIndexPath:indexPath animated:YES];
//  
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//  if (indexPath.section == 0) {
//    static NSString*identifier = @"CGUserMemberHeaderTableViewCell";
//    CGUserMemberHeaderTableViewCell *cell = (CGUserMemberHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMemberHeaderTableViewCell" owner:self options:nil];
//      cell = [array objectAtIndex:0];
//      [cell.buyVIP addTarget:self action:@selector(buyVIPClick) forControlEvents:UIControlEventTouchUpInside];
//      [cell.InviteColleagues addTarget:self action:@selector(inviteColleaguesClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    CGSettingEntity *entity = [CGCompanyDao getSettingStatisticsFromLocal];
//    cell.vipLabel.text = entity.timeLimit;
//    cell.inviteLabel.text = entity.successfulInvitation;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//  }else{
//    static NSString*identifier = @"CGUserMemberTableViewCell";
//    CGUserMemberTableViewCell *cell = (CGUserMemberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserMemberTableViewCell" owner:self options:nil];
//      cell = [array objectAtIndex:0];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CGCorporateMemberEntity *entity = self.dataArray[indexPath.row];
//    cell.title.text = entity.title;
//    cell.title.textColor = [CTCommonUtil convert16BinaryColor:entity.color];
//    CGListEntity *entity1 = entity.list[0];
//    cell.ordinaryLabel.text = entity1.info;
//    cell.ordinaryLabel.textColor = [CTCommonUtil convert16BinaryColor:entity1.color];
//    CGListEntity *entity2 = entity.list[1];
//    cell.VIPLabel.text = entity2.info;
//    cell.VIPLabel.textColor = [CTCommonUtil convert16BinaryColor:entity2.color];
//    return cell;
//  }
//  return nil;
//}
//
//-(void)buyVIPClick{
//  CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
//  vc.type = 3;
//  [self.navigationController pushViewController:vc animated:YES];
//}
//
//-(void)inviteColleaguesClick{
//  CGInviteFriendsViewController *vc = [[CGInviteFriendsViewController alloc]init];
//  [self.navigationController pushViewController:vc animated:YES];
//}
@end
