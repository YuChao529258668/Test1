//
//  CGUserCollectCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/15.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserCollectCollectionViewCell.h"
#import "CGUserCenterBiz.h"
#import "HeadlineBiz.h"

#import "RecommendTableViewCell.h"
#import "CommentaryTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "CGKnowledgeMealTableViewCell.h"

@interface CGUserCollectCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,HeadlineOnlyTitleTableViewCellDelegate,HeadlineLeftPicTableViewCellDelegate,HeadlineRightPicTableViewCellDelegate,HeadlineMorePicTableViewCellDelegate>
@property(nonatomic,retain)CGUserCenterBiz *biz;
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, copy) CGUserCollectCollectionViewBlock block;
@property(nonatomic,retain)HeadlineBiz *headlineBiz;
@property (nonatomic, strong) CGInfoHeadEntity *deleteInfo;
@end

@implementation CGUserCollectCollectionViewCell

-(HeadlineBiz *)headlineBiz{
  if (!_headlineBiz) {
    _headlineBiz = [[HeadlineBiz alloc]init];
  }
  return _headlineBiz;
}

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

- (void)awakeFromNib {
    [super awakeFromNib];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableFooterView = [[UIView alloc]init];
          [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
          [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
          [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
          [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
    // Initialization code
          //下拉刷新
  __weak typeof(self) weakSelf = self;
          self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.entity.page = 1;
            [weakSelf.biz getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
                  [weakSelf.tableView.mj_header endRefreshing];
                  weakSelf.entity.data = reslut;
                  [weakSelf.tableView reloadData];
              weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
              } fail:^(NSError *error) {
                  [weakSelf.tableView.mj_header endRefreshing];
              }];
          }];
          //上拉加载更多
          self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.entity.page += 1;
            [weakSelf.biz getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
              if(reslut && reslut.count > 0){
                [weakSelf.entity.data addObjectsFromArray:reslut];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
              }else {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
              }
  
              } fail:^(NSError *error) {
                  [weakSelf.tableView.mj_footer endRefreshing];
              }];
          }];
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity block:(CGUserCollectCollectionViewBlock)block{
  self.entity = entity;
  self.block = block;
  if (self.entity.data.count<=0) {
    [self.tableView.mj_header beginRefreshing];
  }else{
    [self.tableView reloadData];
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
    if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
      self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

#pragma UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.entity.data[indexPath.row] isKindOfClass:[KnowledgeHeaderEntity class]]) {
//        static NSString* cellIdentifier = @"CGKnowledgeMealTableViewCell";
//        CGKnowledgeMealTableViewCell *cell = (CGKnowledgeMealTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if(!cell){
//          cell = [[CGKnowledgeMealTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//        }
      KnowledgeHeaderEntity *entity = self.entity.data[indexPath.row];
      CGInfoHeadEntity *info = [[CGInfoHeadEntity alloc]init];
      info.infoId = entity.packageId;
      info.title = entity.packageTitle;
      info.icon = entity.packageCover;
      info.type = 26;
      info.createtime = entity.createtime;
//      [cell updateItem:entity header:nil];
//        return  cell;
      HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
      cell.timeType = 3;
      [cell updateItem:info];
      cell.delegate = self;
      return cell;
    }
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.type == 11) {
      static NSString* cellIdentifier = @"RecommendTableViewCell";
      RecommendTableViewCell *cell = (RecommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecommendTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateInfo:info];
      return cell;
    }else if (info.type == 17|| info.type ==21){
      static NSString* cellIdentifier = @"CommentaryTableViewCell";
      CommentaryTableViewCell *cell = (CommentaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentaryTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell updateInfo:info];
      return cell;
    }else{
      if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        cell.timeType = 3;
        [cell updateItem:info];
        cell.delegate = self;
//        cell.close.hidden = YES;
        return cell;
      }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        cell.timeType = 3;
        [cell updateItem:info];
        cell.delegate = self;
//        cell.close.hidden = YES;
        return cell;
      }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        cell.timeType = 3;
        [cell updateItem:info];
        cell.delegate = self;
//        cell.close.hidden = YES;
        return cell;
      }else{
                HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
                cell.delegate = self;
            cell.timeType = 3;
                [cell updateItem:info];
                return cell;
      }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self.entity.data[indexPath.row] isKindOfClass:[KnowledgeHeaderEntity class]]) {
//    return  150+40+40;
    KnowledgeHeaderEntity *entity = self.entity.data[indexPath.row];
    CGInfoHeadEntity *info = [[CGInfoHeadEntity alloc]init];
    info.infoId = entity.packageId;
    info.title = entity.packageTitle;
    info.icon = entity.packageCover;
    info.createtime = entity.startTime;
    info.isFollow = YES;
    info.type = 26;
    HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
    [cell updateItem:info];
    return cell.height;
  }
    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
    if (info.type == 11) {
      return 212;
    }else if (info.type == 17|| info.type ==21){
      return [CommentaryTableViewCell height:info];
    }else if (info.type == 1){
      if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        [cell updateItem:info];
        return cell.height;
      }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        [cell updateItem:info];
        return cell.height;
      }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        [cell updateItem:info];
        return cell.height;
      }
    }
    return 122;
  return 0;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGInfoHeadEntity *info = self.entity.data[indexPath.row];
//  if (info.type == 15){
//    return;
//  }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  self.block(self.entity.data[indexPath.row]);
}

- (void)doProductDetailWithIndex:(NSInteger )index{

}

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY{
  if ([info.label2 isEqualToString:@"管家"]) {
    self.deleteInfo = info;
    UIAlertView *alerView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
  }else{
    [self deleteCollect:info];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    [self deleteCollect:self.deleteInfo];
  }
}

-(void)deleteCollect:(CGInfoHeadEntity *)info{
  __weak typeof(self) weakSelf = self;
  [self.headlineBiz.component startBlockAnimation];
  [self.headlineBiz collectWithId:info.infoId type:info.type collect:0 success:^{
    if (weakSelf.entity.rolId.integerValue == 26) {
      for (KnowledgeHeaderEntity *entity in weakSelf.entity.data) {
        if ([entity.packageId isEqualToString:info.infoId]) {
          [weakSelf.entity.data removeObject:entity];
          break;
        }
      }
    }else{
      [weakSelf.entity.data removeObject:info];
    }
    [weakSelf.headlineBiz.component stopBlockAnimation];
    [weakSelf.tableView reloadData];
//    if (weakSelf.entity.data.count==0) {
//      [weakSelf.tableView reloadData];
//    }else{
//      [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[weakSelf.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
  } fail:^(NSError *error) {
    [weakSelf.headlineBiz.component stopBlockAnimation];
  }];
}
@end
