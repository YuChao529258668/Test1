//
//  CGMessageEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGMessageEntity : NSObject
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger count;
@end

