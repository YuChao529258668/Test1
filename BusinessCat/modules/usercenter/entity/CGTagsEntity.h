//
//  CGTagsEntity.h
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGTagsEntity : NSObject
@property (nonatomic, copy) NSString *tagID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *tags;
@end

@interface CGTags : NSObject
@property (nonatomic, copy) NSString *tagID;
@property (nonatomic, copy) NSString *tagName;
@end
