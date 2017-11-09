//
//  CGOrderTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGOrderEntity.h"
typedef void (^CGOrderTableButtonViewCellBlock)(CGOrderEntity *entity,NSInteger type,UIButton *button);
@interface CGOrderTableViewCell : UITableViewCell
-(void)update:(CGOrderEntity *)entity block:(CGOrderTableButtonViewCellBlock)block;
+(CGFloat)height:(CGOrderEntity *)entity;
@end
