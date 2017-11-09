//
//  CGTeamDocumentViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGTeamDocumentViewController.h"
#import "CGHorrolView.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGTeamDocumentCollectionViewCell.h"
#import "CGKnowledgeCatalogController.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGVipListEntity.h"
#import "CGDiscoverBiz.h"
#import "CGLineLayout.h"
#import "commonViewModel.h"

@interface CGTeamDocumentViewController ()
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *joinOrganizationButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTop;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) commonViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation CGTeamDocumentViewController

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

-(CGDiscoverBiz *)biz{
  if (!_biz) {
    _biz = [[CGDiscoverBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  if (self.type == 2) {
    [self getCompanyList];
  }else{
    [self.biz.component startBlockAnimation];
    __weak typeof(self) weakSelf = self;
    [self.biz userVipListWithType:self.type success:^(NSMutableArray *result) {
      weakSelf.dataArray = [NSMutableArray array];
      for (CGVipListEntity *entity in result) {
        CGHorrolEntity *info = [[CGHorrolEntity alloc]initWithRolId:entity.packageId rolName:entity.gradeName sort:0];
        [weakSelf.dataArray addObject:info];
      }
      [weakSelf.topView addSubview:weakSelf.bigTypeScrollView];
      if (result.count == 1) {
        CGVipListEntity *entity = result[0];
        weakSelf.title = [NSString stringWithFormat:@"%@区",entity.gradeName];
      }
      [weakSelf updateTopViewState];
      [weakSelf.collectionView reloadData];
      [weakSelf.biz.component stopBlockAnimation];
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
    }];
  }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
  [self.biz.component stopBlockAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinOrganizationClick:(UIButton *)sender {
}

-(void)updateTopViewState{
  if (self.dataArray.count>0) {
    if (self.dataArray.count == 1) {
      self.collectionTop.constant = 64;
      self.topView.hidden = YES;
    }else{
      self.collectionTop.constant =104;
      self.topView.hidden = NO;
    }
  }else{
    self.collectionTop.constant = 64;
    self.topView.hidden = YES;
  }
}

-(void)getCompanyList{
  [self updateTopViewState];
  //  __weak typeof(self) weakSelf = self;
  if ([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (companyEntity.auditStete == 1) {
        CGHorrolEntity *entity;
        if (companyEntity.companyType == 2) {
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
        }else{
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
        }
        if ([companyEntity.companyId isEqualToString:self.companyID]) {
          CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
          viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
          self.collectionView.collectionViewLayout = viewLayout;
          [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
        }
        entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
        [self.dataArray addObject:entity];
      }
    }
    [self.topView addSubview:self.bigTypeScrollView];
    [self updateTopViewState];
    [self.collectionView reloadData];
  }
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  //  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    [_bigTypeScrollView removeFromSuperview];
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.dataArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      __weak typeof(self) weakSelf = self;
      [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
      weakSelf.selectIndex = index;
    }];
  }
  return _bigTypeScrollView;
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
  return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGTeamDocumentCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CGTeamDocumentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  __weak typeof(self) weakSelf = self;
  [cell updateUIWithEntity:self.dataArray[indexPath.section] type:self.type showType:self.showType block:^(CGInfoHeadEntity *entity) {
      if(entity.layout == ContentLayoutCatalog){//目录
        CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:entity.packageId companyId:nil cataId:entity.infoId];
        controller.titleStr = entity.title;
        controller.isShowMenu = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
      }else{//非目录
        [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:entity typeArray:nil];
//        CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:entity.infoId type:entity.type block:^{
//    
//        }];
//        detail.info = entity;
//        [weakSelf.navigationController pushViewController:detail animated:YES];
      }
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
