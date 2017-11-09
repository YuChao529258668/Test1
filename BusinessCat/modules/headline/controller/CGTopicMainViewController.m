//
//  CGTopicMainViewController.m
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTopicMainViewController.h"
#import "HeadlineTopicCell.h"
#import "CGCommentView.h"
#import "HeadlineBiz.h"
#import "ShareUtil.h"
#import "CGMainLoginViewController.h"
#import "HeadLineDao.h"
#import "CGTopicCommentController.h"
#import "WKWebViewController.h"
#import "CGDiscoverLink.h"
#import "CGDiscoverReleaseSourceViewController.h"
#import "ObjectShareTool.h"
#import "HeadlineDetailLoadingView.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"
#import "CGUserOrganizaJoinEntity.h"
#import "KxMenu.h"

#define HeadlineTopicCellIdentifier @"HeadlineTopicCell"

#define TOPICTOPBARHEIGHT 125
#define OTHERTOPBARHEIGHT 60

@interface CGTopicMainViewController ()<CGTopicToolBarDelegate,HeadlineTopicCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UILabel *companyCount;
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *delTopicBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic,retain)HeadlineDetailLoadingView *rightBtn;

@property(nonatomic,retain)HeadlineBiz *biz;
@property (weak, nonatomic) IBOutlet UILabel *topicContent;
@property (weak, nonatomic) IBOutlet UIView *empty;

@property(nonatomic,retain)NSString *inputStr;

@property(nonatomic,retain)ShareUtil *shareUtil;

@property(nonatomic,retain)NSMutableArray *topicArray;

@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
@property(nonatomic,assign)BOOL statusBarHidden;
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIView *giveView;
@property (weak, nonatomic) IBOutlet UILabel *giveLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconX;
@property (weak, nonatomic) IBOutlet UIView *zanBgView;

@end

@implementation CGTopicMainViewController


-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

-(void)viewDidAppear:(BOOL)animated{
  [self.tableview reloadData];
}

-(HeadlineBiz *)biz{
  if(!_biz){
    _biz = [[HeadlineBiz alloc]init];
  }
  return _biz;
}

-(NSMutableArray *)topicArray{
  if(!_topicArray){
    _topicArray = [NSMutableArray array];
  }
  return _topicArray;
}

-(instancetype)initWithDetail:(CGInfoDetailEntity *)detail{
  self = [super init];
  if(self){
    self.detail = detail;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideCustomNavi];
  self.view.backgroundColor = [UIColor whiteColor];
  self.line.backgroundColor = CTCommonLineBg;
  self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableview registerNib:[UINib nibWithNibName:HeadlineTopicCellIdentifier bundle:nil] forCellReuseIdentifier:HeadlineTopicCellIdentifier];
  self.toolbar.delegate = self;
  self.back.backgroundColor = [CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor];
  [self topicTableViewRefresh];
  [self loadDataFirst];
  self.zanView.layer.borderWidth = 0.5;
  self.zanView.layer.borderColor = CTThemeMainColor.CGColor;
  self.giveView.layer.borderWidth = 0.5;
  self.giveView.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#EC4836"].CGColor;
  [self.toolbar updateToolBar:self.detail isDetail:NO comment:nil];
}

-(void)loadDataFirst{
  [self loadDataByMode:0 firstLoad:YES];
}

//查询话题信息
-(void)queryInfoDetailStateByIdThenLoadComment:(BOOL)load{
  __weak typeof(self) weakSelf = self;
  [self.biz queryInfoDetailStateById:self.detail.infoId type:self.detail.type success:^(CGTopicEntity *detailState) {
    if(!weakSelf.detail){
      weakSelf.detail = [[CGInfoDetailEntity alloc]init];
    }else{
    }
    [weakSelf loadDataByMode:0 firstLoad:YES];
  } fail:^(NSError *error) {
    
  }];
}

-(void)topicTableViewRefresh{
  //上拉加载更多
  __weak typeof(self) weakSelf = self;
  self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    [weakSelf loadDataByMode:1 firstLoad:NO];
  }];
}

//加载数据
-(void)loadDataByMode:(int)mode firstLoad:(BOOL)firstLoad{
  if(firstLoad){
    [self.biz.component startBlockAnimation];
  }
  long time = 0;
  if (mode == 1){//上拉加载更多
    if(self.topicArray.count > 0){
      CGCommentEntity *last = self.topicArray[self.topicArray.count-1];
      time = last.time;
    }
  }
  __weak typeof(self) weakSelf = self;
  [self.biz queryHeadlineTopicListWithInfoId:self.detail.infoId mode:mode type:self.detail.type time:time success:^(NSMutableArray *result) {
    [weakSelf.biz.component stopBlockAnimation];
    [weakSelf.tableview.mj_footer endRefreshing];
    
    if(mode == 0){
      weakSelf.topicArray = result;
    }else if(mode == 1){
      if(result && result.count > 0){
        [weakSelf.topicArray addObjectsFromArray:result];
      }
    }
    if (weakSelf.topicArray.count>0) {
      self.empty.hidden = YES;
    }else{
      self.empty.hidden = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableview reloadData];
    });
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
    [weakSelf.tableview.mj_footer endRefreshing];
    if(error.code == 110113){//未登录
      CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
        [weakSelf loadDataFirst];
      } fail:^(NSError *error) {
        
      }];
      [weakSelf.navigationController pushViewController:controller animated:YES];
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf presentViewController:controller animated:YES completion:nil];
//      });
    }
  }];
}

//打开评论界面
-(void)openCommentView{
  NSString *placeholder = nil;
  placeholder = @"优质评论将会被优先展示";
  __weak typeof(self) weakSelf = self;
  CGCommentView *comment = [[CGCommentView alloc]initWithContent:self.inputStr placeholder:placeholder finish:^(NSString *data) {
    weakSelf.inputStr = data;
    if(![CTStringUtil stringNotBlank:weakSelf.inputStr]){
      [[CTToast makeText:@"请输入内容"]show:weakSelf.view];
      return;
    }
    [weakSelf postComment];
  } cancel:^(NSString *data) {
    weakSelf.inputStr = data;
  }];
  [comment showInView:self.view];
}

-(void)postComment{
  __weak typeof(self) weakSelf = self;
  [self.biz.component startBlockAnimation];
  [self.biz postTopicCommentWithContent:self.inputStr infoId:self.detail.infoId type:self.detail.type success:^(CGCommentEntity *coment) {
    [weakSelf.biz.component stopBlockAnimation];
    weakSelf.inputStr = @"";
    self.empty.hidden = YES;
    [[CTToast makeText:@"评论成功"]show:weakSelf.view];
    [weakSelf.topicArray insertObject:coment atIndex:0];
    [weakSelf.tableview reloadData];
    
  } fail:^(NSError *error){
    [weakSelf.biz.component stopBlockAnimation];
    if(error.code == 110113){//未登录
      CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
        [weakSelf loadDataFirst];
      } fail:^(NSError *error) {
        
      }];
      [weakSelf.navigationController pushViewController:controller animated:YES];
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf presentViewController:controller animated:YES completion:nil];
//      });
    }
  }];
}

#pragma mark UITableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.topicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  float height = 55+10;
  CGCommentEntity *entity = self.topicArray[indexPath.row];
  CGRect contentRect = [entity.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
  height += contentRect.size.height;
  if(![CTStringUtil stringNotBlank:entity.replyData.uid]){
    return height;
  }else{
    CGRect replyContentRect = [entity.replyData.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    return height+70+replyContentRect.size.height;
  }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  HeadlineTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:HeadlineTopicCellIdentifier];
  cell.delegate = self;
  CGCommentEntity *entity = self.topicArray[indexPath.row];
  [cell updateItem:entity];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  CGCommentEntity *comment = self.topicArray[indexPath.row];
  CGTopicCommentController *controller = [[CGTopicCommentController alloc]initWithComment:comment detail:self.detail showCommentView:NO];
  [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tuiAction:(id)sender {
  if ([CTStringUtil stringNotBlank:self.inputStr]) {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你有内容未发表，是否关闭？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
  }else{
    [super baseBackAction];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    [super baseBackAction];
  }
}

//点击空提示
- (IBAction)emptyAction:(id)sender {
  [self openCommentView];
}

//删除话题
- (IBAction)delAction:(id)sender {
  
}


#pragma ToobarDelegate

//弹出评论界面
-(void)detailToolbarOpenTopicCommentAction{
  if(!self.detail){
    return;
  }
  [self openCommentView];
}

//爆料
-(void)detailToolbarScoopAction{
  [self toTeamCircleAction];
//  NSArray *menuItems =
//  @[[KxMenuItem menuItem:@"发到邮箱"
//                   image:[UIImage imageNamed:@"mailbox"]
//                  target:self
//                  action:@selector(toEmailAction)],
//    [KxMenuItem menuItem:@"发到企业圈"
//                   image:[UIImage imageNamed:@"sentto_tuanduiquan"]
//                  target:self
//                  action:@selector(toTeamCircleAction)],
//    [KxMenuItem menuItem:@"分享到"
//                        image:[UIImage imageNamed:@"gw_fxshare"]
//                       target:self
//                       action:@selector(detailToolbarShareAction)]];
//  
//  CGRect fromRect = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-40, 24,24);
//  //  CGRect toRect = [sender convertRect:fromRect toView:self.view];
//  [KxMenu showMenuInView:self.view
//                fromRect:fromRect
//               menuItems:menuItems];
}

//发送到邮箱
-(void)toEmailAction{
  
}

//发送到企业圈
-(void)toTeamCircleAction{
  NSUserDefaults *fact = [NSUserDefaults standardUserDefaults];
  [fact setObject:@YES forKey:@"fact"];
  self.toolbar.fact.hidden = YES;
  CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
    if (isOutside == NO) {
      if (isCurrent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:0]];
      }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:reloadIndex]];
      }
    }
  }];
  if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
    CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[0];
    CGHorrolEntity *entity;
    if (companyEntity.companyType == 2) {
      entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
    }else{
      entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
    }
    entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
    vc.currentEntity = entity;
    vc.releaseType = DiscoverReleaseTypeCompany;
  }else{
    vc.releaseType = DiscoverReleaseTypeNoCompany;
  }
  
  CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
  link.linkIcon = self.detail.infoPic;
  link.linkId = self.detail.infoId;
  link.linkTitle = self.detail.title;
  link.linkType = self.detail.type;
  vc.link = link;
  if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
    vc.releaseType = HeadlineReleaseTypeCompany;
  }else{
    vc.releaseType = HeadlineReleaseTypeNoCompany;
  }
  [self.navigationController pushViewController:vc animated:YES];
}

//赏
-(void)detailToolbarEnjoyAction{
  
}

//收藏
-(void)detailToolBarCollectAction{
  if(![CTStringUtil stringNotBlank:self.detail.infoId]){
    return;
  }
  int collect = 1;
  if(self.detail.isFollow == 0){
    collect = 1;
  }else{
    collect = 0;
  }
  [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_isFollow value:[NSString stringWithFormat:@"%d",collect] infoId:self.info.infoId table:HeadlineInfo_tableName];
  [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_isFollow value:[NSString stringWithFormat:@"%d",collect] infoId:self.detail.infoId table:HeadlineInfoDetail_tableName];
  self.detail.isFollow = self.detail.isFollow == 0 ? 1 : 0;
  self.info.isFollow = collect;
  [self.toolbar updateToolBar:self.detail isDetail:NO comment:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
  self.biz = [[HeadlineBiz alloc]init];
  [self.biz collectWithId:self.detail.infoId type:self.detail.type collect:collect success:^{
  } fail:^(NSError *error) {
  }];
}

//赞数
-(void)detailToolbarCommentTypeAction{
  
}
//分享
-(void)detailToolbarShareAction{
  if(!self.detail){
    return;
  }
  NSUserDefaults *share = [NSUserDefaults standardUserDefaults];
  [share setObject:@YES forKey:@"share"];
  self.toolbar.share.hidden = YES;
  NSString *url = [NSString stringWithFormat:@"%@#/headlines/content?id=%@&type=%d",URL_H5,self.detail.infoId,self.detail.type];
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  [self.shareUtil showShareMenuWithTitle:self.detail.title desc:self.detail.title isqrcode:1 image:[UIImage imageNamed:@"login_image"] url:url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}
//文档
-(void)detailToolbarDocumentAction{
  
}

-(void)openTopicMainControllerAction{
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark HeadlineTopicCellDelegate

-(void)callbackToTopicCommentController:(HeadlineTopicCell *)cell{
  NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
  CGCommentEntity *comment = self.topicArray[indexPath.row];
  CGTopicCommentController *controller = [[CGTopicCommentController alloc]initWithComment:comment detail:self.detail showCommentView:YES];
  [self.navigationController pushViewController:controller animated:YES];
}

-(void)callbackToDeleteController:(HeadlineTopicCell *)cell{
  NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
  CGCommentEntity *comment = self.topicArray[indexPath.row];
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz authHeadlinesTopicCommentDeleteWithCommentId:comment.commentId success:^{
    [weakSelf.biz.component stopBlockAnimation];
    [weakSelf.topicArray removeObjectAtIndex:indexPath.row];
    [weakSelf.tableview reloadData];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [[CTToast makeText:[error.userInfo objectForKey:@"message"]]show:window];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:YES];
  [self.biz.component stopBlockAnimation];
}

- (IBAction)zanClick:(UIButton *)sender {
  
}

- (IBAction)giveClick:(UIButton *)sender {
}

@end
