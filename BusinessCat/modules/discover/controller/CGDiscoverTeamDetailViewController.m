//
//  CGDiscoverTeamDetailViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGDiscoverTeamDetailViewController.h"
#import "CGDiscoverBiz.h"
#import "CGSourceCircleEntity.h"
#import "CellLayout.h"
#import "CGSourceCircleTableViewCell.h"
#import "Menu.h"
#import "TeamCircleDao.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "CGExceptionalViewController.h"
#import "CGHeadlineInfoDetailController.h"

@interface CGDiscoverTeamDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, assign) NSInteger zanIndex;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSInteger isComment;
@property (nonatomic, strong) SourceCircComments *commentEntity;
@property (nonatomic,strong) Menu* menu;
@property (nonatomic, assign) NSInteger isMenuOpen;
@property (nonatomic, strong) UIButton *BGButton;
@property (nonatomic, strong) CGSourceCircleEntity *deleteEntity;
@property (nonatomic, strong) CGSourceCircleTableViewCell *deleteCell;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, copy) NSString *scoopID;
@property (nonatomic, copy) CGDiscoverTeamDetailUpdateBlock updateBlock;
@property (nonatomic, copy) CGDiscoverTeamDetailDeleteBlock deleteBlock;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation CGDiscoverTeamDetailViewController

-(instancetype)initWithScoopID:(NSString *)scoopID updateBlock:(CGDiscoverTeamDetailUpdateBlock)updateBlock deleteBlock:(CGDiscoverTeamDetailDeleteBlock)deleteBlock{
  self = [super init];
  if(self){
    self.scoopID = scoopID;
    self.updateBlock = updateBlock;
    self.deleteBlock = deleteBlock;
  }
  return self;
}

-(CGDiscoverBiz *)biz{
  if (!_biz) {
    _biz = [[CGDiscoverBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"详情";
  [self getTextBGView];
  [self.view addSubview:self.menu];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  __weak typeof(self) weakSelf = self;
  [self.biz authDiscoverScoopDetailsDataWithScoopId:self.scoopID success:^(NSMutableArray *result) {
    weakSelf.dataArray = [NSMutableArray array];
    for (int i =0; i<result.count; i++) {
      CGSourceCircleEntity *entity = result[i];
      CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
      [weakSelf.dataArray addObject:layout];
      if (![CTStringUtil stringNotBlank:entity.scoopID]) {
        weakSelf.bgView.hidden = NO;
      }
    }
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:NOTIFICATION_INTEGRALEXCEPTIONALSUCCESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)paySuccess{
  SourcePay *enitity = [[SourcePay alloc]init];
  enitity.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
  enitity.nickname = [ObjectShareTool sharedInstance].currentUser.nickname;
  enitity.portrait = [ObjectShareTool sharedInstance].currentUser.portrait;
  CellLayout *layout = self.dataArray[0];
  if (layout.entity.payList.count<=0) {
    layout.entity.payList = [NSMutableArray arrayWithObjects:enitity, nil];
  }else{
    [layout.entity.payList addObject:enitity];
  }
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.count >= indexPath.row) {
    CellLayout* layout = self.dataArray[indexPath.row];
    return layout.cellHeight;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    CGSourceCircleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[CGSourceCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
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
    
        CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
          
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
  };
}

-(void)deleteTeamCircle:(CGSourceCircleTableViewCell *)cell{
  UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alertview show];
  self.deleteCell = cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    __weak typeof(self) weakSelf = self;
    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
    [biz.component startBlockAnimation];
    [biz discoverScoopDeleteWithScoopID:weakSelf.deleteEntity.scoopID success:^{
      [biz.component stopBlockAnimation];
      [TeamCircleDao deleteTeamCircleToDBWithScoopID:weakSelf.deleteEntity.scoopID];
      weakSelf.deleteBlock(weakSelf.deleteCell.cellLayout);
      [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
      [biz.component stopBlockAnimation];
    }];
  }
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
  browser.isShowPageControl = YES;
  [browser show];
}

//查看头像
- (void)showAvatarWithCell:(CGSourceCircleTableViewCell *)cell {
  //  [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.entity.nickname]];
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
  [self.menu menuHide];
  self.BGButton.hidden = YES;
  self.isComment = NO;
  [self.textField becomeFirstResponder];
}

//打赏
-(void)awardClick{
  [self.menu menuHide];
  CellLayout* cellLayout = self.dataArray[self.zanIndex];
  CGExceptionalViewController *vc = [[CGExceptionalViewController alloc]init];
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
  CellLayout* cellLayout = self.dataArray[self.zanIndex];
  [self.menu menuHide];
  self.BGButton.hidden = YES;
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
    [TeamCircleDao updateTeamCircleWithScoopID:cellLayout.entity.scoopID info:cellLayout.entity];
    [weakSelf.dataArray replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    weakSelf.updateBlock(layout);
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
    weakSelf.textBGView.frame = CGRectMake(weakSelf.textBGView.frame.origin.x, ((self.view.frame.size.height)-weakSelf.textBGView.frame.size.height-height), weakSelf.textBGView.frame.size.width, weakSelf.textBGView.frame.size.height);
  }];
  
  if (self.dataArray.count>0){
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.zanIndex inSection:0];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    float min = (self.view.frame.size.height+44)-height;
    if (min < rectInTableView.origin.y+rectInTableView.size.height) {
      [self.tableView setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-(self.tableView.frame.size.height-height)) animated:YES];
    }else{
      [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    self.BGButton.hidden = NO;
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
        sender.userInteractionEnabled = NO;
        CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
        CellLayout* cellLayout = self.dataArray[self.zanIndex];
        [biz discoverScoopCommentWithScoopID:cellLayout.entity.scoopID content:self.textField.text toUid:self.commentEntity.uid success:^(NSString *commetID){
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
          [TeamCircleDao updateTeamCircleWithScoopID:cellLayout.entity.scoopID info:cellLayout.entity];
          [weakSelf.dataArray replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
          [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
          sender.userInteractionEnabled = YES;
          weakSelf.updateBlock(layout);
        } fail:^(NSError *error) {
          sender.userInteractionEnabled = YES;
        }];
      }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[CTToast makeText:@"请输入评论内容"]show:window];
      }
    }else{
      CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
      CellLayout* cellLayout = self.dataArray[self.zanIndex];
      sender.userInteractionEnabled = NO;
      [biz discoverScoopCommentWithScoopID:cellLayout.entity.scoopID content:self.textField.text toUid:nil success:^(NSString *commetID){
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
        [TeamCircleDao updateTeamCircleWithScoopID:cellLayout.entity.scoopID info:cellLayout.entity];
        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        sender.userInteractionEnabled = YES;
        weakSelf.updateBlock(layout);
      } fail:^(NSError *error) {
        sender.userInteractionEnabled = YES;
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

@end
