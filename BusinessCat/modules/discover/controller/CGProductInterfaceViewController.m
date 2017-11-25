//
//  CGProductInterfaceViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGProductInterfaceViewController.h"
#import "InterfaceTableViewCell.h"
#import "CGDiscoverBiz.h"
#import "CGProductInterfaceEntity.h"
#import "CGHeadlineBigImageViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "ClassPushView.h"
#import "InterfaceCatalogEntity.h"
#import "CGInterfaceDetailViewController.h"
#import "XRWaterfallLayout.h"
#import "CGInterfaceImageViewCollectionViewCell.h"

static NSString * const Identifier = @"CGInterfaceImageViewCell";

@interface CGProductInterfaceViewController ()<InterfaceDelegate,XRWaterfallLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, strong) NSMutableArray *catalogArray;
@property (nonatomic, strong) ClassPushView *pushView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@end

@implementation CGProductInterfaceViewController
-(void)dealloc{
    NSLog(@"CGProductInterfaceViewController dealloc");
}
- (void)viewDidLoad {
    NSLog(@"CGProductInterfaceViewController viewDidLoad");
    [super viewDidLoad];
  self.biz = [[CGDiscoverBiz alloc]init];
  //创建瀑布流布局
  XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
  //或者一次性设置
  [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
  //设置代理，实现代理方法
  waterfall.delegate = self;
  [self.collectionView setCollectionViewLayout:waterfall];
  // 注册
  [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGInterfaceImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
  
  self.dataArray = [NSMutableArray array];
  UIButton *cebianBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  cebianBtn.contentMode = UIViewContentModeScaleToFill;
  [cebianBtn addTarget:self action:@selector(cebianAction) forControlEvents:UIControlEventTouchUpInside];
  [cebianBtn setImage:[UIImage imageNamed:@"cebianlan"] forState:UIControlStateNormal];
  [self.navi addSubview:cebianBtn];
  
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f-30, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setImage:[UIImage imageNamed:@"station_magnifier"] forState:UIControlStateNormal];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [self.navi addSubview:rightBtn];
  __weak typeof(self)weakSelf = self;
  //下拉刷新
  self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
    if (weakSelf.dataArray.count>0) {
      CGProductInterfaceEntity *entity = weakSelf.dataArray[0];
      time = entity.createtime;
    }
    weakSelf.page = 1;
    [weakSelf.biz discoverInterfaceListWithPage:self.page tagId:weakSelf.tagId ID:weakSelf.productID verId:nil catalogId:nil action:weakSelf.action success:^(NSMutableArray *result) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView.mj_header endRefreshing];
        weakSelf.dataArray = result;
        [weakSelf.collectionView reloadData];
      });
    } fail:^(NSError *error) {
      [weakSelf.collectionView.mj_header endRefreshing];
    }];
  }];
  
  //上拉加载更多
  self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
    if (weakSelf.dataArray.count>0) {
      CGProductInterfaceEntity *entity = [weakSelf.dataArray lastObject];
      time = entity.createtime;
    }
    weakSelf.page = weakSelf.page+1;
    [weakSelf.biz discoverInterfaceListWithPage:self.page tagId:weakSelf.tagId ID:weakSelf.productID verId:nil catalogId:nil action:weakSelf.action success:^(NSMutableArray *result) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView.mj_footer endRefreshing];
        if(result && result.count > 0){
          [weakSelf.dataArray addObjectsFromArray:result];
          [weakSelf.collectionView reloadData];
        }
      });
    } fail:^(NSError *error) {
      [weakSelf.collectionView.mj_footer endRefreshing];
    }];
  }];
   [self.collectionView.mj_header beginRefreshing];
  
  [self.biz discoverInterfaceCatalogTreeWithID:self.productID action:self.action success:^(NSMutableArray *result) {
    weakSelf.catalogArray = result;
    [weakSelf.pushView setDataWithArray:result];
  } fail:^(NSError *error) {
    
  }];
  self.pushView = [[ClassPushView alloc]initWithSelectIndex:^(NSInteger selectIndex) {
    if (selectIndex == -1) {
      weakSelf.tagId = @"";
    }else{
      InterfaceCatalogEntity *entity = weakSelf.catalogArray[selectIndex];
      weakSelf.tagId = entity.catalogID;
    }
    [weakSelf.collectionView.mj_header beginRefreshing];
  } title:@"界面分类"];
  [self.view addSubview:self.pushView];
}

-(void)cebianAction{
  [self.pushView showInView];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.collectionView reloadData];
}

- (void)rightBtnAction{
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 15;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
  return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  CGInterfaceImageViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
  CGProductInterfaceEntity *interface = self.dataArray[indexPath.item];
  cell.interface = interface;
  return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
  [self doProductDetailWithIndex:indexPath.item];
}

#pragma mark  - <XRWaterfallLayoutDelegate>

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
  //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
  CGProductInterfaceEntity *interface = self.dataArray[indexPath.row];
  if (interface.width<=0) {
    return 300;
  }
  return itemWidth * interface.height / interface.width+40;
  
}

- (void)doProductDetailWithIndex:(NSInteger )index{
//  NSMutableArray *array = [NSMutableArray array];
//  for (int i = 0; i<self.dataArray.count; i++) {
//    CGProductInterfaceEntity *entity = self.dataArray[i];
//    NSString *cover = entity.cover;
//    [array addObject:cover];
//  }
  CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
  vc.array = self.dataArray;
  vc.currentPage = index;
  [self.navigationController pushViewController:vc animated:NO];
}
@end
