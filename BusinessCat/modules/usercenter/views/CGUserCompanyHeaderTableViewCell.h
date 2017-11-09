//
//  CGUserCompanyHeaderTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserCompanyHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgCompanyView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zuzhiY;
@property (weak, nonatomic) IBOutlet UILabel *auditLabel;
@end
