//
//  AttentionCompetitorsCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGAttentionEntity.h"
typedef void (^AttentionCompetitorsDynamicBlock)(id entity);
typedef void (^AttentionCompetitorsListBlock)(id entity);
typedef void (^AttentionStatisticsBlock)(id entity);
@interface AttentionCompetitorsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGAttentionEntity *)entity didSelectEntityDynamicBlock:(AttentionCompetitorsDynamicBlock)dynamicBlock listBlock:(AttentionCompetitorsListBlock)listBlock statisticsBlock:(AttentionStatisticsBlock)statisticsBlock;
@end
