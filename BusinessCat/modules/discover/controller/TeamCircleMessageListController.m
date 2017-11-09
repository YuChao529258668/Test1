//
//  TeamCircleMessageListController.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircleMessageListController.h"
#import "TeamCircleMessageCell.h"
#import "CGDiscoverTeamDetailViewController.h"
#import "CGDiscoverBiz.h"
#import "TeamCircleMessageModel.h"

@interface TeamCircleMessageListController ()

@property(nonatomic,retain)NSString *companyId;
@property(nonatomic,assign)int companyType;

@property(nonatomic,retain)NSMutableArray *data;

@property(nonatomic,assign)BOOL hasMoreMsg;
@end

@implementation TeamCircleMessageListController

#define CellIdentifier @"TeamCircleMessageCell"

-(instancetype)initWithCompanyId:(NSString *)companyId companyType:(int)companyType{
    self = [super init];
    if(self){
            self.hasMoreMsg = YES;
        self.companyId = companyId;
        self.companyType = companyType;
    }
    return self;
}
- (void)viewDidLoad {
    self.title = @"消息";
    [super viewDidLoad];
    self.tableview.separatorColor = CTCommonLineBg;
    [self.tableview registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self loadDataByMode:0 time:0];
}

-(void)loadDataByMode:(int)mode time:(long)time{
    __weak typeof(self) weakSelf = self;
    [[[CGDiscoverBiz alloc]init]queryDiscoverRemindListWithCompanyId:self.companyId companyType:self.companyType mode:mode time:time success:^(NSMutableArray *list) {
        [weakSelf.tableview.mj_header endRefreshing];
        if(mode == 0){
            weakSelf.data = list;
        }else{
            if(list && list.count > 0){
                [weakSelf.data addObjectsFromArray:list];
            }else{
                self.hasMoreMsg = NO;
            }
        }
        [weakSelf.tableview reloadData];
    } fail:^(NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row < self.data.count ? 80 : 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.data.count){
        TeamCircleMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell updateItem:self.data[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            button.tag = 1000;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.userInteractionEnabled = NO;
            [button setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
            [button setTitle:@"查看更多消息..." forState:UIControlStateSelected];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitle:@"无更多消息" forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
        }
        UIButton *button = [cell.contentView viewWithTag:1000];
        button.selected = self.hasMoreMsg;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.data.count){
        TeamCircleMessageModel *entity = self.data[indexPath.row];
        CGDiscoverTeamDetailViewController *controller = [[CGDiscoverTeamDetailViewController alloc]initWithScoopID:entity.scoopId updateBlock:^(CellLayout *cellLayout) {
            
        } deleteBlock:^(CellLayout *cellLayout) {
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if(self.hasMoreMsg){
            long time = 0;
            if(self.data && self.data.count > 0){
                TeamCircleMessageModel *entity = [self.data lastObject];
                time = entity.createTime;
            }
            [self loadDataByMode:1 time:time];
        }
        
        NSLog(@"加载更多点击");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
