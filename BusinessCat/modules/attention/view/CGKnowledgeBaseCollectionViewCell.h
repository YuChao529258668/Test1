//
//  CGKnowledgeBaseCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"

typedef void (^CGKnowledgeBaseCollectionBlock)(CGInfoHeadEntity *entity);
@interface CGKnowledgeBaseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)update:(CGHorrolEntity *)entity catePage:(NSInteger)catePage navTypeId:(NSString *)navTypeId block:(CGKnowledgeBaseCollectionBlock)block;
-(void)update:(CGHorrolEntity *)entity catePage:(NSInteger)catePage navTypeId:(NSString *)navTypeId;
@end
