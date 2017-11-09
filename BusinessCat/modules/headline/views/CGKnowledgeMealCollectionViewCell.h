//
//  CGKnowledgeMealCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
#import "KnowledgeHeaderEntity.h"

typedef void (^CGKnowledgeMealCollectionBlock)(CGInfoHeadEntity *item);
typedef void (^CGKnowledgeMealTopCollectionBlock)(BannerData *entity);
@interface CGKnowledgeMealCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)updateCell:(CGHorrolEntity *)entity navType:(CGHorrolEntity *)navType block:(CGKnowledgeMealCollectionBlock)block topBlock:(CGKnowledgeMealTopCollectionBlock)topBlock;

@end
