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
@property (nonatomic, assign) int state; // 0不可用 1可用 ，共享的没有这个字段
@property (nonatomic, assign) int type;// 0为公司 1为用户
@property (nonatomic, assign) int rebate; // 0原价,1八折，2免费
@property (nonatomic, assign) double price;

// 自定义数据，在支付时用到，table view cell 用不到
@property (nonatomic, assign) int shareType; // 0 myList，我的。1 shareList，共享

@end

//"msg": "可抵扣",
//"duration": 539,
//"name": "我的账户",
//"id": "100c62d0-8c5e-48a0-b911-d65b3f51a123",
//"state": 1,
//"type": 2


//{
//    myList =     (
//                  {
//                      duration = 0;
//                      id = "47cd5da6-49db-4390-abfe-f67e15f567a2";
//                      msg = "\U4e0d\U591f\U62b5\U6263";
//                      name = "\U6211\U7684\U8d26\U6237";
//                      state = 0;
//                      type = 1;
//                  },
//                  {
//                      duration = 21308;
//                      id = "8f82d6d5-e8ed-4c14-b3a9-f808370da47a";
//                      msg = "\U53ef\U62b5\U6263";
//                      name = "\U751f\U610f\U732b";
//                      state = 1;
//                      type = 0;
//                  }
//                  );
//    shareList =     (
//                     {
//                         id = "97a469ed-7494-47b1-a3c5-3d6f39a2a219";
//                         msg = "\U539f\U4ef7";
//                         name = "\U6731\U4f1f\U950b\U7684\U7ba1\U5bb6\U7ec4\U7ec7";
//                         price = "7.5";
//                         state = 0;
//                         type = 0;
//                     }
//                     );
//}

