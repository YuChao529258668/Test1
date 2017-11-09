//
//  ClassPushView.m
//  CGSays
//
//  Created by zhu on 2016/11/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "ClassPushView.h"
#import "DiscoverPushView.h"
#import "CGHorrolEntity.h"
#import "PushViewTableViewCell.h"
#import "CGUserDao.h"

@interface ClassPushView ()
<UITableViewDelegate,UITableViewDataSource>{
  ClassPushViewBlock block;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation ClassPushView

- (instancetype)initWithSelectIndex:(ClassPushViewBlock)index title:(NSString *)title{
  self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  if(self){
    block = index;
    self.selectIndex = -1;
    self.title = title;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = CTCommonLineBg.CGColor;
    self.layer.masksToBounds = YES;
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    [self addSubview:self.bgButton];
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.bgButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self bgView];
    [self tableView];
    [self topView];
    self.hidden = YES;
  }
  return self;
}

- (void)cancelClick{
  [self hiddenView];
}

- (void)setDataWithArray:(NSMutableArray *)array{
  self.dataArray = array;
  [self.tableView reloadData];
}

//弹出
- (void)showInView{
  self.hidden = NO;
    __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.bgView.frame = CGRectMake(SCREEN_WIDTH/3, 0, weakSelf.bgView.frame.size.width, weakSelf.bgView.frame.size.height);
  }completion:^(BOOL finished) {
  }];
}

//收起
- (void)hiddenView{
    __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.bgView.frame = CGRectMake(SCREEN_WIDTH, 0, weakSelf.bgView.frame.size.width, weakSelf.bgView.frame.size.height);
  } completion:^(BOOL finished) {
    weakSelf.hidden = YES;
  }];
}

-(UIView *)bgView{
  if (!_bgView) {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH/3*2, SCREEN_HEIGHT)];
    [self addSubview:_bgView];
  }
  return _bgView;
}

-(UITableView *)tableView{
  if (!_tableView) {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH/3*2,SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.bgView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
  }
  return _tableView;
}

-(UIView *)topView{
  if (!_topView) {
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3*2, 64)];
    [self.bgView addSubview:_topView];
    _topView.layer.borderColor = CTCommonLineBg.CGColor;
    _topView.layer.borderWidth = 0.5;
    _topView.backgroundColor = CTThemeMainColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, SCREEN_WIDTH/3*2, 21)];
    label.text = self.title;
    label.textColor = [UIColor whiteColor];
    [self.bgView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
  }
  return _topView;
}

//- (void)searClick:(UIButton *)sender{
//  CGUserDao *dao = [[CGUserDao alloc]init];
//  CGUserEntity *userInfo = [dao getLoginedUserFromLocal];
//  NSInteger pushViewType = self.isCreate?0:1;
//  NSString *str = self.isCreate?@"主题管理":@"主题复制";
//  if ([self.prompt isEqualToString:@"对手"]) {
//    if (userInfo.companyExternal == 1) {
//     str = @"条件管理";
//      pushViewType = 2;
//    }
//  }
//  typeBlock(pushViewType);
//  DiscoverPushView *pushView = [[DiscoverPushView alloc]initWithFrame:sender.frame title1:str title2:@"主题分享" selectIndex:^(int selectIndex) {
//    if (selectIndex == 0 ) {
//      typeBlock(pushViewType);
//    }else{
//      
//    }
//  } cancel:^{
//    
//  }];
//  pushView.grayView.backgroundColor = [UIColor clearColor];
//  [pushView showInView:self.bgView frame:sender.frame];
//}
//- (void)setIsCreate:(BOOL)isCreate{
//  _isCreate = isCreate;
//  if ([self getPushViewType] ==0 ||[self getPushViewType] ==2) {
//    UIButton *setButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2-44, 20, 44, 44)];
//    [setButton setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
//    [setButton addTarget:self action:@selector(searClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:setButton];
//  }
//}
//
//- (NSInteger)getPushViewType{
//  NSInteger pushViewType = self.isCreate?0:1;
//  if ([self.prompt isEqualToString:@"对手"]&&self.isCreate==YES) {
//    pushViewType = 2;
//  }
//  return pushViewType;
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self hiddenView];
  if (self.selectIndex == indexPath.row) {
    self.selectIndex = -1;
  }else{
    self.selectIndex = indexPath.row;
  }
  [self.tableView reloadData];
  block(self.selectIndex);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString*identifier = @"PushViewTableViewCell";
  PushViewTableViewCell *cell = (PushViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PushViewTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell updateData:self.dataArray[indexPath.row]];
  if (self.selectIndex == indexPath.row) {
    cell.titleLabel.textColor = CTThemeMainColor;
  }else{
    cell.titleLabel.textColor = TEXT_MAIN_CLR;
  }
  return cell;
}
@end
