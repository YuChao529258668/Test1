//
//  YCCreateMeetingController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/18.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCreateMeetingController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;

@property (weak, nonatomic) IBOutlet UIButton *durationBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn16;

@property (weak, nonatomic) IBOutlet UIImageView *blockIV;


@end
