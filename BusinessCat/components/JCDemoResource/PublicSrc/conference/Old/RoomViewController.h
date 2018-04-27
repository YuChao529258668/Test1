//
//  RoomViewController.h
//  UltimateShow
//
//  Created by 沈世达 on 2017/6/1.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UIViewController

@property (nonatomic, copy) NSString *roomId;           // 会议号码
@property (nonatomic, copy) NSString *displayName;      // 昵称

@property (nonatomic,strong) NSString *meetingID;
@property (nonatomic,assign) long meetingState; //状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束。这个是meetingEntrance接口返回的，和会议详情接口的不一样！
@property (nonatomic,assign) BOOL isReview; // 是否回放


//保存文档的url
@property (nonatomic, strong) NSArray<NSString *> *urls;

//  七牛参数
@property (nonatomic,strong) NSString *q;
@property (nonatomic,strong) NSString *AccessKey;
@property (nonatomic,strong) NSString *SecretKey;
@property (nonatomic,strong) NSString *BucketName;

@end
