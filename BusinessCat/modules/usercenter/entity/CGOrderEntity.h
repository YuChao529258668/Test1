//
//  CGOrderEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRewardEntity.h"

@interface CGOrderEntity : NSObject
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderTitle;
@property (nonatomic, assign) NSInteger orderState;
@property (nonatomic, assign) NSInteger orderTime;
@property (nonatomic, assign) NSInteger orderAmount;
@property (nonatomic, assign) NSInteger payState;
@property (nonatomic, copy) NSString *payCauses;
@property (nonatomic, copy) NSString *relationInfo;
@property (nonatomic, strong) NSMutableArray *relationList;
@property (nonatomic, copy) NSString *orderParam;
@property (nonatomic, copy) NSString *iosProductId;
@property (nonatomic, strong) CGRewardEntity *payResult;
@end

@interface RelationEntity : NSObject
@property (nonatomic, copy) NSString *ralationID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger type;
@end
