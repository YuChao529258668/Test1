//
//  CGKonwledgeMoreTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

typedef void (^CGKonwledgeMoreBlock)(CGInfoHeadEntity *item);
@interface CGKonwledgeMoreTableViewCell : UITableViewCell
-(void)update:(NSMutableArray *)array block:(CGKonwledgeMoreBlock)block;
+(NSInteger)height:(NSMutableArray *)array;
@end
