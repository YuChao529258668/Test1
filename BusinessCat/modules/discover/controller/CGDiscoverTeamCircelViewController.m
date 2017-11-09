//
//  CGDiscoverTeamCircelViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGDiscoverTeamCircelViewController.h"
#import "CGHorrolView.h"
#import "CGCompanyDao.h"
#import "CGUserDao.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserCenterBiz.h"
#import "TeamCircelCollectionViewCell.h"
#import "DiscoverPushView.h"
#import "CGDiscoverReleaseSourceViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGMainLoginViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "CGExceptionalViewController.h"
#import "TeamCircleDao.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGLineLayout.h"
#import "CGDiscoverTeamDetailViewController.h"
#import "CellLayout.h"
#import "TeamCircleMessageListController.h"

@interface CGDiscoverTeamCircelViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property (nonatomic, strong) NSMutableArray *companyArray;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTop;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CGHorrolEntity *noCompanyentity;
@property (nonatomic, assign) NSInteger needOpenCellIndexPath;
@property (nonatomic, assign) NSInteger exceptionalIndex;
@end

@implementation CGDiscoverTeamCircelViewController

static CGDiscoverTeamCircelViewController *_sharedManager;

+ (CGDiscoverTeamCircelViewController *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_sharedManager){
            _sharedManager = [[CGDiscoverTeamCircelViewController alloc]init];
        }
    });
    return _sharedManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业圈";
    self.selectIndex = 0;
    [self getNaviButton];
    self.addButton.backgroundColor = CTThemeMainColor;
    self.noCompanyentity = [[CGHorrolEntity alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(organizaChange) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLoginSuccess) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headlineFact:) name:NOTIFICATION_HEADLINE_FACT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:NOTIFICATION_INTEGRALEXCEPTIONALSUCCESS object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDiscoverHasLastData:) name:NotificationDiscoverHasLastData object:nil];
    [self getCompanyList];
  if (self.companyArray.count>0) {
    CGHorrolEntity *data = self.companyArray[0];
    if (data.rolType.intValue == 4) {
      self.rightBtn.hidden = YES;
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)notificationDiscoverHasLastData:(NSNotification *)notification{
  TeamCircleLastStateEntity *entity = notification.object;
  [self.bigTypeScrollView notificationDiscoverHasLastDataWith:entity];
}


-(NSMutableArray *)companyArray{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

-(void)headlineFact:(NSNotification *)noti{
    NSNumber *index = [noti object];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index.integerValue] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.selectIndex = index.integerValue;
    [self.bigTypeScrollView setSelectIndex:index.intValue];
    __weak typeof(self) weakSelf = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index.integerValue];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        TeamCircelCollectionViewCell *cell = (TeamCircelCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
        [cell.tableView.mj_header beginRefreshing];
    });
}

-(void)organizaChange{
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
        CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
        NSString *companyID;
        if (companyEntity.companyType == 2) {
            companyID = companyEntity.classId;
        }else{
            companyID = companyEntity.companyId;
        }
        [array1 addObject:companyID];
    }
    NSMutableArray *array2= [NSMutableArray array];
    for (CGHorrolEntity *entity in self.companyArray) {
        [array2 addObject:entity.rolId];
    }
    if (![array1 isEqual:array2]) {
        self.bigTypeScrollView.array = [NSMutableArray array];
        [self getCompanyList];
        [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
    }
}

#pragma mark -- 剩下的工作就是在UICollectionView 所在的ViewController设置偏移量
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGLineLayout *viewLayout = [[CGLineLayout alloc] init];
    viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
    self.collectionView.collectionViewLayout = viewLayout;
    self.collectionView.contentOffset = CGPointMake(SCREEN_WIDTH *self.selectIndex, 0.f);
    [self.bigTypeScrollView setSelectIndex:(int)self.selectIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectIndex];
    TeamCircelCollectionViewCell *cell = (TeamCircelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    if(cell.entity.data && cell.entity.data.count > 0){
//        [cell getLastListData];
//    }
  
}

//登录后收到的通知
-(void)notificationLoginSuccess{
    __weak typeof(self) weakSelf = self;
    if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
            CGHorrolEntity *entity;
            if (companyEntity.companyType == 2) {
                entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
            }else{
                entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
            }
            entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
            [TeamCircleDao queryMonitorinListFromDBWithOrganizationID:companyEntity.companyId success:^(NSMutableArray *result) {
                entity.data = result;
                if (i==0) {
                    [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:i]]];
                }
            } fail:^(NSError *error) {
                
            }];
          if (companyEntity.auditStete == 1) {
            entity.icon = companyEntity.scoopCover;
            [self.companyArray addObject:entity];
          }
        }
        [self updateTopViewState];
        self.bigTypeScrollView.array = nil;
        [self.companyView addSubview:self.bigTypeScrollView];
        [self.collectionView reloadData];
    }
}

-(void)logout{
    self.companyArray = [NSMutableArray array];
    [self.companyView addSubview:self.bigTypeScrollView];
    [self updateTopViewState];
    [self.collectionView reloadData];
}

-(void)paySuccess{
    SourcePay *enitity = [[SourcePay alloc]init];
    enitity.uid = [ObjectShareTool sharedInstance].currentUser.uuid;
    enitity.nickname = [ObjectShareTool sharedInstance].currentUser.nickname;
    enitity.portrait = [ObjectShareTool sharedInstance].currentUser.portrait;
    if (self.companyArray.count<=0) {
        CellLayout *cellLayout = self.noCompanyentity.data[self.exceptionalIndex];
        if (cellLayout.entity.payList.count<=0) {
            cellLayout.entity.payList = [NSMutableArray arrayWithObjects:enitity, nil];
        }else{
            [cellLayout.entity.payList addObject:enitity];
        }
        CellLayout *layout = [self layoutWithStatusModel:cellLayout.entity];
        [self.noCompanyentity.data replaceObjectAtIndex:self.exceptionalIndex withObject:layout];
        [TeamCircleDao updateTeamCircleWithScoopID:cellLayout.entity.scoopID info:cellLayout.entity];
    }else{
        CGHorrolEntity *horrolentity = [self.companyArray objectAtIndex:self.selectIndex];
        CellLayout *cellLayout = horrolentity.data[self.exceptionalIndex];
        if (cellLayout.entity.payList.count<=0) {
            cellLayout.entity.payList = [NSMutableArray arrayWithObjects:enitity, nil];
        }else{
            [cellLayout.entity.payList addObject:enitity];
        }
        [TeamCircleDao updateTeamCircleWithScoopID:cellLayout.entity.scoopID info:cellLayout.entity];
        CellLayout *layout = [self layoutWithStatusModel:cellLayout.entity];
        [horrolentity.data replaceObjectAtIndex:self.exceptionalIndex withObject:layout];
    }
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:self.selectIndex]]];
}

- (CellLayout *)layoutWithStatusModel:(CGSourceCircleEntity *)statusModel{
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel isUnfold:NO dateFormatter:self.dateFormatter];
    return layout;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

-(void)getCompanyList{
    [self updateTopViewState];
    if ([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
        self.companyArray = [NSMutableArray array];
        for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
            CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
            if (companyEntity.auditStete == 1) {
                CGHorrolEntity *entity;
                if (companyEntity.companyType == 2) {
                    entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
                }else{
                    entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
                }
                entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
                entity.icon = companyEntity.scoopCover;
                [self.companyArray addObject:entity];
            }
        }
        [self.companyView addSubview:self.bigTypeScrollView];
        [self updateTopViewState];
        [self.collectionView reloadData];
    }
}

- (void)getNaviButton{
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-36, 32, 20, 20)];
    [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [self.navi addSubview:self.rightBtn];
    
}

- (void)rightBtnAction:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
        if (isOutside == NO) {
            if (isCurrent == YES) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:weakSelf.selectIndex];
                TeamCircelCollectionViewCell *cell = (TeamCircelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.tableView.mj_header beginRefreshing];
            }else{
                weakSelf.needOpenCellIndexPath = YES;
                weakSelf.selectIndex = reloadIndex;
                [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:reloadIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                [weakSelf.bigTypeScrollView setSelectIndex:(int)reloadIndex];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    TeamCircelCollectionViewCell * cell = (TeamCircelCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:reloadIndex]];
                    [cell.tableView.mj_header beginRefreshing];
                });
            }
        }
    }];
    vc.selectIndex = self.selectIndex;
    if (self.companyArray.count>0) {
        vc.currentEntity = self.companyArray[self.selectIndex];
        vc.releaseType = DiscoverReleaseTypeCompany;
    }else{
        vc.releaseType = DiscoverReleaseTypeNoCompany;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//获取当前在哪页
-(int)currentPage{
    int pageWidth = self.collectionView.contentOffset.x/SCREEN_WIDTH;
    self.selectIndex = pageWidth;
    return pageWidth;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.bigTypeScrollView setSelectIndex:[self currentPage]];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    TeamCircelCollectionViewCell *targetCell = (TeamCircelCollectionViewCell *)cell;
    if(targetCell.entity.data && targetCell.entity.data.count > 0){
//        [targetCell getLastListData];
      [targetCell.tableView reloadData];
    }
}

- (void)searchBtnAction:(UIButton *)sender{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 16;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateTopViewState{
    if (self.companyArray.count>0) {
        self.topView.hidden = YES;
        if (self.companyArray.count == 1) {
            self.collectionTop.constant = 64;
            self.companyView.hidden = YES;
        }else{
            self.collectionTop.constant =104;
            self.companyView.hidden = NO;
        }
    }else{
        self.topView.hidden = NO;
        self.companyView.hidden = YES;
    }
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
    if(!_bigTypeScrollView || _bigTypeScrollView.array.count <= 0){
        [_bigTypeScrollView removeFromSuperview];
        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.companyArray finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            __weak typeof(self) weakSelf = self;
          weakSelf.selectIndex = index;
            weakSelf.rightBtn.hidden = data.rolType.intValue == 4?YES:NO;
            [weakSelf.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
          TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
          NSMutableArray *removeArray = [NSMutableArray array];
          for (TeamCircleCompanyState *state in entity.list) {
            if ([state.companyId isEqualToString:data.rolId]) {
              [removeArray addObject:state];
            }
          }
          [entity.list removeObjectsInArray:[removeArray copy]];
          [TeamCircleLastStateEntity saveToLocal:entity];
        }];
              TeamCircleLastStateEntity *entity = [TeamCircleLastStateEntity getFromLocal];
              [_bigTypeScrollView notificationDiscoverHasLastDataWith:entity];
    }
    return _bigTypeScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionViewDelegate&UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.companyArray.count<=0) {
        return 1;
    }
    return self.companyArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld",indexPath.section];
    //重用cell
    [collectionView registerNib:[UINib nibWithNibName:@"TeamCircelCollectionViewCell"
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    TeamCircelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    if (self.companyArray.count<=0) {
        [cell updateUIWithEntity:self.noCompanyentity block:^(NSInteger selectIndex, CGSourceCircleEntity *entity) {
            weakSelf.exceptionalIndex = selectIndex;
        } linkBlock:^(NSString *linkID, NSInteger linkType) {
            CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:linkID type:linkType block:^{
                
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } didSelectBlock:^(NSInteger selectIndex,CGSourceCircleEntity *entity) {
            CGDiscoverTeamDetailViewController *vc = [[CGDiscoverTeamDetailViewController alloc]initWithScoopID:entity.scoopID updateBlock:^(CellLayout *cellLayout) {
                [weakSelf.noCompanyentity.data replaceObjectAtIndex:selectIndex withObject:entity];
            } deleteBlock:^(CellLayout *cellLayout) {
                [weakSelf.noCompanyentity.data removeObjectAtIndex:selectIndex];
                [weakSelf.collectionView reloadData];
            }];
            vc.index = selectIndex;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } toMsgBlock:^(NSString *companyId, int companyType) {
            TeamCircleMessageListController *controller = [[TeamCircleMessageListController alloc]initWithCompanyId:companyId companyType:companyType];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
    }else{
        CGHorrolEntity *horrolentity = [self.companyArray objectAtIndex:indexPath.section];
        [cell updateUIWithEntity:horrolentity block:^(NSInteger selectIndex, CGSourceCircleEntity *entity) {
            weakSelf.exceptionalIndex = selectIndex;
            CGExceptionalViewController *vc = [[CGExceptionalViewController alloc]init];
            vc.sourceCircleID = entity.scoopID;
            vc.toUserID = entity.userId;
            vc.iconImage = entity.portrait;
            vc.userName = entity.nickname;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } linkBlock:^(NSString *linkID, NSInteger linkType) {
            CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:linkID type:linkType block:^{
                
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } didSelectBlock:^(NSInteger selectIndex,CGSourceCircleEntity *entity) {
            CGDiscoverTeamDetailViewController *vc = [[CGDiscoverTeamDetailViewController alloc]initWithScoopID:entity.scoopID updateBlock:^(CellLayout *cellLayout) {
                [horrolentity.data replaceObjectAtIndex:selectIndex withObject:cellLayout];
                [weakSelf.collectionView reloadData];
            } deleteBlock:^(CellLayout *cellLayout) {
                [horrolentity.data removeObjectAtIndex:selectIndex];
                [weakSelf.collectionView reloadData];
            }];
            vc.index = selectIndex;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } toMsgBlock:^(NSString *companyId, int companyType) {
            TeamCircleMessageListController *controller = [[TeamCircleMessageListController alloc]initWithCompanyId:companyId companyType:companyType];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionView.bounds.size;
}

//点击登录
-(void)clickToLoginAction{
    //  __weak typeof(self) weakSelf = self;
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
    //  [self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)addCompanyClick:(UIButton *)sender {
    if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
        CGUserChangeOrganizationViewController *vc = [[CGUserChangeOrganizationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self clickToLoginAction];
    }
}
@end
