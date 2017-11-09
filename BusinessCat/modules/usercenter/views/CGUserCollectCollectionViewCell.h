//
//  CGUserCollectCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/15.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
#import "KnowledgeHeaderEntity.h"

typedef void (^CGUserCollectCollectionViewBlock)(id entity);
@interface CGUserCollectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity block:(CGUserCollectCollectionViewBlock)block;
@end
