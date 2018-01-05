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

@end

@implementation YCMeetingDesktopController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addObserForMtcNotification];
}

/*
ZINT Mtc_ConfCommand(ZUINT iConfId，ZCONST ZCHAR pcCmd,ZCONST ZCHAR pcParm);
iConfId：    会议ID
pcCmd：        MtcConfCmdReplayStartRecord
pcParm：        json格式里套了Storage这个json，键值对类似： {"MtcConfIsVideoKey":true,"Storage":{"Protocol":"qiniu","AccessKey":"","SecretKey":"","BucketName":"","FileKey":"abc123.mp4"}}
协议是七牛，后面的key,客户填自己七牛上相对应的值。
 
界面使用以下key来组装json
MtcConfIsVideoKey         是否录制视频
MtcConfStorageKey        表示字符串Storage
 
MtcConfProtocolKey        表示字符串Protocol，目前值为qiniu
MtcConfAccessKeyKey        表示字符串AccessKey
MtcConfSecretKeyKey        表示字符串SecretKey
MtcConfBucketNameKey    表示字符串BucketName 空间名 video
MtcConfFileKeyKey        表示字符串FileKey，用来定义文件名 用户填入.mp4
 
MtcConfAutoSplitKey        表示字符串AutoSplit,用来分割录制文件，优点是直播器异常退出的话，还可以提交录制文件给七牛。
MtcConfSplitFileSizeKey     表示字符串SplitFileSize,规定分割的大小。
*/


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
//    @"MtcConfAccessKeyKey" : @"EuOXxzahj6vQ6VxyIq9Hu5DLBz2xz0B3ZimBMYjH",
//    @"MtcConfSecretKeyKey" : @"A-CB5N8j-AyQRtDbWUj9bjNusIeIQwrGzJr__7Du",

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
    NSDictionary *storageDic = @{@"MtcConfProtocolKey" : @"qiniu",
                                 @"MtcConfAccessKeyKey" : @"aaa",
                                 @"MtcConfSecretKeyKey" : @"sss",
                                 @"MtcConfBucketNameKey" : @"video",
                                 @"MtcConfFileKeyKey" : fileName};
    NSDictionary *para = @{@"MtcConfIsVideoKey" : @YES, @"MtcConfStorageKey" : storageDic};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:para options:0 error:nil];
    
    ZINT ret = Mtc_ConfCommand(iConfId, MtcConfCmdReplayStartRecord, [data bytes]);// MTC: ERROR:  334967056 No replayer.
    if (ret == ZOK) {
        self.vedioControlBtn.selected = YES;
    } else {
        [CTToast showWithText:@"发起录屏 失败"];
    }
    
//    NSString *json = [para JSONString];
//    ZCHAR *pcCmd = MtcConfCmdReplayStartRecord;
//    ZCONST ZCHAR *pcParm = json.UTF8String;
//
//    ZINT success = Mtc_ConfCommand(iConfId, pcCmd, pcParm);
//    if (success == ZOK) {
//        self.vedioControlBtn.selected = YES;
//    } else {
//        [CTToast showWithText:@"发起录屏 失败"];
//    }
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
    } else {
        [CTToast showWithText:@"发起录屏 失败"];
    }
}

- (void)endScreen {
//    ZUINT iConfId = self.meeting.conferenceNumber.intValue;
    ZUINT iConfId = self.confID;
    ZCHAR *pcCmd = MtcConfCmdReplayStopRecord;
    ZINT success = Mtc_ConfCommand(iConfId, pcCmd, nil);
    if (success == ZOK) {
        self.vedioControlBtn.selected = NO;
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
