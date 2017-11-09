//
//  CGKnowledgeBaseTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeBaseEntity.h"
typedef void (^CGKnowledgeBaseTableBlock)(NavsEntity *entity,NSInteger index);
@interface CGKnowledgeBaseTableViewCell : UITableViewCell
-(void)update:(NSMutableArray *)array block:(CGKnowledgeBaseTableBlock)block;
+(CGFloat)height:(NSMutableArray *)array;
@end
