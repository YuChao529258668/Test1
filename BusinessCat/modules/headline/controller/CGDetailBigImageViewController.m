//
//  CGDetailBigImageViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGDetailBigImageViewController.h"
#import "CGLineLayout.h"
#import "CGLibraryCollectionViewCell.h"

@interface CGDetailBigImageViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger currIndex;
@end

@implementation CGDetailBigImageViewController

- (BOOL)shouldAutorotate{
  //是否允许转屏
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  //viewController所支持的全部旋转方向
  return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  //viewController初始显示的方向
  return UIInterfaceOrientationPortrait;
}

//屏幕旋转完成的状态
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  
}

//获取将要旋转的状态
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  
}

//获取旋转中的状态
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self.collectionView reloadData];
   [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currIndex] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(instancetype)initWithArray:(NSMutableArray *)array currIndex:(NSInteger)currIndex{
  self = [super init];
  if(self){
    
    self.array = array;
    self.currIndex = currIndex;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self hideCustomNavi];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.currIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  self.currIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
//  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
//  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.currIndex, 0.f);
//  self.collectionView.collectionViewLayout = viewLayout;
}


- (BOOL)isSupportPanReturnBack{
  return NO;
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
  return self.array.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGLibraryCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
  CGLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  cell.imageView.frame = cell.sv.frame;
  [cell updateDetailString:self.array[indexPath.section]];
  __weak typeof(self) weakSelf = self;
  [cell didSelectBlock:^{
    [weakSelf.navigationController popViewControllerAnimated:NO];
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
