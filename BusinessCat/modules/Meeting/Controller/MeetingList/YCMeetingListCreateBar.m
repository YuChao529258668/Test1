//
//  YCMeetingListCreateBar.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/23.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingListCreateBar.h"

@implementation YCMeetingListCreateBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.barContainer.hidden = YES;
}

- (IBAction)clickHideBtn:(id)sender {
//    self.hidden = YES;
    [self dismiss];

}


- (IBAction)hide:(id)sender {
//    self.hidden = YES;
    [self dismiss];

}

+ (instancetype)bar {
    YCMeetingListCreateBar *bar = [[NSBundle mainBundle] loadNibNamed:@"YCMeetingListCreateBar" owner:nil options:nil].firstObject;
    bar.barContainer.backgroundColor = CTThemeMainColor;
    bar.barContainer.layer.cornerRadius = bar.barContainer.frame.size.height/2;
    return bar;
}

- (void)barAlignToView:(UIView *)view {
    self.barYConstraint.constant = view.frame.origin.y - (self.barContainer.frame.size.height - view.frame.size.height)/2;
    
    float space = self.superview.frame.size.width - CGRectGetMaxX(view.frame);
    self.barLeftConstraint.constant = space;
    self.barRightConstraint.constant = space;
}

#pragma mark - Actions

- (IBAction)clickMeeting:(id)sender {
    [self dismiss];
    
    if (self.clickButtonIndexBlock) {
        self.clickButtonIndexBlock(0);
    }
}

#pragma mark -

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)showOrHide {
    if (self.superview) {
        [self removeFromSuperview];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}


@end
