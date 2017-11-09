//
//  CGHeadlineBigImageViewController.m
//  CGSays
//
//  Created by zhu on 2017/2/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGHeadlineBigImageViewController.h"
#import "CGLibraryCollectionViewCell.h"
#import "LWProgeressHUD.h"
#import "CGLineLayout.h"
#import "KxMenu.h"
#import "CGInfoHeadEntity.h"
#import "CGProductInterfaceEntity.h"
#import "HeadlineBiz.h"
#import "CGInterfaceDetailViewController.h"
#import "CGPlatformManagementViewController.h"
#import "ShareUtil.h"
#import "CGFeedbackReleaseViewController.h"
#import "CGMainLoginViewController.h"
#import "CGEnterpriseMemberViewController.h"

@interface CGHeadlineBigImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *originalArray;
@property (nonatomic, strong) NSMutableArray *thumbnailArray;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *artwork;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (nonatomic, strong) ShareUtil *shareUtil;

@property (nonatomic, assign) BOOL isShowTopView;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UIView *copyrightBGView;
@property (weak, nonatomic) IBOutlet UIButton *copyrightButton;

@end

@implementation CGHeadlineBigImageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.artwork.layer.cornerRadius = 15;
  self.artwork.layer.masksToBounds = YES;
  self.artwork.backgroundColor = [CTCommonUtil convert16BinaryColor:@"#E7E7E7"];
  [self.artwork setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  self.bottomView.layer.masksToBounds = YES;
  [self hideCustomNavi];
  self.originalArray = [NSMutableArray array];
  self.thumbnailArray = [NSMutableArray array];
  for (int i =0;i<self.array.count;i++) {
    id cover = self.array[i];
    if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
      CGProductInterfaceEntity *entity = cover;
      NSString *original = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",entity.cover];
      NSString *thumbnail = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",entity.cover];
      [self.originalArray addObject:original];
      [self.thumbnailArray addObject:thumbnail];
      if (i == self.currentPage) {
        self.collectButton.selected = entity.isFollow;
      }
    }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
      CGInfoHeadEntity *entity = cover;
      NSString *original = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",entity.cover];
      NSString *thumbnail = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",entity.cover];
      [self.originalArray addObject:original];
      [self.thumbnailArray addObject:thumbnail];
      if (i == self.currentPage) {
        self.collectButton.selected = entity.isFollow;
      }
    }
  }
  self.copyrightButton.layer.cornerRadius = 4;
  self.copyrightButton.layer.masksToBounds = YES;
  self.copyrightButton.layer.borderColor = CTCommonLineBg.CGColor;
  self.copyrightButton.layer.borderWidth = 1;
//  for (NSString *cover in self.array) {
//    NSString *original = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",cover];
//    NSString *thumbnail = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",cover];
//    [self.originalArray addObject:original];
//    [self.thumbnailArray addObject:thumbnail];
//  }
  [self.backButton setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:@"#F9F9F9"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
  [self.menuButton setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:@"#F9F9F9"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
  self.isShowTopView = YES;
  self.pageCount = self.array.count;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.pagingEnabled = YES;
  [self.collectionView reloadData];
  [self.artwork setTitle:[NSString stringWithFormat:@"%ld/%ld",self.self.currentPage+1,self.pageCount] forState:UIControlStateNormal];
//  [self.artwork setTitle:[NSString stringWithFormat:@"%ld/%ld(高清)",self.self.currentPage+1,self.pageCount] forState:UIControlStateSelected];

  dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
  
  dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  });
  
//  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
//    self.menuButton.hidden = NO;
//  }else{
//    self.copyrightButton.frame = CGRectMake(SCREEN_WIDTH, 38, 50, 25);
//  }
  
  if (self.array.count>0) {
    id cover = self.array[self.currentPage];
    if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
      CGProductInterfaceEntity *entity = cover;
      if ([CTStringUtil stringNotBlank:entity.notice]) {
        self.copyrightButton.hidden = NO;
      }else{
        self.copyrightButton.hidden = YES;
      }
    }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
      CGInfoHeadEntity *entity = cover;
      if ([CTStringUtil stringNotBlank:entity.notice]) {
        self.copyrightButton.hidden = NO;
      }else{
        self.copyrightButton.hidden = YES;
      }
    }
  }
}

- (IBAction)meunClick:(UIButton *)sender {
  NSMutableArray *menuItems = [NSMutableArray array];
  [menuItems addObject:[KxMenuItem menuItem:@"留言管家"
                                     image:nil
                                    target:self
                                     action:@selector(feedbackAction)]];
  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
    [menuItems addObject:[KxMenuItem menuItem:@"校正管理"
                                        image:nil
                                       target:self
                                       action:@selector(libraryCorrectionbackAction)]];
  }
  
  [KxMenu setTintColor:[UIColor blackColor]];
  CGRect fromRect = sender.frame;
  [KxMenu setTintColor:[UIColor blackColor]];
  
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
}

//校正管理
-(void)libraryCorrectionbackAction{
  NSString *infoId;
  if ([self.array[self.currentPage] isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = self.array[self.currentPage];
    infoId = entity.interfaceID;
  }else if([self.array[self.currentPage] isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = self.array[self.currentPage];
    infoId = entity.infoId;
  }
  CGPlatformManagementViewController *vc = [[CGPlatformManagementViewController alloc]initWithInfoId:infoId type:1 array:self.typeArray time:0 block:^(NSString *success) {
    
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

//点击登录
-(void)clickToLoginAction{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
  } fail:^(NSError *error) {
    
  }];
  //    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

//我要反馈
-(void)feedbackAction{
  if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
    [self clickToLoginAction];
    return;
  }
  if (![ObjectShareTool sharedInstance].currentUser.housekeeper) {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请开通管家会员才能使用！" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    [alertView show];
    return;
  }
  id cover = self.array[self.currentPage];
  NSString *ID;
  NSString *title;
  NSInteger type;
  NSString *icon;
  if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = cover;
    ID = entity.interfaceID;
    title = entity.name;
    type = entity.type;
    icon = entity.cover;
  }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = cover;
    ID = entity.infoId;
    type = entity.type;
    title = entity.title;
    icon = entity.cover;
  }
  CGFeedbackReleaseViewController *vc = [[CGFeedbackReleaseViewController alloc]initWithBlock:^(NSString *success) {
  }];
  CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
  link.linkId = ID;
  link.linkTitle = title;
  link.linkType = type;
  link.linkIcon = icon;
  vc.link = link;
  vc.level = 1;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.currentPage, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
}

- (IBAction)backClick:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(UIButton *)sender {
  NSMutableArray *array;
  if (self.artwork.selected) {
    array = self.originalArray;
  }else{
    array = self.thumbnailArray;
  }
  NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[self.currentPage]]];
  UIImage* image = [UIImage imageWithData:data];
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)toproductClick:(UIButton *)sender {
  id cover = self.array[self.currentPage];
  NSString *productID;
  NSInteger type =1;
  if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = cover;
    productID = entity.productId;
    type = 15;
  }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = cover;
    productID = entity.infoId;
    type = entity.type;
  }
  CGInterfaceDetailViewController *vc = [[CGInterfaceDetailViewController alloc]init];
  vc.productID = productID;
  vc.type = type;
  [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)collectionClick:(UIButton *)sender {
  id cover = self.array[self.currentPage];
  if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = cover;
    if (entity.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      entity.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:entity.interfaceID type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        entity.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      entity.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:entity.interfaceID type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        entity.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = cover;
    if (entity.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      entity.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:entity.infoId type:15 collect:1 success:^{
      } fail:^(NSError *error) {
        entity.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      entity.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:entity.infoId type:15 collect:0 success:^{
      } fail:^(NSError *error) {
        entity.isFollow = YES;
        sender.selected = YES;
      }];
    }
  }
}

- (IBAction)artworkClick:(UIButton *)sender {
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.currentPage, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
  sender.selected = !sender.selected;
  [self.collectionView reloadData];
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
  [self.artwork setTitle:[NSString stringWithFormat:@"%ld/%ld",self.self.currentPage+1,self.pageCount] forState:UIControlStateNormal];
//  [self.artwork setTitle:[NSString stringWithFormat:@"%ld/%ld(高清)",self.self.currentPage+1,self.pageCount] forState:UIControlStateSelected];
  id cover = self.array[self.currentPage];
  if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = cover;
    self.collectButton.selected = entity.isFollow;
    if ([CTStringUtil stringNotBlank:entity.notice]) {
      self.copyrightButton.hidden = NO;
    }else{
      self.copyrightButton.hidden = YES;
    }
  }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = cover;
    self.collectButton.selected = entity.isFollow;
    if ([CTStringUtil stringNotBlank:entity.notice]) {
      self.copyrightButton.hidden = NO;
    }else{
      self.copyrightButton.hidden = YES;
    }
  }
}

- (IBAction)shareClick:(UIButton *)sender {
//  [KxMenuItem menuItem:@"发到邮箱"
//                 image:[UIImage imageNamed:@"mailbox"]
//                target:self
//                action:@selector(toEmailAction)],
//  [KxMenuItem menuItem:@"发到企业圈"
//                 image:[UIImage imageNamed:@"sentto_tuanduiquan"]
//                target:self
//                action:@selector(toTeamCircleAction)],
  NSArray *menuItems = menuItems = @[
                                     [KxMenuItem menuItem:@"分享到"
                                                    image:[UIImage imageNamed:@"gw_fxshare"]
                                                   target:self
                                                   action:@selector(detailToolbarShareAction)]];
  
  [KxMenu setTintColor:[UIColor blackColor]];
  CGRect fromRect = CGRectMake(SCREEN_WIDTH-40, SCREEN_HEIGHT-40, 24,24);
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
}

-(void)toEmailAction{
  
}

-(void)toTeamCircleAction{
  
}

-(void)detailToolbarShareAction{
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  NSString *url;
  NSString *title;
  if ([self.array[self.currentPage] isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = self.array[self.currentPage];
    url = entity.cover;
    title = entity.name;
  }else if([self.array[self.currentPage] isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = self.array[self.currentPage];
    url = entity.cover;
    title = [CTStringUtil stringNotBlank:entity.title]?entity.title:entity.name;
  }
  
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",url]]];
  SDImageCache* cache = [SDImageCache sharedImageCache];
  UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
  [self.shareUtil showShareMenuWithTitle:title desc:@"我在荐识发现了这份非常优质的素材，现在也推荐给你" isqrcode:1 image:cachedImage url:url block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
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
  return self.array.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGLibraryCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
  CGLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  NSMutableArray *array;
  if (self.artwork.selected) {
    array = self.originalArray;
  }else{
    array = self.thumbnailArray;
  }
  
  [cell updateString:array[indexPath.section]];
  __weak typeof(self) weakSelf = self;
  [cell didSelectBlock:^{
    [weakSelf hiddenTopView];
  }];
  
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.collectionView.bounds.size;
}

-(void)hiddenTopView{
  self.isShowTopView = !self.isShowTopView;
  __weak typeof(self) weakSelf = self;
  if (self.isShowTopView) {
    [UIView animateWithDuration:0.1 animations:^{
      weakSelf.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
      weakSelf.backButton.frame = CGRectMake(15, 30, 40, 40 );
      weakSelf.menuButton.frame = CGRectMake(SCREEN_WIDTH-55, 30, 40, 40);
      weakSelf.copyrightButton.frame = CGRectMake(weakSelf.copyrightButton.frame.origin.x, 38, 50, 25);
    } completion:^(BOOL finished) {
      weakSelf.bottomHeight.constant = 44;
    }];
  }else{
    [UIView animateWithDuration:0.1 animations:^{
      weakSelf.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
      weakSelf.backButton.frame = CGRectMake(15, -40, 40, 40 );
      weakSelf.menuButton.frame = CGRectMake(SCREEN_WIDTH-55, -40, 40, 40);
      weakSelf.copyrightButton.frame = CGRectMake(weakSelf.copyrightButton.frame.origin.x, -25, 50, 25);
    } completion:^(BOOL finished) {
      weakSelf.bottomHeight.constant = 0;
    }];
  }
}

- (IBAction)copyrightTipAction:(UIButton *)sender {
  self.copyrightBGView.hidden = NO;
  id cover = self.array[self.currentPage];
  NSString *tip;
  if ([cover isKindOfClass:[CGProductInterfaceEntity class]]) {
    CGProductInterfaceEntity *entity = cover;
    tip = entity.notice;
  }else if([cover isKindOfClass:[CGInfoHeadEntity class]]){
    CGInfoHeadEntity *entity = cover;
    tip = entity.notice;
  }
  self.copyrightLabel.text = tip;
}

- (IBAction)copyRightAction:(UIButton *)sender {
  self.copyrightBGView.hidden = YES;
}
@end
