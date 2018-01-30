//
//  CGUserSearchViewController.m
//  CGSays
//
//  Created by zhu on 16/10/21.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserSearchViewController.h"
#import "CGUserSearchCompanyTableViewCell.h"
#import "HCSortString.h"
#import "CGUserCenterBiz.h"
#import <MJRefresh.h>
#import "CGUserCompanySearchNullTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserChoseCompanyViewController.h"
#import "CGUserorganizaApplyEntity.h"
#import "CGUserCreateDepartmentViewController.h"
#import "CGUserChoseOrganizeViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGSearchController.h"
#import "CGSearchBar.h"
#import "HeadlineBiz.h"
#import "SearchHistoricalTableViewCell.h"
#import "CGSearchVoiceView.h"
#import "CGMainLoginViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGUserCreateGroupViewController.h"

@interface CGUserSearchViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, strong) CGUserorganizaApplyEntity *info;
@property (nonatomic, strong) CGUserSearchCompanyEntity *selectEntity;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (weak, nonatomic) IBOutlet UILabel *noFindLabel;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (nonatomic, strong) CGSearchVoiceView *searchView;
@property (nonatomic, strong) NSMutableArray *keyWordArray;
@property (nonatomic, assign) BOOL isSearchKeyWord;
@property (nonatomic, assign) BOOL searching;
@end

@implementation CGUserSearchViewController

-(instancetype)initWithBlock:(CGUserSearchBlock)block{
    self = [super init];
    if(self){
        resultBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.biz = [[CGUserCenterBiz alloc]init];
    [self updataUI];
    self.selectIndexPath = nil;
    self.keyWord = @"";
    self.isSearchKeyWord = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    
    // 百度搜索
    self.searchView = [[CGSearchVoiceView alloc]initWithPlaceholder:@"请输入名称" voiceBlock:^(NSString *content) {
        self.isSearchKeyWord = YES;
//        HeadlineBiz *biz = [[HeadlineBiz alloc]init];
//        [biz jpSearchWithKeyword:content success:^(NSMutableArray *result) {
//            weakSelf.keyWordArray = result;
//            [weakSelf.tableView reloadData];
//        } fail:^(NSError *error) {
//
//        }];
    } changeText:^(NSString *content) {
        weakSelf.isSearchKeyWord = YES;
//        HeadlineBiz *biz = [[HeadlineBiz alloc]init];
//        [biz jpSearchWithKeyword:content success:^(NSMutableArray *result) {
//            weakSelf.keyWordArray = result;
//            [weakSelf.tableView reloadData];
//        } fail:^(NSError *error) {
//
//        }];
    }];
    self.searchView.textField.delegate = self;
    [self.tableView setTableHeaderView:self.searchView];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self getUserInfoWithKeyWord:self.keyWord];
    [self.createBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)updataUI{
    self.title = @"搜索组织";
    self.noFindLabel.text = @"你所在的组织找不到？";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        self.isSearchKeyWord = NO;
        [self getUserInfoWithKeyWord:textField.text];
        [self.searchView.textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isSearchKeyWord = YES;
    [self.tableView reloadData];
}

- (void)getUserInfoWithKeyWord:(NSString *)keyWord{
    if(!keyWord || keyWord.length <= 0)return;
  self.dataArray = [NSMutableArray array];
  self.searching = YES;
  [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    [self.biz.component startBlockAnimation];
    [self.biz userCompanySearchWithkeyword:keyWord type:nil success:^(NSMutableArray *result) {
        __strong typeof(weakSelf) swself = weakSelf;
        weakSelf.searching = NO;
        swself.dataArray = result;
        [swself.tableView reloadData];
        if (result.count>0) {
            weakSelf.tableViewBottom.constant = 44;
        }else{
            weakSelf.tableViewBottom.constant = 0;
        }
        [self.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
        weakSelf.searching = NO;
        [self.biz.component stopBlockAnimation];
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchView.textField resignFirstResponder];
}

- (IBAction)nextClick:(UIButton *)sender {
  [self creatClick];
}

- (void)creatClick{
  if ([ObjectShareTool sharedInstance].currentUser.isLogin == NO) {
    [self clickToLoginAction];
    return;
  }
  if (![CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
    [self getUserName];
    return;
  }
//    CGUserChoseOrganizeViewController *vc = [[CGUserChoseOrganizeViewController alloc]init];
//    vc.keyWord = self.searchView.textField.text;
//    vc.isDiscover = self.isDiscover;
//    [self.navigationController pushViewController:vc animated:YES];
    
    CGUserCreateGroupViewController *vc = [CGUserCreateGroupViewController new];
    vc.type = 1; // 创建公司
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchKeyWord) {
        if (self.keyWordArray.count<=0) {
            return 0;
        }
        return self.keyWordArray.count;
    }else{
        if (self.dataArray.count<=0&&self.searching == NO) {
            return 1;
        }
        return self.dataArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearchKeyWord) {
        if (self.keyWordArray.count<=0) {
            return self.tableView.frame.size.height;
        }
        return 50;
    }else{
        if (self.dataArray.count<=0) {
            return self.tableView.frame.size.height;
        }
        return 81;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearchKeyWord) {
        if (self.keyWordArray.count<=0) {
            NSString*identifier1 = @"CGUserCompanySearchNullTableViewCell";
            CGUserCompanySearchNullTableViewCell *cell = (CGUserCompanySearchNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanySearchNullTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.createButton addTarget:self action:@selector(creatClick) forControlEvents:UIControlEventTouchUpInside];
            cell.detailLabel.text = @"请输入关键字搜索你的组织";
            cell.createButton.hidden = YES;
            return cell;
        }
        NSString*identifier = @"SearchHistoricalTableViewCell";
        SearchHistoricalTableViewCell *cell = (SearchHistoricalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchHistoricalTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = self.keyWordArray[indexPath.row];
        return cell;
    }else{
        if (self.dataArray.count<=0) {
            NSString*identifier1 = @"CGUserCompanySearchNullTableViewCell";
            CGUserCompanySearchNullTableViewCell *cell = (CGUserCompanySearchNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserCompanySearchNullTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.createButton addTarget:self action:@selector(creatClick) forControlEvents:UIControlEventTouchUpInside];
            cell.detailLabel.text = @"如果找不到你的组织，可以进行创建";
            cell.createButton.hidden = NO;
            return cell;
        }
        NSString*identifier = @"CGUserSearchCompanyTableViewCell";
        CGUserSearchCompanyTableViewCell *cell = (CGUserSearchCompanyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserSearchCompanyTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        CGUserSearchCompanyEntity *entity = self.dataArray[indexPath.row];
        [cell updateWithEntity:entity];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearchKeyWord) {
        if (self.keyWordArray.count>0) {
            self.searchView.textField.text = self.keyWordArray[indexPath.row];
            self.isSearchKeyWord = NO;
            self.searching = YES;
            [self.tableView reloadData];
            [self getUserInfoWithKeyWord:self.keyWordArray[indexPath.row]];
            [self.searchView.textField resignFirstResponder];
            
        }
    }else{
        if ([ObjectShareTool sharedInstance].currentUser.isLogin == NO) {
            [self clickToLoginAction];
            return;
        }
      if (![CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
        [self getUserName];
        return;
      }
  
        if (self.dataArray.count>0) {
            self.info = [[CGUserorganizaApplyEntity alloc]init];
            CGUserSearchCompanyEntity *entity = self.dataArray[indexPath.row];
            if (entity.type == UserChoseOrganizeTypeSchool) {
                self.info.organizaID = entity.companyId;
                self.info.type = entity.type;
                self.info.organizaName = entity.name;
                CGUserCreateDepartmentViewController *vc = [[CGUserCreateDepartmentViewController alloc]init];
                vc.isDiscover = self.isDiscover;
                vc.choseType = entity.type;
                vc.organizeID = entity.companyId;
                vc.type = UserCreateTypeCollect;
                vc.info = self.info;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                self.selectEntity = entity;
                
                if(![ObjectShareTool sharedInstance].currentUser.isVip && [ObjectShareTool sharedInstance].currentUser.companyList.count >= 1){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请升级成为VIP后才能加入多家组织。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
                    alert.tag = 1000;
                    [alert show];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定加入组织" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.tag = 1001;
                    [alertView show];
                }
            }
        }
    }
}

-(void)getUserName{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入真实姓名" message:@"（以后不能修改）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
  UITextField *txtName = [alert textFieldAtIndex:0];
  txtName.placeholder = @"请输入姓名";
  alert.tag = 1002;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    //TODO
    if (alertView.tag == 1001 && buttonIndex == 1) {
        [self.biz.component startBlockAnimation];
        [self.biz userCompanyJoinWithCompangyID:self.selectEntity.companyId depaId:nil type:self.selectEntity.type classId:nil position:nil startTime:nil success:^(NSMutableArray *result) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
            if (weakSelf.isDiscover) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
//                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
//                    if ([vc isKindOfClass:[CGUserChangeOrganizationViewController class]]) {
//                        [weakSelf.navigationController popToViewController:vc  animated:NO];
//                        break;
//                    }
//                }
              [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            [weakSelf.biz.component stopBlockAnimation];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
        }];
    }else if (alertView.tag == 1000){
      if (buttonIndex == 1) {
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
      }
    }else if (alertView.tag == 1002){
      if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if ([CTStringUtil stringNotBlank:txt.text]) {
          [self.biz.component startBlockAnimation];
          [self.biz updateUserInfoWithUsername:txt.text nickname:nil gender:nil portrait:nil email:nil addSkillIds:nil delSkillIds:nil skillLevel:[ObjectShareTool sharedInstance].currentUser.skillLevel success:^{
            [weakSelf.biz.component stopBlockAnimation];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATESKILLLEVEL object:nil];
          } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
          }];
        }
      }
    }
}

-(void)baseBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

//点击登录
-(void)clickToLoginAction{
    __weak typeof(self) weakSelf = self;
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
      [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
      
    }];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
