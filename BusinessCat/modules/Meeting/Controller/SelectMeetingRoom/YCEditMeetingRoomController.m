//
//  YCEditMeetingRoomController.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/14.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCEditMeetingRoomController.h"
#import "YCMeetingBiz.h"

@interface YCEditMeetingRoomController ()

@end


@implementation YCEditMeetingRoomController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    self.addressView.hidden = !self.isAddressMode;
    self.roomView.hidden = self.isAddressMode;

    if (self.isAddMode) {
        self.roomDeleteBtn.hidden = YES;
        self.addressDeleteBtn.hidden = YES;
        
        self.roomSaveBtnCenterConstraint.constant = 0;
        self.addressSaveBtnCenterConstraint.constant = 0;
    }
    
    if (self.isAddressMode) {
        self.addressTV.text = self.room.roomName;
        if (self.room.roomNum) {
            self.addressCountTF.text = [NSString stringWithFormat:@"%d", self.room.roomNum];
        }
        if (self.room.sort) {
            self.addressOrderTF.text = [NSString stringWithFormat:@"%d", self.room.sort];
        }
    } else {
        self.roomNameTF.text = self.room.roomName;
        if (self.room.roomNum) {
            self.roomCountTF.text = [NSString stringWithFormat:@"%d", self.room.roomNum];
        }
        if (self.room.sort) {
            self.roomOrderTF.text = [NSString stringWithFormat:@"%d", self.room.sort];
        }
    }
}


#pragma mark - Actions

- (IBAction)clickDimissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickAddressSaveBtn:(id)sender {
    if ([YCTool isBlankString:self.addressTV.text]) {
        [CTToast showWithText:@"请填写地址"];
        return;
    }
    
    if (self.addressCountTF.text.intValue == 0) {
        [CTToast showWithText:@"请填写人数"];
        return;
    }
    
    if (self.addressOrderTF.text.intValue == 0 && ![self.addressOrderTF.text isEqualToString:@"0"]) {
        [CTToast showWithText:@"请填写顺序"];
        return;
    }

    __weak typeof(self) weakself = self;
    int count = self.addressCountTF.text.intValue;
    int sort = self.addressOrderTF.text.intValue;

    [[YCMeetingBiz new]addMeetingRoomWithRoomID:self.room.roomId toId:nil roomName:self.addressTV.text type:3 roomNum:count sort:sort success:^(id data) {
        [CTToast showWithText:@"保存成功"];
        weakself.room.roomName = weakself.addressTV.text;
        weakself.room.roomNum = weakself.addressCountTF.text.intValue;

        [weakself dismissViewControllerAnimated:YES completion:nil];
        if (weakself.saveSuccessBlock) {
            weakself.saveSuccessBlock();
        }
    } fail:^(NSError *error) {
        [CTToast showWithText:@"保存失败"];
    }];
}

- (IBAction)clickAddressDeleteBtn:(id)sender {
    [self delete];
}

- (IBAction)clickRoomSaveBtn:(id)sender {
    if ([YCTool isBlankString:self.roomNameTF.text]) {
        [CTToast showWithText:@"请填写名称"];
        return;
    }
    
    if (self.roomCountTF.text.intValue == 0) {
        [CTToast showWithText:@"请填写人数"];
        return;
    }
    
    if (self.roomOrderTF.text.intValue == 0 && ![self.roomOrderTF.text isEqualToString:@"0"]) {
        [CTToast showWithText:@"请填写顺序"];
        return;
    }

    __weak typeof(self) weakself = self;
    int count = self.roomCountTF.text.intValue;
    int sort = self.roomOrderTF.text.intValue;
    [[YCMeetingBiz new]addMeetingRoomWithRoomID:self.room.roomId toId:self.companyRoom.id roomName:self.roomNameTF.text type:1 roomNum:count sort:sort success:^(id data) {
        [CTToast showWithText:@"保存成功"];
        weakself.room.roomName = weakself.roomNameTF.text;
        weakself.room.roomNum = weakself.roomCountTF.text.intValue;
        [weakself dismissViewControllerAnimated:YES completion:nil];
        if (weakself.saveSuccessBlock) {
            weakself.saveSuccessBlock();
        }
    } fail:^(NSError *error) {
        [CTToast showWithText:@"保存失败"];
    }];
}

- (IBAction)clickRoomDeleteBtn:(id)sender {
    [self delete];
}

- (void)handleTap:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
    
    if ([self.roomCountTF.text isEqualToString:@""]) {
        if (self.room.roomNum) {
            self.roomCountTF.text = [NSString stringWithFormat:@"%d", self.room.roomNum];
        }
    }
    
    if ([self.addressCountTF.text isEqualToString:@""]) {
        if (self.room.roomNum) {
            self.addressCountTF.text = [NSString stringWithFormat:@"%d", self.room.roomNum];
        }
    }
    
    if ([self.addressOrderTF.text isEqualToString:@""]) {
        if (self.room.sort) {
            self.addressOrderTF.text = [NSString stringWithFormat:@"%d", self.room.sort];
        }
    }
    
    if ([self.roomOrderTF.text isEqualToString:@""]) {
        if (self.room.sort) {
            self.roomOrderTF.text = [NSString stringWithFormat:@"%d", self.room.sort];
        }
    }

}


#pragma mark - Data

- (void)delete {
    __weak typeof(self) weakself = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"是否删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[YCMeetingBiz new] deleteMeetingRoomWithRoomID:self.room.roomId success:^(id data) {
            [CTToast showWithText:@"删除成功"];
            [weakself dismissViewControllerAnimated:YES completion:nil];
            if (weakself.deleteSuccessBlock) {
                weakself.deleteSuccessBlock();
            }
        } fail:^(NSError *error) {
            [CTToast showWithText:@"删除失败"];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}



@end

