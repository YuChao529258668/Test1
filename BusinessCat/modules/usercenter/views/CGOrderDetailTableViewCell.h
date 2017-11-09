//
//  CGOrderDetailTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGOrderEntity.h"

@interface CGOrderDetailTableViewCell : UITableViewCell
-(void)update:(CGOrderEntity *)entity;
+(CGFloat)height:(CGOrderEntity *)entity;
@end
