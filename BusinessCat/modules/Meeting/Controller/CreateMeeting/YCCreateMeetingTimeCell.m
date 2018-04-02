//
//  YCCreateMeetingTimeCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCCreateMeetingTimeCell.h"

@implementation YCCreateMeetingTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickBtn:(UIButton *)sender {
    self.clickIndex = sender.tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class notificationName]  object:self];
}

#pragma mark -

+ (NSString *)notificationName {
    return @"YCCreateMeetingTimeCellClickNotification";
}

+ (float)height {
    return 158;
}

+ (CGSize)itemSize {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = 0;
    
    if (screenWidth < 375) {
        width = 38;
    } else if (screenWidth == 375) {
        width = 40;
    } else {
        width = 44;
    }
    return CGSizeMake(width, [self height]);
}

- (void)shouldHighlight:(BOOL)b {
    if (b) {
        self.backgroundColor = CTThemeMainColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
