//
//  CGUserSearchCompanyTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserSearchCompanyEntity.h"

@interface CGUserSearchCompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *auditLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

-(void)updateWithEntity:(CGUserSearchCompanyEntity *)entity;
@end
