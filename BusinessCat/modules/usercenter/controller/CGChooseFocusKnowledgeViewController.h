//
//  CGChooseFocusKnowledgeViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "KnowledgeBaseEntity.h"
typedef void (^CGChooseFocusKnowledgeBlock)(NSMutableArray *array);
typedef void (^CGSelectFocusKnowledgeBlock)(KnowledgeBaseEntity *baseEntity,NavsEntity *navsEntity);
@interface CGChooseFocusKnowledgeViewController : CTBaseViewController
-(instancetype)initWithArray:(NSMutableArray *)array block:(CGChooseFocusKnowledgeBlock)block;
-(instancetype)initWithBlock:(CGSelectFocusKnowledgeBlock)selectBlock;
@end
