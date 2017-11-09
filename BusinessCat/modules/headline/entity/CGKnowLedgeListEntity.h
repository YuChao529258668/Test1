//
//  CGKnowLedgeListEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGKnowLedgeListEntity : NSObject
@property (nonatomic, assign) NSInteger layout;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *ldegeID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, strong) NSMutableArray *list;
@end
