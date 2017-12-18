//
//  YCMeetingRoomMembersCell.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCMeetingRoomMembersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;// 职位

@property (weak, nonatomic) IBOutlet UIButton *allowBtn; // 允许互动，点击发送通知
@property (weak, nonatomic) IBOutlet UIButton *endBtn; // 结束互动，点击发送通知


+ (float)cellHeight;

// 通知的名字
+ (NSString *)allowNotificationName; // 允许互动
+ (NSString *)endNotificationName; // 结束互动

@end
