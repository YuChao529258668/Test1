//
//  CGProductReviewCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
typedef void (^CGProductReviewCollectionViewBlock)(NSInteger type,CGInfoHeadEntity* entity);

@interface CGProductReviewCollectionViewCell : UICollectionViewCell
- (void)updateUIWithEntity:(CGHorrolEntity *)entity type:(NSInteger)type tagId:(NSString *)tagId block:(CGProductReviewCollectionViewBlock)block;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
