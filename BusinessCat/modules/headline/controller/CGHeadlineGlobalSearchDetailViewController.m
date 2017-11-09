//
//  CGHeadlineGlobalSearchDetailViewController.m
//  CGSays
//
//  Created by zhu on 16/11/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHeadlineGlobalSearchDetailViewController.h"
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
#import "CGAttentionProductViewController.h"
#import "CGBoundaryCollectionViewCell.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>
#import "commonViewModel.h"

@interface CGHeadlineGlobalSearchDetailViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property(nonatomic,retain)NSMutableArray *typeArray;
@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *tableviewArray;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIButton *selectButton;
@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGHeadlineGlobalSearchDetailViewController

-(NSMutableString *)speekWord{
  if(!_speekWord){
    _speekWord = [NSMutableString string];
  }
  return _speekWord;
}

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

-(instancetype)initWithClear:(CGHeadlineGlobalSearchDetailClearBlock)cancel voiceSearchBlock:(CGHeadlineGlobalVoiceSearchBlock)voiceSearchBlock{
    self = [super init];
    if(self){
        
        clearBlock = cancel;
      voiceBlock = voiceSearchBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.view addSubview:self.bigTypeScrollView];
  if (![CTStringUtil stringNotBlank:self.selectIndex]) {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *selectIndex = [ user objectForKey:@"selectIndex"];
    self.selectIndex = [NSString stringWithFormat:@"%d",selectIndex.length<=0?0:selectIndex.intValue];
  }
  [self.bigTypeScrollView setSelectIndex:self.selectIndex.intValue];
    self.isClick = YES;
    [self getNaviButton];
    self.collectionView.pagingEnabled=YES;
    self.textField.text = self.keyWord;
    self.textField.delegate = self;
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
    viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex.intValue, 0.f);
    self.collectionView.collectionViewLayout = viewLayout;
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.selectIndex.integerValue == 2) {
    [self.collectionView reloadData]; 
  }
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
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
  UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(55, 27, SCREEN_WIDTH-70, 30)];
  [self.navi addSubview:bgView];
  bgView.layer.cornerRadius = 4;
  bgView.backgroundColor = [UIColor whiteColor];
  bgView.layer.masksToBounds = YES;
  UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-30, 0, 30, 30)];
  [searchBtn addTarget:self action:@selector(voiceSearch) forControlEvents:UIControlEventTouchUpInside];
  [searchBtn setImage:[UIImage imageNamed:@"searchVoiceinput"] forState:UIControlStateNormal];
  [bgView addSubview:searchBtn];
  self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-70-30, 30)];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
  UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
  [view addSubview:iv];
  iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
  self.textField.leftView = view;
  self.textField.font = [UIFont systemFontOfSize:15];
  self.textField.leftViewMode = UITextFieldViewModeAlways;
  self.textField.borderStyle = UITextBorderStyleNone;
  self.textField.placeholder = @"请输入关键字";
  self.textField.returnKeyType = UIReturnKeySearch;
  self.textField.enablesReturnKeyAutomatically = YES;
  self.textField.delegate = self;
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  [self.navi addSubview:self.textField];
  [bgView addSubview:self.textField];
}

-(void)voiceSearch{
  [self.textField resignFirstResponder];
  //初始化语音识别控件
  self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
  self.iflyRecognizerView.delegate = self;
  [self.iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
  //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
  [self.iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
  //启动识别服务
  [self.iflyRecognizerView start];
}

/*科大讯飞语音识别回调
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast{
  for(NSString *key in [resultArray[0] allKeys]){
    NSData *wordData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *allWordDict = [NSJSONSerialization JSONObjectWithData:wordData options:kNilOptions error:nil];
    NSArray *wordArray = [allWordDict objectForKey:@"ws"];
    for(NSDictionary *wordDict in wordArray){
      for(NSDictionary *itemWord in [wordDict objectForKey:@"cw"]){
        NSString *end = [itemWord objectForKey:@"w"];
        if(![end containsString:@"。"] && ![end containsString:@"，"]&& ![end containsString:@"！"]){
          [self.speekWord appendString:end];
        }
      }
    }
  }
  if(isLast){//最后一次
    NSString *word = self.speekWord;
    self.textField.text = word;
    if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
      self.keyWord = word;
      self.textField.text = word;
      voiceBlock(word);
      for (CGHorrolEntity *entity in self.typeArray) {
        entity.data = [NSMutableArray array];
      }
      [self.collectionView reloadData];
    }
    self.speekWord = nil;
    self.iflyRecognizerView = nil;
  }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error{
  
}

- (void)baseBackAction{
      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count-3)]  animated:YES];
}

-(NSMutableArray *)typeArray{
    if(!_typeArray){
        _typeArray = [NSMutableArray array];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"1" rolName:@"知识" sort:0]];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"14" rolName:@"文库" sort:5]];
        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"15" rolName:@"素材" sort:4]];
//        [_typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:@"25" rolName:@"工具" sort:6]];
    }
    return _typeArray;
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
  __weak typeof(self) weakSelf = self;
  if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
    _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
      [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        weakSelf.selectIndex = [NSString stringWithFormat:@"%d",index];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.selectIndex forKey:@"selectIndex"];
        [user synchronize];
      }completion:^(BOOL finished) {
        
      }];
    }];
  }
  return _bigTypeScrollView;
}

//获取当前在哪页
-(int)currentPage{
    int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
    self.selectIndex = [NSString stringWithFormat:@"%d",pageWidth];
    return pageWidth;
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
    return self.typeArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 2) {
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CGBoundaryCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGBoundaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.typeID = self.typeID;
    cell.keyWord = self.keyWord;
    cell.action = self.action;
    [cell updateUIWithEntity:self.typeArray[indexPath.section] loadType:1 isCache:NO block:^(NSInteger index) {
//      NSMutableArray *array = [NSMutableArray array];
      CGHorrolEntity *typeEntity = weakSelf.typeArray[indexPath.section];
//      for (int i = 0; i<typeEntity.data.count; i++) {
//        CGInfoHeadEntity *entity = typeEntity.data[i];
//        NSString *cover = entity.cover;
//        [array addObject:cover];
//      }
      CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
      vc.array = typeEntity.data;
      vc.currentPage = index;
      [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    return cell;
  }
  
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGHorrolEntity *entity = [self.typeArray objectAtIndex:indexPath.section];
    __weak typeof(self) weakSelf = self;
    [cell updateUIWithEntity:entity keyWord:self.keyWord action:self.action typeID:self.typeID didSelectEntityBlock:^(id entity) {
        if ([entity isKindOfClass:[CGInfoHeadEntity class]]) {
            CGInfoHeadEntity *info = entity;
//            if (info.infoId.length<=0 || info.type == 15) {
//                return;
//            }
//          CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
//            
//          }];
//          detail.info = info;
//          [weakSelf.navigationController pushViewController:detail animated:YES];
//
          [weakSelf.viewModel messageCommandWithCommand:info.command parameterId:info.parameterId commpanyId:info.commpanyId recordId:info.recordId messageId:info.messageId detial:info typeArray:nil];
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

- (BOOL)isSupportPanReturnBack{
  return NO;
}

@end
