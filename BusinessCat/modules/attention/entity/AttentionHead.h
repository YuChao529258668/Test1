//
//  AttentionHead.h
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionHead : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) int countNum;//总数
@property (nonatomic, assign) long createtime;//创建时间
@property (nonatomic, assign) long attentionTime;
@property (nonatomic, strong) NSString * desc;//描述
@property (nonatomic, strong) NSString * icon;//
@property (nonatomic, strong) NSString * infoId;
@property (nonatomic, strong) NSString * label;//显示标签
@property (nonatomic, assign) int layout;//布局
@property (nonatomic, assign) int newNum;
@property (nonatomic, strong) NSString * prompt;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, assign) int subscribeNum;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) long updatetime;
@property (nonatomic, assign) NSInteger createType;
@property (nonatomic, assign) NSInteger isTop;
@property (nonatomic, assign) NSInteger dataLatestTime;
@end
