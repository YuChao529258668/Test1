//
//  YCMeetingRoomListTimeCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingRoomListTimeCell.h"

@implementation YCMeetingRoomListTimeCell

+ (float)height {
    return 74;
}

+ (CGSize)itemSize {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = 0;
    
    if (screenWidth < 375) {
        width = 20;
    } else if (screenWidth == 375) {
        width = 22;
    } else {
        width = 24;
    }
    return CGSizeMake(width, [self height]);
}

+ (float)space {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float space = 0;
    
    if (screenWidth < 375) {
        space = 3;
    } else if (screenWidth == 375) {
        space = 4;
    } else {
        space = 6;
    }
    return space;
}

+ (float)yellowMaxHeight {
    return 51;
}


#pragma mark -

- (void)setTimeViewFrame:(NSValue *)timeViewFrame {
    _timeViewFrame = timeViewFrame;
    
    CGRect frame = timeViewFrame.CGRectValue;
    self.timeL.frame = frame;
}

- (void)setDarkTimeViewFrame:(NSValue *)darkTimeViewFrame {
    _darkTimeViewFrame = darkTimeViewFrame;
    
    CGRect frame = darkTimeViewFrame.CGRectValue;
    self.darkTimeL.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.darkTimeL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_cell_bg"]];
}


@end
