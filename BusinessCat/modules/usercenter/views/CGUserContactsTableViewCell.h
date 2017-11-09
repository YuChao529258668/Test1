//
//  CGUserContactsTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserPhoneContactEntity.h"
typedef void(^SelectedButtonIndex)(UIButton *sender);
@interface CGUserContactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) SelectedButtonIndex block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
//@property (weak, nonatomic) IBOutlet UILabel *phone;
- (void)updateEntity:(CGUserPhoneContactEntity *)entity didSelectedButtonIndex:(SelectedButtonIndex)block;
@end
