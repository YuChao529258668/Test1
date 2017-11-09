//
//  CGChooseFocusKnowledgeTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeBaseEntity.h"
typedef void (^CGChooseFocusKnowledgeTableBlock)(NavsEntity *navsEntity);
@interface CGChooseFocusKnowledgeTableViewCell : UITableViewCell
-(void)update:(NSMutableArray *)array selectArray:(NSMutableArray *)selectArray;
-(void)update:(NSMutableArray *)array block:(CGChooseFocusKnowledgeTableBlock)block;
+(CGFloat)height:(NSMutableArray *)array;
@end
