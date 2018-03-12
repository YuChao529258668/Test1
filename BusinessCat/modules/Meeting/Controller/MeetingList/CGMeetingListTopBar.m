//
//  CGMeetingListTopBar.m
//  BusinessCat
//
//  Created by 余超 on 2018/2/28.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "CGMeetingListTopBar.h"

@interface CGMeetingListTopBar()
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation CGMeetingListTopBar

+ (instancetype)bar {
    CGMeetingListTopBar *bar = [[NSBundle mainBundle]loadNibNamed:@"CGMeetingListTopBar" owner:nil options:nil].firstObject;
    return bar;
}

+ (float)barHeight {
    return 50;
}

- (void)updateWithToday0:(int)t0 today1:(int)t1 tomorrow:(int)tm week:(int)w other:(int)other {
    self.todayL.text = [NSString stringWithFormat:@"%d/%d 场", t0, t1];
    self.tomorrowL.text = [NSString stringWithFormat:@"%d 场", tm];
    self.weekL.text = [NSString stringWithFormat:@"%d 场", w];
    self.otherL.text = [NSString stringWithFormat:@"%d 场", other];
}


#pragma mark - Actions

- (IBAction)clickTodayBtn:(UIButton *)sender {
    [self handleClickButton:sender index:1];
}
- (IBAction)clickTorrowBtn:(UIButton *)sender {
    [self handleClickButton:sender index:2];
}
- (IBAction)clickWeekBtn:(UIButton *)sender {
    [self handleClickButton:sender index:3];
}
- (IBAction)clickOtherBtn:(UIButton *)sender {
    [self handleClickButton:sender index:4];
}

- (void)handleClickButton:(UIButton *)sender index:(int)index {
    [self.selectedBtn setBackgroundColor:[UIColor clearColor]];
    
    if (self.selectedBtn == sender) {
        self.selectedBtn = nil;
        if (self.didUnSelectBlock) {
            self.didUnSelectBlock();
        }
    } else {
        self.selectedBtn = sender;
        [self.selectedBtn setBackgroundColor:[YCTool colorWithRed:235 green:235 blue:235 alpha:1]];
        
        if (self.didClickIndex) {
            self.didClickIndex(index);
        }
    }
}

@end
