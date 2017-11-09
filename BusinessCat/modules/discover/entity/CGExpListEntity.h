//
//  CGExpListEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGExpListEntity : NSObject
@property (nonatomic, copy) NSString *expID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger subscribe;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isExpJoin;
@end
