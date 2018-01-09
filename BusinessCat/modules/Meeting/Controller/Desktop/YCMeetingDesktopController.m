//
//  YCMeetingDesktopController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/4.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingDesktopController.h"

@interface YCMeetingDesktopController ()
@property (weak, nonatomic) IBOutlet UIButton *vedioControlBtn;
@property (nonatomic,assign) BOOL isScreening;// 是否正在录屏

@end

@implementation YCMeetingDesktopController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.isScreening) {
        [self endScreen];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addObserForMtcNotification];
}


- (IBAction)clickVedioControlBtn:(UIButton *)sender {
    if (!self.meeting) {
        [CTToast showWithText:@"正在获取会议详情，请稍后再试"];
        return;
    }
    if (!self.confID) {
        [CTToast showWithText:@"正在加入会议，请稍后再试"];
        return;
    }

    
    if (self.vedioControlBtn.isSelected) {
        [self endScreen];
    } else {
        [self startScreen];
    }
}

#pragma mark - 录屏

- (void)startScreen {

    //    判断是否为直播会议
//    ZUINT iConfId = self.meeting.conferenceNumber.intValue;
    ZUINT iConfId = self.confID;
    ZCONST ZCHAR *pcName = MtcConfPropDeliveryUri;
    ZCONST ZCHAR *DeliveryURI = Mtc_ConfGetProp(iConfId, pcName); // [username:delivery_10935553@delivery.cloud.justalk.com]
    if (DeliveryURI == ZNULL) {
        [CTToast showWithText:@"不是直播会议，无法录屏"];
        return;
    }
    
    // 发起录屏
    NSString *fileName = [NSString stringWithFormat:@"test%@.mp4", self.meeting.meetingId];
//    NSDictionary *storageDic = @{@"MtcConfProtocolKey" : @"qiniu",
//                                 @MtcConfAccessKeyKey : @"EuOXxzahj6vQ6VxyIq9Hu5DLBz2xz0B3ZimBMYjH",
//                                 @"MtcConfSecretKeyKey" : @"A-CB5N8j-AyQRtDbWUj9bjNusIeIQwrGzJr__7Du",
//                                 @"MtcConfBucketNameKey" : @"video",
//                                 @"MtcConfFileKeyKey" : fileName};
//    NSDictionary *para = @{@MtcConfIsVideoKey : @YES, @"MtcConfStorageKey" : storageDic};
    NSDictionary *storageDic = @{@"Protocol" : @"qiniu",
                                 @"AccessKey" : @"EuOXxzahj6vQ6VxyIq9Hu5DLBz2xz0B3ZimBMYjH",
                                 @"SecretKey" : @"A-CB5N8j-AyQRtDbWUj9bjNusIeIQwrGzJr__7Du",
                                 @"BucketName" : @"video",
                                 @"FileKey" : fileName};
    NSDictionary *para = @{@"MtcConfIsVideoKey" : @YES, @"Storage" : storageDic};

    
    ZINT s = Mtc_ConfStartCdn(iConfId);
    if (s != ZOK) {
        [CTToast showWithText:@"开启 cdn 失败"];
    }

    ZINT ret = Mtc_ConfCommand(iConfId, MtcConfCmdReplayStartRecord, [para JSONString].UTF8String);
    if (ret == ZOK) {
        self.vedioControlBtn.selected = YES;
        self.isScreening = YES;
        [CTToast showWithText:@"开始录屏"];
    } else {
        [CTToast showWithText:@"发起录屏 失败"];
    }
}

- (void)startScreen0 {
    //    @"MtcConfAccessKeyKey" : @"EuOXxzahj6vQ6VxyIq9Hu5DLBz2xz0B3ZimBMYjH",
    //    @"MtcConfSecretKeyKey" : @"A-CB5N8j-AyQRtDbWUj9bjNusIeIQwrGzJr__7Du",
    
    //    判断是否为直播会议
//    ZUINT iConfId = self.meeting.conferenceNumber.intValue;
    ZUINT iConfId = self.confID;
    ZCONST ZCHAR *pcName = MtcConfPropDeliveryUri;
    ZCONST ZCHAR *DeliveryURI = Mtc_ConfGetProp(iConfId, pcName);
    if (DeliveryURI == ZNULL) {
        [CTToast showWithText:@"不是直播会议，无法录屏"];
        //        return;
    }
    
    // 发起录屏
    NSString *fileName = [NSString stringWithFormat:@"test%@.mp4", self.meeting.meetingId];
    NSDictionary *storageDic = @{@"MtcConfProtocolKey" : @"qiniu",
                                 @"MtcConfAccessKeyKey" : @"aaa",
                                 @"MtcConfSecretKeyKey" : @"sss",
                                 @"MtcConfBucketNameKey" : @"video",
                                 @"MtcConfFileKeyKey" : fileName};
    NSDictionary *para = @{@"MtcConfIsVideoKey" : @YES, @"MtcConfStorageKey" : storageDic};
    NSString *json = [para JSONString];
    
    ZCHAR *pcCmd = MtcConfCmdReplayStartRecord;
    ZCONST ZCHAR *pcParm = json.UTF8String;
    
    ZINT success = Mtc_ConfCommand(iConfId, pcCmd, pcParm);
    if (success == ZOK) {
        self.vedioControlBtn.selected = YES;
        [CTToast showWithText:@"开始录屏"];
    } else {
        [CTToast showWithText:@"发起录屏 失败"];
    }
}

- (void)endScreen {
//    ZUINT iConfId = self.meeting.conferenceNumber.intValue;
    ZUINT iConfId = self.confID;
    ZCHAR *pcCmd = MtcConfCmdReplayStopRecord;
    
    ZINT s = Mtc_ConfStopCdn(iConfId);
    if (s != ZOK) {
        [CTToast showWithText:@"关闭 cdn 失败"];
    }

    ZINT success = Mtc_ConfCommand(iConfId, pcCmd, nil);
    if (success == ZOK) {
        self.vedioControlBtn.selected = NO;
        self.isScreening = NO;
        [CTToast showWithText:@"结束录屏"];
    } else {
        [CTToast showWithText:@"结束录屏 失败"];
    }

}


#pragma mark - Notification

- (void)addObserForMtcNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcConfParticipantChangedNotification:) name:@MtcConfParticipantChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMtcConfErrorNotification:) name:@MtcConfErrorNotification object:nil];
}

//* @retval ZOK Command has been sent out successfully.
//*             When server accept the command, there will be
//*             a @ref MtcConfParticipantChangedNotification
//*             notification.
//*             When server reject the command or timeout, there will be
//*             a @ref MtcConfErrorNotification notification.
- (void)handleMtcConfParticipantChangedNotification:(NSNotification *)noti {
    
}

- (void)handleMtcConfErrorNotification:(NSNotification *)noti {
//    MtcConfEventKey = 1;
//    MtcConfIdKey = 42757888;
//    MtcConfNumberKey = 10151299;
//    MtcConfReasonKey = 2103;

//    [CTToast showWithText:@"无法录制视频"];
    [CTToast showWithText:[NSString stringWithFormat:@"无法录制视频 : %@", noti.userInfo[@MtcConfReasonKey]]];
    NSLog(@"无法录制视频 %@", noti);
}



@end
