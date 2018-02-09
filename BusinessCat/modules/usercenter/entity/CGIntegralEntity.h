//
//  CGIntegralEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIntegralEntity : NSObject
@property (nonatomic, assign) NSInteger dateTime;
@property (nonatomic, strong) NSMutableArray *list;
@end

@interface RelationInfoEntity : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *infoID;
@end

@interface IntegralListEntity : NSObject
@property (nonatomic, copy) NSString *rewardId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rewardInfo;
@property (nonatomic, assign) NSInteger rewardType;
@property (nonatomic, assign) NSInteger dateTime;
@property (nonatomic, assign) double rewardNum;
@property (nonatomic, strong) RelationInfoEntity *relationInfo;
@end
