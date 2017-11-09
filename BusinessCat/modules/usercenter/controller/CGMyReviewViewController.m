//
//  CGMyReviewViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMyReviewViewController.h"
#import "CGReviewCollectionViewCell.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGTopicCommentController.h"
#import "CGLineLayout.h"

@interface CGMyReviewViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation CGMyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的点评";
  [self.reviewButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
//  self.reviewButton.selected = YES;
//  self.selectButton = self.reviewButton;
  [self.replyButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
  self.line.backgroundColor = CTThemeMainColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)dataArray{
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"0" rolName:@"我点评的" sort:0]];
    [_dataArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"我回复的" sort:0]];
  }
  return _dataArray;
}

-(void)refresh{
  for (CGHorrolEntity *entity in self.dataArray) {
    entity.data = [NSMutableArray array];
  }
  [self.collectionView reloadData];
}

- (IBAction)topButtonClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  self.selectIndex = sender.tag;
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake(sender.tag*150+41, 38, 68, 2);
  }];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
  if (self.selectIndex) {
    self.reviewButton.selected = NO;
    self.replyButton.selected = YES;
    self.selectButton = self.replyButton;
  }else{
    self.reviewButton.selected = YES;
    self.replyButton.selected = NO;
    self.selectButton = self.reviewButton;
  }
  self.line.frame = CGRectMake(self.selectIndex*150+41, 38, 68, 2);
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
  self.selectButton.selected = NO;
  switch ([self currentPage]) {
    case 0:
      self.reviewButton.selected = YES;
      self.selectButton = self.reviewButton;
      break;
    case 1:
      self.replyButton.selected = YES;
      self.selectButton = self.replyButton;
      break;
    default:
      break;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake([self currentPage]*150+41, 38, 68, 2);
  }];
}

#pragma mark UICollectionViewDelegate&UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGReviewCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  [cell update:self.dataArray[indexPath.section]];
  __weak typeof(self) weakSelf = self;
  cell.clickedLinkCallback = ^(CGDiscoverLink *link) {
    CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
      
    }];
    [weakSelf.navigationController pushViewController:vc animated:YES];
  };
  cell.didSelectRowAtIndexPathCallback = ^(SearchCellLayout *layout, CGReviewCollectionViewCell *cell) {
//    CGCommentEntity *entity = [[CGCommentEntity alloc]init];
//    entity.commentId = layout.entity.commentId;
//    entity.content = layout.entity.content;
//    entity.portrait = layout.entity.portrait;
//    entity.replyNum = layout.entity.replyNum;
//    entity.replyNum = layout.entity.replyNum;
//    entity.userName = layout.entity.nickname;
//    entity.infoId = layout.entity.linkId;
//    entity.type = layout.entity.linkType;
//    entity.uid = layout.entity.userId;
//    entity.time = layout.entity.createTime;
//    CGTopicCommentController *vc = [[CGTopicCommentController alloc]initWithComment:entity detail:nil showCommentView:NO];
//    [weakSelf.navigationController pushViewController:vc animated:YES];
    if ([CTStringUtil stringNotBlank:layout.entity.linkId]) {
      CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:layout.entity.linkId type:layout.entity.linkType block:^{
        
      }];
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }
  };
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}
@end
