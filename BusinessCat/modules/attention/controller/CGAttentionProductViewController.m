//
//  CGAttentionProductViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionProductViewController.h"
#import "CGAttentionEntity.h"
#import "AttentionCompetitorsCollectionViewCell.h"
#import "CGInfoHeadEntity.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGAttentionDynamicViewController.h"
#import "AttentionStatisticsEntity.h"
#import "CGCompanyDao.h"
#import "AttentionBiz.h"


@interface CGAttentionProductViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation CGAttentionProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = self.titleText;
  self.selectIndex = 0;
  self.isClick = YES;
  self.selectButton = self.dynamicButton;
    self.line.backgroundColor = CTThemeMainColor;
    [self.dynamicButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [self.statisticsButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 30, 24, 24)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  NSString *rightStr = @"";
  if (self.type == 8) {
    rightStr = @"xchanpin";
  }else if (self.type == 3){
    rightStr = @"xcompanyanalysis";
  }else if (self.type == 4){
    rightStr = @"xcharacteranalysis";
  }
  [self.rightBtn setImage:[UIImage imageNamed:rightStr] forState:UIControlStateNormal];
  [self.navi addSubview:self.rightBtn];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBtnAction:(UIButton *)sender{
  __weak typeof(self) weakSelf = self;
  if (self.type == 8) {
    if (self.isClick) {
      self.isClick = NO;
      NSString *code = [NSString stringWithFormat:@"details/productDetails?id=%@",self.attentionID];
      [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
      } fail:^{
        weakSelf.isClick = YES;
      }];
    }
  }else if (self.type == 3){
    if (self.isClick) {
      self.isClick = NO;
      NSString *code = [NSString stringWithFormat:@"details/companyDetails?id=%@",self.attentionID];
      [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
      } fail:^{
        weakSelf.isClick = YES;
      }];
      
    }
  }else if (self.type == 4){
    if (self.isClick) {
      self.isClick = NO;
      NSString *code = [NSString stringWithFormat:@"details/figureDetails?id=%@",self.attentionID];
      [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
      } fail:^{
        weakSelf.isClick = YES;
      }];
    }
  }
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

-(NSMutableArray *)typeArray{
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
    default:
      break;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake([self currentPage]*150+58, 38, 35, 2);
  }];
}
- (IBAction)topButtonClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  self.selectIndex = sender.tag;
  [UIView animateWithDuration:0.3 animations:^{
    self.line.frame = CGRectMake(sender.tag*150+58, 38, 35, 2);
  }];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
  NSString *index = [NSString stringWithFormat:@"%d",self.selectIndex];
  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
  [user setObject:index forKey:@"selectIndex"];
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
  return 2;
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
