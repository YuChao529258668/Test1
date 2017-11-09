//
//  CGProductInterfaceEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGProductInterfaceEntity : NSObject
@property (nonatomic, copy) NSString *interfaceID;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *media;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger isIcon;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger original;
@property (nonatomic, copy) NSString *notice;
@end
