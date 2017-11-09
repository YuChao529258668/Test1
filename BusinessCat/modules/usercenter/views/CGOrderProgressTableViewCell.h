//
//  CGOrderProgressTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGOrderProgressEntity.h"

@interface CGOrderProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *pointButton;
-(void)update:(CGOrderProgressEntity *)entity;
@end
