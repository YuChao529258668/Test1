//
//  CGBoundaryCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGBoundaryCollectionViewCell.h"
#import "CGInterfaceImageViewCollectionViewCell.h"
#import "CGDiscoverBiz.h"
#import "DiscoverDao.h"
#import "XRWaterfallLayout.h"
#import "CGUserCenterBiz.h"
#import "CGInterfaceAppIconCollectionViewCell.h"

#import "YCMeetingBiz.h"

static NSString * const Identifier = @"CGInterfaceImageViewCell";
static NSString * const Identifier2 = @"CGInterfaceAppIconViewCell";

@interface CGBoundaryCollectionViewCell ()<XRWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CGInterfaceImageViewCollectionDelegate>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, strong) CGUserCenterBiz *collectBiz;
@property (nonatomic, copy) CGBoundaryCollectionViewBlock block;
@property (nonatomic, assign) NSInteger isCache;
@end

@implementation CGBoundaryCollectionViewCell

-(CGUserCenterBiz *)collectBiz{
  if (!_collectBiz) {
    _collectBiz = [[CGUserCenterBiz alloc]init];
  }
  return _collectBiz;
}

- (void)awakeFromNib {
    [super awakeFromNib];
  //创建瀑布流布局
  XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
  //或者一次性设置
  [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
  //设置代理，实现代理方法
  waterfall.delegate = self;
  [self.collectionView setCollectionViewLayout:waterfall];
  self.biz = [[CGDiscoverBiz alloc]init];
  // 注册
  [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGInterfaceImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
  [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGInterfaceAppIconCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier2];
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  //下拉刷新
  __weak typeof(self) weakSelf = self;
  self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if (weakSelf.loadType == 1) {
      NSString *subType = nil;
      if ([weakSelf.entity.rolId isEqualToString:@"14"]) {
        subType = @"2,3,4,5,7,9,14,15";
      }
      weakSelf.entity.page = 1;
      [weakSelf.entity.biz commonSearchWithKeyword:weakSelf.keyWord pageNo:1 type:weakSelf.entity.rolId.intValue action:weakSelf.action ID:weakSelf.typeID subType:subType success:^(NSMutableArray *result) {
        [weakSelf.collectionView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          if (result.count<=0) {
                      weakSelf.bgView.hidden = NO;
          }else{
                      weakSelf.bgView.hidden = YES;
            weakSelf.entity.data = result;
            [weakSelf.collectionView reloadData];
          }
          weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
        });
      } fail:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
      }];
    }else if (weakSelf.loadType == 2){
      weakSelf.entity.page = 1;
        if (self.isUseForMeeting) {
            [[YCMeetingBiz new] getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page meetingID:weakSelf.meetingID success:^(NSMutableArray *reslut) {
                [weakSelf.collectionView.mj_header endRefreshing];
                weakSelf.entity.data = reslut;
                [weakSelf.collectionView reloadData];
                weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
            } fail:^(NSError *error) {
                [weakSelf.collectionView.mj_header endRefreshing];
            }];
        } else {
            [weakSelf.collectBiz getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
                [weakSelf.collectionView.mj_header endRefreshing];
                weakSelf.entity.data = reslut;
                [weakSelf.collectionView reloadData];
                weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
            } fail:^(NSError *error) {
                [weakSelf.collectionView.mj_header endRefreshing];
            }];
        }
      
    }else{
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGProductInterfaceEntity *entity = weakSelf.entity.data[0];
        time = entity.createtime;
      }
      weakSelf.entity.page = 1;
      [weakSelf.biz discoverInterfaceListWithPage:weakSelf.entity.page tagId:self.entity.rolId ID:nil verId:nil catalogId:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        if (weakSelf.isCache) {
         [DiscoverDao saveInterfaceListToDB:result action:weakSelf.entity.action]; 
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [weakSelf.collectionView.mj_header endRefreshing];
          weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
          weakSelf.entity.data = result;
          [weakSelf.collectionView reloadData];
        });
      } fail:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
      }];
    }
    
  }];
  
  
  //上拉加载更多
  self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
    if (weakSelf.loadType == 2) {
      weakSelf.entity.page += 1;
        if (self.isUseForMeeting) {
            [[YCMeetingBiz new] getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page meetingID:weakSelf.meetingID success:^(NSMutableArray *reslut) {
                if(reslut && reslut.count > 0){
                    [weakSelf.entity.data addObjectsFromArray:reslut];
                    [weakSelf.collectionView reloadData];
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }else {
                    weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
            } fail:^(NSError *error) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }];
        } else {
            [weakSelf.collectBiz getUserCollectionDataWithLabel:weakSelf.entity.rolId.intValue page:weakSelf.entity.page success:^(NSMutableArray *reslut) {
                if(reslut && reslut.count > 0){
                    [weakSelf.entity.data addObjectsFromArray:reslut];
                    [weakSelf.collectionView reloadData];
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }else {
                    weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
            } fail:^(NSError *error) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }];
        }
      
    }else{
      NSInteger time = [[NSDate date] timeIntervalSince1970]*1000;
      if (weakSelf.entity.data.count>0) {
        CGProductInterfaceEntity *entity = [weakSelf.entity.data lastObject];
        time = entity.createtime;
      }
      weakSelf.entity.page = weakSelf.entity.page+1;
      [weakSelf.biz discoverInterfaceListWithPage:weakSelf.entity.page tagId:self.entity.rolId ID:nil verId:nil catalogId:nil action:weakSelf.entity.action success:^(NSMutableArray *result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          if(result && result.count > 0){
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.entity.data addObjectsFromArray:result];
          }else{
            weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
          }
          [weakSelf.collectionView reloadData];
        });
      } fail:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];
      }];
    }
  }];
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity loadType:(NSInteger)loadType isCache:(BOOL)isCache{
  self.loadType = loadType;
  self.entity = entity;
  self.isCache = isCache;
  [self.collectionView.mj_header beginRefreshing];
}

-(void)cancelCollectionWithIndex:(NSInteger)index{
  [self.entity.data removeObjectAtIndex:index];
  [self.collectionView reloadData];
}

- (void)updateUIWithEntity:(CGHorrolEntity *)entity loadType:(NSInteger)loadType isCache:(BOOL)isCache block:(CGBoundaryCollectionViewBlock)block{
  self.loadType = loadType;
  self.isCache = isCache;
//  if(self.loadType == 1){
//    self.collectionView.mj_footer = nil;
//  }
  self.entity = entity;
  self.block = block;
  __weak typeof(self) weakSelf = self;
  if (self.loadType == 1||self.loadType == 2) {
    if (weakSelf.entity.data.count>0) {
      [weakSelf.collectionView reloadData];
    }else{
    [weakSelf.collectionView.mj_header beginRefreshing];
    }
  }else{
    if (entity.data.count<=0) {
      [DiscoverDao queryInterfaceListFromDBWithAction:entity.action success:^(NSMutableArray *result,BOOL isRefresh) {
        weakSelf.entity.data = result;
        [weakSelf.collectionView reloadData];
        if (isRefresh) {
          [weakSelf.collectionView.mj_header beginRefreshing];
        }
      } fail:^(NSError *error) {
        [weakSelf.collectionView.mj_header beginRefreshing];
      }];
    }else{
      [weakSelf.collectionView reloadData];
    }
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ((scrollView.contentOffset.y+self.collectionView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.collectionView.frame.size.height) {
    if (self.collectionView.mj_footer.isRefreshing == NO&&self.collectionView.mj_footer.state != MJRefreshStateNoMoreData){
      self.collectionView.mj_footer.state = MJRefreshStateRefreshing;
    }
  }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.entity.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGInterfaceImageViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.delegate = self;
    if (self.loadType == 1) {
      CGInfoHeadEntity *product = self.entity.data[indexPath.item];
      product.isIcon = self.loadType == 3?1:product.isIcon;
      cell.product = product;
    }else if (self.loadType == 2){
      CGInfoHeadEntity *product = self.entity.data[indexPath.item];
      product.isIcon = self.loadType == 3?1:product.isIcon;
      cell.product = product;
      cell.closeButton.hidden = NO;
      cell.collectBtn.hidden = YES;
      cell.closeButton.tag = indexPath.row;
    }else{
      CGProductInterfaceEntity *interface = self.entity.data[indexPath.row];
      interface.isIcon = self.loadType == 3?1:interface.isIcon;
      cell.interface = interface;
      cell.title.text = [NSString stringWithFormat:@"%@",interface.name];
    }
    return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
  self.block(indexPath.item);
}

#pragma mark  - <XRWaterfallLayoutDelegate>

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
  //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
  if (self.loadType == 1 ||self.loadType == 2) {
    CGInfoHeadEntity *product = self.entity.data[indexPath.row];
    if (product.width<=0) {
      return 300;
    }
    return itemWidth * product.height / product.width+40;
  }else{
    CGProductInterfaceEntity *interface = self.entity.data[indexPath.row];
    if (interface.width<=0) {
      return 300;
    }
    return itemWidth * interface.height / interface.width+40;
  }

}


@end
