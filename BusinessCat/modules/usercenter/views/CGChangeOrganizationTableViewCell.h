//
//  CGChangeOrganizationTableViewCell.h
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserOrganizaJoinEntity.h"
typedef void (^CGClaimOrganizationBlock)(UIButton *sender);
typedef void (^CGBuyVIPOrganizationBlock)(UIButton *sender);
typedef void (^CGDeleteOrganizationBlock)(UIButton *sender);

@interface CGChangeOrganizationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
-(void)info:(CGUserOrganizaJoinEntity *)entity editing:(BOOL)editing deleteBlock:(CGDeleteOrganizationBlock)deleteBlock claimBlock:(CGClaimOrganizationBlock)claimBlock vipBlock:(CGBuyVIPOrganizationBlock)vipBlock;
@end
