//
//  YCMeetingInviteCallController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/16.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingInviteCallController.h"
#import "RoomViewController.h"

#import "YCMeetingBiz.h"

@interface YCMeetingInviteCallController ()
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YCMeetingInviteCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = CTThemeMainColor;
    
    float red = 91/256.0;
    UIColor *color = [UIColor colorWithRed:red green:red blue:red alpha:1];
    self.nameLabel.textColor = color;
    self.inviteLabel.textColor = color;
    self.meetingName.textColor = color;
    
    self.avartIV.layer.cornerRadius = 6;
    
    NSURL *url = [NSURL URLWithString:self.meeting.ycCompere.userIcon];
    [self.avartIV sd_setImageWithURL:url placeholderImage:self.avartIV.image];
    
    self.nameLabel.text = self.meeting.ycCompere.userName;
    self.meetingName.text = self.meeting.meetingName;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playSound) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)playSound {
    SystemSoundID soundID = 1051;//具体参数详情下面贴出来
    //播放声音
    //    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlayAlertSound(soundID);
    //    AudioServicesstop
}

#pragma mark -

- (IBAction)clickAttendBtn:(UIButton *)sender {
    [self goToMeetingRoom];
    [self.timer invalidate];
    self.timer = nil;
    return;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"加入会议？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self joinMeeting];
        [self goToMeetingRoom];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)clickRefuseBtn:(UIButton *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"拒绝会议？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.timer invalidate];
        self.timer = nil;
        [self  dismiss];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark -

- (void)joinMeeting {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meeting.meetingId userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:[ObjectShareTool currentUserID] userDel:nil success:^(YCMeetingState *state) {
        [CTToast showWithText:@"正在跳转会议界面"];
        [weakself goToMeetingRoom];
    } fail:^(NSError *error) {

    }];
}

//        状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
- (void)goToMeetingRoom {
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        roomVc.roomId = self.meeting.conferenceNumber;
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        roomVc.meetingID = self.meeting.meetingId;
        roomVc.meetingState = self.meeting.meetingState;
        roomVc.isReview = (self.meeting.meetingState == 3)? YES: NO;
        roomVc.AccessKey = self.AccessKey;
        roomVc.SecretKey = self.SecretKey;
        roomVc.BucketName = self.BucketName;
        
        [self.navigationController pushViewController:roomVc animated:YES];
//        [self pushViewController:roomVc animated:YES];
    } else {
        [CTToast showWithText:@"会议功能尚未登录，请稍后再试"];
        [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    // // The view controller that presented this view controller (or its farthest ancestor.)
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

}

@end
