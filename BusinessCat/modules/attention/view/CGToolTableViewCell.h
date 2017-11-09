//
//  CGToolTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@interface CGToolTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *source;
-(void)updateItem:(CGInfoHeadEntity *)info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceTrailing;
@end
