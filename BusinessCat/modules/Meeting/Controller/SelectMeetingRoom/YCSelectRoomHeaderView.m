//
//  YCSelectRoomHeaderView.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCSelectRoomHeaderView.h"

@implementation YCSelectRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor yellowColor];
    [self.button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    BOOL selected = !self.triangleBtn.isSelected;
    self.triangleBtn.selected = selected;
    [self setDisplay:!selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class notificationName] object:self];
}

- (void)setDisplay:(BOOL)isDisplay {
    if (isDisplay) {
        self.triangleBtn.transform = CGAffineTransformMakeRotation(0);
    } else {
        self.triangleBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

+ (instancetype)headerView {
    YCSelectRoomHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"YCSelectRoomHeaderView" owner:nil options:nil].firstObject;
    return view;
}

+ (float)headerViewHeight {
    return 42;
}

+ (NSString *)notificationName {
    return @"YCSelectRoomHeaderViewClickNotification";
}

@end
