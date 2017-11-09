//
//  CGPartSeeTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGPartSeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *gou;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end
