//
//  AttentionStatisticsEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionStatisticsEntity : NSObject
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *icon;
@end
