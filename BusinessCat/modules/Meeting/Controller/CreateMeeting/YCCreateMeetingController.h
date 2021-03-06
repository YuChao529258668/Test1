//
//  YCCreateMeetingController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/18.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMeetingRoom.h"

@interface YCCreateMeetingController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTF;

// 废弃
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;

@property (weak, nonatomic) IBOutlet UIButton *durationBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

// 废弃
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn16;

@property (weak, nonatomic) IBOutlet UIButton *createMeetingBtn;

@property (weak, nonatomic) IBOutlet UIImageView *blockIV;
@property (weak, nonatomic) IBOutlet UIImageView *blockIV2;

@property (nonatomic, assign) BOOL useCollectionView;// 使用方格 view 选择开会时间
@property (nonatomic, strong) YCMeetingRoom *room;
@property (nonatomic, strong) NSDate *pointDate;// 指定日期


@end
