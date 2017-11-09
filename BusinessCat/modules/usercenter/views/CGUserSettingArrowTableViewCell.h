//
//  CGUserSettingArrowTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserSettingArrowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *redPoint;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTrailing;

@end
