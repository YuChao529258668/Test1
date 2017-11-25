//
//  CGKnowledgeBaseDetailViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBaseDetailViewController.h"
#import "AttentionBiz.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGClassificationView.h"
#import "CGHorrolView.h"
#import "CGKnowledgeBaseCollectionViewCell.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "DiscoverDao.h"
#import "CGLineLayout.h"
#import "CGKnowledgeCatalogController.h"
#import "commonViewModel.h"
#import "CGAcquisitionViewController.h"

@interface CGKnowledgeBaseDetailViewController ()
@property (nonatomic, strong) AttentionBiz *biz;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger page;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) CGClassificationView *pushView;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGKnowledgeBaseDetailViewController

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.biz = [[AttentionBiz alloc]init];
  self.selectIndex = 0;
  self.isClick = YES;
  self.isPush = NO;
  [self.topView addSubview:self.bigTypeScrollView];
  if (self.catePage == 0) {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"station_magnifier"] forState:UIControlStateNormal];
    [self.navi addSubview:rightBtn];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFontSizeChange) name:NOTIFICATION_FONTSIZE object:nil];
  
  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
      UIButton *caiji = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-92.5f, 22, 40, 40)];
      caiji.contentMode = UIViewContentModeScaleAspectFit;
      [caiji addTarget:self action:@selector(caijiAction) forControlEvents:UIControlEventTouchUpInside];
      [caiji setTitle:@"采集" forState:UIControlStateNormal];
      [self.navi addSubview:caiji];
  }
}

-(void)caijiAction{
  CGAcquisitionViewController *vc = [[CGAcquisitionViewController alloc]init];
  vc.navtype = self.bigTypeId;
  vc.navtype2 = self.navTypeId;
  vc.tagName = [NSString stringWithFormat:@"%@(%@)",self.bigName,self.navName];
  UIPasteboard *board = [UIPasteboard generalPasteboard];
  vc.url = board.string;
  [self.navigationController pushViewController:vc animated:YES];
}

//字体改变的通知，更新所有tableview
-(void)notificationFontSizeChange{
  [self.collectionView reloadData];
}

//todo
-(void)rightBtnAction{
  if (self.catePage==0) {
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 1;
    vc.infoAction = 2;
    vc.level = 2;
    vc.typeID = self.navTypeId;
    [self.navigationController pushViewController:vc animated:YES];
  }else{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 25;
    vc.action = @"library";
    [self.navigationController pushViewController:vc animated:YES];
  }
}

-(NSMutableArray *)typeArray{
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
    CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
    [_typeArray addObject:entity2];
    CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
    [_typeArray addObject:entity3];
//    CGHorrolEntity *entity4 = [[CGHorrolEntity alloc]initWithRolId:@"3" rolName:@"精选" sort:0];
//    [_typeArray addObject:entity4];
  }
  return _typeArray;
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
  [self.bigTypeScrollView setSelectIndex:self.selectIndex];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  self.isClick = YES;
}

- (IBAction)rightClick:(UIButton *)sender {
  self.isPush = !self.isPush;
  if (self.isPush) {
    __weak typeof(self) weakSelf = self;
    self.pushView = [[CGClassificationView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-64) array:self.array index:self.index secondaryIndex:self.secondaryIndex block:^(NSString *navTypeId, NSString *name, NSInteger index, NSInteger secondaryIndex) {
      weakSelf.navTypeId = navTypeId;
      weakSelf.index = index;
      weakSelf.secondaryIndex = secondaryIndex;
      weakSelf.title = name;
      [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:weakSelf.selectIndex]]];
    } closeBlock:^{
      weakSelf.isPush = !weakSelf.isPush;
    }];
    [self.view addSubview:self.pushView];
  }else{
    [self.pushView close];
  }
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        weakSelf.selectIndex = index;
      }completion:^(BOOL finished) {
        if (weakSelf.selectIndex !=1) {
          CGKnowledgeBaseCollectionViewCell * cell = (CGKnowledgeBaseCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:weakSelf.selectIndex]];
          [cell update:weakSelf.typeArray[weakSelf.selectIndex] catePage:weakSelf.catePage navTypeId:weakSelf.navTypeId];
        }
      }];
    }];
  }
  return _bigTypeScrollView;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
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
  return self.typeArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGKnowledgeBaseCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGKnowledgeBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  __weak typeof(self) weakSelf = self;
  [cell update:self.typeArray[indexPath.section] catePage:self.catePage navTypeId:self.navTypeId block:^(CGInfoHeadEntity *entity) {
    [weakSelf.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:entity typeArray:nil];
  }];

  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
  //  [self.biz.component stopBlockAnimation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
