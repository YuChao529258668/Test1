//
//  YCCreateMeetingUserCell.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCCreateMeetingUserCell.h"

#define kYCCreateMeetingUserCellReduceBtnClickNotification @"kYCCreateMeetingUserCellReduceBtnClickNotification"

@implementation YCCreateMeetingUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarIV.layer.cornerRadius = self.avatarIV.frame.size.width / 2;
    self.avatarIV.clipsToBounds = YES;
    
    [self.reduceBtn addTarget:self action:@selector(reduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.positionLabel.hidden = YES;
}

- (void)reduceBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:kYCCreateMeetingUserCellReduceBtnClickNotification object:self];
}

+ (float)cellHeight {
    return 54;
}

+ (NSString *)reducceNotificationName {
    return kYCCreateMeetingUserCellReduceBtnClickNotification;
}

@end
