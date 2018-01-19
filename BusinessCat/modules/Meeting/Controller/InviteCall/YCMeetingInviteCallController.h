//
//  YCMeetingInviteCallController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/16.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMeeting.h"

@interface YCMeetingInviteCallController : UIViewController
//@interface YCMeetingInviteCallController : UINavigationController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingName;
@property (weak, nonatomic) IBOutlet UIImageView *avartIV;

@property (nonatomic, strong) CGMeeting *meeting;

//  七牛参数
@property (nonatomic,strong) NSString *AccessKey;
@property (nonatomic,strong) NSString *SecretKey;
@property (nonatomic,strong) NSString *BucketName;

@end
