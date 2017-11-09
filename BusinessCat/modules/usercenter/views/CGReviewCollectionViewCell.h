//
//  CGReviewCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGDiscoverLink.h"
#import "SearchCellLayout.h"

@interface CGReviewCollectionViewCell : UICollectionViewCell
-(void)update:(CGHorrolEntity *)entity;
@property (nonatomic,copy) void(^clickedLinkCallback)(CGDiscoverLink *link);//点击链接
@property (nonatomic,copy) void(^didSelectRowAtIndexPathCallback)(SearchCellLayout *layout,CGReviewCollectionViewCell *cell);//点击cell
@end
