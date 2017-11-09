//
//  AttentionStatisticsTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionStatisticsEntity.h"

@protocol AttentionStatisticsTableViewDelegate <NSObject>
@optional

- (void)doProductDetailWithEntity:(AttentionStatisticsEntity *)entity;

@end

@interface AttentionStatisticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (nonatomic, strong) AttentionStatisticsEntity *product1;
@property (nonatomic, strong) AttentionStatisticsEntity *product2;
@property (nonatomic, weak) id <AttentionStatisticsTableViewDelegate> delegate;
@end
