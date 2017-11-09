//
//  CGUserorganizaApplyEntity.h
//  CGSays
//
//  Created by zhu on 2016/11/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserorganizaApplyEntity : NSObject

@property (nonatomic, copy) NSString *organizaID;
@property (nonatomic, copy) NSString *organizaName;
@property (nonatomic, copy) NSString *depaID;
@property (nonatomic, copy) NSString *depaName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *roleID;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *position;
@end
