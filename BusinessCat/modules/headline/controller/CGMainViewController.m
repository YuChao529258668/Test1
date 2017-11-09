//
//  CGMainViewController.m
//  CGSays
//
//  Created by mochenyang on 2017/3/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMainViewController.h"
#import "CGHeadlineInfoDetailController.h"
#import "CGHorrolEntity.h"
#import "CGHorrolView.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "CGInfoHeadEntity.h"
#import "HeadlineBiz.h"
#import "AlertMessageOnHeadertView.h"
#import "HeadLineDelConfirmView.h"
#import "HeadLineDao.h"
#import "CGCommonBiz.h"
#import "CGReloadView.h"
#import "CGUserDao.h"
#import "ZbarController.h"
#import "QiniuBiz.h"
#import "PDFViewController.h"
#import "HeadlineBigTypeEditController.h"
#import "CGClassificationCorrectionViewController.h"
#import "CGUserChangeOrganizationViewController.h"
#import "WKWebViewController.h"
#import "CGOpponentView.h"
#import "CTRootViewController.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"
#import "CGDiscoverCircleNullTableViewCell.h"

@interface CGMainViewController ()<UITableViewDelegate,UITableViewDataSource,HeadlineOnlyTitleTableViewCellDelegate,HeadlineLeftPicTableViewCellDelegate,HeadlineRightPicTableViewCellDelegate,HeadlineMorePicTableViewCellDelegate>
@property (retain, nonatomic) CGHorrolView *bigTypeScrollView;
@property(nonatomic,retain)NSMutableArray *tableviewArray;
@property(nonatomic,retain)UIView *typeLine;
@end

@implementation CGMainViewController

-(UIView *)typeLine{
    if(!_typeLine){
        _typeLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_bigTypeScrollView.frame), CGRectGetMaxY(_bigTypeScrollView.frame)-0.5f, SCREEN_WIDTH-CGRectGetMaxX(_bigTypeScrollView.frame), 0.5f)];
        _typeLine.tag = 99;
        _typeLine.backgroundColor = CTCommonLineBg;
    }
    return _typeLine;
}

-(NSMutableArray *)tableviewArray{
    if(!_tableviewArray){
        _tableviewArray = [NSMutableArray array];
    }
    return _tableviewArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //字体改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFontSizeChange) name:NOTIFICATION_FONTSIZE object:nil];
    //头条收藏回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfoCollectState) name:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
    
    if([ObjectShareTool sharedInstance].bigTypeData.count > 0){//本地有缓存，先显示缓存
        [self addHeadlineViewToPage];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

#pragma 通知-Notification

-(void)addBlackView{
    CGReloadView *reloadView = [[CGReloadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 104-44) block:^{
        [((CTRootViewController *)self.parentViewController)toCheckToken];
    }];
    [self.bottom addSubview:reloadView];
}

//字体改变的通知，更新所有tableview
-(void)notificationFontSizeChange{
    for (UITableView *tableView in self.tableviewArray) {
        [tableView reloadData];
    }
}
//头条收藏回调通知
-(void)notificationInfoCollectState{
    [[self currentTableView] reloadData];
}

//重置头条列表的位置
-(void)resetHeadlineLocationAction{
    [super resetHeadlineLocationAction];
    [[self currentTableView] setContentOffset:CGPointMake(0, 0) animated:NO];
}

//提示信息
-(void)alertMsg:(NSString *)message{
    CTRootViewController *parentController = (CTRootViewController *)self.parentViewController;
    if(parentController.headlineTabIsShow){
        [[AlertMessageOnHeadertView initWithText:message]showInView:self.bottom frame:CGRectMake([self currentTableView].frame.origin.x, [self currentTableView].frame.origin.y, [self currentTableView].frame.size.width, 30)];
    }
}

//初始化大类控件
-(CGHorrolView *)bigTypeScrollView{
    __weak typeof(self) weakSelf = self;
    if(!_bigTypeScrollView){
        _bigTypeScrollView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, 40) array:[ObjectShareTool sharedInstance].bigTypeData finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            [weakSelf.bottom setContentOffset:CGPointMake(weakSelf.bottom.frame.size.width*index, 0) animated:NO];
            if(!clickOnShow){//非选中Item状态
                [weakSelf loadLocalInfoSuccess:^{
                } fail:^(NSError *error) {
                    [[weakSelf currentTableView].mj_header beginRefreshing];
                }];
            }else{
                [[weakSelf currentTableView].mj_header beginRefreshing];
            }
        }];
    }
    return _bigTypeScrollView;
}


//初始化列表控件
-(void)initContentTableView{
    [self.bottom.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除以前存在的列表控件
    self.bottom.contentOffset = CGPointMake(0, 0);
    [self.tableviewArray removeAllObjects];
    UITableView *tableview;
    UITableView *first;
    for(int i=0;i<[ObjectShareTool sharedInstance].bigTypeData.count;i++){
        CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[i];
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104-44)];
        tableview.tag = i;
        [self.tableviewArray addObject:tableview];
        tableview.backgroundColor = CTCommonViewControllerBg;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.showsHorizontalScrollIndicator = NO;
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableview registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
        [tableview registerNib:[UINib nibWithNibName:@"HeadlineLeftPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
        [tableview registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
        [tableview registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
        [tableview registerNib:[UINib nibWithNibName:@"OpponentTableViewCell" bundle:nil] forCellReuseIdentifier:@"OpponentCell"];
        [self.bottom addSubview:tableview];
        //下拉刷新
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshTableASync:i];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        // 设置文字
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"智能推荐中" forState:MJRefreshStateRefreshing];
        tableview.mj_header = header;
        
        
        //上拉加载更多
        tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if(bigTypeEntity.time <= 0){
                bigTypeEntity.time = [[NSDate date] timeIntervalSince1970]*1000;
            }
            [bigTypeEntity.biz queryRemoteHeadlineDataByLabel:bigTypeEntity.rolId time:bigTypeEntity.time mode:1 success:^(NSMutableArray *bigTypeData) {
                [tableview.mj_footer endRefreshing];
                if(bigTypeData && bigTypeData.count > 0){
                    [bigTypeEntity.data addObjectsFromArray:bigTypeData];
                    [tableview reloadData];
                }
            } fail:^(NSError *error){
                [tableview.mj_footer endRefreshing];
            }];
        }];
        if(i == 0){
            first = tableview;
        }
    }
    self.bottom.contentSize = CGSizeMake(CGRectGetMaxX(tableview.frame), 0);
    if(first){
        // 马上进入刷新状态
        [self loadLocalInfoSuccess:^{
            [self refreshTableASync:0];
        } fail:^(NSError *error) {
            [first.mj_header beginRefreshing];
        }];
    }
//    [self setTableViewScrollStatus:NO];//初始化时默认tableview不能滚动
}

-(void)refreshTableASync:(int)index{
    if([ObjectShareTool sharedInstance].bigTypeData.count > 0){
        CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[index];
        bigTypeEntity.time = [[NSDate date] timeIntervalSince1970]*1000;
        bigTypeEntity.isFirst = NO;
        [bigTypeEntity.biz queryRemoteHeadlineDataByLabel:bigTypeEntity.rolId time:bigTypeEntity.time mode:0 success:^(NSMutableArray *bigTypeData) {
            [[self currentTableView].mj_header endRefreshing];
            if(bigTypeData && bigTypeData.count > 0){
                NSRange range = NSMakeRange(0, [bigTypeData count]);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [bigTypeEntity.data insertObjects:bigTypeData atIndexes:indexSet];
                [self alertMsg:[NSString stringWithFormat:@"荐识智能推荐有%d条更新",(int)bigTypeData.count]];
                [[self currentTableView] reloadData];
            }else{
                [self alertMsg:@"暂无新数据"];
            }
        } fail:^(NSError *error){
            [[self currentTableView].mj_header endRefreshing];
        }];
    }else{
        [((CTRootViewController *)self.parentViewController)toCheckToken];
    }
    
}

//获取当前在哪页
-(int)currentPage{
    CGFloat pageWidth = self.bottom.frame.size.width;
    return floor((self.bottom.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

//获取当前显示的tableview
-(UITableView *)currentTableView{
    UITableView *currTableview;
    for(UITableView *tableview in self.tableviewArray){
        if(tableview.tag == [self currentPage]){
            currTableview = tableview;
            break;
        }
    }
    return currTableview;
}
/**
 *  加载本地数据,本地加载到或者已在内存存在返回success，否则返回fail
 */
-(void)loadLocalInfoSuccess:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[[self currentPage]];
    if(!bigTypeEntity.data || bigTypeEntity.data.count <= 0){
        HeadLineDao *dao = [[HeadLineDao alloc]init];
        __weak typeof(self) weakSelf = self;
      bigTypeEntity.isFirst = NO;
        [dao queryInfoDataFromDB:bigTypeEntity.rolId success:^(NSMutableArray *result) {
            [bigTypeEntity.data addObjectsFromArray:result];
            [[weakSelf currentTableView] reloadData];
            success();
        } fail:^(NSError *error) {
            fail(nil);
        }];
    }else{
        success();
    }
}

//大类编辑按钮事件
- (IBAction)headlineTypeEditAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    HeadlineBigTypeEditController *controller = [[HeadlineBigTypeEditController alloc]initWithSuccess:^(int index) {
        [weakSelf addHeadlineViewToPage];
        [weakSelf.bigTypeScrollView setSelectIndex:index];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottom.contentOffset = CGPointMake(weakSelf.bottom.frame.size.width*index, 0);
        }completion:^(BOOL finished) {
            
        }];
    } cancel:^(NSError *error) {
        
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

//加载服务器头条分类数据
-(void)queryRemoteHeadlineType{
    //检查服务器分类是否有更新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //加载远程大类
            HeadlineBiz *biz = [[HeadlineBiz alloc]init];
          [biz queryRemoteBigTypeDataWithType:12 success:^(NSMutableArray *bigTypeData) {
            [self addHeadlineViewToPage];
          } fail:^(NSError *error) {
            
          }];
        });
    });
}

-(void)addHeadlineViewToPage{
    __weak typeof(self) weakSelf = self;
    [weakSelf.bigTypeScrollView removeFromSuperview];
    weakSelf.bigTypeScrollView = nil;
    [weakSelf.typeView addSubview:weakSelf.bigTypeScrollView];
    
    [weakSelf.typeView addSubview:weakSelf.typeLine];
    
    [weakSelf initContentTableView];
}


#pragma UITableView Delegate

//延时更新某个cell，不延时的话reloadRowsAtIndexPaths函数会卡顿一会儿
-(void)reloadOneCell:(NSIndexPath *)indexPath{
    [[self currentTableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int tag = (int)tableView.tag;
    CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[tag];
  if (bigTypeEntity.data.count<=0&&bigTypeEntity.isFirst == NO) {
    return 1;
  }
    return bigTypeEntity.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int tag = (int)tableView.tag;
    CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[tag];
    NSUserDefaults *fontSize = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [fontSize objectForKey:NSUSERDEFAULT_FONTSIZE];
    NSNumber *systemFontSize = dic[@"systemFontSize"];
  if (bigTypeEntity.data.count<=0&&bigTypeEntity.isFirst == NO) {
    NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
    CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = @"暂无数据~";
    cell.icon.image = [UIImage imageNamed:@"no_data"];
    return cell;
  }
    CGInfoHeadEntity *info = bigTypeEntity.data[indexPath.row];
    if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
        HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
      cell.timeType = 0;
      [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:systemFontSize.floatValue];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
      cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:systemFontSize.floatValue];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
      cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:systemFontSize.floatValue];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
      cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:systemFontSize.floatValue];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int tag = (int)tableView.tag;
    CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[tag];
  if (bigTypeEntity.data.count<=0&&bigTypeEntity.isFirst == NO) {
    return tableView.frame.size.height;
  }
  CGInfoHeadEntity *info = bigTypeEntity.data[indexPath.row];
    if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
        return 116;
    }else if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        [cell updateItem:info];
        return cell.height;
    }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        [cell updateItem:info];
        return cell.height;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        [cell updateItem:info];
        return cell.height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int tag = (int)tableView.tag;
    CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[tag];
  if (bigTypeEntity.data.count<=0&&bigTypeEntity.isFirst == NO) {
    return;
  }
  CGInfoHeadEntity *info = bigTypeEntity.data[indexPath.row];
    if (info.infoId.length<=0) {
        return;
    }
  
    if(info.read != 1){
        info.read = 1;
        [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_read value:@"1" infoId:info.infoId table:HeadlineInfo_tableName];
        [self performSelector:@selector(reloadOneCell:) withObject:indexPath afterDelay:0.5f];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    __weak typeof(self) weakSelf = self;
  CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
    
    for (CGInfoHeadEntity *headentity in bigTypeEntity.data) {
      if ([headentity.infoId isEqualToString:info.infoId]) {
        [bigTypeEntity.data removeObject:headentity];
        [[[HeadLineDao alloc]init]deleteInfoDataByInfoID:headentity.infoId];
        break;
      }
    }
    [[weakSelf currentTableView] reloadData];
  }];
  detail.info = info;
  [self.navigationController pushViewController:detail animated:YES];
  
    [self performSelector:@selector(menuScrollToTop) withObject:nil afterDelay:0.4];
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.bigTypeScrollView setSelectIndex:[self currentPage]];
    __weak typeof(self) weakSelf = self;
    [self loadLocalInfoSuccess:^{
        
    } fail:^(NSError *error) {
        [[weakSelf currentTableView].mj_header beginRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark

//关闭此条内容的回调
-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY{
//    if(((CTRootViewController *)self.parentViewController).headlineTabIsShow){
        __weak typeof(self) weakSelf = self;
        UITableView *currTableview = [self currentTableView];
        if(currTableview){
            NSIndexPath *indexPath = [currTableview indexPathForCell:cell];
            CGRect rectInTableView = [currTableview rectForRowAtIndexPath:indexPath];
            CGRect rect = [currTableview convertRect:rectInTableView toView:[currTableview superview]];
            float x,y;
            float closeY = rect.origin.y+104;
            HeadlineColseShowPosition position;
            if(info.layout == ContentLayoutLeftPic || info.layout == ContentLayoutMorePic || info.layout == ContentLayoutOnlyTitle){
                x = SCREEN_WIDTH - 20;
                y = closeY+closeBtnY;
                position = HeadlineColseShowPositionRight;
            }else{
                HeadlineRightPicTableViewCell *rcell = (HeadlineRightPicTableViewCell *)cell;
                if (rcell.isCenter == NO) {
                    x = SCREEN_WIDTH - 20;
                    position = HeadlineColseShowPositionRight;
                    y = closeY+closeBtnY;
                }else{
                    position = HeadlineColseShowPositionCenter;
                    x = SCREEN_WIDTH/2;
                    y = closeY+closeBtnY;
                }
            }
            HeadLineDelConfirmView *closeView = [[HeadLineDelConfirmView alloc]initWithX:x y:y del:^(int closeType) {
                CGHorrolEntity *bigTypeEntity = [ObjectShareTool sharedInstance].bigTypeData[[weakSelf currentPage]];
                HeadlineBiz *biz = [[HeadlineBiz alloc]init];
                [biz closeInfoWithId:info.infoId type:info.type closeType:closeType success:^{
                    [bigTypeEntity.data removeObject:info];
                    HeadLineDao *headlineDao = [[HeadLineDao alloc]init];
                    [headlineDao deleteInfoDataByInfoID:info.infoId];
                  if (bigTypeEntity.data.count<=0) {
                    [currTableview reloadData];
                  }else{
                  [currTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[currTableview indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
                  }
                    [self alertMsg:@"将减少此类内容的推荐"];
                } fail:^(NSError *error){
                    
                }];
//                if (closeType == 7&&userInfo.platformAdmin == YES) {
//                    CGClassificationCorrectionViewController *vc = [[CGClassificationCorrectionViewController alloc]initWithBlock:^(NSString *navType) {
//                        HeadlineBiz *biz = [[HeadlineBiz alloc]init];
//                        [biz headlinesCorrectingNavTypeWithID:info.infoId navType:navType success:^{
//                            [bigTypeEntity.data removeObject:info];
//                            HeadLineDao *headlineDao = [[HeadLineDao alloc]init];
//                            [headlineDao deleteInfoDataByInfoID:info.infoId];
//                            [currTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[currTableview indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        } fail:^(NSError *error) {
//                            
//                        }];
//                    }];
//                    vc.bigtype = info.bigtype;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                }else{
//                    HeadlineBiz *biz = [[HeadlineBiz alloc]init];
//                    [biz closeInfoWithId:info.infoId type:info.type closeType:closeType success:^{
//                        [bigTypeEntity.data removeObject:info];
//                        HeadLineDao *headlineDao = [[HeadLineDao alloc]init];
//                        [headlineDao deleteInfoDataByInfoID:info.infoId];
//                        [currTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[currTableview indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [self alertMsg:@"将减少此类内容的推荐"];
//                    } fail:^(NSError *error){
//                        
//                    }];
//                }
                
            } cancel:^{
                
            }];
            
            [closeView showInView:[UIApplication sharedApplication].keyWindow position:position y:y];
        }
//    }
}


@end
