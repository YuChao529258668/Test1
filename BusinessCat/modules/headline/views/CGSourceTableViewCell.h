//
//  CGSourceTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/4/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoDetailEntity.h"

@interface CGSourceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceWidth;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
-(void)update:(CGInfoDetailEntity *)entity;
@end
