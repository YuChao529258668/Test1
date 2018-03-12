//
//  CGMeetingListTopBar.h
//  BusinessCat
//
//  Created by 余超 on 2018/2/28.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGMeetingListTopBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *otherL;
@property (weak, nonatomic) IBOutlet UILabel *weekL;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowL;
@property (weak, nonatomic) IBOutlet UILabel *todayL;

@property (nonatomic,copy) void (^didClickIndex)(int index);// 1,2,3,4
@property (nonatomic,copy) void (^didUnSelectBlock)();

+ (instancetype)bar;
+ (float)barHeight;
- (void)updateWithToday0:(int)t0 today1:(int)t1 tomorrow:(int)tm week:(int)w other:(int)other;
@end
