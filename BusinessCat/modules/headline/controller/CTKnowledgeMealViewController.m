//
//  CTKnowledgeMealViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTKnowledgeMealViewController.h"
#import "CGHorrolView.h"
#import "CGKnowledgeMealCollectionViewCell.h"
#import "CGKnowledgeBiz.h"
#import "CGKnowledgeCatalogController.h"
#import "CTButtonRightImg.h"
#import "CGNavTypeSelector.h"
#import "CGDatePickerView.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGMainLoginViewController.h"
#import "CGKnowledgePushView.h"
#import "KnowledgeBaseEntity.h"
#import "AttentionBiz.h"
#import "commonViewModel.h"
#import "CGTutorialViewController.h"
#import "CGUserCenterBiz.h"

#define ShowDayNum 8

@interface CTKnowledgeMealViewController ()
@property(nonatomic,retain)CGHorrolEntity *currentNavType;
@property(nonatomic,retain)CGDatePickerView *picker;
@property(nonatomic,retain)UIButton *calendarBtn;
@property (nonatomic, strong) KnowledgeHeaderEntity *selectItem;
@property(nonatomic,retain)CTButtonRightImg *navTypeBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray<CGHorrolEntity *> *typeArray;
@property(nonatomic,retain)NSString *selectDayString;//当前的日期 格式：20170526
@property(nonatomic,retain)NSString *tomorrowString;//明天的日期 格式：20170527
@property(nonatomic,retain)NSString *selectFromCalendar;//从日历选择了日期
@property (nonatomic, strong) CGKnowledgePushView *pushView;
@property (weak, nonatomic) IBOutlet UIView *noIdentifyView;
@property (nonatomic, strong) commonViewModel *viewModel;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) NSMutableArray *directoryFristArray;
@end

@implementation CTKnowledgeMealViewController

-(void)tokenCheckComplete:(BOOL)state{
    if (state) {
        [self checkDateState];
    }
}

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

//加载完成分类回调，为了避免今日知识和岗位知识的分类的公用处理
-(void)loadNavTypeFinish{
    [self setDefaultNavType];
}

-(UIButton *)calendarBtn{
    if(!_calendarBtn){
        _calendarBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
        [_calendarBtn setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
        [_calendarBtn addTarget:self action:@selector(clickCalendarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calendarBtn;
}
-(CTButtonRightImg *)navTypeBtn{
    if(!_navTypeBtn){
        _navTypeBtn = [[CTButtonRightImg alloc]initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, 44)];
        UIImage *image = [[UIImage imageNamed:@"triangle"] imageWithTintColor:[UIColor blackColor]];
        [_navTypeBtn setImage:image forState:UIControlStateNormal];
        [_navTypeBtn addTarget:self action:@selector(clickNavTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _navTypeBtn;
}

-(CGDatePickerView *)picker{
    __weak typeof(self) weakSelf = self;
    if(!_picker){
        _picker = [[CGDatePickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) block:^(NSDate *date) {
            weakSelf.calendarBtn.selected = NO;
            NSString *dateString = [CTDateUtils formatDateToYYYYMMDD:date];
            CGHorrolEntity *entity = [[CGHorrolEntity alloc]initWithRolId:dateString rolName:[CTDateUtils formatDateToYYMD:date] sort:0];
            if(!weakSelf.selectFromCalendar && weakSelf.typeArray.count <= ShowDayNum){
                [weakSelf.typeArray insertObject:entity atIndex:0];
                [weakSelf.bigTypeScrollView insertEntity:entity];
            }else{
                [weakSelf.typeArray replaceObjectAtIndex:0 withObject:entity];
                [weakSelf.bigTypeScrollView replaceEntity:entity];
            }
            weakSelf.selectFromCalendar = dateString;
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [weakSelf.collectionView reloadData];
            [self.bigTypeScrollView setSelectIndex:0];
        } cancel:^{
            weakSelf.calendarBtn.selected = NO;
        }];
    }
    return _picker;
}

//点击日历事件
-(void)clickCalendarAction:(UIButton *)button{
    if(!button.selected){
        button.selected = YES;
        [self.picker showInView:[UIApplication sharedApplication].keyWindow];
    }
}

//点击分类事件
-(void)clickNavTypeAction:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    self.pushView = [[CGKnowledgePushView alloc]initWithArray:[ObjectShareTool sharedInstance].knowledgeBigTypeData select:self.currentNavType block:^(CGHorrolEntity *entity) {
      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      [user setObject:entity.rolId forKey:@"knowledgeSelectID"];
        button.selected = NO;
        weakSelf.currentNavType = entity;
        [weakSelf.navTypeBtn setTitle:entity.rolName forState:UIControlStateNormal];
      for (KnowledgeBaseEntity *bigtype in [ObjectShareTool sharedInstance].knowledgeBigTypeData) {
        if ([bigtype.navType isEqualToString:entity.rolId]) {
          if (bigtype.state == 2) {
            self.noIdentifyView.hidden = NO;
          }else{
            self.noIdentifyView.hidden = YES;
          }
          break;
        }
      }
      for (CGHorrolEntity *entity in self.typeArray) {
        entity.data = [NSMutableArray array];
      }
        [weakSelf.collectionView reloadData];
    }];
}

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomBackBtn];
    [self.navi addSubview:self.navTypeBtn];
    [self.navi addSubview:self.calendarBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDateState) name:NotificationToApplicationDidBecomeActive object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jobknowledgeFirst) name:NOTIFICATION_JOBKNOWLEDGEFIRST object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePacker) name:NotificationDiscoverHasLastData object:nil];
    [self setDefaultNavType];
    [self checkDateState];
  
  
  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
  NSNumber *tutorial = [user objectForKey:@"fristTutorial"];
  if (tutorial.boolValue == NO) {
  __weak typeof(self) weakSelf = self;
  [self.biz authUserHelpCateListWithID:@"9f8209ca-827d-3a3a-da72-f51a1e4eddde" success:^(NSMutableArray *reslut) {
    weakSelf.directoryFristArray = reslut;
    [weakSelf.biz authUserHelpCateListWithID:@"ec3b8780-81f7-02a0-6df0-4793c6651e7c" success:^(NSMutableArray *reslut) {
      CGTutorialViewController *vc = [[CGTutorialViewController alloc]init];
      vc.modalPresentationStyle = UIModalPresentationCustom;
      vc.directoryFristArray = weakSelf.directoryFristArray;
      vc.directorySecondArray = reslut;
      vc.isFrist = YES;
      [weakSelf presentViewController:vc animated:YES completion:nil];
    } fail:^(NSError *error) {
    }];
  } fail:^(NSError *error) {
  }];
  }
}

-(void)updatePacker{
  NSDate *today = [CTDateUtils today];
  NSDate *tomorrow = [CTDateUtils tomorrowWithDate:today];
  NSDate *d = [CTDateUtils beforeDayWithDate:tomorrow beforeDate:1];
    if ([ObjectShareTool sharedInstance].currentUser.platformAdmin == 0) {
      [self.picker setMaxDateLimit:[CTDateUtils beforeDayWithDate:d beforeDate:1]];
    }else{
      [self.picker setMaxDateLimit:nil];
    }
}

-(void)jobknowledgeFirst{
  KnowledgeBaseEntity *bigtype = [ObjectShareTool sharedInstance].knowledgeBigTypeData[0];
  self.currentNavType = [[CGHorrolEntity alloc]initWithRolId:bigtype.navType rolName:bigtype.name sort:0];
  [self.navTypeBtn setTitle:bigtype.name forState:UIControlStateNormal];
  if (bigtype.state == 2) {
    self.noIdentifyView.hidden = NO;
  }else{
    self.noIdentifyView.hidden = YES;
  }
  [self.collectionView reloadData];
}

//收到推送处理
-(void)getPushDealWithRecordId:(NSString *)recordId parameterId:(NSString *)parameterId{
  [self.bigTypeScrollView setSelectIndex:0];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
  for (int i = 0; i<[ObjectShareTool sharedInstance].knowledgeBigTypeData.count; i++) {
    KnowledgeBaseEntity *bigtype = [ObjectShareTool sharedInstance].knowledgeBigTypeData[i];
    if ([bigtype.navType isEqualToString:recordId]) {
      self.currentNavType = [[CGHorrolEntity alloc]initWithRolId:bigtype.navType rolName:bigtype.name sort:0];
      [self.navTypeBtn setTitle:bigtype.name forState:UIControlStateNormal];
      if (bigtype.state == 2) {
        self.noIdentifyView.hidden = NO;
      }else{
        self.noIdentifyView.hidden = YES;
      }
      [self.collectionView reloadData];
      break;
    }
  }
}

-(void)setDefaultNavType{
    if([ObjectShareTool sharedInstance].knowledgeBigTypeData && [ObjectShareTool sharedInstance].knowledgeBigTypeData.count > 0){
      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      NSString *selectID = [user objectForKey:@"knowledgeSelectID"];
      NSInteger selectIndex = 0;
      for (int i = 0; i<[ObjectShareTool sharedInstance].knowledgeBigTypeData.count; i++) {
        KnowledgeBaseEntity *knowledgeEntity = [ObjectShareTool sharedInstance].knowledgeBigTypeData[i];
        if ([knowledgeEntity.navType isEqualToString:selectID]) {
          selectIndex = i;
          break;
        }
      }
        KnowledgeBaseEntity *first = [ObjectShareTool sharedInstance].knowledgeBigTypeData[selectIndex];
        self.currentNavType = [[CGHorrolEntity alloc]initWithRolId:first.navType rolName:first.name sort:0];
        [self.navTypeBtn setTitle:self.currentNavType.rolName forState:UIControlStateNormal];
      if (first.state == 2) {
        self.noIdentifyView.hidden = NO;
      }else{
        self.noIdentifyView.hidden = YES;
      }
        [self.collectionView reloadData];
    }
}

//检查日期是否发生变化
-(void)checkDateState{
    __weak typeof(self) weakSelf = self;
    NSDate *today = [CTDateUtils today];
    NSString *todayString = [CTDateUtils formatDateToYYYYMMDD:today];
    NSDate *tomorrow = [CTDateUtils tomorrowWithDate:today];
    NSString *tomorrowString = [CTDateUtils formatDateToYYYYMMDD:tomorrow];
    if(!self.tomorrowString || ![self.tomorrowString isEqualToString:tomorrowString] || !self.typeArray){//未有日期，当成变化
        self.selectFromCalendar = nil;
        self.selectDayString = todayString;
        self.tomorrowString = tomorrowString;
        [self.bigTypeScrollView removeFromSuperview];
        self.bigTypeScrollView = nil;
        self.typeArray = [NSMutableArray<CGHorrolEntity *> array];
        for(int i=1;i<=ShowDayNum;i++){
            NSDate *d = [CTDateUtils beforeDayWithDate:tomorrow beforeDate:i];
            NSString *week = [CTDateUtils weekdayStringFromDate:d];
            if(i == 1){
              if ([ObjectShareTool sharedInstance].currentUser.platformAdmin == 0) {
               [self.picker setMaxDateLimit:[CTDateUtils beforeDayWithDate:d beforeDate:1]];
              }else{
                [self.picker setMaxDateLimit:nil];
              }
            }
//            if(i == ShowDayNum){
//                week = @"明天";
//              continue;
//            }else
              if(i == 1){
                week = @"今天";
            }else if(i == 2){
                week = @"昨天";
            }
            NSString *ds = [CTDateUtils formatDateToYYYYMMDD:d];
            [self.typeArray addObject:[[CGHorrolEntity alloc]initWithRolId:ds rolName:week sort:i]];
        }
        [self.topView addSubview:self.bigTypeScrollView];
        //日期发生变化，默认选中今天
        [self.bigTypeScrollView setSelectIndex:0];
        [weakSelf.collectionView reloadData];
        [self performSelector:@selector(scrollToToday) withObject:nil afterDelay:0.3];
        
    }
}

-(void)scrollToToday{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict{
    [self checkDateState];
  NSNumber *page = dict[@"clickOnPage"];
  if (page.integerValue == 1) {
    CGKnowledgeMealCollectionViewCell *cell = (CGKnowledgeMealCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self currentPage]]];
    [cell.tableView.mj_header beginRefreshing];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
    __weak typeof(self) weakSelf = self;
    if(!_bigTypeScrollView){
        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.typeArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                weakSelf.selectDayString = data.rolId;
            }completion:^(BOOL finished) {
                
            }];
        }];
    }
    return _bigTypeScrollView;
}

//获取当前在哪页
-(int)currentPage{
    int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
    return pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.bigTypeScrollView setSelectIndex:[self currentPage]];
}

#pragma mark UICollectionViewDelegate&UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.typeArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.section];
    [collectionView registerNib:[UINib nibWithNibName:@"CGKnowledgeMealCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    CGKnowledgeMealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGHorrolEntity *entity = self.typeArray[indexPath.section];
    [cell updateCell:entity navType:self.currentNavType block:^(CGInfoHeadEntity *item) {
      [weakSelf.viewModel messageCommandWithCommand:item.command parameterId:item.parameterId commpanyId:item.commpanyId recordId:item.recordId messageId:item.messageId detial:nil typeArray:nil];
//      weakSelf.selectItem = item;
//        if(item.onlyVip == 1 && ![ObjectShareTool sharedInstance].currentUser.isLogin){
//            CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
//              [weakSelf jumpInDetail:item];
//            } fail:^(NSError *error) {
//              
//            } ];
//          [weakSelf.navigationController pushViewController:controller animated:YES];
//        }else{
//            [weakSelf jumpInDetail:item];
//        }
    } topBlock:^(BannerData *entity) {
      [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.parameterId commpanyId:entity.commpanyId recordId:entity.recordId messageId:entity.messageId detial:nil typeArray:nil];
    }];
    return cell;
}

-(void)jumpInDetail:(KnowledgeHeaderEntity *)item{
    if(item.packageType == 26){
        CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:item.mainId packageId:item.packageId companyId:nil cataId:nil];
      controller.icon = item.packageCover;
      controller.titleStr = item.packageTitle;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:item.packageId type:item.packageType block:^{
            
        }];
        CGInfoHeadEntity *info = [[CGInfoHeadEntity alloc]init];
        info.infoId = item.packageId;
        info.type = item.packageType;
        detail.info = info;
        [self.navigationController pushViewController:detail animated:YES];
    }
    item.readNum += 1;
    [self.collectionView reloadData];
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionView.bounds.size;
}




@end
