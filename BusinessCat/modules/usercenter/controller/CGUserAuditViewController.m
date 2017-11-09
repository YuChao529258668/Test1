//
//  CGUserViewAuditController.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserAuditViewController.h"
#import "CGUserCenterBiz.h"
#import <UIImageView+WebCache.h>
#import "CGUserCompanyAuditListEntity.h"
#import "UserAuditCollectionViewCell.h"
#import "CGHorrolView.h"
#import "CGUserAuditTableViewCell.h"
#import "UserAuditNoDataTableViewCell.h"

@interface CGUserAuditViewController ()<UIActionSheetDelegate>

@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property(nonatomic,retain)NSMutableArray *headViewEntitys;

@property(nonatomic,retain)NSMutableDictionary *datas;

@property(nonatomic,retain)NSMutableDictionary *pages;

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,retain)NSMutableArray *organzias;

@end

@implementation CGUserAuditViewController

-(NSMutableArray *)organzias{
    if(!_organzias){
        _organzias = [NSMutableArray array];
        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
          for (int i =0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
            CGUserOrganizaJoinEntity *local =  [ObjectShareTool sharedInstance].currentUser.companyList[i];
                if(local.companyAdmin == 1 && local.isAudit == 1){//超级管理员和需要审核才显示
                  if ([self.companyID isEqualToString:local.companyId]) {
                    [self queryList:NO force:NO];
                  }
                    [_organzias addObject:local];
                }
            }
          [self.organizaHeaderView setSelectIndex:self.currentIndex];
        }
    }
    return _organzias;
}

-(NSMutableDictionary *)datas{
    if(!_datas){
        _datas = [NSMutableDictionary dictionary];
    }
    return _datas;
}
-(NSMutableDictionary *)pages{
    if(!_pages){
        _pages = [NSMutableDictionary dictionary];
    }
    return _pages;
}

//获取当前组织id
-(NSString *)getOrganizaId{
    if(self.organzias && self.organzias.count > 0){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        NSString *organizaId;
        if(entity.companyType == 2){
            organizaId = entity.classId;
        }else{
            organizaId = entity.companyId;
        }
        return organizaId;
    }
    return nil;
}

//获取当前组织类型
-(int)getOrganizaType{
    if(self.organzias && self.organzias.count > self.currentIndex){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        return entity.companyType;
    }
    return 0;
}

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
    __weak typeof(self) weakSelf = self;
    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            weakSelf.currentIndex = index;
            [self queryList:NO force:NO];
        }];
    }
    return _organizaHeaderView;
}

//大类控件的数据
-(NSMutableArray *)headViewEntitys{
    if(!_headViewEntitys){
        _headViewEntitys = [NSMutableArray array];
        if(self.organzias && self.organzias.count > 0){
            for(int i=0;i<self.organzias.count;i++){
                CGUserOrganizaJoinEntity *local = self.organzias[i];
                if(local.isAudit == 1 && local.companyAdmin){
                    CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyFullName sort:i];
                    [_headViewEntitys addObject:organiza];
                }
            }
        }
    }
    return _headViewEntitys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入审核";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
    if(self.organzias.count > 0){
        [self.view addSubview:self.organizaHeaderView];
        CGRect rect = self.organizaHeaderView.frame;
        rect.origin.y = CGRectGetMaxY(self.navi.frame);
        self.organizaHeaderView.frame = rect;
    }else{
        self.tableview.frame = CGRectMake(0, CGRectGetMaxY(self.navi.frame), self.tableview.frame.size.width, SCREEN_HEIGHT-64);
    }
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
    }];
    
    //上拉加载更多
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(self.organzias.count > 0){
            [self queryList:YES force:NO];
        }else{
            [weakSelf.tableview.mj_footer endRefreshing];
        }
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

-(void)refresh{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableview.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableview.frame.size.height) {
    if (self.tableview.mj_footer.isRefreshing == NO&&self.tableview.mj_footer.state != MJRefreshStateNoMoreData) {
      self.tableview.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

-(void)updateView{
    self.organzias = nil;
    self.headViewEntitys = nil;
    [self.organizaHeaderView removeFromSuperview];
    self.organizaHeaderView = nil;
    [self.datas removeAllObjects];
    [self.tableview reloadData];
    if(self.organzias.count > 0){
        [self.view addSubview:self.organizaHeaderView];
        CGRect rect = self.organizaHeaderView.frame;
        rect.origin.y = CGRectGetMaxY(self.navi.frame);
        self.organizaHeaderView.frame = rect;
        self.tableview.frame = CGRectMake(0, CGRectGetMaxY(self.organizaHeaderView.frame), self.tableview.frame.size.width, SCREEN_HEIGHT-CGRectGetMaxY(self.organizaHeaderView.frame));
    }else{
        self.tableview.frame = CGRectMake(0, CGRectGetMaxY(self.navi.frame), self.tableview.frame.size.width, SCREEN_HEIGHT-CGRectGetMaxY(self.navi.frame));
    }
    [self queryList:NO force:YES];
    NSLog(@"更新用户信息成功");
}

//mode NO:下拉 YES：上拉 force：是否强制刷新
-(void)queryList:(BOOL)mode force:(BOOL)force{
    __weak typeof(self) weakSelf = self;
    if(!mode){//下拉刷新
        if(force && [self getOrganizaId]){
            [weakSelf.datas removeObjectForKey:[self getOrganizaId]];
            [self.pages setObject:[NSNumber numberWithInt:1] forKey:[self getOrganizaId]];
        }
    }
    if([[weakSelf.datas allKeys]containsObject:[self getOrganizaId]] && !mode){//只有下拉刷新并且有数据才不请求
        [self.tableview reloadData];
    }else{
        CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
        int page = [[self.pages objectForKey:[self getOrganizaId]]intValue];
        if(!mode){
            page = 1;
        }else{
            page += 1;
        }
        [biz userCompanyAuditListWithOrganizaId:[self getOrganizaId] type:[self getOrganizaType] Page:page success:^(NSMutableArray *result) {
            CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
            entity.isLoaded = YES;
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
            if(result && result.count > 0){
                if(!mode){//下拉刷新
                    [weakSelf.datas setObject:result forKey:[self getOrganizaId]];
                    [self.pages setObject:[NSNumber numberWithInt:1] forKey:[self getOrganizaId]];
                }else{
                    NSMutableArray *value = [weakSelf.datas objectForKey:[self getOrganizaId]];
                    [value addObjectsFromArray:result];
                    [weakSelf.datas setObject:value forKey:[self getOrganizaId]];
                    [self.pages setObject:[NSNumber numberWithInt:page] forKey:[self getOrganizaId]];
                }
            }
            [self.tableview reloadData];
        } fail:^(NSError *error) {
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.organzias.count <= 0){
        return SCREEN_HEIGHT-64;
    }
    NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
    if (value.count<=0) {
        return SCREEN_HEIGHT-64;
    }
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.organzias.count > 0){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
        if(value.count <= 0){
            if(entity.isLoaded){
                return 1;
            }else{
                return 0;
            }
        }else{
            return value.count;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if(self.organzias.count <= 0){
        static NSString*identifier1 = @"UserAuditNoDataTableViewCell";
        UserAuditNoDataTableViewCell *cell = (UserAuditNoDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserAuditNoDataTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        return cell;
    }
    NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
    if (value.count <= 0) {
        static NSString*identifier1 = @"UserAuditNoDataTableViewCell";
        UserAuditNoDataTableViewCell *cell = (UserAuditNoDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserAuditNoDataTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        return cell;
    }else{
        static NSString*identifier = @"CGUserAuditTableViewCell";
        CGUserAuditTableViewCell *cell = (CGUserAuditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAuditTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CGUserCompanyAuditListEntity *entity = value[indexPath.row];
        [cell updatItem:entity block:^(CGUserCompanyAuditListEntity *entity) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf uploadResult:entity reason:nil type:1];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [weakSelf showAgainRejectView:entity];
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            
        }];
        
        return cell;
    }
}

-(void)showAgainRejectView:(CGUserCompanyAuditListEntity *)entity{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入拒绝的理由";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *text = alert.textFields[0].text;
        if(text.length <= 0){
            [[CTToast makeText:@"请输入拒绝理由"]show:weakSelf.view];
            [weakSelf showAgainRejectView:entity];
        }else{
            [weakSelf uploadResult:entity reason:text type:2];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)uploadResult:(CGUserCompanyAuditListEntity *)entity reason:(NSString *)reason type:(int)type{
    __weak typeof(self) weakSelf = self;
    CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
    [biz.component startBlockAnimation];
    [biz userCompanyAuditWithUserID:entity.userId organizaId:[self getOrganizaId] organizaType:[self getOrganizaType] action:type reason:reason success:^{
        [ObjectShareTool sharedInstance].currentUser.auditNum -= 1;
        if([ObjectShareTool sharedInstance].currentUser.auditNum < 0){
            [ObjectShareTool sharedInstance].currentUser.auditNum = 0;
        }
        entity.auditState = type;
        [biz.component stopBlockAnimation];
        if(type == 1){
            NSMutableArray *value = [self.datas objectForKey:[self getOrganizaId]];
            [value removeObject:entity];
        }
        
        [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
        [biz.component stopBlockAnimation];
    }];
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
