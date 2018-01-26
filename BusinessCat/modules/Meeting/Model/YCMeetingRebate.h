//
//  YCMeetingRebate.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/24.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCMeetingRebate : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) NSInteger duration;// 分钟
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) int state; // 0不可用 1可用
@property (nonatomic, assign) int type;// 1为公司 2为用户

@end

//"msg": "可抵扣",
//"duration": 539,
//"name": "我的账户",
//"id": "100c62d0-8c5e-48a0-b911-d65b3f51a123",
//"state": 1,
//"type": 2

