//
//  CGNavTypeSelector.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"

typedef void(^CGNavTypeSelectorBlock)(CGHorrolEntity *item);
typedef void(^CGNavTypeSelectorCancel)(void);

@interface CGNavTypeSelector : UIView

-(instancetype)initWithFrame:(CGRect)frame showAtY:(float)showAtY dataArray:(NSMutableArray *)dataArray block:(CGNavTypeSelectorBlock)block cancel:(CGNavTypeSelectorCancel)cancel;

@end
