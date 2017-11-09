//
//  CGKonwledgeRightTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGKonwledgeRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;

@end
