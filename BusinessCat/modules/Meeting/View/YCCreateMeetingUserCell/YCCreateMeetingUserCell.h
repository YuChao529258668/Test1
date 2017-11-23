//
//  YCCreateMeetingUserCell.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCreateMeetingUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn; // 点击发送通知，名字通过reducceNotificationName获取
+ (float)cellHeight;
+ (NSString *)reducceNotificationName;
@end
