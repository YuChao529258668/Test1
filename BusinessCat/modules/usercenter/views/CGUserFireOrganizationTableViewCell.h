//
//  CGUserFireOrganizationTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserOrganizaJoinEntity.h"

@interface CGUserFireOrganizationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
-(void)update:(CGUserOrganizaJoinEntity *)entity;
@end
