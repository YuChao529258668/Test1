//
//  CGTeamDocumentCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"

typedef void (^CGTeamDocumentCollectionViewBlock)(CGInfoHeadEntity *entity);
@interface CGTeamDocumentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity type:(NSInteger)type showType:(NSInteger)showType block:(CGTeamDocumentCollectionViewBlock)block;
@end
