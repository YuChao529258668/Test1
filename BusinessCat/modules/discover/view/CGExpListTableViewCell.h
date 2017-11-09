//
//  CGExpListTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGExpListEntity.h"

@interface CGExpListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (weak, nonatomic) IBOutlet UILabel *lock;
-(void)update:(CGExpListEntity *)entity;
@end
