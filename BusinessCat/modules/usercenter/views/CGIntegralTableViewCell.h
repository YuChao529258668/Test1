//
//  CGIntegralTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGIntegralEntity.h"

@interface CGIntegralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *integral;
-(void)update:(IntegralListEntity *)entity;
@end
