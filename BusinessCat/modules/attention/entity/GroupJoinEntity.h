//
//  GroupJoinEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupJoinEntity : NSObject
@property (nonatomic, assign) NSInteger isSubscribe;
@property (nonatomic, strong) NSMutableArray *list;
@end

@interface JoinEntity : NSObject
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger isJoin;
@end
