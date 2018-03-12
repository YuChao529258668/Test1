//
//  YCCompereCommandController.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCCompereCommandController.h"
#import "YCMeetingBiz.h"


#define kYCUpdateStatesKey @"YC_Update_States"


@interface YCCompereCommandController ()

@end

@implementation YCCompereCommandController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.compereBtnClickAble = YES;
        self.interactBtnClickAble = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.compereBtnClickAble) {
        self.menuForLocalMember.hidden = YES;
    } else {
        self.menuForLocalMember.hidden = NO;
    }
    
    self.CycleView.layer.cornerRadius = self.CycleView.frame.size.width/2;
    self.CycleView.clipsToBounds = YES;
    self.avatarIV.layer.cornerRadius = self.avatarIV.frame.size.width/2;
    self.avatarIV.clipsToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:self.user.userIcon];
    [self.avatarIV sd_setImageWithURL:url];
    self.nameLabel.text = self.user.userName;
    
    if (self.user.interactionState) {
        self.interactLabel.text = @"禁止互动";
        self.interactBtn.selected = YES;
    } else {
        self.interactLabel.text = @"允许互动";
        self.interactBtn.selected =  NO;
    }
    
    self.removeLabel.textColor = [UIColor redColor];
    self.compereLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#777777"];
    self.interactLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#777777"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

+ (instancetype)controllerWithMeetingState:(YCMeetingState *)meetingState user:(YCMeetingUser *)user {
    YCCompereCommandController *vc = [YCCompereCommandController new];
    vc.meetingState = meetingState;
    vc.user = user;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return vc;
}

#pragma mark - Actions

- (IBAction)clickCloseBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickInteractBtn:(id)sender {
    long state = self.user.interactionState? 0:1;
    [self updateUserInteractingState:state];
}

- (IBAction)clickCompereBtn:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"设置该成员为主持人？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakself = self;
        
        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingState.meetingId userId:nil soundState:nil videoState:nil interactionState:nil compereState:self.user.userid userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
            weakself.meetingState = state;
            [weakself sendUpdateStatesCommand];
            if (weakself.completeBlock) {
                weakself.completeBlock();
            }
            [weakself dismiss];
        } fail:^(NSError *error) {
            [CTToast showWithText:[NSString stringWithFormat:@"更改主持人失败 : %@", error]];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];}

- (IBAction)clickRemoveBtn:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除成员？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakself = self;
        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingState.meetingId userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:self.user.userid success:^(YCMeetingState *state) {
            weakself.meetingState = state;
            [weakself sendUpdateStatesCommand];
            if (weakself.completeBlock) {
                weakself.completeBlock();
            }
            [weakself dismiss];
        } fail:^(NSError *error) {
            [CTToast showWithText:[NSString stringWithFormat:@"删除成员失败 : %@", error]];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)updateRequestInteractionBtnWithInteracState:(long)interactionState {
    if (interactionState) {
        self.interactLabel.text = @"禁止互动";
        self.interactBtn.selected = YES;
    } else {
        self.interactLabel.text = @"允许互动";
        self.interactBtn.selected =  NO;
    }
}

#pragma mark -

- (void)updateUserInteractingState:(long)interactState {
    NSString *state = [NSString stringWithFormat:@"%ld", interactState];
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:weakself.meetingState.meetingId userId:self.user.userid soundState:state videoState:state interactionState:state compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
    
//    [[YCMeetingBiz new] meetingUserWithMeetingID:weakself.meetingState.meetingId userId:self.user.userid soundState:nil videoState:nil interactionState:state compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.user.interactionState = interactState;
        [weakself sendUpdateStatesCommand];
        [weakself updateRequestInteractionBtnWithInteracState:interactState];
        if (weakself.completeBlock) {
            weakself.completeBlock();
        }
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"修改互动状态失败 : %@", error]];
    }];
}

- (void)sendUpdateStatesCommand {
    NSString *content = [NSString stringWithFormat:@"%@", self.meetingState.meetingId];
    [[JCEngineManager sharedManager] sendData:kYCUpdateStatesKey content:content toReceiver:nil];
}

#pragma mark -

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
