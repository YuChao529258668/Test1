//
//  CGEnterpriseMemberViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGEnterpriseMemberViewController.h"
#import "CGEnterpriseMemberTableViewCell.h"
#import "CGUserMemberHeaderTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGCorporateMemberEntity.h"
#import "CGEnterpriseMemberHeaderTableViewCell.h"
#import "CGBuyVIPViewController.h"
#import "CGCompanyDao.h"
#import "CGHorrolView.h"
#import "CGAttestationController.h"
#import "CGMainLoginViewController.h"
#import "CGLineLayout.h"

@interface CGEnterpriseMemberViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *companyArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewY;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) CGCorporateMemberEntity *entity;
@end

@implementation CGEnterpriseMemberViewController

- (void)viewDidLoad {
    if(self.type){
        self.title = @"VIP企业套餐";
    }else{
        self.title = @"VIP会员";
    }
    [super viewDidLoad];
  if (self.type ) {
    self.title = @"VIP企业套餐";
  }else{
    self.title = @"VIP会员套餐";
  }
    self.title = @"";
    
    self.biz = [[CGUserCenterBiz alloc]init];
    self.selectIndex = 0;
    [self updateDate];
    self.bgView.backgroundColor = CTThemeMainColor;
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableview reloadData];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDate) name:NOTIFICATION_BUYMEMBER object:nil];
}

-(void)updateDate{
  if (self.type) {
    [self getCompany];
  }else{
    self.tableViewY.constant = 64;
    self.bgViewY.constant = 64;
    __weak typeof(self) weakSelf = self;
    [self.biz userPrivilegeWithID:nil type:0 success:^(CGCorporateMemberEntity *reslut) {
      weakSelf.entity = reslut;
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      
    }];
  }
}

-(void)getCompany{
  self.companyArray = [NSMutableArray array];
    if([ObjectShareTool sharedInstance].currentUser.auditCompanyList && [ObjectShareTool sharedInstance].currentUser.auditCompanyList.count > 0){
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.auditCompanyList.count; i++) {
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.auditCompanyList[i];
            CGHorrolEntity *entity;
            if (companyEntity.auditStete == 1&&companyEntity.companyType!=4) {
                entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
                entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
              if ([companyEntity.companyId isEqualToString:self.companyID]) {
                self.selectIndex = i;
                [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
                if (!entity.memberEntity) {
                  __weak typeof(self) weakSelf = self;
                  [self.biz userPrivilegeWithID:entity.rolId type:entity.rolType.integerValue success:^(CGCorporateMemberEntity *reslut) {
                    entity.memberEntity = reslut;
                    [weakSelf.tableView reloadData];
                  } fail:^(NSError *error) {
                    
                  }];
                }else{
                  [self.tableView reloadData];
                }
              }
                [self.companyArray addObject:entity];
                if (i == 0) {
                    __weak typeof(self) weakSelf = self;
                    [self.biz userPrivilegeWithID:entity.rolId type:entity.rolType.integerValue success:^(CGCorporateMemberEntity *reslut) {
                        entity.memberEntity = reslut;
                        [weakSelf.tableView reloadData];
                    } fail:^(NSError *error) {
                        
                    }];
                }
                
            }
        }
        self.bigTypeScrollView.array = nil;
        [self.view addSubview:self.bigTypeScrollView];
      [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
        if(self.bigTypeScrollView.array.count <=1){
            self.tableViewY.constant = 64;
            self.bgViewY.constant = 64;
            self.bigTypeScrollView.hidden = YES;
        }else{
            self.tableViewY.constant = 104;
            self.bgViewY.constant = 104;
        }
      
      
    }
}

-(NSMutableArray *)companyArray{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
    __weak typeof(self) weakSelf = self;
    if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
        [_bigTypeScrollView removeFromSuperview];
        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) array:self.companyArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            weakSelf.selectIndex = index;
          weakSelf.companyID = data.rolId;
            if (!data.memberEntity) {
                [self.biz userPrivilegeWithID:data.rolId type:data.rolType.integerValue success:^(CGCorporateMemberEntity *reslut) {
                    data.memberEntity = reslut;
                    [weakSelf.tableView reloadData];
                } fail:^(NSError *error) {
                    
                }];
            }else{
                [weakSelf.tableView reloadData];
            }
        }];
    }
    return _bigTypeScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 159;
    }
    if (self.type) {
        if (self.companyArray.count<=0) {
            return 0;
        }
        CGHorrolEntity *entity = self.companyArray[self.selectIndex];
        return (entity.memberEntity.privilegeList.count+1)*50;
    }else{
        return (self.entity.privilegeList.count+1)*50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCorporateMemberEntity *memberEntity;
    if (self.type) {
        CGHorrolEntity *entity = self.companyArray[self.selectIndex];
        memberEntity = entity.memberEntity;
    }else{
        memberEntity = self.entity;
    }
    if (indexPath.section == 0) {
        static NSString*identifier = @"CGEnterpriseMemberHeaderTableViewCell";
        CGEnterpriseMemberHeaderTableViewCell *cell = (CGEnterpriseMemberHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGEnterpriseMemberHeaderTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }

        [cell update:memberEntity type:self.type];

        return cell;
    }else{
        __weak typeof(self) weakSelf = self;
        static NSString*identifier = @"CGEnterpriseMemberTableViewCell";
        CGEnterpriseMemberTableViewCell *cell = (CGEnterpriseMemberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGEnterpriseMemberTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell updateTitleArray:memberEntity.privilegeTitle listArray:memberEntity.privilegeList block:^(NSString *gradeId, NSString *gradeName) {
          if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
            if([gradeName hasPrefix:@"升级"]){
                NSString *alertMsg = nil;
                if(self.type){
                    alertMsg = @"升级后，系统会将你的当前企业会员剩余有效期时间自动换成对等价值的新企业会员的天数进行累加";
                }else{
                    alertMsg = @"升级后，系统会将你的当前会员剩余有效期时间自动换成对等价值的新会员的天数进行累加";
                }
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
              [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
              [alertController addAction:[UIAlertAction actionWithTitle:@"我要升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [weakSelf jumpToBuyWithGradeId:gradeId gradeName:gradeName];
              }]];
              [weakSelf presentViewController:alertController animated:YES completion:nil];
            }else{
              [weakSelf jumpToBuyWithGradeId:gradeId gradeName:gradeName];
            }
          }else{
            [weakSelf clickToLoginAction];
          }
        } claimBlock:^{
            CGHorrolEntity *entity = self.companyArray[self.selectIndex];
            CGUserOrganizaJoinEntity *or = [[CGUserOrganizaJoinEntity alloc]init];
            or.companyId = entity.rolId;
            or.companyType = [entity.rolType intValue];
            or.companyName = entity.rolName;
            CGAttestationController *vc = [[CGAttestationController alloc]initWithOrganiza:or block:^(NSString *success) {
                
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    }
    return nil;
}

-(void)jumpToBuyWithGradeId:(NSString *)gradeId gradeName:(NSString *)gradeName{
    CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
    vc.type = self.type;
    vc.gradeID = gradeId;
    vc.titleText = gradeName;
  if (self.type == 1) {
    CGHorrolEntity *entity = self.companyArray[self.selectIndex];
    vc.companyID = entity.rolId;
    vc.companyType = entity.rolType.integerValue;
  }
    [self.navigationController pushViewController:vc animated:YES];
}

//点击登录
-(void)clickToLoginAction{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
  } fail:^(NSError *error) {
    
  }];
  //    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
