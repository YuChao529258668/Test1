//
//  DiscoverIndexTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGDiscoverAppsEntity.h"

typedef void (^ClickAtIndexBlock)(CGGropuAppsEntity *entity);
@interface DiscoverIndexTableViewCell : UITableViewCell
- (void)updateApplyWithapplyList:(NSMutableArray *)lists;
@property (strong, nonatomic) ClickAtIndexBlock block;
- (void)didSelectedButtonIndex:(ClickAtIndexBlock)block;
+(float)heightWithArray:(NSMutableArray *)list;
@end
