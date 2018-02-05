//
//  CGUserChangeOrganizationViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChangeOrganizationViewController.h"
#import "CGChangeOrganizationTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserSearchViewController.h"
#import "CGUserDao.h"
#import "CGAttestationController.h"
#import "ChangeOrganizationViewModel.h"
#import "CGUserContactsViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGMainLoginViewController.h"

@interface CGUserChangeOrganizationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *addOrganizationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (weak, nonatomic) IBOutlet UIView *morenBG;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation CGUserChangeOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所属组织";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getlocal) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
    self.biz = [[CGUserCenterBiz alloc]init];
    self.editBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 22, 40, 40)];
    [self.editBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn setImage:[UIImage imageNamed:@"icon_panbook"] forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navi addSubview:self.editBtn];
//    self.numberLabel.textColor = CTThemeMainColor;
    self.numberLabel.textColor = [YCTool colorOfHex:0xffcc00];
    [self.addbutton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self getlocal];
    //发出拉取用户信息的通知，目的是检查用户加入的组织列表是否有变更
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
  self.addbutton.backgroundColor = CTThemeMainColor;
  self.addOrganizationButton.backgroundColor = CTThemeMainColor;
}

-(void)getlocal{
    self.numberLabel.hidden = NO;
    if (![ObjectShareTool sharedInstance].currentUser.companyList || [ObjectShareTool sharedInstance].currentUser.companyList.count<=0) {
        self.morenBG.hidden = NO;
        self.topLine.hidden = YES;
    }else{
        self.topLine.hidden = NO;
        self.morenBG.hidden = YES;
    }
    [self.tableview reloadData];
    self.numberLabel.text = [NSString stringWithFormat:@"您的账号加入%lu个组织：",(unsigned long)([ObjectShareTool sharedInstance].currentUser.companyList?[ObjectShareTool sharedInstance].currentUser.companyList.count:0)];
}

-(void)rightBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.tableview setEditing:sender.selected animated:YES];
    if (!self.tableview.isEditing) {
        self.bottomView.hidden = NO;
        self.tableBottom.constant = 86;
        [self.editBtn setImage:[UIImage imageNamed:@"icon_panbook"] forState:UIControlStateNormal];
        [self.editBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        self.bottomView.hidden = YES;
        self.tableBottom.constant = 0;
        [self.editBtn setImage:nil forState:UIControlStateNormal];
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self performSelector:@selector(reloadTableview) withObject:nil afterDelay:0.2f];
}

-(void)refresh{
  __weak typeof(self) weakSelf = self;
  [[[CGUserCenterBiz alloc]init] queryUserDetailInfoWithCode:nil success:^(CGUserEntity *user) {
    [weakSelf getlocal];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];
}

-(void)reloadTableview{
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ObjectShareTool sharedInstance].currentUser.companyList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    static NSString*identifier = @"CGChangeOrganizationTableViewCell";
    CGChangeOrganizationTableViewCell *cell = (CGChangeOrganizationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGChangeOrganizationTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[indexPath.row];
    [cell info:entity editing:self.tableview.editing deleteBlock:^(UIButton *sender) {
        if (entity.companyAdmin == 1) {
            [weakSelf showAlertView:entity];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定退出该组织？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.biz.component startBlockAnimation];
            //退出组织
            NSString *organizaId = entity.companyId;
            if(entity.companyType == 2){
                organizaId = entity.classId;
            }
            [weakSelf.biz userOrganizaExitWithID:organizaId type:(int)entity.companyType success:^{
                [sender setUserInteractionEnabled: YES];
                [weakSelf.biz.component stopBlockAnimation];
                [[ObjectShareTool sharedInstance].currentUser.companyList removeObjectAtIndex:indexPath.row];
                [[[CGUserDao alloc]init]saveLoginedInLocal:[ObjectShareTool sharedInstance].currentUser];
                [weakSelf.tableview reloadData];
                weakSelf.numberLabel.text = [NSString stringWithFormat:@"您的账号加入%ld个组织：",(unsigned long)[ObjectShareTool sharedInstance].currentUser.companyList.count];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
            } fail:^(NSError *error) {
                [weakSelf.biz.component stopBlockAnimation];
                [sender setUserInteractionEnabled: YES];
            }];
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        
    } claimBlock:^(UIButton *sender) {
        CGAttestationController *vc = [[CGAttestationController alloc]initWithOrganiza:entity block:^(NSString *success) {
            
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } vipBlock:^(UIButton *sender) {
      CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
      vc.type = 1;
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    CGUserOrganizaJoinEntity *entity = [[ObjectShareTool sharedInstance].currentUser.companyList objectAtIndex:sourceIndexPath.row];
    [[ObjectShareTool sharedInstance].currentUser.companyList removeObjectAtIndex:sourceIndexPath.row];
    [[ObjectShareTool sharedInstance].currentUser.companyList insertObject:entity atIndex:destinationIndexPath.row];
    [[[CGUserDao alloc]init]saveLoginedInLocal:[ObjectShareTool sharedInstance].currentUser];
    //组织顺序发生变化，发出通知
    [[[CGUserCenterBiz alloc]init]sortOrganizas:[ObjectShareTool sharedInstance].currentUser.companyList success:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOUPDATEUSERINFO object:nil];
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)showAlertView:(CGUserOrganizaJoinEntity *)entity{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请转让管理员后才能退出" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"去转让" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGUserContactsViewController *controller = [[CGUserContactsViewController alloc]initWithOrganiza:entity];
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)addOrganizaClick:(UIButton *)sender {
//  if ([ObjectShareTool sharedInstance].currentUser.username.length<=0) {
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入组织需真实姓名，请去档案填写真实姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//    return;
//  }
//
  if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
    [self clickToLoginAction];
  }else{
    CGUserSearchViewController *vc = [[CGUserSearchViewController alloc]initWithBlock:^(CGUserSearchCompanyEntity *entity) {
      
    }];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (IBAction)addClick:(UIButton *)sender {
//    if ([ObjectShareTool sharedInstance].currentUser.username.length<=0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入组织需真实姓名，请去档案填写真实姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
  
    CGUserSearchViewController *vc = [[CGUserSearchViewController alloc]initWithBlock:^(CGUserSearchCompanyEntity *entity) {
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    //跳转升级vip界面
  }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.biz.component stopBlockAnimation];
}

//点击登录
-(void)clickToLoginAction{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf getlocal];
  } fail:^(NSError *error) {
    
  }];
  //    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
