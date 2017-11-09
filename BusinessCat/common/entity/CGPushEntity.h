//
//  CGPushEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class apsEntity;
@class alertEntity;

@interface CGPushEntity : NSObject
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *parameterId;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, strong) apsEntity *aps;
@end

@interface apsEntity : NSObject
@property (nonatomic, copy) NSString *sound;
@property (nonatomic, strong) alertEntity *alert;
@end

@interface alertEntity : NSObject
@property (nonatomic, copy) NSString *body;
@end
