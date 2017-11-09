//
//  BadgeView.h
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeView : UILabel

+ (id)badgeViewInTableViewCell:(UITableViewCell *)cell;

+ (id)badgeViewInView:(UIView *)view;

@end
