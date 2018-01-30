//
//  CGUserContactsViewController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserContactsViewController.h"
#import "CGUserContactsTableViewCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import <objc/runtime.h>
#import "CGUserCenterBiz.h"
#import <UIImageView+WebCache.h>
#import "CGUserDao.h"
#import "CGSearchController.h"
#import "CGHorrolView.h"
#import "CGUserEditDepartmentViewController.h"
#import "KxMenu.h"
#import "CGEnterpriseArchivesViewController.h"
#import "CGInviteMembersViewController.h"

@interface CGUserContactsViewController ()

@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property(nonatomic,retain)NSMutableArray *headViewEntitys;

@property(nonatomic,retain)NSMutableArray *organzias;

@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewY;

@property(nonatomic,retain)NSMutableDictionary *datas;//数据
@property(nonatomic,retain)NSMutableDictionary *indexs;//索引

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,retain)NSMutableArray *searchData;

@property(nonatomic,assign)BOOL isSearching;//是否正在搜索


@property(nonatomic,assign)BOOL isCLickCalling;

@end

@implementation CGUserContactsViewController

// 让子类通过 init 创建对象时，也能使用 xib 定义的界面
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithNibName:@"CGUserContactsViewController" bundle:nil];
    }
    return self;
}

-(instancetype)initWithOrganiza:(CGUserOrganizaJoinEntity *)organiza{
    self = [super init];
    if(self){
        if(organiza){
            if(self.organzias && self.organzias.count > 0){
                for(int i=0;i<self.organzias.count;i++){
                    CGUserOrganizaJoinEntity *local = self.organzias[i];
                    if(organiza.companyType == 2){//传进来的是学校
                        if([organiza.classId isEqualToString:local.classId]){
                            self.currentIndex = i;
                            break;
                        }
                    }else{//非学校
                        if([organiza.companyId isEqualToString:local.companyId]){
                            self.currentIndex = i;
                            break;
                        }
                    }
                }
            }
        }
    }
    return self;
}

-(NSMutableArray *)organzias{
    if(!_organzias){
        _organzias = [NSMutableArray array];
        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
            for(CGUserOrganizaJoinEntity *local in [ObjectShareTool sharedInstance].currentUser.companyList){
                if(local.auditStete == 1){
                    [_organzias addObject:local];
                }
            }
        }
    }
    return _organzias;
}

-(NSMutableArray *)headViewEntitys{
    if(!_headViewEntitys){
        _headViewEntitys = [NSMutableArray array];
        if(self.organzias && self.organzias.count > 0){
            for(int i=0;i<self.organzias.count;i++){
                CGUserOrganizaJoinEntity *local = self.organzias[i];
                CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyName sort:i];
                [_headViewEntitys addObject:organiza];
            }
        }
    }
    return _headViewEntitys;
}

-(NSMutableArray *)searchData{
    if(!_searchData){
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}

-(NSMutableDictionary *)datas{
    if(!_datas){
        _datas = [NSMutableDictionary dictionary];
    }
    return _datas;
}

-(NSMutableDictionary *)indexs{
    if(!_indexs){
        _indexs = [NSMutableDictionary dictionary];
    }
    return _indexs;
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

- (void)viewDidLoad {
    self.title = @"通讯录";
    [super viewDidLoad];
  self.biz = [[CGUserCenterBiz alloc]init];
    if(self.organzias.count > 1){
        [self.view addSubview:self.organizaHeaderView];
    }else{
      self.tableViewY.constant = 64;
    }
//  [self.tableview setTableHeaderView:self.searchBar];
    [self setupTableViewHeaderView];
  self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
  self.tableview.sectionIndexColor = [UIColor darkGrayColor];
  [self getContacts];
  [self.organizaHeaderView setSelectIndex:self.currentIndex];
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  self.rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightBtn setImage:[UIImage imageNamed:@"radar_Subject_library_more"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_click"] forState:UIControlStateNormal];
  [self.navi addSubview:self.rightBtn];
  if (self.organzias.count>0) {
    CGUserOrganizaJoinEntity *organiza = self.organzias[0];
    if (organiza.companyType == 4) {
      self.rightBtn.hidden = YES;
    }
  }
}

-(void)rightBtnAction:(UIButton *)sender{
  NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:[KxMenuItem menuItem:@"邀请成员"
                                                                              image:[UIImage imageNamed:@"yaoqingtongshi_user"]
                                                                             target:self
                                                                             action:@selector(doInviteMembersAction)], nil];
  if(self.organzias.count > 0){
    CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
    if(entity.companyAdmin){
      [menuItems addObject:[KxMenuItem menuItem:@"部门管理"
                                         image:[UIImage imageNamed:@"departmentmanagement_user"]
                                        target:self
                                         action:@selector(doDepartmentManagementAction)]];
      [menuItems addObject:[KxMenuItem menuItem:@"企业档案"
                                         image:[UIImage imageNamed:@"enterprisefile"]
                                        target:self
                                         action:@selector(doEnterpriseArchivesAction)]];
    }
  }
  
  [KxMenu showMenuInView:self.view
                fromRect:sender.frame
               menuItems:menuItems];
  [KxMenu setTintColor:[UIColor blackColor]];
}

-(void)doInviteMembersAction{
  CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
  CGInviteMembersViewController *vc = [[CGInviteMembersViewController alloc]init];
  vc.companyID = entity.companyId;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)doEnterpriseArchivesAction{
  CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
  CGEnterpriseArchivesViewController *vc = [[CGEnterpriseArchivesViewController alloc]init];
  vc.companyID = entity.companyId;
  vc.companytype = entity.companyType;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)doDepartmentManagementAction{
      CGUserEditDepartmentViewController *controller = [[CGUserEditDepartmentViewController alloc]initWithOrganiza:self.organzias[self.currentIndex]];
      [self.navigationController pushViewController:controller animated:YES];
}


-(void)refresh{
  for (CGHorrolEntity *entity in _headViewEntitys) {
    entity.data = [NSMutableArray array];
  }
  [self getContacts];
}

//获取当前组织id
-(NSString *)getOrganizaId{
    CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
    NSString *organizaId;
    if(entity.companyType == 2){
        organizaId = entity.classId;
    }else{
        organizaId = entity.companyId;
    }
    return organizaId;
}

//获取当前组织类型
-(int)getOrganizaType{
    CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
    return entity.companyType;
}

-(NSDictionary *)getContactData{
    return [self.datas objectForKey:[self getOrganizaId]];
}

-(NSMutableArray *)getIndex{
    return [self.indexs objectForKey:[self getOrganizaId]];
}

-(void)getContacts{
    NSMutableArray *data;
   
    if([[self.datas allKeys]containsObject:[self getOrganizaId]]){
        data = [self.datas objectForKey:[self getOrganizaId]];
    }
    __weak typeof(self) weakSelf = self;
    if(!data || data.count <= 0){
        [self.biz.component startBlockAnimation];
        [self.biz userCompanyContactsWithKeyword:nil organizaId:[self getOrganizaId] type:[self getOrganizaType] success:^(NSMutableArray *reslut) {
            [weakSelf.biz.component stopBlockAnimation];
            if(reslut && reslut.count > 0){
                NSMutableDictionary *data = [HCSortString sortAndGroupForArray:reslut PropertyName:@"letter"];
                [weakSelf.datas setObject:data forKey:[self getOrganizaId]];
                NSMutableArray *index = [HCSortString sortForStringAry:[data allKeys]];
                [weakSelf.indexs setObject:index forKey:[self getOrganizaId]];
                [self.tableview reloadData];
            }
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
        }];
    }else{
        [self.tableview reloadData];
    }
}

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
    __weak typeof(self) weakSelf = self;
    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            weakSelf.currentIndex = index;
            [weakSelf.tableview reloadData];
            [self getContacts];
          CGUserOrganizaJoinEntity *organiza = weakSelf.organzias[index];
          if (organiza.companyType == 4) {
            self.rightBtn.hidden = YES;
          }else{
            self.rightBtn.hidden = NO;
          }
        }];
    }
    return _organizaHeaderView;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

-(CGSearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[CGSearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) block:^(NSString *content) {
            [self searching:content];
        } cancel:^{
            self.isSearching = NO;
            self.searchBar.text = nil;
            [self.searchBar resignFirstResponder];
            [self.tableview reloadData];
            [self setupTableViewHeaderView];
        }];
        _searchBar.placeholder = @"搜姓名、手机号";
    }
    return _searchBar;
}

-(void)searching:(NSString *)content{
    if([CTStringUtil stringNotBlank:content]){
        [self.searchData removeAllObjects];
        self.isSearching = YES;
        [self setupTableViewHeaderView];
        NSDictionary *data = [self getContactData];
        if(data.count > 0){
            for(NSString *key in data){
                NSArray *value = [data objectForKey:key];
                for(CGUserCompanyContactsEntity *entity in value){
                    if([entity.userName rangeOfString:content].location !=NSNotFound){
                        [self.searchData addObject:entity];
                    }
                }
                
            }
        }
    }else{
        [self.searchData removeAllObjects];
        self.isSearching = NO;
        [self setupTableViewHeaderView];
    }
    
    [self.tableview reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearching){
        return 1;
    }
    if(self.organzias.count > 0){
        return [self getIndex].count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching){
        return self.searchData.count;
    }
    if(self.organzias.count > 0){
        NSArray *value = [[self getContactData]objectForKey:[self getIndex][section]];
        return value.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.isSearching){
        return 0;
    }
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [CTCommonUtil convert16BinaryColor:@"F9F9F9"];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    if(self.organzias.count > 0){
        label.text = [NSString stringWithFormat:@"    %@",[self getIndex][section]];
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.isSearching){
        return 0;
    }
    if(self.organzias.count > 0){
        NSMutableArray *indexs = [self getIndex];
        return indexs;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*identifier = @"CGUserContactsTableViewCell";
    CGUserContactsTableViewCell *cell = (CGUserContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserContactsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = [self tableViewCellSelectionStyle];
    }
    CGUserCompanyContactsEntity *entity;
    if(self.isSearching){
        entity = self.searchData[indexPath.row];
    }else{
        NSArray *value = [[self getContactData]objectForKey:[self getIndex][indexPath.section]];
        entity = value[indexPath.row];
    }
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:entity.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    cell.nameLabel.text = entity.userName;
    
//    CGUserOrganizaJoinEntity *organiza = self.organzias[self.currentIndex];
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:entity.position?[NSString stringWithFormat:@"%@-",entity.position]:@""];
    [desc appendString:entity.department?entity.department:@"未知部门"];
//    if(organiza.companyAdmin || organiza.companyManage){//本人是超级管理员或普通管理员，显示谁是否是管理员的信息
//        if(entity.companyAdmin){
//            [desc appendString:@"-超级管理员"];
//        }else if(entity.companyManage){
//            [desc appendString:@"-管理员"];
//        }
//    }
    if(entity.companyAdmin){
        [desc appendString:@"-超级管理员"];
    }else if(entity.companyManage){
        [desc appendString:@"-管理员"];
    }
    
    cell.detailLabel.text = desc;
    
    cell.button.hidden = YES;
    cell.buttonWidth.constant = 0;
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *entity;
    if(self.isSearching){
        entity = self.searchData[indexPath.row];
    }else{
        NSArray *value = [[self getContactData]objectForKey:[self getIndex][indexPath.section]];
        entity = value[indexPath.row];
    }
    
    //点击自己，不处理
    if([[ObjectShareTool sharedInstance].currentUser.uuid isEqualToString:entity.userId]){
        return;
    }
    
    [self handleSelectCellAtIndexPath:indexPath With:entity];
    
//    [self jumpToChatViewControllerWith:entity];
}


#pragma mark - 跳转到聊天界面

- (void)jumpToChatViewControllerWith:(CGUserCompanyContactsEntity *)entity {
    IMAUser *user = [IMAUser new];
//    user.userId = @"yc529258666";
    user.userId = entity.userId;
//    user.userId = entity.txyIdentifier;
    user.nickName = entity.userName;
    user.icon = entity.userIcon;
    
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ad.rootController pushToChatViewControllerWith:user];
}

- (void)handleSelectCellAtIndexPath:(NSIndexPath *)indexPath With:(CGUserCompanyContactsEntity *)entity {
    __weak typeof(self) weakSelf = self;
    CGUserOrganizaJoinEntity *organiza = self.organzias[self.currentIndex];
    if(organiza.companyAdmin == 1&&organiza.companyType !=4){//当前登录的用户为超级管理员
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *chat = [UIAlertAction actionWithTitle:@"聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToChatViewControllerWith:entity];
        }];
        [alertController addAction:chat];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if(!weakSelf.isCLickCalling && entity.phone){
                weakSelf.isCLickCalling = YES;
                NSString *allString = [NSString stringWithFormat:@"tel:%@",entity.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                [weakSelf performSelector:@selector(setCallingState) withObject:nil afterDelay:3];
            }
        }]];
        if(entity.companyManage){
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf setOrganizaManager:0 organiza:organiza entity:entity];
            }]];
        }else{
            [alertController addAction:[UIAlertAction actionWithTitle:@"设为管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf setOrganizaManager:1 organiza:organiza entity:entity];
            }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"转让超级管理员给他" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf transferOrganizaSuperAdmin:organiza entity:entity];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"强制退出组织" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf exitUserWithOrganiza:organiza entity:entity section:(int)indexPath.section];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *chat = [UIAlertAction actionWithTitle:@"聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToChatViewControllerWith:entity];
        }];
        [alertController addAction:chat];

        [alertController addAction:[UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if(!weakSelf.isCLickCalling && entity.phone){
                weakSelf.isCLickCalling = YES;
                NSString *allString = [NSString stringWithFormat:@"tel:%@",entity.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                [weakSelf performSelector:@selector(setCallingState) withObject:nil afterDelay:3];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];

//        if(entity.phone){
//            if(!weakSelf.isCLickCalling){
//                weakSelf.isCLickCalling = YES;
//                NSString *allString = [NSString stringWithFormat:@"tel:%@",entity.phone];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
//                [weakSelf performSelector:@selector(setCallingState) withObject:nil afterDelay:3];
//            }
//        }
    }
}

//设置管理员
-(void)setOrganizaManager:(int)type organiza:(CGUserOrganizaJoinEntity *)organiza entity:(CGUserCompanyContactsEntity *)entity{
    __weak typeof(self) weakSelf = self;
    NSString *str = nil;
    if(type == 0){
        str = @"确定取消管理员？";
    }else if (type == 1){
        str = @"确定设为管理员？";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *organizaId = organiza.companyId;
        if(organiza.companyType == 2){
            organizaId = organiza.classId;
        }
        [self.biz.component startBlockAnimation];
        [self.biz organizaManagerOperatorWithOrganizaId:organizaId organizaType:organiza.companyType userId:entity.userId action:type success:^{
            [weakSelf.biz.component stopBlockAnimation];
            entity.companyManage = type;
            [weakSelf.tableview reloadData];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf presentViewController:alertController animated:YES completion:nil];
}

//转让超级管理员
-(void)transferOrganizaSuperAdmin:(CGUserOrganizaJoinEntity *)organiza entity:(CGUserCompanyContactsEntity *)entity{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定转让超级管理员身份？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *organizaId = organiza.companyId;
        if(organiza.companyType == 2){
            organizaId = organiza.classId;
        }
        [self.biz.component startBlockAnimation];
        [self.biz organizaSuperManagerOperatorWithOrganizaId:organizaId organizaType:organiza.companyType userId:entity.userId success:^{
            [weakSelf.biz.component stopBlockAnimation];
            organiza.companyAdmin = 0;
            organiza.companyManage = 0;
//            [weakSelf setRightBtnState];
            [weakSelf.tableview reloadData];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf presentViewController:alertController animated:YES completion:nil];
}

//把该成员退出组织
-(void)exitUserWithOrganiza:(CGUserOrganizaJoinEntity *)organiza entity:(CGUserCompanyContactsEntity *)entity section:(int)section{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入理由";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *text = alert.textFields[0].text;
        if(text.length <= 0){
            [[CTToast makeText:@"请输入拒绝理由"]show:weakSelf.view];
            [weakSelf exitUserWithOrganiza:organiza entity:entity section:section];
        }else{
            NSString *organizaId = organiza.companyId;
            if(organiza.companyType == 2){
                organizaId = organiza.classId;
            }
            [self.biz.component startBlockAnimation];
            [self.biz organizaExitUserWithOrganizaId:organizaId organizaType:organiza.companyType userId:entity.userId reason:text success:^{
                if(weakSelf.isSearching){
                    [weakSelf.searchData removeObject:entity];
                }else{
                    NSMutableArray *value = [[weakSelf getContactData]objectForKey:[weakSelf getIndex][section]];
                    [value removeObject:entity];
                    if(!value || value.count <= 0){
                        NSString *re = nil;
                        NSMutableArray *indexs = [weakSelf getIndex];
                        for(NSString *str in indexs){
                            if([str isEqualToString:entity.letter] || [str isEqualToString:@"#"]){
                                re = str;
                                break;
                            }
                        }
                        if(re){
                            [indexs removeObject:re];
                        }
                    }
                }
                [weakSelf.biz.component stopBlockAnimation];
                [weakSelf.tableview reloadData];
            } fail:^(NSError *error) {
                [weakSelf.biz.component stopBlockAnimation];
            }];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setCallingState{
    self.isCLickCalling = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 用于子类重写或调用

// 子类重写这个方法，用于多选。UITableViewCellSelectionStyleNone 会看不到勾勾
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle {
    return UITableViewCellSelectionStyleNone;
}

//- (NSString *)userIDAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *userID;
//    CGUserCompanyContactsEntity *entity;
//    if(self.isSearching){
//        entity = self.searchData[indexPath.row];
//    }else{
//        NSArray *value = [[self getContactData]objectForKey:[self getIndex][indexPath.section]];
//        entity = value[indexPath.row];
//    }
//    userID = entity.userId;
////    userID = entity.userName;
//    return userID;
//}

- (CGUserCompanyContactsEntity *)contactAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *entity;
    if(self.isSearching){
        entity = self.searchData[indexPath.row];
    }else{
        NSArray *value = [[self getContactData]objectForKey:[self getIndex][indexPath.section]];
        entity = value[indexPath.row];
    }
    return entity;
}

#pragma mark - 群聊相关

- (UIButton *)createGroupChatBtn {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"群聊" forState: UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    btn.titleLabel.backgroundColor = [UIColor greenColor];
    btn.backgroundColor = [UIColor whiteColor];
    btn.contentMode = UIViewContentModeLeft;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    [btn addTarget:self action:@selector(groupChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)groupChatBtnClick {
    PublicGroupViewController *vc = [[PublicGroupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupTableViewHeaderView {
    CGRect frame = self.searchBar.frame;
    frame.origin.y = 5;
    self.searchBar.frame = frame;
    
    if (self.isSearching) {
        frame.size.height = CGRectGetMaxY(self.searchBar.frame) + 5;
        UIView *view = [[UIView alloc]initWithFrame:frame];
        //    view.backgroundColor = [UIColor yellowColor];
        
        [view addSubview:self.searchBar];
        [self.tableview setTableHeaderView:view];
    } else {
        UIButton *btn = [self createGroupChatBtn];
        frame.origin.y = CGRectGetMaxY(self.searchBar.frame) + 5;
        frame.size.height = 60;
        btn.frame = frame;
        
        frame.size.height = CGRectGetMaxY(btn.frame) + 10;
        UIView *view = [[UIView alloc]initWithFrame:frame];
        //    view.backgroundColor = [UIColor yellowColor];
        
        [view addSubview:btn];
        [view addSubview:self.searchBar];
        [self.tableview setTableHeaderView:view];
    }
}


@end

// 调试输出
/*
(lldb) po self.indexs
{
    "8f82d6d5-e8ed-4c14-b3a9-f808370da47a" =     (
                                                  J,
                                                  L,
                                                  W,
                                                  Y
                                                  );
}

(lldb) po [self getIndex]
<__NSArrayM 0x6040000522a0>(
                            J,
                            L,
                            W,
                            Y
                            )

(lldb) po self.datas
{
    "8f82d6d5-e8ed-4c14-b3a9-f808370da47a" =     {
        J =         (
                     "<CGUserCompanyContactsEntity: 0x60400049f040>"
                     );
        L =         (
                     "<CGUserCompanyContactsEntity: 0x604000480550>"
                     );
        W =         (
                     "<CGUserCompanyContactsEntity: 0x604000493830>"
                     );
        Y =         (
                     "<CGUserCompanyContactsEntity: 0x60400049f090>"
                     );
    };
}

(lldb) po [self getContactData]
{
    J =     (
             "<CGUserCompanyContactsEntity: 0x60400049f040>"
             );
    L =     (
             "<CGUserCompanyContactsEntity: 0x604000480550>"
             );
    W =     (
             "<CGUserCompanyContactsEntity: 0x604000493830>"
             );
    Y =     (
             "<CGUserCompanyContactsEntity: 0x60400049f090>"
             );
}
*/
