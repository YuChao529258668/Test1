//
//  CGOrderCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGOrderEntity.h"
typedef void (^CGOrderTableViewCellBlock)(CGOrderEntity *entity,NSInteger type);
typedef void (^CGOrderTableViewDidSelectIndexBlock)(CGOrderEntity *entity);
@interface CGOrderCollectionViewCell : UICollectionViewCell
-(void)update:(CGHorrolEntity *)entity;
-(void)didSelectIndexWithBlock:(CGOrderTableViewDidSelectIndexBlock)block tableViewButtonBlock:(CGOrderTableViewCellBlock)tableViewButtonBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
