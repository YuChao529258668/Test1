//
//  YCCompereCommandController.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMeetingState.h"

@interface YCCompereCommandController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *CycleView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *interactBtn;
@property (weak, nonatomic) IBOutlet UIButton *compereBtn;
@property (weak, nonatomic) IBOutlet UILabel *interactLabel;
@property (weak, nonatomic) IBOutlet UILabel *compereLabel;
@property (weak, nonatomic) IBOutlet UILabel *removeLabel;
@property (weak, nonatomic) IBOutlet UIView *menuForLocalMember;

@property (nonatomic,strong) YCMeetingState *meetingState; //会议状态，摄像头是否打开等等
@property (nonatomic,strong) YCMeetingUser *user;
@property (nonatomic,copy) void (^completeBlock)();

@property (nonatomic, assign) BOOL interactBtnClickAble;
@property (nonatomic, assign) BOOL compereBtnClickAble;


+ (instancetype)controllerWithMeetingState:(YCMeetingState *)meetingState user:(YCMeetingUser *)user;

@end
