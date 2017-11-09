//
//  RecommendTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/1/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@interface RecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)updateInfo:(CGInfoHeadEntity *)info;
@end
