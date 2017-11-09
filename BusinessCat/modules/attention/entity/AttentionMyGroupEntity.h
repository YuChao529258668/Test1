//
//  AttentionMyGroupEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionMyGroupEntity : NSObject
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, assign) NSInteger newNum;
@property (nonatomic, assign) NSInteger conditionNum;
@property (nonatomic, assign) NSInteger isCanDel;
@end
