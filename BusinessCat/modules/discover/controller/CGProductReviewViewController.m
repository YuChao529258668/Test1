//
//  CGProductReviewViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGProductReviewViewController.h"
#import "CGHorrolEntity.h"
#import "CGHorrolView.h"
#import "CollectionViewCell.h"
#import "CGProductReviewCollectionViewCell.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGHeadlineInfoDetailController.h"
#import "DiscoverDao.h"
#import "CGLineLayout.h"
#import "CGDiscoverBiz.h"
#import "ClassPushView.h"
#import "CGKnowledgeCatalogController.h"
#import "InterfaceCatalogEntity.h"
#import "commonViewModel.h"

#define InterfaceKey [NSString stringWithFormat:@"%ld",self.type]

@interface CGProductReviewViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger isClick;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) NSMutableArray *catalogArray;
@property (nonatomic, strong) ClassPushView *pushView;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGProductReviewViewController

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.isClick = YES;
  self.title = self.titleStr;
  [self.topView addSubview:self.bigTypeScrollView];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setImage:[UIImage imageNamed:@"common_search_white_icon"] forState:UIControlStateNormal];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.navi addSubview:rightBtn];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFontSizeChange) name:NOTIFICATION_FONTSIZE object:nil];
  self.biz = [[CGDiscoverBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  NSInteger type = 0;
  switch (self.type) {
    case 4:
      type = 5;
      break;
    case 3:
      type = 6;
      break;
    case 1:
      rightBtn.hidden = YES;
      type = 7;
      break;
    case 5:
      rightBtn.hidden = YES;
      type = 8;
      break;
    case 7:
      type = 9;
      break;
    case 8:
      type = 10;
      break;
    case 9:
      type = 11;
//      self.screenButton.hidden = YES;/
      break;
    default:
      break;
  }
  self.pushView = [[ClassPushView alloc]initWithSelectIndex:^(NSInteger selectIndex) {
    for (CGHorrolEntity *horrolEntity in weakSelf.typeArray) {
      horrolEntity.data = [NSMutableArray array];
    }
    if (selectIndex == -1) {
      weakSelf.tagId = @"";
      weakSelf.title = weakSelf.titleStr;
    }else{
      InterfaceCatalogEntity *entity = weakSelf.catalogArray[selectIndex];
      weakSelf.title = entity.name;
      weakSelf.tagId = entity.catalogID;
    }
    [weakSelf.collectionView reloadData];
  } title:@"分类"];
  [self.view addSubview:self.pushView];
//  if (self.type != 9) {
    self.catalogArray = [[ObjectShareTool sharedInstance].discoverDict objectForKey:InterfaceKey];
    if (self.catalogArray.count<=0) {
      [self.biz discoverInterfaceCatalogTreeWithID:nil action:type success:^(NSMutableArray *result) {
        [[ObjectShareTool sharedInstance].discoverDict setObject:result forKey:InterfaceKey];
        weakSelf.catalogArray = result;
        [weakSelf.pushView setDataWithArray:result];
      } fail:^(NSError *error) {
        
      }];
    }else{
      [self.pushView setDataWithArray:self.catalogArray];
    }
//  }
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

//字体改变的通知，更新所有tableview
-(void)notificationFontSizeChange{
  [self.collectionView reloadData];
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
  [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
}

- (void)rightBtnAction{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 14;
  if (self.type == 0) {
    
  }else if (self.type == 2){
    
  }else if (self.type == 3){
    vc.subType = @"2";
  }else if (self.type == 4){
    vc.subType = @"3";
  }else if (self.type == 5){
   vc.subType = @"18";
  }else if (self.type == 7){
    vc.subType = @"19";
  }else if (self.type == 8){
    vc.subType = @"6";
  }else if (self.type == 9){
    vc.type = 26;
  }else{
    vc.subType = @"1";
  }
  vc.action = @"library";
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)categoriesClick:(UIButton *)sender {
  [self.pushView showInView];
}

-(NSMutableArray *)typeArray{
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
    if (self.type == 1){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"最新" sort:0];
      entity2.action = 1;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 1;
      [_typeArray addObject:entity3];
      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"精选" sort:0];
      entity1.action = 1;
      [_typeArray addObject:entity1];
    }else if (self.type == 2){
      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"0" rolName:@"推荐" sort:0];
      entity1.action = 0;
      [_typeArray addObject:entity1];
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"最新" sort:0];
      entity2.action = 0;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 0;
      [_typeArray addObject:entity3];
      CGHorrolEntity *entity4 = [[CGHorrolEntity alloc]initWithRolId:@"3" rolName:@"官方" sort:0];
      entity4.action = 0;
      [_typeArray addObject:entity4];
      CGHorrolEntity *entity5 = [[CGHorrolEntity alloc]initWithRolId:@"4" rolName:@"我的" sort:0];
      entity5.action = 0;
      [_typeArray addObject:entity5];
    }else if (self.type == 3){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
      entity2.action = 2;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 2;
      [_typeArray addObject:entity3];
//      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"私有" sort:0];
//      entity1.action = 2;
//      [_typeArray addObject:entity1];
    }else if (self.type == 4){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
      entity2.action = 3;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 3;
      [_typeArray addObject:entity3];
//      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"私有" sort:0];
//      entity1.action = 3;
//      [_typeArray addObject:entity1];
    }else if (self.type == 5){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"最新" sort:0];
      entity2.action = 18;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 18;
      [_typeArray addObject:entity3];
      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"精选" sort:0];
      entity1.action = 18;
      [_typeArray addObject:entity1];
    }else if (self.type == 6){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"最新" sort:0];
      entity2.action = 12;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 12;
      [_typeArray addObject:entity3];
      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"精选" sort:0];
      entity1.action = 12;
      [_typeArray addObject:entity1];
    }else if (self.type == 7){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
      entity2.action = 19;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 19;
      [_typeArray addObject:entity3];
//      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"私有" sort:0];
//      entity1.action = 19;
//      [_typeArray addObject:entity1];
    }else if (self.type == 8){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
      entity2.action = 6;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 6;
      [_typeArray addObject:entity3];
//      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"私有" sort:0];
//      entity1.action = 6;
//      [_typeArray addObject:entity1];
    }else if (self.type == 9){
      CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"推荐" sort:0];
      entity2.action = 1000;
      [_typeArray addObject:entity2];
      CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"2" rolName:@"最热" sort:0];
      entity3.action = 1000;
      [_typeArray addObject:entity3];
//      CGHorrolEntity *entity1 = [[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"私有" sort:0];
//      entity1.action = 1000;
//      [_typeArray addObject:entity1];
    }
  }
  return _typeArray;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
//   int width = self.type == 9?0:40;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        weakSelf.selectIndex = index;
      }completion:^(BOOL finished) {
        
      }];
    }];
  }
  return _bigTypeScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    // Dispose of any resources that can be recreated.
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
  [collectionView registerNib:[UINib nibWithNibName:@"CGProductReviewCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGProductReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  __weak typeof(self) weakSelf = self;
  [cell updateUIWithEntity:self.typeArray[indexPath.section] type:self.type tagId:self.tagId block:^(NSInteger type, CGInfoHeadEntity *entity) {
    [weakSelf.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:entity typeArray:weakSelf.catalogArray];
//    if (entity.type == 26) {
//      CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:entity.infoId companyId:nil cataId:nil];
//      controller.title = entity.name;
//      [weakSelf.navigationController pushViewController:controller animated:YES];
//    }else{
//      CGHeadlineInfoDetailController *controller = [[CGHeadlineInfoDetailController alloc]initWithInfoId:entity.infoId type:entity.type block:^{
//        CGHorrolEntity *entity1 = weakSelf.typeArray[indexPath.section];
//        for (CGInfoHeadEntity *headentity in entity1.data) {
//          if ([headentity.infoId isEqualToString:entity.infoId]) {
//            [entity1.data removeObject:headentity];
//            [DiscoverDao deleteProductInterfaceFromDBWithType:entity1.rolId.integerValue action:entity1.action ID:headentity.infoId];
//            break;
//          }
//        }
//        [cell.tableView reloadData];
//      }];
//      controller.info = entity;
//      [weakSelf.navigationController pushViewController:controller animated:YES];
//    }
  }];
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

@end
