//
//  AttentionGroupTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionCompanyEntity.h"
@interface AttentionGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redY;
@property (weak, nonatomic) IBOutlet UILabel *red;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabelTrailing;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
-(void)update:(companyEntity *)entity;
@end
