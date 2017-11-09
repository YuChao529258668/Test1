//
//  CGOrderProgressEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGOrderProgressEntity : NSObject
@property (nonatomic, copy) NSString *scheduleId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger orderState;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, assign) NSInteger createtime;
@end
