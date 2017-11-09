//
//  CGUserPhoneContactViewController.m
//  CGSays
//
//  Created by zhu on 16/10/25.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserPhoneContactViewController.h"
#import "CGUserContactsTableViewCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "CGUserCenterBiz.h"
#import "CGUserSearchCompanyEntity.h"
#import <ContactsUI/ContactsUI.h>
#import "CGUserPhoneContactEntity.h"
#import "CGUserDao.h"
#import <MessageUI/MessageUI.h>
#import "CGSearchController.h"
#import "CGSearchBar.h"
#import "CGHorrolView.h"
#import "KxMenu.h"

@interface CGUserPhoneContactViewController ()<MFMessageComposeViewControllerDelegate>

@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property(nonatomic,retain)NSMutableArray *headViewEntitys;

@property (strong, nonatomic) CGSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewY;

@property(nonatomic,retain)NSMutableDictionary *contactState;//状态的数据
@property(nonatomic,retain)NSMutableDictionary *contacts;//数据
@property(nonatomic,retain)NSMutableArray *indexs;//索引

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,retain)NSMutableArray *searchData;

@property(nonatomic,assign)BOOL isSearching;//是否正在搜索

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSMutableArray *phones;//只有手机号，用于调用接口进行匹配是否已经邀请
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) CGUserPhoneContactEntity *selectEntity;
@end

@implementation CGUserPhoneContactViewController

-(NSMutableDictionary *)contactState{
    if(!_contactState){
        _contactState = [NSMutableDictionary dictionary];
    }
    return _contactState;
}

-(CGUserCenterBiz *)biz{
    if(!_biz){
        _biz = [[CGUserCenterBiz alloc]init];
    }
    return _biz;
}

-(NSMutableArray *)phones{
    if(!_phones){
        _phones = [NSMutableArray array];
    }
    return _phones;
}

-(NSMutableArray *)searchData{
    if(!_searchData){
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}

-(NSMutableDictionary *)contacts{
    if(!_contacts){
        _contacts = [NSMutableDictionary dictionary];
    }
    return _contacts;
}

-(NSMutableArray *)indexs{
    if(!_indexs){
        _indexs = [NSMutableArray array];
    }
    return _indexs;
}

//获取当前组织id
-(NSString *)getOrganizaId{
    CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[self.currentIndex];
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
    CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[self.currentIndex];
    return entity.companyType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请成员";
    if(self.headViewEntitys.count > 1){
        [self.view addSubview:self.organizaHeaderView];
    }else{
        self.tableViewY.constant = 64;
    }
    self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableview.sectionIndexColor = [UIColor darkGrayColor];
    [self getPhoneContactAuth];
//  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
//  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
//  [rightBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
//  [rightBtn setBackgroundImage:[UIImage imageNamed:@"radar_Subject_library_more"] forState:UIControlStateNormal];
//  [self.navi addSubview:rightBtn];
}

-(void)messageAction{
  NSArray *menuItems = @[
                 
                  [KxMenuItem menuItem:@"微信邀请"
                                 image:nil
                                target:self
                                action:@selector(weixinInvitationAction)],
                  [KxMenuItem menuItem:@"二维码邀请"
                                 image:nil
                                target:self
                                action:@selector(qrCodeInvitationAction)]];
  
  [KxMenu setTintColor:[UIColor blackColor]];
  CGRect fromRect = CGRectMake(SCREEN_WIDTH-40, 40, 24,24);
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
}

-(void)weixinInvitationAction{
  
}

-(void)qrCodeInvitationAction{
  
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.biz.component stopBlockAnimation];
}

//获取通讯录授权
-(void)getPhoneContactAuth{
    [self.biz.component startBlockAnimation];
    __weak typeof(self) weakSelf = self;
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {//授权成功
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.bgView.hidden = YES;
                [weakSelf getAddressBook:store];
            });
        }else{//授权失败
            [self.biz.component stopBlockAnimation];
            weakSelf.bgView.hidden = NO;
            [weakSelf.view bringSubviewToFront:weakSelf.bgView];
        }
    }];
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized){
        self.bgView.hidden = NO;
        return;
    }
}

//查询通讯录
-(void)getAddressBook:(CNContactStore *)store{
    __weak typeof(self) weakSelf = self;
    NSArray *fetchKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        NSMutableArray *tempList = [NSMutableArray array];
        [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            CGUserPhoneContactEntity *entity = [[CGUserPhoneContactEntity alloc]init];
            NSString *firstname = contact.givenName;
            NSString *lastname = contact.familyName;
            entity.name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
            if (entity.name.length<=0) {
                entity.name = @" ";
            }
            NSArray *phones = contact.phoneNumbers;
            for (CNLabeledValue *labelValue in phones) {
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSArray *arr = [phoneNumber.stringValue componentsSeparatedByString:NSLocalizedString(@"-", nil)];
                NSString *str = [arr componentsJoinedByString:@""];
                if([str hasPrefix:@"+"]){
                    if([str hasPrefix:@"+86"]){
                        str = [str substringFromIndex:3];
                    }else{
                        str = [str substringFromIndex:1];
                    }
                }
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(str.length == 11){
                    entity.phone = str;
                    break;
                }
            }
            if (entity.phone.length == 11) {
                [tempList addObject:entity];
                [weakSelf.phones addObject:entity.phone];
            }
        }];
        if(tempList.count > 0){
            weakSelf.contacts = [HCSortString sortAndGroupForArray:tempList PropertyName:@"name"];
            weakSelf.indexs = [HCSortString sortForStringAry:[weakSelf.contacts allKeys]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self queryContactState];
            });
        }
    });
}

-(void)queryContactState{
    __weak typeof(self) weakSelf = self;
    if(self.phones.count > 0){//有电话号码才调接口
        for(NSString *key in self.contacts){
            NSArray *value = [self.contacts objectForKey:key];
            for(CGUserPhoneContactEntity *entity in value){
                entity.isInvite = 0;
            }
        }
//        NSMutableArray *locals = [self queryLocalState];
//        if(locals && locals.count > 0){
//            [self generatorState];
//            [weakSelf.biz.component stopBlockAnimation];
//            [weakSelf.tableview reloadData];
//        }else{
            [self.biz authCommonPhonebookWithPhones:self.phones companyId:[self getOrganizaId] success:^(NSMutableArray *reslut) {
                [self.contactState setObject:reslut forKey:[self getOrganizaId]];
                [self generatorState];
                [weakSelf.biz.component stopBlockAnimation];
                [weakSelf.tableview reloadData];
                [weakSelf.tableview setTableHeaderView:self.searchBar];
            } fail:^(NSError *error) {
                [weakSelf.biz.component stopBlockAnimation];
            }];
            
//        }
    }
}

-(NSMutableArray *)queryLocalState{
    return [self.contactState objectForKey:[self getOrganizaId]];
}

-(void)generatorState{
    for(NSString *key in self.contacts){
        NSArray *value = [self.contacts objectForKey:key];
        for(CGUserPhoneContactEntity *entity in value){
            for(CGUserPhoneContactEntity *local in [self queryLocalState]){
                if([local.phone isEqualToString:entity.phone] && local.isInvite == 1){
                    entity.isInvite = 1;
                }
            }
        }
    }
}

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
    __weak typeof(self) weakSelf = self;
    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            weakSelf.currentIndex = index;
            [weakSelf queryContactState];
        }];
    }
    return _organizaHeaderView;
}

-(NSMutableArray *)headViewEntitys{
    if(!_headViewEntitys){
        _headViewEntitys = [NSMutableArray array];
        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
            for(int i=0;i<[ObjectShareTool sharedInstance].currentUser.companyList.count;i++){
                CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[i];
                CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyName sort:i];
                if ([self.companyID isEqualToString:local.companyId]) {
                    self.currentIndex = i;
                    [self queryContactState];
                }
                [_headViewEntitys addObject:organiza];
            }
            [self.organizaHeaderView setSelectIndex:self.currentIndex];
        }
    }
    return _headViewEntitys;
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
        }];
        _searchBar.placeholder = @"搜姓名、手机号";
    }
    return _searchBar;
}

-(void)searching:(NSString *)content{
    if([CTStringUtil stringNotBlank:content]){
        [self.searchData removeAllObjects];
        self.isSearching = YES;
        if(self.contacts.count > 0){
            for(NSString *key in self.contacts){
                NSArray *value = [self.contacts objectForKey:key];
                for(CGUserPhoneContactEntity *entity in value){
                    if([entity.phone rangeOfString:content].location !=NSNotFound || [entity.name rangeOfString:content].location !=NSNotFound){
                        [self.searchData addObject:entity];
                    }
                }
            }
        }
    }else{
        [self.searchData removeAllObjects];
        self.isSearching = NO;
    }
    [self.tableview reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearching){
        return 1;
    }
    return self.indexs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching){
        return self.searchData.count;
    }
    NSArray *value = [self.contacts objectForKey:self.indexs[section]];
    return value.count;
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
    label.text = [NSString stringWithFormat:@"    %@",self.indexs[section]];
    return label;
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.isSearching){
        return 0;
    }
    return self.indexs;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    static NSString*identifier = @"CGUserContactsTableViewCell";
    CGUserContactsTableViewCell *cell = (CGUserContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserContactsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGUserPhoneContactEntity *entity;
    if(self.isSearching){
        entity = self.searchData[indexPath.row];
    }else{
        NSArray *sectionList = [self.contacts objectForKey:self.indexs[indexPath.section]];
        entity = sectionList[indexPath.row];
    }
    
    if (entity.icon) {
        cell.icon.image = entity.icon;
    }
    [cell updateEntity:entity didSelectedButtonIndex:^(UIButton *sender) {
        //      [weakSelf showMessageView:@[entity.phone] title:@"" body:@"邀请你加入团队。马上点击以下链接http://team580.com/ ,下载app后通过手机验证码登录，团队成员都在等你了，点击链接快快加入哦！"];
        weakSelf.selectEntity = entity;
        CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
        [biz.component startBlockAnimation];
        [biz authUserInvitationWithPhone:entity.phone organizaId:[self getOrganizaId] organizaType:[self getOrganizaType]  success:^{
            [biz.component stopBlockAnimation];
            entity.isInvite = 4;
            [weakSelf.tableview reloadData];
        } fail:^(NSError *error) {
            [biz.component stopBlockAnimation];
        }];
    }];
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            self.selectEntity.isInvite = 1;
            [self.tableview reloadData];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
@end
