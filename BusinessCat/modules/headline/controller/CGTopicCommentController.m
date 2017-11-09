//
//  CGTopicCommentController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTopicCommentController.h"
#import "CGCommentEntity.h"
#import "HeadlineTopicReplyCell.h"
#import "CGTopicToolBar.h"
#import "CGCommentView.h"
#import "HeadlineBiz.h"
#import "ShareUtil.h"
#import <MJRefresh.h>
#define identifier @"HeadlineTopicReplyCell"
#import "CGDiscoverLink.h"
#import "CGDiscoverReleaseSourceViewController.h"
#import "HeadlineTopicMyReplyCell.h"
#define identifierMy @"HeadlineTopicMyReplyCell"
#import "CGMainLoginViewController.h"
@interface CGTopicCommentController ()<CGTopicToolBarDelegate,HeadlineTopicReplyCellDelegate,HeadlineTopicMyReplyCellDelegate>

@property(nonatomic,retain)HeadlineBiz *biz;
@property(nonatomic,retain)NSString *inputStr;
@property(nonatomic,retain)CGCommentEntity *comment;
@property(nonatomic,retain)CGCommentEntity *clickSubComment;//点击某条评论进行评论
@property(nonatomic,retain)CGInfoDetailEntity *detail;
@property(nonatomic,retain)ShareUtil *shareUtil;

@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,assign)BOOL showCommentView;//进入是否打开评论输入框

@property (weak, nonatomic) IBOutlet CGTopicToolBar *toolbar;
@end

@implementation CGTopicCommentController
-(NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}

-(HeadlineBiz *)biz{
    if(!_biz){
        _biz = [[HeadlineBiz alloc]init];
    }
    return _biz;
}

-(instancetype)initWithComment:(CGCommentEntity *)comment detail:(CGInfoDetailEntity *)detail showCommentView:(BOOL)showCommentView{
    self = [super init];
    if(self){
        self.showCommentView = showCommentView;
        self.detail = detail;
        self.comment = comment;
    }
    return self;
}

- (void)viewDidLoad {
    self.title = @"详情";
    [super viewDidLoad];
    self.toolbar.delegate = self;
    self.navi.backgroundColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"headline_detail_back"] forState:UIControlStateNormal];
    self.titleView.textColor = [UIColor blackColor];
    [self.tableview registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
  [self.tableview registerNib:[UINib nibWithNibName:identifierMy bundle:nil] forCellReuseIdentifier:identifierMy];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = CTCommonViewControllerBg;
    [self updateView];
    [self topicTableViewRefresh];
    [self loadDataFirst:YES];
    if(self.showCommentView){
        [self openCommentView];
    }
}

-(void)baseBackAction{
  if ([CTStringUtil stringNotBlank:self.inputStr]) {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你有内容未发表，是否关闭？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
  }else{
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = CTCommonViewControllerBg;
    label.font = [UIFont systemFontOfSize:16];
    if(section == 1 && self.array.count > 0){
        label.text = @"    全部评论";
    }else{
        label.text = @"";
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 40;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCommentEntity *item;
    if(indexPath.section == 0){
        item = self.comment;
    }else{
        item = self.array[indexPath.row];
    }
    if(item){
        NSString *text = item.content;
        if([CTStringUtil stringNotBlank:item.replyData.uid] && [item.replyData.uid rangeOfString:@"null"].location == NSNotFound && indexPath.section != 0){
            text = [NSString stringWithFormat:@"%@//@%@:%@",item.content,item.replyData.userName,item.replyData.content];
        }
    
        CGRect contentRect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
      if (indexPath.section == 0) {
        return 70 + contentRect.size.height+15;
      }
        return 70 + contentRect.size.height;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    HeadlineTopicMyReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMy];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
      cell.contentView.backgroundColor = [UIColor whiteColor];
      [cell updateItem:self.comment parent:YES];
    }else{
      cell.contentView.backgroundColor = CTCommonViewControllerBg;
      CGCommentEntity *item = self.array[indexPath.row];
      [cell updateItem:item parent:NO];
    }
    return cell;
  }else{
    HeadlineTopicReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
      cell.contentView.backgroundColor = [UIColor whiteColor];
      [cell updateItem:self.comment parent:YES];
    }else{
      cell.contentView.backgroundColor = CTCommonViewControllerBg;
      CGCommentEntity *item = self.array[indexPath.row];
      [cell updateItem:item parent:NO];
    }
    return cell;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        self.clickSubComment = nil;
    }else{
        self.clickSubComment = self.array[indexPath.row];
    }
    [self openCommentView];
}


#pragma ToobarDelegate
//弹出评论界面
-(void)detailToolbarOpenTopicCommentAction{
  if(!self.comment){
    return;
  }
  [self openCommentView];
}

//赏
-(void)detailToolbarEnjoyAction{
  
}

//赞数
-(void)detailToolbarCommentTypeAction{
  if(self.comment.isPraise == 1){
    [[CTToast makeText:@"你已赞过"]show:[UIApplication sharedApplication].keyWindow];
    [self.tableview reloadData];
    [self.toolbar updatePraise:self.comment.praiseNum];
  }else{
    self.comment.praiseNum += 1;
    self.comment.isPraise = 1;
    [self.tableview reloadData];
    [self.toolbar updatePraise:self.comment.praiseNum];
      __weak typeof(self) weakSelf = self;
    [[[HeadlineBiz alloc]init]topicCommentPraiseWithInfoId:self.comment.infoId commentId:self.comment.commentId type:self.comment.type success:^{
      
    } fail:^(NSError *error) {
      if(error.code == 120104){//您已赞过
        weakSelf.comment.isPraise = 1;
      }else{
        weakSelf.comment.praiseNum -= 1;
        weakSelf.comment.isPraise = 0;
      }
      [weakSelf.tableview reloadData];
      [weakSelf.toolbar updatePraise:weakSelf.comment.praiseNum];
    }];
  }
}

//分享
-(void)detailToolbarShareAction{
  if(!self.detail){
    return;
  }
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

-(void)HeadlineTopicMyReplyPraiseAction{
  [self.toolbar updatePraise:self.comment.praiseNum];
}

-(void)openTopicMainControllerAction{
    [self.navigationController popViewControllerAnimated:YES];
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
        [weakSelf.biz.component startBlockAnimation];
      [weakSelf.biz postCommentToCommentWithParentComment:weakSelf.comment toComment:weakSelf.clickSubComment content:weakSelf.inputStr type:weakSelf.detail.type success:^(CGCommentEntity *comment) {
            if(weakSelf.clickSubComment){
                weakSelf.clickSubComment.replyNum += 1;
                comment.replyData.uid = weakSelf.clickSubComment.uid;
                comment.replyData.userName = weakSelf.clickSubComment.userName;
                comment.replyData.content = weakSelf.clickSubComment.content;
                weakSelf.clickSubComment = nil;
            }
            weakSelf.comment.replyNum += 1;
            weakSelf.comment.replyData.userName = comment.userName;
            weakSelf.comment.replyData.uid = comment.uid;
            weakSelf.comment.replyData.content = comment.content;
            
            [weakSelf.biz.component stopBlockAnimation];
            [[CTToast makeText:@"评论成功"]show:weakSelf.view];
//            weakSelf.detail.topicInfo.discuss += 1;
            [weakSelf.array insertObject:comment atIndex:0];
            [weakSelf.tableview reloadData];
            weakSelf.inputStr = @"";
            [weakSelf updateView];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
          if(error.code == 110113){//未登录
            CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
              [weakSelf loadDataFirst];
            } fail:^(NSError *error) {
              
            }];
            [weakSelf.navigationController pushViewController:controller animated:YES];
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [weakSelf presentViewController:controller animated:YES completion:nil];
//            });
          }
        }];
    } cancel:^(NSString *data) {
      weakSelf.inputStr = data;
      weakSelf.clickSubComment = nil;
    }];
    [comment showInView:self.view];
}

-(void)loadDataFirst{
  [self loadDataByMode:0 firstLoad:YES];
}

-(void)updateView{
  [self.toolbar updateToolBar:self.detail isDetail:YES comment:self.comment];
  [self.toolbar updatePraise:self.comment.praiseNum];
}

-(void)loadDataFirst:(BOOL)first{
    [self loadDataByMode:0 firstLoad:first];
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
    long time = 0;
    if(self.array.count > 0){
        if (mode == 1){//上拉加载更多
            CGCommentEntity *last = self.array[self.array.count-1];
            time = last.time;
        }
    }
    if(firstLoad){
        [self.biz.component startBlockAnimation];
    }
    __weak typeof(self) weakSelf = self;
    [self.biz queryHeadlineTopicReplyListWithCommentId:self.comment.commentId mode:mode time:time success:^(NSMutableArray *result) {
        [weakSelf.biz.component stopBlockAnimation];
        [weakSelf.tableview.mj_footer endRefreshing];
        if(result && result.count > 0){
            if(mode == 0){
                weakSelf.array = result;
            }else{
                [weakSelf.array addObjectsFromArray:result];
            }
            [weakSelf.tableview reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark HeadlineTopicReplyCell

-(void)callbackToTopicCommentController:(HeadlineTopicReplyCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    if(indexPath.section == 0){
        self.clickSubComment = nil;
    }else{
        self.clickSubComment = self.array[indexPath.row];
    }
    [self openCommentView];
}

-(void)callbackToTopicMyCommentController:(HeadlineTopicMyReplyCell *)cell{
  NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
  if(indexPath.section == 0){
    self.clickSubComment = nil;
  }else{
    self.clickSubComment = self.array[indexPath.row];
  }
  [self openCommentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.biz.component stopBlockAnimation];
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
