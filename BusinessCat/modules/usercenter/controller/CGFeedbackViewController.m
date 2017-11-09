//
//  CGFeedbackViewController.m
//  CGSays
//
//  Created by zhu on 2017/4/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGFeedbackViewController.h"
#import "CGSourceCircleTableViewCell.h"
#import "CGDiscoverCircleNullTableViewCell.h"
#import "CGUserDao.h"
#import "Menu.h"
#import "CGDiscoverBiz.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "CGExceptionalViewController.h"
#import "CGUserCenterBiz.h"
#import "CGFeedbackReleaseViewController.h"
#import "DiscoverPushView.h"
#import "CGHeadlineInfoDetailController.h"
#import "CommonWebViewController.h"
#import "CGUserHelpCatePageViewController.h"
#import "CGEnterpriseMemberViewController.h"

@interface CGFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger isFirst;
@property (nonatomic, assign) NSInteger zanIndex;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSInteger isComment;
@property (nonatomic, strong) SourceCircComments *commentEntity;
@property (nonatomic, strong) CGSourceCircleEntity *deleteEntity;
@property (weak, nonatomic) IBOutlet UIButton *BGButton;
@property (nonatomic, strong) CGSourceCircleTableViewCell *deleteCell;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *cebianBtn;
@property (nonatomic, strong) FeedbackInfoEntity *infoEntity;

@end

@implementation CGFeedbackViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"管家服务";
  self.biz = [[CGUserCenterBiz alloc]init];
  self.tableView.separatorStyle = NO;
  [self getTextBGView];
  self.isFirst = YES;
  self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf getLastListData];
  }];
  //上拉加载更多
  self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSInteger time = (NSInteger)[datenow timeIntervalSince1970];
    if (weakSelf.dataArray.count>0) {
      CellLayout *layout = [weakSelf.dataArray lastObject];
      time = layout.entity.time;
    }
    [self.biz userFeedbackListWithTime:time mode:1 success:^(NSMutableArray *reslut) {
      for (int i =0; i<reslut.count; i++) {
        CGSourceCircleEntity *entity = reslut[i];
        CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
        [weakSelf.dataArray addObject:layout];
      }
      if (reslut.count == 0) {
        weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
      }
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_footer endRefreshing];
    }];
  }];
  [self.tableView.mj_header beginRefreshing];
  
  [self.biz userFeedbackGetInfoWithType:self.type success:^(FeedbackInfoEntity *reslut) {
    weakSelf.infoEntity = reslut;
    if (weakSelf.infoEntity.housekeeper) {
      [weakSelf getPublished];
    }
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
  self.cebianBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  self.cebianBtn.contentMode = UIViewContentModeScaleToFill;
  [self.cebianBtn addTarget:self action:@selector(cebianAction) forControlEvents:UIControlEventTouchUpInside];
  [self.cebianBtn setImage:[UIImage imageNamed:@"protocol"] forState:UIControlStateNormal];
  [self.navi addSubview:self.cebianBtn];
}

-(void)getPublished{
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f-40, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
  self.rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.navi addSubview:self.rightBtn];
}

-(void)refresh{
  [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.textField resignFirstResponder];
  [ [NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [ [NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)cebianAction{
  CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
  vc.pageId = self.type == 1?@"a22c9bd3-1290-a89c-d74c-e174c9a55fae":@"f22d19f8-a664-47c9-d47e-11a13d17f120";
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightBtnAction{
  __weak typeof(self) weakSelf = self;
  CGFeedbackReleaseViewController *vc = [[CGFeedbackReleaseViewController alloc]initWithBlock:^(NSString *success) {
    [weakSelf.tableView.mj_header beginRefreshing];
  }];
  vc.level = 1;
  [self.navigationController pushViewController:vc animated:YES];
}

//获取最新列表数据
-(void)getLastListData{
  __weak typeof(self) weakSelf = self;
  NSDate *datenow = [NSDate date];
  [self.biz userFeedbackListWithTime:[datenow timeIntervalSince1970] mode:0 success:^(NSMutableArray *reslut) {
    weakSelf.isFirst = NO;
    weakSelf.dataArray = [NSMutableArray array];
    for (int i =0; i<reslut.count; i++) {
      CGSourceCircleEntity *entity = reslut[i];
      CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
      [weakSelf.dataArray addObject:layout];
    }
    [weakSelf.tableView.mj_header endRefreshing];
    weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    weakSelf.isFirst = NO;
    [weakSelf.tableView reloadData];
    [weakSelf.tableView.mj_header endRefreshing];
  }];
}

- (IBAction)hiddEmueClick:(UIButton *)sender {
  [self.textField resignFirstResponder];
  self.BGButton.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData) {
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

-(void)buyVipAction{
  CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
  vc.type = self.type;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isFirst == YES&&self.dataArray.count==0) {
    return 0;
  }
  
  if (self.dataArray.count<=0) {
    return 1;
  }
  return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (self.dataArray.count>0&&section == 0&&[CTStringUtil stringNotBlank:self.infoEntity.content]) {
    CGFloat height = [CTStringUtil heightWithFont:15 width:SCREEN_WIDTH-30 str:self.infoEntity.content];
    if (self.infoEntity.housekeeper == NO) {
    return 15+height+10+30+40;
    }else{
     return 15+height+10+30;
    }
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if (self.dataArray.count>0&&section == 0&&[CTStringUtil stringNotBlank:self.infoEntity.content]){
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 60)];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.infoEntity.content;
    CGFloat height = [CTStringUtil heightWithFont:15 width:SCREEN_WIDTH-30 str:label.text];
    label.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, height);
    label.numberOfLines = 0;
    label.textColor = [UIColor darkGrayColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y+10, SCREEN_WIDTH, 0)];
    if (self.infoEntity.housekeeper == NO) {
      btn.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, SCREEN_WIDTH, 40);
      [view addSubview:btn];
      [btn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
      [btn setTitle:self.type == 1?@"开通管家企业":@"开通管家会员" forState:UIControlStateNormal];
      btn.titleLabel.font = [UIFont systemFontOfSize:15];
      [btn addTarget:self action:@selector(buyVipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, btn.frame.origin.y+btn.frame.size.height, SCREEN_WIDTH-30, 20)];
    bgView.backgroundColor = CTCommonViewControllerBg;
    [view addSubview:bgView];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, bgView.frame.size.width-20, 20)];
    [bgView addSubview:textLabel];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = @"服务历史";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:13];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, textLabel.frame.size.height+textLabel.frame.origin.y+10);
    return view;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.count<=0){
    return SCREEN_HEIGHT-64;
  }else if (self.dataArray.count >= indexPath.row) {
    CellLayout* layout = self.dataArray[indexPath.row];
    return layout.cellHeight;
  }
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.count<=0) {
    NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
    CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
  CellLayout* cellLayout = self.dataArray[indexPath.row];
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
    weakSelf.BGButton.hidden = YES;
    weakSelf.isComment = NO;
    weakSelf.zanIndex = [weakSelf.tableView indexPathForCell:cell].row;
    [weakSelf.textField becomeFirstResponder];
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
    if (link.linkType == 15) {
      CommonWebViewController *vc = [[CommonWebViewController alloc]init];
      vc.url = link.linkIcon;
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }else{
      CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
        
      }];
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }
  };
}

-(void)deleteTeamCircle:(CGSourceCircleTableViewCell *)cell{
  UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
  [alertview show];
  self.deleteCell = cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    //删除反馈
    __weak typeof(self) weakSelf = self;
    [self.biz.component startBlockAnimation];
    [self.biz userFeedbackDeleteWithID:weakSelf.deleteEntity.scoopID success:^{
      [weakSelf.biz.component stopBlockAnimation];
      [weakSelf.dataArray removeObjectAtIndex:[weakSelf.tableView indexPathForCell:weakSelf.deleteCell].row];
      if (weakSelf.dataArray.count>=1) {
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[weakSelf.tableView indexPathForCell:weakSelf.deleteCell], nil] withRowAnimation:UITableViewRowAnimationFade];
      }else{
        [weakSelf.tableView reloadData];
      }
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }
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

}


//展开Cell
- (void)openTableViewCell:(CGSourceCircleTableViewCell *)cell {
  CellLayout* layout =  [self.dataArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
  CGSourceCircleEntity* model = layout.entity;
  CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:YES dateFormatter:self.dateFormatter];
  [self.dataArray replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(CGSourceCircleTableViewCell *)cell {
  CellLayout* layout =  [self.dataArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
  CGSourceCircleEntity* model = layout.entity;
  CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:NO dateFormatter:self.dateFormatter];
  
  [self.dataArray replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
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
  self.BGButton.hidden = YES;
  self.isComment = NO;
  [self.textField becomeFirstResponder];
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
    [self.tableView setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-(self.tableView.frame.size.height-height-50)) animated:YES];
  }else{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
  }
}

-(void)keyboardHidden:(NSNotification*)info{ //键盘收回；
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    weakSelf.textBGView.frame = CGRectMake(weakSelf.textBGView.frame.origin.x, SCREEN_HEIGHT, weakSelf.textBGView.frame.size.width, weakSelf.textBGView.frame.size.height);
  }];
  self.BGButton.hidden = YES;
}

//发表点击事件
- (void)releaseClick:(UIButton *)sender{
  __weak typeof(self) weakSelf = self;
  if (self.textField.text.length>0) {
    if (self.isComment) {
      if (self.textField.text.length>0) {
        CellLayout* cellLayout = self.dataArray[self.zanIndex];
        [self.biz userFeedbackCommentWithID:cellLayout.entity.scoopID content:self.textField.text toUid:self.commentEntity.uid success:^(NSString *commentID) {
          [weakSelf.textField resignFirstResponder];
          //TODO评论
          SourceCircComments *comment = [[SourceCircComments alloc]init];
          comment.commentType = 1;
          comment.nickname = [ObjectShareTool sharedInstance].currentUser.username;
          comment.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
          comment.content = weakSelf.textField.text;
          SourceCircReply *replay = [[SourceCircReply alloc]init];
          replay.nickname = weakSelf.commentEntity.nickname;
          replay.uid = weakSelf.commentEntity.uid;
          comment.reply = replay;
          weakSelf.textField.text = @"";
          [cellLayout.entity.comments addObject:comment];
          CellLayout *layout = [weakSelf layoutWithStatusModel:cellLayout.entity];
          [weakSelf.dataArray replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
          [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } fail:^(NSError *error) {
          
        }];
      }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"请输入评论内容"]show:window];
      }
    }else{
      CellLayout* cellLayout = self.dataArray[self.zanIndex];
      [self.biz userFeedbackCommentWithID:cellLayout.entity.scoopID content:self.textField.text toUid:nil success:^(NSString *commentID) {
        [weakSelf.textField resignFirstResponder];
        SourceCircComments *comment = [[SourceCircComments alloc]init];
        comment.commentType = 1;
        comment.nickname = [ObjectShareTool sharedInstance].currentUser.username;
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
        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
      } fail:^(NSError *error) {
        
      }];
    }
  }else{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"请输入评论内容"]show:window];
  }
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
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
