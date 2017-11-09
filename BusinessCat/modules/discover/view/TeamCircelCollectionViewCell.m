//
//  TeamCircelCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircelCollectionViewCell.h"
#import "CGSourceCircleTableViewCell.h"
#import "CGDiscoverCircleNullTableViewCell.h"
#import "CGUserDao.h"
#import "Menu.h"
#import "CGDiscoverBiz.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "CGExceptionalViewController.h"
#import "TeamCircleDao.h"
#import "TeamCircleHeadView.h"

@interface TeamCircelCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger zanIndex;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSInteger isComment;
@property (nonatomic, strong) SourceCircComments *commentEntity;
@property (nonatomic,strong) Menu* menu;
@property (nonatomic, assign) NSInteger isMenuOpen;
@property (nonatomic, strong) CGSourceCircleEntity *deleteEntity;
@property (nonatomic, copy) TeamCircelCollectionViewBlock block;
@property (nonatomic, copy) TeamCircelCollectionViewLinkBlock linkBlock;
@property (nonatomic, strong) CGSourceCircleTableViewCell *deleteCell;
@property (nonatomic, copy) TeamCircelCollectionViewDidSelectBlock didSelectBlock;
@property(nonatomic,copy)TeamCircelCollectionViewCellToMessageBlock toMsgBlock;
@property(nonatomic,retain)TeamCircleHeadView *headerView;

@end

@implementation TeamCircelCollectionViewCell

-(UIView *)headerView{
    if(!_headerView){
        __weak typeof(self) weakSelf = self;
        _headerView = [[TeamCircleHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPIMAGEHEIGHT+10) block:^(TeamCircleCompanyState *entity) {
            [weakSelf.tableView reloadData];
            if(weakSelf.toMsgBlock){
                weakSelf.toMsgBlock(entity.companyId, entity.companyType);
            }
        }];
    }
    return _headerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self getTextBGView];
    self.isFirst = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationDiscoverHasLastData:) name:NotificationDiscoverHasLastData object:nil];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.menu];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TeamCircleLastStateEntity *state = [TeamCircleLastStateEntity getFromLocal];
        TeamCircleCompanyState *companyState = [state getCompanyStateById:weakSelf.entity.rolId companyType:[weakSelf.entity.rolType intValue]];
        [weakSelf.headerView updateHeadView:companyState cover:weakSelf.entity.icon];
        [weakSelf getLastListData];
      weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
    }];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSInteger time = (NSInteger)[datenow timeIntervalSince1970];
        if (weakSelf.entity.data.count>0) {
            CellLayout *layout = [weakSelf.entity.data lastObject];
            time = layout.entity.time;
        }
        CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
        [biz discoverScoopListWithType:1 time:time mode:1 companyId:weakSelf.entity.rolId companyType:weakSelf.entity.rolType.integerValue success:^(NSMutableArray *result) {
            for (int i =0; i<result.count; i++) {
                CGSourceCircleEntity *entity = result[i];
                CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
                [weakSelf.entity.data addObject:layout];
            }
            if (result.count == 0) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView reloadData];
        } fail:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)notificationDiscoverHasLastData:(NSNotification *)notification{
    TeamCircleLastStateEntity *entity = notification.object;
    TeamCircleCompanyState *companyState = [entity getCompanyStateById:self.entity.rolId companyType:[self.entity.rolType intValue]];
    [self.headerView updateHeadView:companyState cover:self.entity.icon];
    [self.tableView reloadData];
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

//获取最新列表数据
-(void)getLastListData{
    __weak typeof(self) weakSelf = self;
//    self.entity.data = [NSMutableArray array];
    NSDate *datenow = [NSDate date];
    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
    [biz discoverScoopListWithType:1 time:(NSInteger)[datenow timeIntervalSince1970] mode:0 companyId:weakSelf.entity.rolId companyType:weakSelf.entity.rolType.integerValue success:^(NSMutableArray *result) {
        weakSelf.isFirst = NO;
        weakSelf.entity.data = [NSMutableArray array];
        for (int i =0; i<result.count; i++) {
            CGSourceCircleEntity *entity = result[i];
            CellLayout *layout = [weakSelf layoutWithStatusModel:entity];
            [weakSelf.entity.data addObject:layout];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        weakSelf.isFirst = NO;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData) {
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity block:(TeamCircelCollectionViewBlock)block linkBlock:(TeamCircelCollectionViewLinkBlock)linkBlock didSelectBlock:(TeamCircelCollectionViewDidSelectBlock)didSelectBlock toMsgBlock:(TeamCircelCollectionViewCellToMessageBlock)toMsgBlock{
    self.block = block;
    self.linkBlock = linkBlock;
    self.didSelectBlock = didSelectBlock;
    self.toMsgBlock = toMsgBlock;
    self.entity = entity;
//  self.isFirst = YES;
    TeamCircleLastStateEntity *state = [TeamCircleLastStateEntity getFromLocal];
    TeamCircleCompanyState *companyState = [state getCompanyStateById:self.entity.rolId companyType:[self.entity.rolType intValue]];
    [self.headerView updateHeadView:companyState cover:self.entity.icon];
    __weak typeof(self) weakSelf = self;
    if (self.entity.data.count<=0) {
        [TeamCircleDao queryMonitorinListFromDBWithOrganizationID:entity.rolId success:^(NSMutableArray *result) {
            weakSelf.entity.data = result;
            [weakSelf.tableView reloadData];
            [weakSelf getLastListData];
        } fail:^(NSError *error) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }else{
        [self.tableView reloadData];
    }
}



- (void)updateUIWithEntity:(CGHorrolEntity *)entity{
    self.entity = entity;
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)hiddEmueClick:(UIButton *)sender {
    self.isMenuOpen = NO;
    [self.menu menuHide];
    [self.textField resignFirstResponder];
    self.BGButton.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isFirst == YES) {
    return 0;
  }else{
    if (self.entity.data.count<=0) {
      return 1;
    }else{
      return self.entity.data.count;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.entity.data.count<=0){
        return SCREEN_HEIGHT-64-50-140;
    }else if (self.entity.data.count >= indexPath.row) {
        CellLayout* layout = self.entity.data[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.entity.data.count<=0) {
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
    CellLayout* cellLayout = self.entity.data[indexPath.row];
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
        weakSelf.linkBlock(link.linkId,link.linkType);
        //    CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType];
        //    [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.entity.data && self.entity.data.count > indexPath.row){
        CellLayout* cellLayout = self.entity.data[indexPath.row];
        self.didSelectBlock(indexPath.row,cellLayout.entity);
    }
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
            [weakSelf.entity.data removeObjectAtIndex:[weakSelf.tableView indexPathForCell:weakSelf.deleteCell].row];
            if (weakSelf.entity.data.count>0) {
                [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[weakSelf.tableView indexPathForCell:weakSelf.deleteCell], nil] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [weakSelf.tableView reloadData];
            }
        } fail:^(NSError *error) {
            [biz.component stopBlockAnimation];
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
    browser.isShowPageControl = YES;
    [browser show];
}

//查看头像
- (void)showAvatarWithCell:(CGSourceCircleTableViewCell *)cell {
    //  [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.entity.nickname]];
}


//展开Cell
- (void)openTableViewCell:(CGSourceCircleTableViewCell *)cell {
    CellLayout* layout =  [self.entity.data objectAtIndex:[self.tableView indexPathForCell:cell].row];
    CGSourceCircleEntity* model = layout.entity;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:YES dateFormatter:self.dateFormatter];
    [self.entity.data replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(CGSourceCircleTableViewCell *)cell {
    CellLayout* layout =  [self.entity.data objectAtIndex:[self.tableView indexPathForCell:cell].row];
    CGSourceCircleEntity* model = layout.entity;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model isUnfold:NO dateFormatter:self.dateFormatter];
    
    [self.entity.data replaceObjectAtIndex:[self.tableView indexPathForCell:cell].row withObject:newLayout];
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
    CellLayout* cellLayout = self.entity.data[self.zanIndex];
    self.block(self.zanIndex,cellLayout.entity);
}

//点赞
- (void)didclickedLikeButton:(LikeButton *)likeButton {
    __weak typeof(self) weakSelf = self;
    CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
    CellLayout* cellLayout = self.entity.data[self.zanIndex];
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
        [weakSelf.entity.data replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
        weakSelf.textBGView.frame = CGRectMake(weakSelf.textBGView.frame.origin.x, ((self.frame.size.height)-weakSelf.textBGView.frame.size.height-height), weakSelf.textBGView.frame.size.width, weakSelf.textBGView.frame.size.height);
    }];
    
    if (self.entity.data.count>0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.zanIndex inSection:0];
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
        float min = (self.frame.size.height+44)-height;
        if (min < rectInTableView.origin.y+rectInTableView.size.height) {
            [self.tableView setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-(self.tableView.frame.size.height-44-height)) animated:YES];
        }else{
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        self.BGButton.hidden = NO;
    }
}

-(void)keyboardHidden:(NSNotification*)info{ //键盘收回；
    __weak typeof(self) weakSelf = self;
    if (self.tableView.contentOffset.y+self.tableView.frame.size.height>self.tableView.contentSize.height) {
        if (self.tableView.contentSize.height - self.tableView.bounds.size.height>0) {
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height);
        }
    }
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
                CellLayout* cellLayout = self.entity.data[self.zanIndex];
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
                    [weakSelf.entity.data replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    sender.userInteractionEnabled = YES;
                } fail:^(NSError *error) {
                    sender.userInteractionEnabled = YES;
                }];
            }else{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [[CTToast makeText:@"请输入评论内容"]show:window];
            }
        }else{
            CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
            CellLayout* cellLayout = self.entity.data[self.zanIndex];
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
                [weakSelf.entity.data replaceObjectAtIndex:weakSelf.zanIndex withObject:layout];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.zanIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                sender.userInteractionEnabled = YES;
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
    [self addSubview:self.textBGView];
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
