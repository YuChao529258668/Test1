//
//  CGHeadlineDetailLeftTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@interface CGHeadlineDetailLeftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterY;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
-(void)updateItem:(CGInfoHeadEntity *)entity;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
