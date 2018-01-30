//
//  CGInterfaceViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceViewController.h"
#import "CGHorrolView.h"
#import "CGInterfaceCollectionViewCell.h"
#import "CGProductInterfaceEntity.h"
#import "CGHeadlineBigImageViewController.h"
#import "CGProductInterfaceViewController.h"
#import "ClassPushView.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "InterfaceCatalogEntity.h"
#import "CGDiscoverBiz.h"
#import "CGInterfaceDetailViewController.h"
#import "CGBoundaryCollectionViewCell.h"
#import "CGLineLayout.h"

#define InterfaceKey [NSString stringWithFormat:@"%@%ld",self.productID,self.type]

@interface CGInterfaceViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger isClick;
@property (nonatomic, strong) ClassPushView *pushView;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) NSMutableArray *catalogArray;
@property (nonatomic, strong) UIButton *cebianBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger isCache;//是否需要缓存
@end

@implementation CGInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  [self.view addSubview:self.bigTypeScrollView];
  self.biz = [[CGDiscoverBiz alloc]init];
  self.title = self.titleStr;
  self.cebianBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  self.cebianBtn.contentMode = UIViewContentModeScaleToFill;
  [self.cebianBtn addTarget:self action:@selector(cebianAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.cebianBtn setImage:[UIImage imageNamed:@"cebianlan"] forState:UIControlStateNormal];
    [self.cebianBtn setImage:[UIImage imageNamed:@"icon_sift"] forState:UIControlStateNormal];
  [self.navi addSubview:self.cebianBtn];
  
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34.5f-40, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setImage:[UIImage imageNamed:@"station_magnifier"] forState:UIControlStateNormal];
  self.rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.navi addSubview:self.rightBtn];
  __weak typeof(self) weakSelf = self;
  self.isCache = YES;
  self.pushView = [[ClassPushView alloc]initWithSelectIndex:^(NSInteger selectIndex) {
    CGBoundaryCollectionViewCell * cell = (CGBoundaryCollectionViewCell *)[weakSelf.collectionView
                                                                           cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGHorrolEntity *horrolEntity = self.typeArray[0];
    if (selectIndex == -1) {
      horrolEntity.rolId = self.productID;
      self.title = self.titleStr;
      self.isCache = YES;
    }else{
      InterfaceCatalogEntity *entity = weakSelf.catalogArray[selectIndex];
      horrolEntity.rolId = entity.catalogID;
      self.title = entity.name;
      self.isCache = NO;
    }
    NSInteger type = weakSelf.type ==2?3:0;
    [cell updateUIWithEntity:horrolEntity loadType:type isCache:self.isCache];
  } title:@"分类"];
  [self.view addSubview:self.pushView];
  
  self.catalogArray = [[ObjectShareTool sharedInstance].discoverDict objectForKey:InterfaceKey];
  if (self.catalogArray.count<=0) {
    [self.biz discoverInterfaceCatalogTreeWithID:nil action:self.type success:^(NSMutableArray *result) {
      [[ObjectShareTool sharedInstance].discoverDict setObject:result forKey:InterfaceKey];
      weakSelf.catalogArray = result;
      [weakSelf.pushView setDataWithArray:result];
    } fail:^(NSError *error) {
      
    }];
  }else{
    [self.pushView setDataWithArray:self.catalogArray];
  }
    // Do any additional setup after loading the view from its nib.
}

-(void)topButtonFrameWithType:(NSInteger)type{
  if (type) {
    self.cebianBtn.hidden = YES;
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40);
  }else{
    self.cebianBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-42.5f-40, 22, 40, 40);
  }
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.collectionView reloadData];
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
//  [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
}

-(void)cebianAction{
  [self.pushView showInView];
}

- (void)rightBtnAction{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 15;
    vc.action = [NSString stringWithFormat:@"%d",(int)self.type];
  [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)typeArray{
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
    CGHorrolEntity *entity2 = [[CGHorrolEntity alloc]initWithRolId:self.productID rolName:@"素材" sort:0];
    entity2.action = self.type;
    [_typeArray addObject:entity2];
    CGHorrolEntity *entity3 = [[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"产品" sort:0];
    entity3.action = self.type;
    [_typeArray addObject:entity3];
  }
  return _typeArray;
}

////初始化大类控件
//-(CGHorrolView *)bigTypeScrollView{
//  __weak typeof(self) weakSelf = self;
//  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
//    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
//      [UIView animateWithDuration:0.3 animations:^{
//        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        weakSelf.selectIndex = index;
//        [weakSelf topButtonFrameWithType:index];
//      }completion:^(BOOL finished) {
//        
//      }];
//    }];
//  }
//  return _bigTypeScrollView;
//}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
  [self topButtonFrameWithType:[self currentPage]];
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
  if (indexPath.section == 0) {
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CGBoundaryCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGBoundaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    NSInteger type = self.type ==2?3:0;
    [cell updateUIWithEntity:self.typeArray[indexPath.section] loadType:type isCache:self.isCache block:^(NSInteger index) {
//      NSMutableArray *array = [NSMutableArray array];
      CGHorrolEntity *typeEntity = weakSelf.typeArray[0];
//      for (int i = 0; i<typeEntity.data.count; i++) {
//        CGProductInterfaceEntity *entity = typeEntity.data[i];
//        NSString *cover = entity.cover;
//        [array addObject:cover];
//      }
      CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
      vc.array = typeEntity.data;
      vc.currentPage = index;
      vc.typeArray = weakSelf.catalogArray;
      [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    return cell;
  }else{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CGInterfaceCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGInterfaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [cell updateUIWithEntity:self.typeArray[indexPath.section] interfaceBlock:^(NSInteger index) {
      CGHorrolEntity *typeEntity = weakSelf.typeArray[0];
      CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
      vc.array = typeEntity.data;
      vc.currentPage = index;
      vc.typeArray = weakSelf.catalogArray;
      [weakSelf.navigationController pushViewController:vc animated:NO];
    } productBlock:^(CGExpListEntity *entity) {
      CGInterfaceDetailViewController *vc = [[CGInterfaceDetailViewController alloc]init];
      vc.productID = entity.expID;
      vc.type = entity.type;
      [weakSelf.navigationController pushViewController:vc animated:YES];
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
