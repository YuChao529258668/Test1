//
//  CGUserMemberHeaderTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserMemberHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buyVIP;
@property (weak, nonatomic) IBOutlet UIButton *InviteColleagues;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;

@end
