//
//  CGBoundaryCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
typedef void (^CGBoundaryCollectionViewBlock)(NSInteger index);
typedef void (^CGBoundaryCollectionViewNocCollectBlock)(NSInteger index);
@interface CGBoundaryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, assign) NSInteger loadType;//0发现界面 1搜索界面 2收藏界面 3app图标
- (void)updateUIWithEntity:(CGHorrolEntity *)entity loadType:(NSInteger)loadType isCache:(BOOL)isCache block:(CGBoundaryCollectionViewBlock)block;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity loadType:(NSInteger)loadType isCache:(BOOL)isCache;

@property (nonatomic,assign) BOOL isUseForMeeting; // 是否从会议界面跳过来
@property (nonatomic,strong) NSString *meetingID;

@end
