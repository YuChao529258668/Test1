//
//  YCMeetingListCreateBar.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/23.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCMeetingListCreateBar : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barRightConstraint;

@property (weak, nonatomic) IBOutlet UIView *barContainer;

@property (weak, nonatomic) IBOutlet UIView *whiteView;



@property (nonatomic,copy) void (^clickButtonIndexBlock)(int index);



+ (instancetype)bar;
- (void)barAlignToView:(UIView *)view;

- (void)showOrHide;

@end
