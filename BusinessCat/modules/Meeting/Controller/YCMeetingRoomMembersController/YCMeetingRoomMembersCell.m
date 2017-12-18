//
//  YCMeetingRoomMembersCell.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingRoomMembersCell.h"

@implementation YCMeetingRoomMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarIV.layer.cornerRadius = self.avatarIV.frame.size.width / 2;
    self.avatarIV.clipsToBounds = YES;
    
    self.allowBtn.layer.cornerRadius = 4;
    self.allowBtn.clipsToBounds = YES;
    
    self.endBtn.layer.cornerRadius = 4;
    self.endBtn.clipsToBounds = YES;
    self.endBtn.hidden = YES;
    
    [self.allowBtn addTarget:self action:@selector(clickAllowBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.endBtn addTarget:self action:@selector(clickEndBtn) forControlEvents:UIControlEventTouchUpInside];
}

+ (float)cellHeight {
    return 60;
}

- (void)clickAllowBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:[YCMeetingRoomMembersCell allowNotificationName] object:self];
}

- (void)clickEndBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:[YCMeetingRoomMembersCell endNotificationName] object:self];
}

+ (NSString *)allowNotificationName {
    return @"YCMeetingRoomMembersCelAllowNotificationl";
}

+ (NSString *)endNotificationName {
    return @"YCMeetingRoomMembersCellEndNotification";
}


@end
