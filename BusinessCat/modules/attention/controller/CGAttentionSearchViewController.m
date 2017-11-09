//
//  CGAttentionSearchViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionSearchViewController.h"
#import "HeadlineBiz.h"
#import "CGHorrolEntity.h"
#import "CGHorrolView.h"
#import "CGInfoHeadEntity.h"
#import "CollectionViewCell.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGDiscoverLink.h"
#import "CGLineLayout.h"
#import "WKWebViewController.h"
#import "CGHeadlineBigImageViewController.h"

@interface CGAttentionSearchViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textField;
//@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property(nonatomic,retain)NSMutableArray *typeArray;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, assign) BOOL isClick;
@property (weak, nonatomic) IBOutlet UIButton *productButton;
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *figureButton;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIButton *keyWordButton;
@property (weak, nonatomic) IBOutlet UIButton *indexCompanyButton;
@property (weak, nonatomic) IBOutlet UIButton *indexFigureButton;
@property (weak, nonatomic) IBOutlet UIButton *indexProductButton;

@property (weak, nonatomic) IBOutlet UIView *attentionIndexView;
@property (weak, nonatomic) IBOutlet UIView *attentionGroupView;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation CGAttentionSearchViewController

-(instancetype)initWithClear:(CGAttentionSearchDetailClearBlock)cancel{
  self = [super init];
  if(self){
    
    clearBlock = cancel;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.selectIndex = 0;
  self.isClick = YES;
  [self getNaviButton];
  self.collectionView.pagingEnabled=YES;
  self.textField.text = self.keyWord;
  self.textField.delegate = self;
  self.selectButton = self.isAttentionIndex?self.indexProductButton:self.productButton;
    self.line.backgroundColor = CTThemeMainColor;
    [self.productButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [self.companyButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [self.figureButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [self.keyWordButton setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    self.attentionIndexView.hidden = self.isAttentionIndex?NO:YES;
    self.attentionGroupView.hidden = self.isAttentionIndex?YES:NO;
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
  viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
  self.collectionView.collectionViewLayout = viewLayout;
  
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  if (textField.text.length<=0) {
    clearBlock(YES);
  }else{
    clearBlock(NO);
  }
  [self.navigationController popViewControllerAnimated:NO];
}

- (void)getNaviButton{
  self.textField = [[UITextField alloc]initWithFrame:CGRectMake(55, 27, SCREEN_WIDTH-70, 30)];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
  UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
  [view addSubview:iv];
  iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
  self.textField.leftView = view;
  self.textField.font = [UIFont systemFontOfSize:15];
  self.textField.leftViewMode = UITextFieldViewModeAlways;
  self.textField.borderStyle = UITextBorderStyleRoundedRect;
  self.textField.placeholder = @"请输入关键字";
  self.textField.returnKeyType = UIReturnKeySearch;
  self.textField.enablesReturnKeyAutomatically = YES;
  self.textField.delegate = self;
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  [self.navi addSubview:self.textField];
}

- (void)baseBackAction{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count-3)]  animated:YES];
}

-(NSMutableArray *)typeArray{
  if(!_typeArray){
    _typeArray = [NSMutableArray array];
    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"8" rolName:@"产品" sort:0]];
    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"3" rolName:@"公司" sort:1]];
    [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"4" rolName:@"人物" sort:2]];
    if (!self.isAttentionIndex) {
     [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"18" rolName:@"关键字" sort:3]];
    }
  }
  return _typeArray;
}

//获取当前在哪页
-(int)currentPage{
  int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
  self.selectIndex = pageWidth;
  return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  self.selectButton.selected = NO;
  if (self.isAttentionIndex) {
    switch ([self currentPage]) {
      case 0:
        self.indexProductButton.selected = YES;
        self.selectButton = self.indexProductButton;
        break;
      case 1:
        self.indexProductButton.selected = YES;
        self.selectButton = self.indexProductButton;
        break;
      case 2:
        self.indexFigureButton.selected = YES;
        self.selectButton = self.indexFigureButton;
        break;
      default:
        break;
    }
  }else{
    switch ([self currentPage]) {
      case 0:
        self.productButton.selected = YES;
        self.selectButton = self.productButton;
        break;
      case 1:
        self.companyButton.selected = YES;
        self.selectButton = self.companyButton;
        break;
      case 2:
        self.figureButton.selected = YES;
        self.selectButton = self.figureButton;
        break;
      case 3:
        self.keyWordButton.selected = YES;
        self.selectButton = self.keyWordButton;
        break;
        
      default:
        break;
    }
  }
  [UIView animateWithDuration:0.3 animations:^{
    if (self.isAttentionIndex) {
      self.line2.frame = CGRectMake([self currentPage]*100+32, 38, 35, 2);
    }else{
     self.line.frame = CGRectMake([self currentPage]*75+18, 38, 35, 2);
    }
  }];
}
- (IBAction)topButtonClick:(UIButton *)sender {
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  self.selectIndex = sender.tag;
  [UIView animateWithDuration:0.3 animations:^{
    if (self.isAttentionIndex) {
      self.line2.frame = CGRectMake(sender.tag*100+32, 38, 35, 2);
    }else{
      self.line.frame = CGRectMake(sender.tag*75+18, 38, 35, 2);
    }
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
  return self.typeArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
  CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

  cell.isAttention = self.isAttentionIndex?NO:YES;
  cell.subjectId = self.subjectId;
  CGHorrolEntity *entity = [self.typeArray objectAtIndex:indexPath.section];
  __weak typeof(self) weakSelf = self;
  [cell updateUIWithEntity:entity keyWord:self.keyWord action:self.action typeID:nil didSelectEntityBlock:^(id entity) {
    if ([entity isKindOfClass:[CGInfoHeadEntity class]]) {
      CGInfoHeadEntity *info = entity;
      if (info.infoId.length<=0 || info.type == 15) {
        return;
      }
      CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
        
      }];
      detail.info = info;
      [weakSelf.navigationController pushViewController:detail animated:YES];
    }else if ([entity isKindOfClass:[CGDiscoverLink class]]){
      CGDiscoverLink *link = entity;
      CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
        
      }];
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }
  } interfaceSelectIndex:^(NSMutableArray *array, NSInteger index) {
    CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
    vc.array = array;
    vc.currentPage = index;
    [weakSelf.navigationController pushViewController:vc animated:NO];
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
