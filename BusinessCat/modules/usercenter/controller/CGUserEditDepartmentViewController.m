//
//  CGUserEditDepartmentViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserEditDepartmentViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserTextViewController.h"
#import "CGUserSearchViewController.h"
#import "CGUserDepaEntity.h"
#import "CGUserCenterBiz.h"
#import "CGHorrolView.h"

@interface CGUserEditDepartmentViewController ()
@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property(nonatomic,retain)NSMutableArray *headViewEntitys;
@property(nonatomic,assign)int currentIndex;

@property(nonatomic,retain)NSMutableDictionary *datas;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@property(nonatomic,retain)NSMutableArray *organzias;

@property(nonatomic,assign)BOOL hideOrganizaNaviView;//是否隐藏顶部的组织导航栏

@end

@implementation CGUserEditDepartmentViewController

-(instancetype)initWithOrganiza:(CGUserOrganizaJoinEntity *)organiza{
    self = [super init];
    if(self){
        if(organiza){
            self.hideOrganizaNaviView = YES;
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
                if(local.companyAdmin == 1 || local.companyManage == 1){//超级管理员或管理员
                    [_organzias addObject:local];
                }
            }
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

//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
    __weak typeof(self) weakSelf = self;
    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, self.hideOrganizaNaviView ? 0 : 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            weakSelf.currentIndex = index;
            [self getData];
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
                if(local.companyAdmin || local.companyManage){//超级管理员或普通管理员
                    CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyFullName sort:i];
                    [_headViewEntitys addObject:organiza];
                }
            }
        }
    }
    return _headViewEntitys;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"部门管理";
    [self.view addSubview:self.organizaHeaderView];
    [self.organizaHeaderView setSelectIndex:self.currentIndex];
    [self.createBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
    if([[weakSelf.datas allKeys]containsObject:[self getOrganizaId]]){
        [weakSelf.tableview reloadData];
    }else{
        CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
        [biz.component startBlockAnimation];
        [biz authUserOrganizaDepaListWithOrganizaID:[self getOrganizaId] type:[self getOrganizaType] success:^(NSMutableArray *reslut) {
            [biz.component stopBlockAnimation];
            [weakSelf.datas setObject:reslut forKey:[self getOrganizaId]];
            [weakSelf.tableview reloadData];
        } fail:^(NSError *error) {
            [biz.component stopBlockAnimation];
            [weakSelf.tableview reloadData];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
    return value.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString*identifier = @"CGUserTextArrowTableViewCell";
    CGUserTextArrowTableViewCell *cell = (CGUserTextArrowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserTextArrowTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
    CGUserDepaEntity *entity = value[indexPath.row];
    cell.nameLabel.text = entity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *value = [self.datas objectForKey:[self getOrganizaId]];
    CGUserDepaEntity *entity = value[indexPath.row];
    __weak typeof(self) weakSelf = self;
    CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
        entity.name = text;
        [weakSelf.tableview reloadData];
    }];
    vc.textType = UserTextTypeEditDepartment;
    vc.type = [self getOrganizaType];
    vc.depaId = entity.depaID;
    vc.organizeID = [self getOrganizaId];
    vc.text = entity.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
        NSMutableArray *value = [self.datas objectForKey:[self getOrganizaId]];
        CGUserDepaEntity *entity = value[indexPath.row];
        [biz.component startBlockAnimation];
        [biz userOrganizaDepaDeleteWithOrganizaId:[self getOrganizaId] depaId:entity.depaID type:[self getOrganizaType] success:^{
            [value removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [biz.component stopBlockAnimation];
        } fail:^(NSError *error) {
            [tableView reloadData];
            [biz.component stopBlockAnimation];
        }];
    }
}

- (IBAction)creatDepartment:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
        CGUserDepaEntity *entity = [[CGUserDepaEntity alloc]init];
        entity.name = text;
        entity.depaID = textID;
        NSMutableArray *value = [self.datas objectForKey:[self getOrganizaId]];
        [value addObject:entity];
        [weakSelf.tableview reloadData];
    }];
    vc.textType = UserTextTypeCreatDepartment;
    vc.type = [self getOrganizaType];
    vc.organizeID = [self getOrganizaId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
@end
