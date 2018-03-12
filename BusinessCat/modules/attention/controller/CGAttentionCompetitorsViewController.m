//
//  CGAttentionCompetitorsViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionCompetitorsViewController.h"
#import "CGAttentionEntity.h"
#import "AttentionCompetitorsCollectionViewCell.h"
#import "CGAttentionSearchKeyWordViewController.h"
#import "CGInfoHeadEntity.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGAttentionProductViewController.h"
#import "AttentionHead.h"
#import "AttentionStatisticsEntity.h"
#import "CGAttentionDynamicViewController.h"
#import "CGCompanyDao.h"
#import "AttentionBiz.h"
#import "CGAttentionDynamicViewController.h"

@interface CGAttentionCompetitorsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation CGAttentionCompetitorsViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.titleText;
  self.selectIndex = 0;
  self.isClick = YES;
  self.selectButton = self.dynamicButton;
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 30, 24, 24)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
  [self.navi addSubview:self.rightBtn];
  self.rightBtn.hidden = YES;
  //关注回调
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProductSuccess:) name:NOTIFICATION_ATTENTION object:nil];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

-(void)updateProductSuccess:(NSNotification*) notification{
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
  AttentionCompetitorsCollectionViewCell * cell = (AttentionCompetitorsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//  NSNumber *isupdate = [notification object];
//  if (isupdate.intValue) {
   [cell.tableView.mj_header beginRefreshing];
//  }
}

-(void)rightBtnAction:(UIButton *)sender{
  CGAttentionSearchKeyWordViewController *vc = [[CGAttentionSearchKeyWordViewController alloc]init];
  vc.subjectId = self.attentionID;
  [self.navigationController pushViewController:vc animated:YES];
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

-(NSMutableArray *)typeArray{
  //TODO id我乱写的
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
    [_typeArray addObject:[[CGAttentionEntity alloc]initWithRolId:self.attentionID rolName:@"动态" type:self.type]];
    CGAttentionEntity *entity = [[CGAttentionEntity alloc]initWithRolId:self.attentionID rolName:@"统计" type:self.type];
    if (self.type == 8) {
      entity.data = [CGCompanyDao getProductStatisticsFromLocal];
    }else if (self.type == 3){
      entity.data = [CGCompanyDao getCompanyStatisticsFromLocal];
    }else if (self.type == 4){
      entity.data = [CGCompanyDao getFigureStatisticsFromLocal];
    }else if(self.type == 9){
      entity.data = [CGCompanyDao getGroupStatisticsFromLocal];
    }
    [_typeArray addObject:entity];
    [self getStatisticsData];
    [_typeArray addObject:[[CGAttentionEntity alloc]initWithRolId:self.attentionID rolName:@"名单" type:self.type]];
  }
  return _typeArray;
}

-(void)getStatisticsData{
  CGAttentionEntity *entity = _typeArray[1];
  AttentionBiz *biz = [[AttentionBiz alloc]init];
  [biz radarGroupDetailsStatisticsWithType:entity.type ID:entity.rolId page:0 success:^(NSMutableArray *result) {
    entity.data = result;
  } fail:^(NSError *error) {
    
  }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  [self.bigTypeScrollView setSelectIndex:[self currentPage]];
  self.selectButton.selected = NO;
  switch ([self currentPage]) {
    case 0:
      self.dynamicButton.selected = YES;
      self.selectButton = self.dynamicButton;
      break;
    case 1:
      self.statisticsButton.selected = YES;
      self.selectButton = self.statisticsButton;
      break;
    case 2:
      self.listButton.selected = YES;
      self.selectButton = self.listButton;
      break;
    default:
      break;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake([self currentPage]*100+32, 38, 35, 2);
  }];
  self.rightBtn.hidden = [self currentPage]==2?NO:YES;
}

- (IBAction)topButtonClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  self.selectIndex = sender.tag;
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake(sender.tag*100+32, 38, 35, 2);
  }];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
  NSString *index = [NSString stringWithFormat:@"%d",self.selectIndex];
  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
  [user setObject:index forKey:@"selectIndex"];
  self.rightBtn.hidden = sender.tag==2?NO:YES;
    [user synchronize];
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
  return 3;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"AttentionCompetitorsCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  AttentionCompetitorsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  CGAttentionEntity *entity = [self.typeArray objectAtIndex:indexPath.section];
  __weak typeof(self) weakSelf = self;
  [cell updateUIWithEntity:entity didSelectEntityDynamicBlock:^(id entity) {
    CGInfoHeadEntity *info = entity;
    if (info.infoId.length<=0 || info.type == 15) {
      return;
    }
    CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
      
    }];
    detail.info = info;
    [weakSelf.navigationController pushViewController:detail animated:YES];
  } listBlock:^(id entity) {
    AttentionHead *info = entity;
    if (info.type == 18) {
      CGAttentionDynamicViewController *vc = [[CGAttentionDynamicViewController alloc]init];
      vc.type = info.type;
      vc.dynamicID = info.infoId;
      vc.title = info.title;
      [self.navigationController pushViewController:vc animated:YES];
    }else{
      CGAttentionProductViewController *vc = [[CGAttentionProductViewController alloc]init];
      vc.titleText = info.title;
      vc.attentionID = info.infoId;
      vc.type = info.type;
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }
  } statisticsBlock:^(id entity) {
    AttentionStatisticsEntity *info = entity;
    CGAttentionDynamicViewController *vc = [[CGAttentionDynamicViewController alloc]init];
    vc.dynamicID = weakSelf.attentionID;
    vc.title = weakSelf.titleText;
    vc.type = weakSelf.type;
    vc.navTypeId = info.typeId;
    [weakSelf.navigationController pushViewController:vc animated:YES];
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
