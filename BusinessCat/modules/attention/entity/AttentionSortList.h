//
//  AttentionSortList.h
//  CGSays
//
//  Created by zhu on 2016/12/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionSortList : NSObject
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) NSInteger isRed;
@property (nonatomic, strong) NSMutableArray *data;
@end
