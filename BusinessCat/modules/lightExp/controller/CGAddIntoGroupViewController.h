//
//  CGAddIntoGroupViewController.h
//  CGSays
//
//  Created by zhu on 2016/12/5.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGLightExpEntity.h"
typedef void (^CGAddIntoGroupBlock)(CGLightExpEntity *entity);
typedef void (^CGAddGroupBlock)(CGLightExpEntity *entity);

@interface CGAddIntoGroupViewController : CTBaseViewController

//初始化，使用block回调供外部进行相关的下一步操作
-(instancetype)initWithArray:(NSMutableArray *)array block:(CGAddIntoGroupBlock)block addGroupBlock:(CGAddGroupBlock)addGroupBlock;
@end
