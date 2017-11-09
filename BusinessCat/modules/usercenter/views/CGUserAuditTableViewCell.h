//
//  CGUserAuditTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserCompanyAuditListEntity.h"

typedef void(^CGUserAuditTableViewCellButtonSelect)(CGUserCompanyAuditListEntity *entity);

@interface CGUserAuditTableViewCell : UITableViewCell<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property(nonatomic,retain)CGUserCompanyAuditListEntity *entity;

@property(nonatomic,copy)CGUserAuditTableViewCellButtonSelect block;


-(void)updatItem:(CGUserCompanyAuditListEntity *)item block:(CGUserAuditTableViewCellButtonSelect)block;

@end
