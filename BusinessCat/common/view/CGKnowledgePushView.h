//
//  CGKnowledgePushView.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"

typedef void (^CGKnowledgeBlock)(CGHorrolEntity *entity);
@interface CGKnowledgePushView : UIView
- (instancetype)initWithArray:(NSMutableArray *)array select:(CGHorrolEntity *)select block:(CGKnowledgeBlock)block;
@end
