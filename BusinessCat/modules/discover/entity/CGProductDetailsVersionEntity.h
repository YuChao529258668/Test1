//
//  CGProductDetailsVersionEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGProductDetailsVersionEntity : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger isGallery;
@property (nonatomic, assign) NSInteger isVedio;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, assign) NSInteger createtime;

//自定义参数
@property (nonatomic, assign) NSInteger isPush;
@end
