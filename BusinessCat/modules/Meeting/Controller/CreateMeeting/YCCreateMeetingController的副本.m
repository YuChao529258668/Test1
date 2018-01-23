//
//  YCCreateMeetingController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/18.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCCreateMeetingController.h"
#import "YCDatePickerViewController.h"
#import "YCPickerViewForDateController.h"
#import "YCSelectMeetingRoomController.h"
#import "YCMeetingBiz.h"

@interface YCCreateMeetingController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durautionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (nonatomic, assign) BOOL isVideo;// 会议类型
@property (nonatomic, assign) BOOL isLive;// 是否直播
@property (nonatomic, strong) NSDate *whichDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger count;// 4 8 16

@end

@implementation YCCreateMeetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configViews];
}

#pragma mark - Actions

- (IBAction)dismiss:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickVideoBtn:(id)sender {
    UIColor *color = [UIColor clearColor];
    self.videoBtn.backgroundColor = CTThemeMainColor;
    self.voiceBtn.backgroundColor = color;
    self.isVideo = YES;
}
- (IBAction)clickVoiceBtn:(id)sender {
    UIColor *color = [UIColor clearColor];
    self.voiceBtn.backgroundColor = CTThemeMainColor;
    self.videoBtn.backgroundColor = color;
    self.isVideo = NO;
}
- (IBAction)clickLiveBtn:(id)sender {
    BOOL selected = !self.liveBtn.isSelected;
    self.liveBtn.selected = selected;
    self.liveBtn.backgroundColor = selected? CTThemeMainColor: [UIColor clearColor];
    self.isLive = selected;
}
- (IBAction)clickDateBtn:(id)sender {
//    YCDatePickerViewController *vc = [YCDatePickerViewController new];
//    vc.minimumDate = [NSDate date];
//    vc.currentDate = self.whichDate;
//    [vc setDatePickerMode:UIDatePickerModeDate];
//    vc.onDecitdeDate = ^(NSDate *date) {
//        self.whichDate = date;
//        [self updateDateViews];
//    };
//    [self presentViewController:vc animated:YES completion:nil];
    
    YCPickerViewForDateController *vc = [YCPickerViewForDateController new];
    vc.mode = UIDatePickerModeDate;
    vc.hint = @"选择日期";
    vc.minimumDate = [NSDate date];
    vc.onSelectItemBlock = ^(NSDate *date) {
        self.whichDate = date;
        [self updateDateViews];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)clickBeginTimeBtn:(id)sender {
//    YCDatePickerViewController *vc = [YCDatePickerViewController new];
//    vc.minimumDate = self.whichDate;
//    vc.currentDate = self.beginDate;
//    [vc setDatePickerMode:UIDatePickerModeTime];
//    vc.onDecitdeDate = ^(NSDate *date) {
//        self.beginDate = date;
//        [self updateDateViews];
//    };
//    [self presentViewController:vc animated:YES completion:nil];
    
    YCPickerViewForDateController *vc = [YCPickerViewForDateController new];
    vc.hint = @"选择开始时间";
    vc.minimumDate = self.whichDate;
    vc.onSelectItemBlock = ^(NSDate *date) {
        self.beginDate = date;
        [self updateDateViews];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)clickEndTimeBtn:(id)sender {
//    YCDatePickerViewController *vc = [YCDatePickerViewController new];
//    vc.minimumDate = [self.beginDate dateByAddingTimeInterval:60];
//    vc.currentDate = self.endDate;
//    [vc setDatePickerMode:UIDatePickerModeTime];
//    vc.onDecitdeDate = ^(NSDate *date) {
//        self.endDate = date;
//        [self updateDateViews];
//    };
//    [self presentViewController:vc animated:YES completion:nil];
    
    YCPickerViewForDateController *vc = [YCPickerViewForDateController new];
    vc.hint = @"选择结束时间";
    vc.minimumDate = [self.beginDate dateByAddingTimeInterval:60];
    vc.onSelectItemBlock = ^(NSDate *date) {
        self.endDate = date;
        [self updateDateViews];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)clickDurationBtn:(id)sender {
}
- (IBAction)clickBtn4:(id)sender {
    UIColor *color = [UIColor clearColor];
    self.btn4.backgroundColor = CTThemeMainColor;
    self.btn8.backgroundColor = color;
    self.btn16.backgroundColor = color;
    self.count = 4;
}
- (IBAction)clickBtn8:(id)sender {
    UIColor *color = [UIColor clearColor];
    self.btn8.backgroundColor = CTThemeMainColor;
    self.btn4.backgroundColor = color;
    self.btn16.backgroundColor = color;
    self.count = 8;
}
- (IBAction)clickBtn16:(id)sender {
    UIColor *color = [UIColor clearColor];
    self.btn16.backgroundColor = CTThemeMainColor;
    self.btn8.backgroundColor = color;
    self.btn4.backgroundColor = color;
    self.count = 16;
}
- (IBAction)clickCreateMeetingBtn:(id)sender {
    if ([YCTool isBlankString:self.titleTF.text] ) {
        [CTToast showWithText:@"会议主题不能为空"];
        return;
    }
    
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日";
    NSString *whichString = [f stringFromDate:self.whichDate];
    
    f.dateFormat = @"HH:mm";
    NSString *beginString = [f stringFromDate:self.beginDate];
    beginString = [NSString stringWithFormat:@"%@ %@", whichString, beginString];
    
    NSString *endString = [f stringFromDate:self.endDate];
    endString = [NSString stringWithFormat:@"%@ %@", whichString, endString];
    
    NSLog(@"%@", beginString);
    NSLog(@"%@", endString);
    
    f.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSDate *beginDate = [f dateFromString:beginString];
    NSDate *endDate = [f dateFromString:endString];
    
    
    int meetingType = self.isVideo? 1: 0; //会议形式（0：音频，1：视频）
    int live = self.isLive? 1: 0;
    
    __weak typeof(self) weakself = self;
    int roomType = 1; //roomType 视频的会议室类型 0:公司 1:用户
    NSString *crID = @""; //companyRoomId 公司会议房间Id（空为非公司会议）
    [[YCMeetingBiz new] bookMeeting2WithMeetingID:@"" oldMeetingID:@"" MeetingType:meetingType MeetingName:self.titleTF.text users:@"" roomID:@"" beginDate:beginDate endDate:endDate live:live accessNumber:self.count roomType:roomType companyRoomId:crID Success:^(id data) {
        [CTToast showWithText:@"创建成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        
    }];

}
- (void)handleTextField {
    [self.titleTF resignFirstResponder];
}

#pragma mark - 界面配置

- (void)configViews {
    UIImage *Image = self.blockIV.image;
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    Image = [Image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.blockIV.image = Image;
    
    [self.videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.btn4 sendActionsForControlEvents:UIControlEventTouchUpInside];

    float red = 85.0/255;
    UIColor *gray1 = [UIColor colorWithRed:red green:red blue:red alpha:1];
    self.titleLabel.textColor = gray1;
    self.dateLabel.textColor = gray1;
    self.durautionLabel.textColor = gray1;
    self.countLabel.textColor = gray1;
    
    float blue = 186.0/255;
    UIColor *gray2 = [UIColor colorWithRed:blue green:blue blue:blue alpha:1];
    self.label1.textColor = gray2;
    self.label2.textColor = gray2;
    
    [self.durationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // 占位符 placeholder 颜色和内容
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"少于30字" attributes:
                                      @{NSForegroundColorAttributeName:gray2,
                                        NSFontAttributeName: self.titleTF.font
                                        }];
    self.titleTF.attributedPlaceholder = attrString;
    [self.titleTF setReturnKeyType:UIReturnKeyDone];
    [self.titleTF addTarget:self action:@selector(handleTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSArray *btns = @[_videoBtn, _voiceBtn, _liveBtn, _btn4, _btn8, _btn16, _createMeetingBtn];
    for (UIButton *btn in btns) {
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
    }
    
    self.whichDate = [NSDate dateWithTimeIntervalSinceNow:5 * 60];
    self.beginDate = self.whichDate;
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:35 * 60];
//    self.endDate = [NSDate dateWithTimeIntervalSinceNow:35 * 60 + 59];
    [self updateDateViews];
}

- (void)updateDateViews {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日 EEEE";
    [self.dateBtn setTitle:[f stringFromDate:self.whichDate] forState:UIControlStateNormal];

    f.dateFormat = @"HH:mm";
    self.beginLabel.text = [f stringFromDate:self.beginDate];
    
    if (self.endDate == [self.endDate earlierDate:self.beginDate]) {
        self.endDate = [self.beginDate dateByAddingTimeInterval:30 * 60];
    }
    self.endLabel.text = [f stringFromDate:self.endDate];

//    NSInteger seconds = self.endDate.timeIntervalSince1970 - self.beginDate.timeIntervalSince1970;
    NSInteger seconds = self.endDate.timeIntervalSince1970 - self.beginDate.timeIntervalSince1970 + 59;
    [YCTool HMSForSeconds:seconds block:^(NSInteger h, NSInteger m, NSInteger s, NSMutableString *string) {
        if (h) {
            [string appendFormat:@"%ld 小时", (long)h];
        }
        if (m) {
            [string appendFormat:@" %ld 分钟", (long)m];
        }
        if (h + m == 0) {
            [string appendString: @"0 分钟"];
        }
        [self.durationBtn setTitle:string forState:UIControlStateNormal];
    }];
}

#pragma mark -

- (void)test {
    UIPickerView *pv;
}


@end
