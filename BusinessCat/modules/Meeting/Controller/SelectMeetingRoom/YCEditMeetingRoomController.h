//
//  YCEditMeetingRoomController.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/14.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMeetingRoom.h"

@interface YCEditMeetingRoomController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
@property (weak, nonatomic) IBOutlet UITextField *addressCountTF;
@property (weak, nonatomic) IBOutlet UIButton *addressDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressSaveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressSaveBtnCenterConstraint;

@property (weak, nonatomic) IBOutlet UIView *roomView;
@property (weak, nonatomic) IBOutlet UITextField *roomNameTF;
@property (weak, nonatomic) IBOutlet UITextField *roomCountTF;
@property (weak, nonatomic) IBOutlet UIButton *roomDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *roomSaveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roomSaveBtnCenterConstraint; // 居中约束

@property (nonatomic,copy) void (^saveSuccessBlock)();
@property (nonatomic,copy) void (^deleteSuccessBlock)();

@property (nonatomic, strong) YCMeetingRoom *room;
@property (nonatomic, strong) YCMeetingCompanyRoom *companyRoom;

@property (nonatomic, assign) BOOL isAddressMode; // 会议室地址，否则会议室
@property (nonatomic, assign) BOOL isAddMode; // 添加，否则编辑、删除


@end
