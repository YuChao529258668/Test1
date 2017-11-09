//
//  CGMessageDetailTextTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMessageDetailEntity.h"

@interface CGMessageDetailTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) CGFloat height;

-(void)update:(CGMessageDetailEntity *)entity;

@end
