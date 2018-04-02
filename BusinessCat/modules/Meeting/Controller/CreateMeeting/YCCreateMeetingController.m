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
#import "YCMeetingPayController.h"
#import "YCMeetingBiz.h"
#import "YCMeetingRoom.h"
#import "RoomViewController.h"
#import "CGBuyVIPViewController.h"

#import "YCCreateMeetingTimeCell.h"

@interface YCCreateMeetingController ()<UITextFieldDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *navigationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durautionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *selectModeLabel;

@property (nonatomic, assign) BOOL isVideo;// 会议类型
@property (nonatomic, assign) BOOL isLive;// 是否直播
@property (nonatomic, strong) NSDate *whichDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger count;// 4 8 16
@property (nonatomic, assign) BOOL isDurationOver8Hour;// 超过8小时

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (nonatomic, strong) YCMeetingRoom *room;
@property (nonatomic, strong) YCMeetingRebate *rebate;
@property (nonatomic, assign) long durationMinute;// 会议时长，分钟

// oneView
@property (weak, nonatomic) IBOutlet UILabel *labelOneVIew;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIewOneView;

// twoView
@property (weak, nonatomic) IBOutlet UILabel *countLabelTwo;
@property (weak, nonatomic) IBOutlet UIImageView *countImageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;


@property (nonatomic, strong) YCMeetingPayController *payController;


// 新版日期
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *selectTimeView;
@property (nonatomic, strong) NSIndexPath *beginIndex;// section = hour, item = min
@property (nonatomic, strong) NSIndexPath *endIndex;// section = hour, item = min


@end


#pragma mark -

@implementation YCCreateMeetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserverForWeiXinPay];
    [self configViews];
    
    
    self.selectTimeView.hidden = !self.useCollectionView;
    if (self.useCollectionView) {
        [self configCollectionView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (IBAction)clickCreateMeetingBtn:(UIButton *)sender {
//    if ([YCTool isBlankString:self.titleTF.text] ) {
//        [CTToast showWithText:@"会议主题不能为空"];
//        return;
//    }
    
    
    if (self.count == 0 && !self.room) {
        [CTToast showWithText:@"请选择会议模式"];
        return;
    }
    
    if (self.isDurationOver8Hour) {
        [CTToast showWithText:@"会议时长不能超过8小时"];
        return;
    }
    
    if (self.count > 0) {
        [self goToPayViewController];
    } else {
        [self createMeetingWithJuHua:YES];
    }

}
- (void)handleTextField {
    [self.titleTF resignFirstResponder];
}
- (IBAction)clickSelectRoomBtn:(UIButton *)sender {
    YCSelectMeetingRoomController *vc = [YCSelectMeetingRoomController new];
    vc.beginDate = self.beginDate;
    vc.endDate = self.endDate;
    vc.count = self.count;
    vc.isVideo = self.isVideo;
    vc.selectedRoom = self.room;
    vc.didSelectBlock = ^(YCMeetingRoom *room, BOOL isVideo, NSInteger count) {
        self.room = room;
        self.isVideo = isVideo;
        self.count = count;
        
        self.oneView.hidden = YES;
        self.twoView.hidden = YES;
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *str;
        if ([app_Name isEqualToString:@"易事猫"]) {
            str = @"会议";
        } else {
            str = @"会面";
        }

        if (room && count) {
            self.oneView.hidden = YES;
            self.twoView.hidden = NO;
            
            if (isVideo) {
                self.countLabelTwo.text = [NSString stringWithFormat:@"%ld人视频%@", (long)count, str];
                self.countImageViewTwo.image = [UIImage imageNamed:@"meeting_videobtn_normal"];
            } else {
                self.countLabelTwo.text = [NSString stringWithFormat:@"%ld人语音%@", (long)count, str];
                self.countImageViewTwo.image = [UIImage imageNamed:@"meeting_speech_normal"];
            }
            self.roomNameLabel.text = room.roomName;
//            self.roomImageView.image = [UIImage imageNamed:@"meeting_home_normal"];
            self.roomImageView.image = [UIImage imageNamed:@"meeting_bighome_normal"];

        } else {
            if (room) {
                self.oneView.hidden = NO;
                self.labelOneVIew.text = room.roomName;
//                self.imageVIewOneView.image = [UIImage imageNamed:@"meeting_home_normal"];
                self.imageVIewOneView.image = [UIImage imageNamed:@"meeting_bighome_normal"];
            }
            if (count) {
                self.oneView.hidden = NO;
                if (isVideo) {
                    self.labelOneVIew.text = [NSString stringWithFormat:@"%ld人视频%@", (long)count, str];
                    self.imageVIewOneView.image = [UIImage imageNamed:@"meeting_videobtn_normal"];
                } else {
                    self.labelOneVIew.text = [NSString stringWithFormat:@"%ld人语音%@", (long)count, str];
                    self.imageVIewOneView.image = [UIImage imageNamed:@"meeting_speech_normal"];
                }
            }
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//- (IBAction)clickPayBtn:(UIButton *)sender {
//    YCMeetingPayController *vc = [YCMeetingPayController new];
//    vc.count = self.count;
//    vc.durationString = [self.durationBtn titleForState:UIControlStateNormal];
//    vc.beginDate = self.beginDate;
//    vc.endDate = self.endDate;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 界面配置

- (void)configViews {
    UIImage *Image = self.blockIV.image;
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    Image = [Image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.blockIV.image = Image;
    self.blockIV2.image = Image;

//    [self.videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//    [self.btn4 sendActionsForControlEvents:UIControlEventTouchUpInside];

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
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"少于30字(非必填)" attributes:
                                      @{NSForegroundColorAttributeName:gray2,
                                        NSFontAttributeName: self.titleTF.font
                                        }];
    self.titleTF.attributedPlaceholder = attrString;
    [self.titleTF setReturnKeyType:UIReturnKeyDone];
    [self.titleTF addTarget:self action:@selector(handleTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    
//    NSArray *btns = @[_videoBtn, _voiceBtn, _liveBtn, _btn4, _btn8, _btn16, _createMeetingBtn];
    NSArray *btns = @[ _createMeetingBtn];
    for (UIButton *btn in btns) {
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
    }
    
    self.whichDate = [NSDate dateWithTimeIntervalSinceNow:5 * 60];
    self.beginDate = self.whichDate;
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:35 * 60];
//    self.endDate = [NSDate dateWithTimeIntervalSinceNow:35 * 60 + 59];
    [self updateDateViews];
    
    self.oneView.hidden = YES;
    self.twoView.hidden = YES;
    self.selectModeLabel.textColor = [YCTool colorOfHex:0xbababa];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if ([app_Name isEqualToString:@"易事猫"]) {
        self.navigationLabel.text = @"预约会议";
        self.titleLabel.text = @"会议主题";
        self.dateLabel.text = @"会议日期";
        self.durautionLabel.text = @"会议时长";
        self.countLabel.text = @"会议模式";
        self.selectModeLabel.text = @"请选择会议模式";
    } else {
        self.navigationLabel.text = @"预约会面";
        self.titleLabel.text = @"会面主题";
        self.dateLabel.text = @"会面日期";
        self.durautionLabel.text = @"会面时长";
        self.countLabel.text = @"会面模式";
        self.selectModeLabel.text = @"请选择会面模式";
    }
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
        self.durationMinute = h * 60 + m;
        
        if (h) {
            [string appendFormat:@"%ld 小时", (long)h];
        }
        if (m) {
            [string appendFormat:@" %ld 分钟", (long)m];
        }
        if (h + m == 0) {
            [string appendString: @"0 分钟"];
        }
        if (h > 8) {
            [string appendString:@"(不能超过8小时)"];
            self.isDurationOver8Hour = YES;
        }
        [self.durationBtn setTitle:string forState:UIControlStateNormal];
        
        UIColor *color = [YCTool colorOfHex:0xff3e3e];
        if (h <= 8) {
            color = [UIColor blackColor];
        }
        [self.durationBtn setTitleColor:color forState:UIControlStateNormal];
    }];
}

#pragma mark -

- (void)goToPayViewController {
    YCMeetingPayController *vc = [YCMeetingPayController new];
    self.payController = vc;
    vc.count = self.count;
    vc.durationString = [self.durationBtn titleForState:UIControlStateNormal];
    vc.beginDate = self.beginDate;
    vc.endDate = self.endDate;
    vc.durationMinute = self.durationMinute;
    vc.isVideo = self.isVideo;
    
    __weak typeof(self) weakself = self;
    vc.onClickPayBtnBlock = ^(YCMeetingRebate *rebate) {
        weakself.rebate = rebate;
        [weakself createMeetingWithJuHua:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createMeetingWithJuHua:(BOOL)juhua {
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
    
    
    __weak typeof(self) weakself = self;
//    int roomType = self.room.type; //roomType 视频的会议室类型 0:公司 1:用户
    int roomType = self.rebate.type; //roomType 视频的会议室类型 0:公司 1:用户
    NSString *crID = self.room.roomId; //companyRoomId 公司会议房间Id（空为非公司会议）
    int meetingType = self.isVideo? 1: 0; //会议形式（0：音频，1：视频）
    int live = self.isLive? 1: 0;
    
    NSString *meetingName = self.titleTF.text;
//    if ([YCTool isBlankString:meetingName]) {
//        // 02月02日周六 16:28会议
//        f.dateFormat = @"MM月dd日EE HH:mm";
//        meetingName = [f stringFromDate:beginDate];
//        meetingName = [NSString stringWithFormat:@"%@%@", meetingName, [ObjectShareTool stringFromAppName]];
//    }
    
    int shareType = self.rebate.shareType;
    if (!self.rebate) {
        shareType = -1;
    }
    int toType = 0;
    NSString *toID;
    if (shareType == 1) {
        toType = self.rebate.type;
        toID = self.rebate.id;
    } else {
        toType = -1;
        toID = @"";
    }
    
    [self.createMeetingBtn setTitle:@"正在预约" forState: UIControlStateNormal];
    self.createMeetingBtn.userInteractionEnabled = NO;

    [[YCMeetingBiz new] bookMeeting2WithMeetingID:@"" oldMeetingID:@"" MeetingType:meetingType MeetingName:meetingName users:@"" roomID:@"" beginDate:beginDate endDate:endDate live:live accessNumber:self.count roomType:roomType companyRoomId:crID shareType:self.rebate.shareType toType:toType toId:toID juhua:juhua Success:^(id data) {
        NSDictionary *detail = data[@"detail"];
        if (detail) {
            [CTToast showWithText:@"创建成功"];
            
//            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
            NSString *meetingId = detail[@"meetingId"];
            [weakself goToMeetingRoomWithMeetingID:meetingId];

        } else {
            [CTToast showWithText:data[@"msg"]];
//            [weakself showChargeAlertWithMessage:data[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        weakself.createMeetingBtn.userInteractionEnabled = YES;
        [weakself.createMeetingBtn setTitle:@"发起预约" forState: UIControlStateNormal];

        [weakself.payController enablePayButton];
        
        [weakself showChargeAlertWithMessage:error.userInfo[@"message"]];
    }];
}

- (void)showChargeAlertWithMessage:(NSString *)msg {
    if (![msg isEqualToString:@"金币不够支付"]) {
        return;
    }

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"是否充值?" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我要充值" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 共享，只用微信支付
        if (self.rebate.shareType) {
            if ([WXApi isWXAppInstalled]) {
                [self gotoWeiXinPay];
            } else {
                [self showHintForInstallWeiXin];
            }
        } else {
            CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
            vc.type = 4;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showHintForInstallWeiXin {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未安装微信，无法发起支付" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)goToMeetingRoomWithMeetingID:(NSString *)mid {
    __weak typeof(self) weakself = self;
    
    [[YCMeetingBiz new] meetingEntranceWithMeetingID:mid Success:^(int state, NSString *password, NSString *message, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *q) {

        // 状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        roomVc.meetingID = mid;
        roomVc.meetingState = state;
        roomVc.isReview = NO;
        roomVc.AccessKey = AccessKey;
        roomVc.SecretKey = SecretKey;
        roomVc.BucketName = BucketName;
        
        UINavigationController *nvc = weakself.navigationController;
        [nvc popToRootViewControllerAnimated:YES];
        [nvc pushViewController:roomVc animated:YES];
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 微信支付

- (void)addObserverForWeiXinPay {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:NOTIFICATION_WEIXINPAYSUCCESS object:nil];
}

- (void)paySuccess:(NSNotification *)noti {
    [self createMeetingWithJuHua:NO];
}

- (void)gotoWeiXinPay {

    NSString *toId = [ObjectShareTool currentUserID];
    NSString *identifier = [CTDeviceTool getUniqueDeviceIdentifierAsString];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"packageid",identifier,@"identity", nil];

    // 后台下单
    [[YCMeetingBiz new]
     authUserPlaceOrderWithToId:toId toType:24 subType:0 payType:1002 payMethod:@"WECHATPAY" toUserId:@"123" body:@"充值金币" detail:@"" attach:dic trade_type:@"APP" device_info:@"" total_fee:self.rebate.price notify_url:@"" order_type:0 iOSProductId:@"" success:^(CGRewardEntity *entity) {
         // 拉起微信支付
         [[CGCommonBiz new] jumpToBizPayWithEntity:entity];
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCCreateMeetingTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCCreateMeetingTimeCell" forIndexPath:indexPath];
    cell.hourL.text = [NSString stringWithFormat:@"%ld:00", (long)indexPath.item];
    cell.cellItem = indexPath.item;
    return cell;
}


#pragma mark - 新版选择日期

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = [YCCreateMeetingTimeCell itemSize];
    layout.minimumInteritemSpacing = 4;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCCreateMeetingTimeCell" bundle:nil] forCellWithReuseIdentifier:@"YCCreateMeetingTimeCell"];
    self.collectionView.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeCellClickNotification:) name:[YCCreateMeetingTimeCell notificationName] object:nil];
    
}

- (void)handleTimeCellClickNotification:(NSNotification *)noti {
    YCCreateMeetingTimeCell *cell = (YCCreateMeetingTimeCell *)noti.object;
    NSInteger hour = cell.cellItem;
    NSInteger min = cell.clickIndex;//0,1,2,3
    
    if (!self.beginIndex) {
        self.beginIndex = [NSIndexPath indexPathForItem:min inSection:hour];
    } else {
        NSInteger h = self.beginIndex.section;
        NSInteger m = self.beginIndex.item;
        
        if (<#condition#>) {
            <#statements#>
        }
    }
    
    if (!self.endIndex) {
        self.endIndex = [NSIndexPath indexPathForItem:min inSection:hour];
    } else {
        
    }


    
    
    NSLog(@"%ld, %ld", hour, min);
}



@end
