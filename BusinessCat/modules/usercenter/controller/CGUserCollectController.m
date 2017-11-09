//
//  CGUserCollectController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserCollectController.h"
#import "CGHorrolEntity.h"
#import "CGHorrolView.h"
#import "CGInfoHeadEntity.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "CGUserCenterBiz.h"
#import "CGHeadlineInfoDetailController.h"
#import "HeadlineBiz.h"
#import "CGHeadlineGlobalSearchViewController.h"

#import "CommentaryTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "InterfaceTableViewCell.h"
#import "HeadlineLeftPicAddTableViewCell.h"
#import "CGKnowledgeMealTableViewCell.h"
#import "CGKnowledgeCatalogController.h"

#import "CGUserCollectCollectionViewCell.h"
#import "CGBoundaryCollectionViewCell.h"
#import "CGHeadlineBigImageViewController.h"
#import "CGFeedbackViewController.h"

@interface CGUserCollectController ()

@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,retain)NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation CGUserCollectController

-(NSMutableArray *)typeArray{
  //全部、头条、公司、产品、人物、界面、文库、行业大观察、每日评说、全民推荐
    if(!_typeArray){
        _typeArray = [NSMutableArray array];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"26" rolName:@"专辑" sort:6]];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"知识" sort:1]];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"14" rolName:@"文库" sort:6]];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"15" rolName:@"素材" sort:5]];
//        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"25" rolName:@"工具" sort:6]];
    }
    return _typeArray;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
    __weak typeof(self) weakSelf = self;
    if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
          [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            weakSelf.selectIndex = index;
          }completion:^(BOOL finished) {
            
          }];
        }];
    }
    return _bigTypeScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管家";
    [self.view addSubview:self.bigTypeScrollView];
  //头条收藏回调通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfoCollectState) name:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFontSizeChange) name:NOTIFICATION_FONTSIZE object:nil];
//  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
//  rightBtn.contentMode = UIViewContentModeScaleToFill;
//  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//  [rightBtn setBackgroundImage:[UIImage imageNamed:@"common_search__white_icon"] forState:UIControlStateNormal];
//  [self.navi addSubview:rightBtn];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f, 30, 24, 24)];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [rightBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setBackgroundImage:[UIImage imageNamed:@"housekeepergj"] forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
}

-(void)messageAction{
  CGFeedbackViewController *vc = [[CGFeedbackViewController alloc]init];
  vc.type = 0;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
}

//字体改变的通知，更新所有tableview
-(void)notificationFontSizeChange{  
  [self.collectionView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.selectIndex == 2) {
    CGHorrolEntity *typeEntity = self.typeArray[2];
    int j = 0;
    for (int i=0; i<typeEntity.data.count; i++) {
      CGInfoHeadEntity *entity = typeEntity.data[i-j];
      if (entity.isFollow == 0) {
        [typeEntity.data removeObject:entity];
        j+=1;
        [ObjectShareTool sharedInstance].currentUser.followNum -=1;
      }
    }
    [self.collectionView reloadData];
  }
}

-(void)notificationInfoCollectState{
}

-(void)rightBtnAction{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 0;
  vc.action = @"library";
  [self.navigationController pushViewController:vc animated:YES];
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
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
  if (indexPath.section == 3) {
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CGBoundaryCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGBoundaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [cell updateUIWithEntity:self.typeArray[indexPath.section] loadType:2 isCache:NO block:^(NSInteger index) {
//      NSMutableArray *array = [NSMutableArray array];
      CGHorrolEntity *typeEntity = weakSelf.typeArray[3];
//      for (int i = 0; i<typeEntity.data.count; i++) {
//        CGProductInterfaceEntity *entity = typeEntity.data[i];
//        NSString *cover = entity.cover;
//        [array addObject:cover];
//      }
      CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
      vc.array = typeEntity.data;
      vc.currentPage = index;
      [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    return cell;
  }else{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CGUserCollectCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGUserCollectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    CGHorrolEntity *info = self.typeArray[indexPath.section];
    [cell updateUIWithEntity:info block:^(id entity) {
        if ([entity isKindOfClass:[KnowledgeHeaderEntity class]]) {
          KnowledgeHeaderEntity *item = entity;
          CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:item.packageId companyId:nil cataId:nil];
          controller.titleStr = item.packageTitle;
          [self.navigationController pushViewController:controller animated:YES];
          return;
        }
          CGInfoHeadEntity *infoEntity = entity;
        if (infoEntity.type == 15){
          return;
        }
        CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:infoEntity.infoId type:infoEntity.type block:^{
          for (CGInfoHeadEntity *headentity in info.data) {
            if ([headentity.infoId isEqualToString:infoEntity.infoId]) {
              [info.data removeObject:headentity];
              [ObjectShareTool sharedInstance].currentUser.followNum -=1;
              break;
            }
          }
          [cell.tableView reloadData];
    }];
      detail.isCollect = YES;
      detail.info = entity;
      [weakSelf.navigationController pushViewController:detail animated:YES];
        }];
    return cell;
  }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}
@end
