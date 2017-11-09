//
//  BadgeView.m
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import "BadgeView.h"

#define kBadgeViewSpacing 10
#define kBadgeViewHeight 18

@implementation BadgeView

+ (id)badgeViewInTableViewCell:(UITableViewCell *)cell
{
    BadgeView *badge = [[BadgeView alloc] init];
    badge.layer.cornerRadius = kBadgeViewHeight / 2;
    badge.text = @"!";
    
    CGSize contentSize = cell.contentView.frame.size;
    CGSize size = [badge sizeThatFits:CGSizeZero];
    CGFloat width = MAX(size.width + kBadgeViewSpacing, kBadgeViewHeight);
    CGFloat originX = contentSize.width - width;
    if (cell.accessoryView) {
        originX -= kBadgeViewSpacing;
    }
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        originX -= kBadgeViewSpacing;
    }
    
    CGFloat originY = (contentSize.height - kBadgeViewHeight) / 2;
    badge.frame = CGRectMake(originX, originY, width, kBadgeViewHeight);
    
    return badge;
}

+ (id)badgeViewInView:(UIView *)view
{
    BadgeView *badge = [[BadgeView alloc] init];
    badge.layer.cornerRadius = kBadgeViewHeight / 2;
    badge.text = @"!";
    CGFloat originX = view.bounds.size.width - kBadgeViewHeight;
    badge.frame = CGRectMake(originX, 0, kBadgeViewHeight, kBadgeViewHeight);
    
    return badge;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:13];
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

@end
