//
//  CGChooseClassificationViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "InterfaceCatalogEntity.h"
typedef void (^CGChooseClassificationBlock)(InterfaceCatalogEntity *entity);
@interface CGChooseClassificationViewController : CTBaseViewController
-(instancetype)initWithArray:(NSMutableArray *)array block:(CGChooseClassificationBlock)block;
@end
