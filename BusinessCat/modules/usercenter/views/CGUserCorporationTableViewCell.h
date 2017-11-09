//
//  CGUserCorporationTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedButtonIndex)(NSInteger index);
@interface CGUserCorporationTableViewCell : UITableViewCell
@property (strong, nonatomic) SelectedButtonIndex block;
@property (weak, nonatomic) IBOutlet UILabel *addressBookLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
- (void)didSelectedButtonIndex:(SelectedButtonIndex)block;
@property (weak, nonatomic) IBOutlet UILabel *privilegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attestationLabel;
- (void)info:(CGUserEntity *)userInfo;
@end
