//
//  CGDiscoverLibraryViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverLibraryViewController.h"
#import "CGLibraryCollectionViewCell.h"
#import "LWProgeressHUD.h"
#import "WKWebViewController.h"

@interface CGDiscoverLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *pageCOuntLabel;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) LWProgeressHUD* progressHUD;
@end

@implementation CGDiscoverLibraryViewController

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

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
  //强制转换
  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideCustomNavi];
  self.array = [NSMutableArray array];
  self.pageCount = 50;
  for (int i=0; i<self.pageCount; i++) {
    NSString *str = [NSString stringWithFormat:@"%@%d.jpg",[self.url substringToIndex:self.url.length-3],i+1];
    [self.array addObject:str];
  }
  self.currentPage = 0;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.pagingEnabled = YES;
  [self.collectionView reloadData];
  self.pageCOuntLabel.text = [NSString stringWithFormat:@"1/%d",self.pageCount];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
  [self.collectionView reloadData];
  [self.collectionView setContentOffset:CGPointMake(self.view.frame.size.width*self.currentPage, 0)];
}

- (IBAction)backClick:(UIButton *)sender {
  [self interfaceOrientation:UIInterfaceOrientationPortrait];
  if (self.isOpen) {
    for (UIViewController *vc in self.navigationController.viewControllers) {
      if ([vc isKindOfClass:[WKWebViewController class]]) {
        [self.navigationController popToViewController:vc  animated:NO];
        break;
      }
    }
  }else{
  [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)saveButton:(UIButton *)sender {
  NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.array[self.currentPage]]];
  UIImage* image = [UIImage imageWithData:data];
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
  if (error){
    [[CTToast makeText:@"保存失败"]show:[UIApplication sharedApplication].keyWindow];
  }else {
    [[CTToast makeText:@"保存成功"]show:[UIApplication sharedApplication].keyWindow];
  }
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
  // 根据当前的x坐标和页宽度计算出当前页数
  self.currentPage = floor((sender.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
  self.pageCOuntLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentPage+1,self.pageCount];
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
    __weak typeof(self) weakSelf = self;
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGLibraryCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
  CGLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.sv.zoomScale =1;
  self.progressHUD = [LWProgeressHUD showHUDAddedTo:cell.contentView];
  [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.section]] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    weakSelf.progressHUD.progress = (float)receivedSize/expectedSize;
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [LWProgeressHUD hideAllHUDForView:cell.contentView];
  }];
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
