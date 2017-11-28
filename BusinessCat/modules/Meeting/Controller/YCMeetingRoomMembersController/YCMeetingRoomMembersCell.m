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
}

+ (float)cellHeight {
    return 54;
}

@end
