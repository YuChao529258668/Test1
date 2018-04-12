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
    
//    iPhone X    1125px × 2436px  (X)
//    iPhone 8 Plus    1242px × 2208px (5.5)
//    iPhone 8    750px × 1334px (4.7)
//    iPhone SE    640px × 1136px (Retina 4)
    
    float width = [UIScreen mainScreen].bounds.size.width;
    float factor = 1;
    if (width == 320) {
        factor = 0.82;
    } else if (width == 375) {
        factor = 0.9;
    } else if (width == 562.5) {
        factor = 0.94;
    }
    CGPoint center = self.whiteView.center;
    self.whiteView.transform = CGAffineTransformMakeScale(factor, factor);
    self.whiteView.center = center;
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

- (IBAction)clickMeeting:(UIButton *)sender {
    [self dismiss];
    
    if (self.clickButtonIndexBlock) {
        self.clickButtonIndexBlock(sender.tag);
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
