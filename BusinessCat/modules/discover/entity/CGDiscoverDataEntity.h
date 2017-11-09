//
//  CGDiscoverDataEntity.h
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGDiscoverDataEntity : NSObject
@property (nonatomic, strong) NSMutableArray *banner;
@property (nonatomic, strong) NSMutableArray *scoop;
@end

@interface BannerData : NSObject
@property (nonatomic, strong) NSString *src;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *commpanyId;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, assign) NSInteger recordType;
@property (nonatomic, copy) NSString *commondAction;
@property (nonatomic, copy) NSString *parameterId;
@property (nonatomic, copy) NSString *messageId;
@end

@interface ScoopData : NSObject
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *name;
@end
