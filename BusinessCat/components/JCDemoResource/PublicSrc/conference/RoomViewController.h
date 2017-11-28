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

@end
