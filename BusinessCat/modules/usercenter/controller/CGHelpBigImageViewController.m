//
//  CGHelpBigImageViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGHelpBigImageViewController.h"
#import "CGDetailBigImageViewController.h"
#import "CGDetailTableViewCell.h"

@interface CGHelpBigImageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end

@implementation CGHelpBigImageViewController

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
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self hideCustomNavi];
  NSString * newString = [self.url substringWithRange:NSMakeRange(0, [self.url length] - 1)];
  self.imageList = [NSMutableArray array];
  for (int i = 0; i<self.pageCount; i++) {
    NSString *imageUrl = [NSString stringWithFormat:@"%@%d?imageMogr2/format/jpg",newString,i+1];
    [self.imageList addObject:imageUrl];
  }
  [self updateimageList];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)viewDidDisappear:(BOOL)animated{
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (IBAction)backAction:(UIButton *)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.width<=0) {
    return 150;
  }
  return SCREEN_WIDTH*self.height/self.width+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section != 0) {
    return 5;
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
  view.backgroundColor = [UIColor whiteColor];
  return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.imageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  CGDetailBigImageViewController *vc = [[CGDetailBigImageViewController alloc]initWithArray:self.imageList currIndex:indexPath.section];
  [self presentViewController:vc animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString* cellIdentifier = @"CGDetailTableViewCell";
  CGDetailTableViewCell *cell = (CGDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDetailTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell updateDetailString:self.imageList[indexPath.section]];
  return cell;
}

-(void)updateimageList{
  SDWebImageManager* manager = [SDWebImageManager sharedManager];
  SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
  __weak typeof(self) weakSelf = self;
  if (self.imageList.count>0) {
    [manager loadImageWithURL:[NSURL URLWithString:self.imageList[0]] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
      
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
      if (finished && image) {
        weakSelf.width = image.size.width;
        weakSelf.height = image.size.height;
        [weakSelf.tableView reloadData];
      }
    }];
  }
}

@end
