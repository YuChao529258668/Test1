//
//  CGDiscoverSourceCircleViewController.m
//  CGSays
//
//  Created by zhu on 16/10/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverSourceCircleViewController.h"
#import "CGSourceCircleTableViewCell.h"
#import "Menu.h"
#import "CellLayout.h"
#import "LWAlertView.h"
#import "CGSourceCircleEntity.h"
#import "LWImageBrowser.h"
#import "CGDiscoverBiz.h"
#import "CGDiscoverReleaseSourceViewController.h"
#import "CGScoopIndexEntity.h"
#import "CGUserDao.h"
#import "CGHeadlineInfoDetailController.h"
#import "DiscoverPushView.h"
#import "CGDiscoverCircleNullTableViewCell.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGUserSearchViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGUserCompanyAttestationEntity.h"
#import "CGUserCenterBiz.h"
#import "CGExceptionalViewController.h"
#import "CGHorrolView.h"
#import "CGCompanyDao.h"

@interface CGDiscoverSourceCircleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) Menu* menu;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic, assign) BOOL isMenuOpen;
@property (nonatomic, assign) NSInteger zanIndex;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIButton *externalButton;
@property (nonatomic, strong) UIButton *topSelectBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) UIImageView *topLine;
@property (nonatomic, strong) CGScoopIndexEntity *indexEntity;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) CGSourceCircleEntity *deleteEntity;
@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, strong) SourceCircComments *commentEntity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopY;
@property (nonatomic, assign) BOOL isFirst;
@property (weak, nonatomic) IBOutlet UIButton *BGButton;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *companyList;
@end

@implementation CGDiscoverSourceCircleViewController

- (void)viewDidLoad {
  self.title = @"企业圈";
  [super viewDidLoad];
  
  [self getNaviButton];
  self.topSelectBtn = self.companyBtn;
  self.tableView.separatorStyle = NO;
  self.isFirst = YES;
  [self.view addSubview:self.menu];
  [self getTextBGView];
  [self getTopLine];
  self.tableView.tableFooterView = [[UIView alloc]init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
  
  if (self.isWaibu) {
    self.externalButton.selected = YES;
    self.companyBtn.selected = NO;
    self.topSelectBtn = self.externalButton;
  }else{
    [self hideCustomBackBtn];
  }
  [self getListdata];
}

-(void)updateTopViewState{
  
}


//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{
  [WKWebViewController setPath:@"setCurrentPath" code:@"discover/reports" success:^(id response) {
    
  } fail:^{
    
  }];
}

-(void)paySuccess{
  [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [ [NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [ [NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//创建评论输入框
- (void)getTextBGView{
  self.textBGView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
  self.textBGView.layer.borderWidth = 1;
  self.textBGView.backgroundColor = CTCommonViewControllerBg;
  self.textBGView.layer.borderColor = CTCommonLineBg.CGColor;
  [self.view addSubview:self.textBGView];
  self.textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-70, 30)];
  [self.textBGView addSubview:self.textField];
  self.textField.placeholder = @"评论";
  self.textField.font = [UIFont systemFontOfSize:15];
  self.textField.borderStyle = UITextBorderStyleRoundedRect;
  UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 10, 40, 30)];
  [self.textBGView addSubview:btn];
  [btn setTitle:@"发表" forState:UIControlStateNormal];
  btn.titleLabel.font = [UIFont systemFontOfSize:15];
  [btn setTitleColor:TEXT_GRAY_CLR forState:UIControlStateNormal];
  btn.layer.cornerRadius = 4;
  btn.layer.masksToBounds = YES;
  btn.layer.borderColor = CTCommonLineBg.CGColor;
  btn.layer.borderWidth = 0.5;
  [btn addTarget:self action:@selector(releaseClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBtnAction:(UIButton *)sender{
//  __weak typeof(self) weakSelf = self;
//  DiscoverPushView *pushView = [[DiscoverPushView alloc]initWithFrame:sender.frame title1:@"发表动态" title2:@"我要爆料" selectIndex:^(int selectIndex) {
//    CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(NSString *success) {
//      [weakSelf getLastListData];
//    }];
//    vc.releaseType = selectIndex;
//    [weakSelf.navigationController pushViewController:vc animated:YES];
//  } cancel:^{
//    
//  }];
//  [pushView showInView:[UIApplication sharedApplication].keyWindow frame:sender.frame];
}

- (void)searchBtnAction:(UIButton *)sender{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 16;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)baseBackAction{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)getNaviButton{
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-36, 32, 20, 20)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
  [self.navi addSubview:self.rightBtn];
  
  self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 74, 30, 24, 24)];
  [self.searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  self.searchBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"station_magnifier"] forState:UIControlStateNormal];
  [self.navi addSubview:self.searchBtn];
}

//获取最新列表数据
-(void)getLastListData{
  __weak typeof(self) weakSelf = self;
//  weakSelf.dataSource = [NSMutableArray array];
//  NSDate *datenow = [NSDate date];
//  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
//  [biz discoverScoopListWithType:weakSelf.topSelectBtn.tag+1 time:(NSInteger)[datenow timeIntervalSince1970] mode:0 success:^(NSMutableArray *result) {
//    weakSelf.isFirst = NO;
//    for (int i =0; i<result.count; i++) {
//      CGSourceCircleEntity *entity = result[i];
//      CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
//      [weakSelf.dataSource addObject:layout];
//    }
//    [weakSelf.tableView.mj_header endRefreshing];
//    [weakSelf.tableView reloadData];
//  } fail:^(NSError *error) {
//    weakSelf.isFirst = NO;
//    [weakSelf.tableView.mj_header endRefreshing];
//  }];
}

//获取列表数据
- (void)getListdata{
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf getLastListData];
  }];
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSInteger time = (NSInteger)[datenow timeIntervalSince1970];
    if (weakSelf.dataSource.count>0) {
      CellLayout *layout = [weakSelf.dataSource lastObject];
      time = layout.entity.time;
    }
//    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
//    [biz discoverScoopListWithType:weakSelf.topSelectBtn.tag+1 time:time mode:1 success:^(NSMutableArray *result) {
//      for (int i =0; i<result.count; i++) {
//        CGSourceCircleEntity *entity = result[i];
//        CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
//        [weakSelf.dataSource addObject:layout];
//      }
//      [weakSelf.tableView.mj_footer endRefreshing];
//      [weakSelf.tableView reloadData];
//    } fail:^(NSError *error) {
//      [weakSelf.tableView.mj_footer endRefreshing];
//    }];
  }];
  [self.tableView.mj_header beginRefreshing];
}

- (void)getIndexData{
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  [biz discoverScoopIndexSuccess:^(CGScoopIndexEntity *entity) {
    __strong typeof(weakSelf) swself = weakSelf;
    swself.indexEntity = entity;
    swself.countLabel.text = [NSString stringWithFormat:@"%ld",entity.count];
  } fail:^(NSError *error) {
    
  }];
}

- (Menu *)menu {
  if (_menu) {
    return _menu;
  }
  _menu = [[Menu alloc] initWithFrame:CGRectZero];
  _menu.backgroundColor = [UIColor whiteColor];
  _menu.opaque = YES;
  [_menu.commentButton addTarget:self action:@selector(didClickedCommentButton)
                forControlEvents:UIControlEventTouchUpInside];
  [_menu.likeButton addTarget:self action:@selector(didclickedLikeButton:)
             forControlEvents:UIControlEventTouchUpInside];
  [_menu.awardButton addTarget:self action:@selector(awardClick) forControlEvents:UIControlEventTouchUpInside];
  return _menu;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.isMenuOpen = NO;
  [self.menu menuHide];
  self.BGButton.hidden = YES;
  [self.textField resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isFirst == YES) {
    return 0;
  }
  
  if (self.dataSource.count<=0) {
    return 1;
  }
  return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataSource.count<=0){
    return SCREEN_HEIGHT-64-50;
  }else if (self.dataSource.count >= indexPath.row) {
    CellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataSource.count<=0) {
    NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
    CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.topSelectBtn.tag == 1) {
      cell.titleLabel.text = @"还没有外部人员给我们爆料!";
    }
    return cell;
  }else{
    static NSString* cellIdentifier = @"cellIdentifier";
    CGSourceCircleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[CGSourceCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
  }
  return nil;
}

- (void)confirgueCell:(CGSourceCircleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.indexPath = indexPath;
  CellLayout* cellLayout = self.dataSource[indexPath.row];
  cell.cellLayout = cellLayout;
  [self callbackWithCell:cell];
}

- (void)callbackWithCell:(CGSourceCircleTableViewCell *)cell {
  __weak typeof(self) weakSelf = self;
  cell.clickedReCommentCallback = ^(CGSourceCircleTableViewCell* cell,SourceCircComments* model) {
    if (![model.uid isEqualToString:[ObjectShareTool sharedInstance].currentUser.uuid]) {
      weakSelf.zanIndex = [weakSelf.tableView indexPathForCell:cell].row;
      [weakSelf.textField becomeFirstResponder];
      weakSelf.isComment = YES;
      weakSelf.commentEntity = model;
    }
  };
  //展开全文点击回调
  cell.clickedOpenCellCallback = ^(CGSourceCircleTableViewCell* cell) {
    //    __strong typeof(weakSelf) sself = weakSelf;
    [weakSelf openTableViewCell:cell];
  };
  //收起全文点击回调
  cell.clickedCloseCellCallback = ^(CGSourceCircleTableViewCell* cell) {
    //    __strong typeof(weakSelf) sself = weakSelf;
    [weakSelf closeTableViewCell:cell];
  };
  //头像点击回调
  cell.clickedAvatarCallback = ^(CGSourceCircleTableViewCell* cell) {
    //    __strong typeof(weakSelf) sself = weakSelf;
    [weakSelf showAvatarWithCell:cell];
  };
  //图片点击回调
  cell.clickedImageCallback = ^(CGSourceCircleTableViewCell* cell,NSInteger imageIndex) {
    //    __strong typeof(weakSelf) sself = weakSelf;
    [weakSelf tableViewCell:cell showImageBrowserWithImageIndex:imageIndex];
  };
  //更多按钮点击回调
  cell.clicmeunCellCallback = ^(CGSourceCircleTableViewCell *cell, CGSourceCircleEntity *entity){
    //    __strong typeof(weakSelf) sself = weakSelf;
    
    CGRect rectInTableView = [weakSelf.tableView rectForRowAtIndexPath:[weakSelf.tableView indexPathForCell:cell]];
    CGRect rectInSuperView = [weakSelf.tableView convertRect:rectInTableView toView:[weakSelf.tableView superview]];
    weakSelf.menu.entity = entity;
    weakSelf.menu.frame = CGRectMake(cell.cellLayout.menuPosition.origin.x - 5.0f,
                                     cell.cellLayout.menuPosition.origin.y - 9.0f + 14.5f+rectInSuperView.origin.y,0.0f,34.0f);
    if (weakSelf.isMenuOpen) {
      weakSelf.isMenuOpen = NO;
      [weakSelf.menu menuHide];
      weakSelf.BGButton.hidden = YES;
    }else{
      weakSelf.isMenuOpen = YES;
      if ([entity.userId isEqualToString:[ObjectShareTool sharedInstance].currentUser.uuid]) {
        [weakSelf.menu menuShow:NO];
      }else{
        [weakSelf.menu menuShow:YES];
      }
      weakSelf.BGButton.hidden = NO;
    }
    weakSelf.zanIndex = [weakSelf.tableView indexPathForCell:cell].row;
  };
  //点击点赞人回调
  cell.clicPraiseCellCallback = ^(CGSourceCircleTableViewCell* cell,SourceCircPraise *praise) {
  };
  cell.clicReplyCellCallback = ^(CGSourceCircleTableViewCell* cell,SourceCircReply *reply){
  };
  
  //删除企业圈
  cell.deleteCallback = ^(CGSourceCircleTableViewCell* cell,CGSourceCircleEntity *entity) {
    [weakSelf deleteTeamCircle:cell];
    weakSelf.deleteEntity = entity;
  };
  //点击链接回调
  cell.linkCallback = ^(CGSourceCircleTableViewCell* cell,CGDiscoverLink *link){
    //    __strong typeof(weakSelf) sself = weakSelf;
    CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
      
    }];
    [weakSelf.navigationController pushViewController:vc animated:YES];
  };
}

-(void)deleteTeamCircle:(CGSourceCircleTableViewCell *)cell{
  __weak typeof(self) weakSelf = self;
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
    [biz.component startBlockAnimation];
    [biz discoverScoopDeleteWithScoopID:weakSelf.deleteEntity.scoopID success:^{
      [biz.component stopBlockAnimation];
      [weakSelf.dataSource removeObjectAtIndex:[weakSelf.tableView indexPathForCell:cell].row];
      [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[weakSelf.tableView indexPathForCell:cell], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    } fail:^(NSError *error) {
      [biz.component stopBlockAnimation];
    }];
  }]];
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
  [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Actions

//点击查看大图
- (void)tableViewCell:(CGSourceCircleTableViewCell *)cell showImageBrowserWithImageIndex:(NSInteger)imageIndex {
  NSMutableArray* tmps = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < cell.cellLayout.imagePostions.count; i ++) {
    SourceCircImgList *image = cell.cellLayout.entity.imgList[i];
    LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                  initWithplaceholder:[UIImage imageNamed:@"morentuzhengfangxing"]
                                  thumbnailURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/200/interlace/1",image.thumbnail]]
                                  HDURL:[NSURL URLWithString:image.src]
                                  containerView:cell.contentView
                                  positionInContainer:CGRectFromString(cell.cellLayout.imagePostions[i])
                                  index:i];
    [tmps addObject:model];
  }
  LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                  currentIndex:imageIndex];
  browser.isShowPageControl = NO;
  [browser show];
}

//查看头像
- (void)showAvatarWithCell:(CGSourceCircleTableViewCell *)cell {
  //  [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.entity.nickname]];
}


//展开Cell
- (void)openTableViewCell:(CGSourceCircleTableViewCell *)cell {
  CellLayout* layout =  [self.dataSource objectAtIndex:[self.tableView indexPathForCell:cell].row];
  CGSourceCircleEntity* model = layout.entity;
  CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:YES dateFormatter:self.dateFormatter];
  [self.dataSource replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(CGSourceCircleTableViewCell *)cell {
  CellLayout* layout =  [self.dataSource objectAtIndex:[self.tableView indexPathForCell:cell].row];
  CGSourceCircleEntity* model = layout.entity;
  CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:NO dateFormatter:self.dateFormatter];
  
  [self.dataSource replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}


- (CellLayout *)layoutWithStatusModel:(CGSourceCircleEntity *)statusModel{
  CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel isUnfold:NO dateFormatter:self.dateFormatter];
  return layout;
}

- (NSDateFormatter *)dateFormatter {
  static NSDateFormatter* dateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
  });
  return dateFormatter;
}

//点击评论
- (void)didClickedCommentButton {
  [self.menu menuHide];
  self.BGButton.hidden = YES;
  self.isComment = NO;
  [self.textField becomeFirstResponder];
}

//打赏
-(void)awardClick{
  [self.menu menuHide];
  CGExceptionalViewController *vc = [[CGExceptionalViewController alloc]init];
  CellLayout* cellLayout = self.dataSource[self.zanIndex];
  vc.sourceCircleID = cellLayout.entity.scoopID;
  vc.toUserID = cellLayout.entity.userId;
  vc.iconImage = cellLayout.entity.portrait;
  vc.userName = cellLayout.entity.nickname;
  [self.navigationController pushViewController:vc animated:YES];
}

//点赞
- (void)didclickedLikeButton:(LikeButton *)likeButton {
  __weak typeof(self) weakSelf = self;
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  CellLayout* cellLayout = self.dataSource[self.zanIndex];
  [self.menu menuHide];
  self.BGButton.hidden = YES;
  //TODO
  [biz authDiscoverScoopPraiseID:cellLayout.entity.scoopID type:!cellLayout.entity.isPraise success:^{
    cellLayout.entity.isPraise = !cellLayout.entity.isPraise;
    if (cellLayout.entity.isPraise) {
      SourceCircPraise *reply = [[SourceCircPraise alloc]init];
      reply.nickname = [ObjectShareTool sharedInstance].currentUser.nickname;
      reply.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
      reply.portrait = [ObjectShareTool sharedInstance].currentUser.portrait;
      if (cellLayout.entity.praise) {
        [cellLayout.entity.praise addObject:reply];
      }else{
        cellLayout.entity.praise = [NSMutableArray array];
        [cellLayout.entity.praise addObject:reply];
      }
    }else{
      for (SourceCircPraise *replay in cellLayout.entity.praise) {
        if ([[ObjectShareTool sharedInstance].currentUser.uuid isEqualToString:replay.uid]) {
          [cellLayout.entity.praise removeObject:replay];
          break;
        }
      }
    }
    CellLayout *layout = [weakSelf layoutWithStatusModel:cellLayout.entity];
    [weakSelf.dataSource replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  } fail:^(NSError *error) {
    
  }];
}

#pragma mark - keyboardChange
-(void)keyboardShow:(NSNotification*)info{ //键盘出现
  __weak typeof(self) weakSelf = self;
  NSDictionary* userInfo = [info valueForKey:@"userInfo"];
  CGRect keyboardRect = [[userInfo valueForKey: UIKeyboardFrameEndUserInfoKey]CGRectValue];
  float height = keyboardRect.size.height;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.textBGView.frame = CGRectMake(weakSelf.textBGView.frame.origin.x, (SCREEN_HEIGHT-weakSelf.textBGView.frame.size.height-height), weakSelf.textBGView.frame.size.width, weakSelf.textBGView.frame.size.height);
  }];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.zanIndex inSection:0];
  CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
  float min = self.tableView.frame.size.height-height-50;
  if (min < rectInTableView.origin.y+rectInTableView.size.height) {
    [self.tableView setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-(self.tableView.frame.size.height-height-50.f)) animated:YES];
  }else{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
  }
  self.BGButton.hidden = NO;
}

-(void)keyboardHidden:(NSNotification*)info{ //键盘收回；
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.textBGView.frame = CGRectMake(weakSelf.textBGView.frame.origin.x, SCREEN_HEIGHT, weakSelf.textBGView.frame.size.width, weakSelf.textBGView.frame.size.height);
  }];
  self.BGButton.hidden = YES;
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//顶部公司、外部点击事件
- (IBAction)topButtonClick:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  self.topSelectBtn.selected = NO;
  self.topSelectBtn = sender;
  sender.selected = YES;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.topLine.frame = CGRectMake((SCREEN_WIDTH/2-30)/2+SCREEN_WIDTH/2*sender.tag, 38, 30, 2);
  }];
  [self.tableView.mj_header beginRefreshing];
}

- (void)getTopLine{
  self.topLine = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-30)/2, 38, 30, 2)];
  [self.topView addSubview:self.topLine];
  self.topLine.backgroundColor = CTThemeMainColor;
}
//发表点击事件
- (void)releaseClick:(UIButton *)sender{
  __weak typeof(self) weakSelf = self;
  if (self.textField.text.length>0) {
    if (self.isComment) {
      if (self.textField.text.length>0) {
        CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
        CellLayout* cellLayout = self.dataSource[self.zanIndex];
        [biz discoverScoopCommentWithScoopID:cellLayout.entity.scoopID content:self.textField.text toUid:self.commentEntity.uid success:^(NSString *commetID){
          [weakSelf.textField resignFirstResponder];
          //TODO评论
          SourceCircComments *comment = [[SourceCircComments alloc]init];
          comment.commentType = 1;
          comment.nickname = [ObjectShareTool sharedInstance].currentUser.nickname;
          comment.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
          comment.content = weakSelf.textField.text;
          SourceCircReply *replay = [[SourceCircReply alloc]init];
          replay.nickname = weakSelf.commentEntity.nickname;
          replay.uid = weakSelf.commentEntity.uid;
          comment.reply = replay;
          weakSelf.textField.text = @"";
          [cellLayout.entity.comments addObject:comment];
          CellLayout *layout = [weakSelf layoutWithStatusModel:cellLayout.entity];
          [weakSelf.dataSource replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
          [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } fail:^(NSError *error) {
          
        }];
      }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"请输入评论内容"]show:window];
      }
    }else{
      CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
      CellLayout* cellLayout = self.dataSource[self.zanIndex];
      [biz discoverScoopCommentWithScoopID:cellLayout.entity.scoopID content:self.textField.text toUid:nil success:^(NSString *commetID){
        [weakSelf.textField resignFirstResponder];
        SourceCircComments *comment = [[SourceCircComments alloc]init];
        comment.commentType = 1;
        comment.nickname = [ObjectShareTool sharedInstance].currentUser.nickname;
        comment.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
        comment.content = weakSelf.textField.text;
        weakSelf.textField.text = @"";
        if (cellLayout.entity.comments) {
          [cellLayout.entity.comments addObject:comment];
        }else{
          cellLayout.entity.comments = [NSMutableArray array];
          [cellLayout.entity.comments addObject:comment];
        }
        CellLayout *layout = [weakSelf layoutWithStatusModel:cellLayout.entity];
        [weakSelf.dataSource replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
      } fail:^(NSError *error) {
        
      }];
    }
  }else{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"请输入评论内容"]show:window];
  }
}

- (IBAction)joinOrganizationClick:(UIButton *)sender {
  
}
- (IBAction)hiddEmueClick:(UIButton *)sender {
  self.isMenuOpen = NO;
  [self.menu menuHide];
  [self.textField resignFirstResponder];
  self.BGButton.hidden = YES;
}
@end
