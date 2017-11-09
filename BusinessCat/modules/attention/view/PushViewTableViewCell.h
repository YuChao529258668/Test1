//
//  PushViewTableViewCell.h
//  CGSays
//
//  Created by zhu on 2016/11/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceCatalogEntity.h"

@interface PushViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
- (void)updateData:(InterfaceCatalogEntity *)entity;
@end
